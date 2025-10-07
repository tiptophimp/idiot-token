// scripts/utils/time.js - Minimal hardened time utility
// Monotonic + offset model for drift-resistant timestamps

import { performance } from "node:perf_hooks";
import { createHash } from "node:crypto";
import { readFileSync, writeFileSync, existsSync } from "node:fs";

/**
 * Hardened time utility with monotonic + offset model
 * Provides drift-resistant, consistent timestamps
 */
class HardenedTime {
  constructor() {
    this.t0Utc = Date.now();
    this.t0Mono = performance.now();
    this.offsetMs = 0;
    this.lastGoodOffset = 0;
    this.offsetFile = './audit/last-good-offset.json';
    this.circuitBreakerOpen = false;
    this.consecutiveFailures = 0;
    this.maxFailures = 3;
    this.lastSyncTime = 0;
    this.syncInterval = 60000; // 60s base
    this.jitterRange = 10000; // ±10s jitter
    this.rateLimitDelay = 0;
    this.driftThreshold = 1500; // 1.5s
    this.stdevThreshold = 750; // 750ms
    this.alertThreshold = 5; // consecutive checks
    this.driftAlerts = 0;
    this.failureRateWindow = 600000; // 10 minutes
    this.failureCounts = [];
    this.apiSources = [
      'https://worldtimeapi.org/api/timezone/UTC',
      'https://timeapi.io/api/Time/current/zone?timeZone=UTC',
      'https://api.timezonedb.com/v2.1/get-time-zone?key=demo&format=json&by=zone&zone=UTC',
      'https://api.clockify.io/api/v1/time/entry',
      'https://api.github.com/zen'
    ];
    
    this.loadLastGoodOffset();
  }

  /**
   * Set time offset from external sources
   * @param {number} offsetMs - Offset in milliseconds
   */
  setOffset(offsetMs) {
    // Clamp offset to ±5s
    const clampedOffset = Math.max(-5000, Math.min(5000, offsetMs));
    
    this.t0Utc = Date.now() + clampedOffset;
    this.t0Mono = performance.now();
    this.offsetMs = clampedOffset;
    this.lastGoodOffset = clampedOffset;
    
    // Persist last good offset
    this.saveLastGoodOffset();
    
    console.log(`[${this.isoNow()}] Time offset set: ${clampedOffset}ms`);
  }

  /**
   * Get current UTC time in milliseconds (monotonic)
   * @returns {number} UTC timestamp in milliseconds
   */
  nowUtcMs() {
    return Math.round(this.t0Utc + (performance.now() - this.t0Mono));
  }

  /**
   * Get current UTC time as ISO string
   * @returns {string} ISO timestamp string
   */
  isoNow() {
    return new Date(this.nowUtcMs()).toISOString();
  }

  /**
   * Get current UTC time as Unix timestamp (seconds)
   * @returns {number} Unix timestamp in seconds
   */
  unixNow() {
    return Math.floor(this.nowUtcMs() / 1000);
  }

  /**
   * Sync time from external sources with outlier rejection
   */
  async syncTime() {
    if (this.circuitBreakerOpen) {
      console.warn(`[${this.isoNow()}] Circuit breaker open, skipping sync`);
      return;
    }

    if (Date.now() - this.lastSyncTime < this.rateLimitDelay) {
      console.log(`[${this.isoNow()}] Rate limited, skipping sync`);
      return;
    }

    try {
      console.log(`[${this.isoNow()}] Starting time sync...`);
      
      const offsets = await this.fetchOffsetsFromSources();
      
      if (offsets.length < 2) {
        throw new Error(`Insufficient sources: ${offsets.length}/5`);
      }

      const medianOffset = this.calculateMedianOffset(offsets);
      const stdev = this.calculateStdev(offsets);
      
      if (stdev > this.stdevThreshold) {
        throw new Error(`High standard deviation: ${stdev}ms > ${this.stdevThreshold}ms`);
      }

      // Check for drift
      const drift = Math.abs(medianOffset - this.offsetMs);
      if (drift > this.driftThreshold) {
        this.driftAlerts++;
        if (this.driftAlerts >= this.alertThreshold) {
          console.error(`[${this.isoNow()}] ALERT: High drift detected: ${drift}ms`);
        }
      } else {
        this.driftAlerts = 0;
      }

      this.setOffset(medianOffset);
      this.consecutiveFailures = 0;
      this.circuitBreakerOpen = false;
      this.lastSyncTime = Date.now();
      
      // Set next sync with jitter
      this.scheduleNextSync();
      
      console.log(`[${this.isoNow()}] Time synced: offset=${medianOffset}ms, stdev=${stdev}ms`);
      
    } catch (error) {
      console.error(`[${this.isoNow()}] Sync failed: ${error.message}`);
      this.handleSyncFailure();
    }
  }

  /**
   * Fetch time offsets from multiple sources
   * @returns {Promise<number[]>} Array of offsets in milliseconds
   */
  async fetchOffsetsFromSources() {
    const promises = this.apiSources.map(async (url, index) => {
      try {
        const controller = new AbortController();
        const timeoutId = setTimeout(() => controller.abort(), 2000); // 2s timeout
        
        const response = await fetch(url, {
          method: 'GET',
          headers: { 'Accept': 'application/json' },
          signal: controller.signal
        });
        
        clearTimeout(timeoutId);
        
        if (!response.ok) {
          throw new Error(`HTTP ${response.status}`);
        }
        
        const data = await response.json();
        const apiTime = this.parseApiTime(data);
        const offset = apiTime - Date.now();
        
        console.log(`[${this.isoNow()}] Source ${index + 1}: offset=${offset}ms`);
        return offset;
        
      } catch (error) {
        console.warn(`[${this.isoNow()}] Source ${index + 1} failed: ${error.message}`);
        throw error;
      }
    });

    const results = await Promise.allSettled(promises);
    const offsets = results
      .filter(result => result.status === 'fulfilled')
      .map(result => result.value);
    
    return offsets;
  }

  /**
   * Parse time from different API response formats
   * @param {any} data - API response data
   * @returns {number} Timestamp in milliseconds
   */
  parseApiTime(data) {
    if (data.unixtime) {
      return data.unixtime * 1000;
    } else if (data.currentFileTime) {
      return data.currentFileTime;
    } else if (data.datetime) {
      return new Date(data.datetime).getTime();
    } else if (data.timestamp) {
      return data.timestamp;
    } else if (data.utc_datetime) {
      return new Date(data.utc_datetime).getTime();
    } else {
      throw new Error('Unknown API response format');
    }
  }

  /**
   * Calculate median offset with outlier rejection
   * @param {number[]} offsets - Array of offsets
   * @returns {number} Median offset
   */
  calculateMedianOffset(offsets) {
    // Sort offsets
    const sorted = [...offsets].sort((a, b) => a - b);
    
    // Reject outliers (>1s from median)
    const median = sorted[Math.floor(sorted.length / 2)];
    const filtered = sorted.filter(offset => Math.abs(offset - median) <= 1000);
    
    if (filtered.length < 2) {
      throw new Error('Too many outliers rejected');
    }
    
    // Calculate median of filtered offsets
    const filteredSorted = filtered.sort((a, b) => a - b);
    const mid = Math.floor(filteredSorted.length / 2);
    
    if (filteredSorted.length % 2 === 0) {
      return (filteredSorted[mid - 1] + filteredSorted[mid]) / 2;
    } else {
      return filteredSorted[mid];
    }
  }

  /**
   * Calculate standard deviation
   * @param {number[]} values - Array of values
   * @returns {number} Standard deviation
   */
  calculateStdev(values) {
    const mean = values.reduce((sum, val) => sum + val, 0) / values.length;
    const variance = values.reduce((sum, val) => sum + Math.pow(val - mean, 2), 0) / values.length;
    return Math.sqrt(variance);
  }

  /**
   * Handle sync failure with circuit breaker
   */
  handleSyncFailure() {
    this.consecutiveFailures++;
    this.failureCounts.push(Date.now());
    
    // Clean old failure counts (older than 10 minutes)
    const cutoff = Date.now() - this.failureRateWindow;
    this.failureCounts = this.failureCounts.filter(time => time > cutoff);
    
    // Check failure rate
    const failureRate = this.failureCounts.length / (this.failureRateWindow / 60000); // failures per minute
    if (failureRate > 0.3) { // 30% failure rate
      console.error(`[${this.isoNow()}] ALERT: High failure rate: ${(failureRate * 100).toFixed(1)}%`);
    }
    
    if (this.consecutiveFailures >= this.maxFailures) {
      this.circuitBreakerOpen = true;
      console.error(`[${this.isoNow()}] Circuit breaker opened after ${this.consecutiveFailures} failures`);
      
      // Backoff: increase rate limit delay
      this.rateLimitDelay = Math.min(300000, this.rateLimitDelay * 2); // Max 5 minutes
    }
  }

  /**
   * Schedule next sync with jitter
   */
  scheduleNextSync() {
    const jitter = (Math.random() - 0.5) * this.jitterRange;
    const nextSync = this.syncInterval + jitter;
    this.rateLimitDelay = Math.max(0, nextSync);
  }

  /**
   * Load last good offset from file
   */
  loadLastGoodOffset() {
    if (!existsSync(this.offsetFile)) {
      return;
    }
    
    try {
      const data = JSON.parse(readFileSync(this.offsetFile, 'utf8'));
      
      // Verify checksum
      const expectedChecksum = createHash('sha256')
        .update(JSON.stringify({ offset: data.offset, timestamp: data.timestamp }))
        .digest('hex');
      
      if (data.checksum !== expectedChecksum) {
        console.warn(`[${this.isoNow()}] Invalid offset file checksum`);
        return;
      }
      
      // Check if offset is not too old (24 hours)
      if (Date.now() - data.timestamp > 86400000) {
        console.warn(`[${this.isoNow()}] Offset file too old, ignoring`);
        return;
      }
      
      this.lastGoodOffset = data.offset;
      this.setOffset(data.offset);
      console.log(`[${this.isoNow()}] Loaded last good offset: ${data.offset}ms`);
      
    } catch (error) {
      console.warn(`[${this.isoNow()}] Failed to load offset file: ${error.message}`);
    }
  }

  /**
   * Save last good offset to file with checksum
   */
  saveLastGoodOffset() {
    try {
      const data = {
        offset: this.lastGoodOffset,
        timestamp: Date.now(),
        checksum: ''
      };
      
      data.checksum = createHash('sha256')
        .update(JSON.stringify({ offset: data.offset, timestamp: data.timestamp }))
        .digest('hex');
      
      writeFileSync(this.offsetFile, JSON.stringify(data, null, 2));
      
    } catch (error) {
      console.warn(`[${this.isoNow()}] Failed to save offset file: ${error.message}`);
    }
  }

  /**
   * Get chain time for protocol logic
   * @param {ethers.Provider} provider - Ethereum provider
   * @returns {Promise<number>} Chain timestamp in milliseconds
   */
  async getChainTime(provider) {
    try {
      const block = await provider.getBlock('latest');
      return block.timestamp * 1000;
    } catch (error) {
      console.warn(`[${this.isoNow()}] Failed to get chain time: ${error.message}`);
      return this.nowUtcMs();
    }
  }

  /**
   * Get status information
   * @returns {object} Status object
   */
  getStatus() {
    return {
      offsetMs: this.offsetMs,
      lastGoodOffset: this.lastGoodOffset,
      circuitBreakerOpen: this.circuitBreakerOpen,
      consecutiveFailures: this.consecutiveFailures,
      lastSyncTime: this.lastSyncTime,
      driftAlerts: this.driftAlerts,
      failureRate: this.failureCounts.length / (this.failureRateWindow / 60000),
      currentTime: this.isoNow(),
      monotonicTime: this.nowUtcMs()
    };
  }
}

// Create singleton instance
const hardenedTime = new HardenedTime();

// Export functions for drop-in compatibility
export function setOffset(offsetMs) {
  hardenedTime.setOffset(offsetMs);
}

export function nowUtcMs() {
  return hardenedTime.nowUtcMs();
}

export function isoNow() {
  return hardenedTime.isoNow();
}

export function unixNow() {
  return hardenedTime.unixNow();
}

export function syncTime() {
  return hardenedTime.syncTime();
}

export function getChainTime(provider) {
  return hardenedTime.getChainTime(provider);
}

export function getStatus() {
  return hardenedTime.getStatus();
}

// Export class and instance
export { HardenedTime, hardenedTime };
export default hardenedTime;
