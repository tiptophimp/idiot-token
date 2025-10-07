// scripts/timeSync.js - Time synchronization and validation script
// Ensures all components use accurate, consistent time

import { timeUtils } from './utils/timeUtils.js';

/**
 * Time synchronization and validation utility
 * Ensures accurate time across all IDIOT token system components
 */
class TimeSync {
  constructor() {
    this.syncInterval = null;
    this.lastSync = null;
    this.timeDrift = 0;
    this.maxDrift = 5000; // 5 seconds max drift
  }

  /**
   * Start time synchronization
   * @param {number} intervalMs - Sync interval in milliseconds (default: 60000 = 1 minute)
   */
  startSync(intervalMs = 60000) {
    console.log(`${timeUtils.logTimestamp()} Starting time synchronization...`);
    
    // Initial sync
    this.syncTime();
    
    // Set up periodic sync
    this.syncInterval = setInterval(() => {
      this.syncTime();
    }, intervalMs);
    
    console.log(`${timeUtils.logTimestamp()} Time sync started (interval: ${intervalMs}ms)`);
  }

  /**
   * Stop time synchronization
   */
  stopSync() {
    if (this.syncInterval) {
      clearInterval(this.syncInterval);
      this.syncInterval = null;
      console.log(`${timeUtils.logTimestamp()} Time sync stopped`);
    }
  }

  /**
   * Sync time with external source
   */
  async syncTime() {
    try {
      const startTime = Date.now();
      
      // Get time from multiple sources for accuracy
      const timeSources = await Promise.allSettled([
        this.getTimeFromAPI('http://worldtimeapi.org/api/timezone/UTC'),
        this.getTimeFromAPI('https://timeapi.io/api/Time/current/zone?timeZone=UTC'),
        this.getTimeFromAPI('https://api.timezonedb.com/v2.1/get-time-zone?key=demo&format=json&by=zone&zone=UTC')
      ]);

      const validTimes = timeSources
        .filter(result => result.status === 'fulfilled' && result.value)
        .map(result => result.value);

      if (validTimes.length > 0) {
        // Calculate average time from valid sources
        const avgTime = validTimes.reduce((sum, time) => sum + time, 0) / validTimes.length;
        const currentTime = Date.now();
        this.timeDrift = avgTime - currentTime;
        
        this.lastSync = timeUtils.now();
        
        if (Math.abs(this.timeDrift) > this.maxDrift) {
          console.warn(`${timeUtils.logTimestamp()} Time drift detected: ${this.timeDrift}ms`);
        } else {
          console.log(`${timeUtils.logTimestamp()} Time synced (drift: ${this.timeDrift}ms)`);
        }
      } else {
        console.warn(`${timeUtils.logTimestamp()} Failed to sync time from external sources`);
      }
    } catch (error) {
      console.error(`${timeUtils.logTimestamp()} Time sync error:`, error.message);
    }
  }

  /**
   * Get time from external API
   * @param {string} url - API URL
   * @returns {Promise<number>} Timestamp in milliseconds
   */
  async getTimeFromAPI(url) {
    try {
      const response = await fetch(url, { 
        method: 'GET',
        headers: { 'Accept': 'application/json' },
        signal: AbortSignal.timeout(5000) // 5 second timeout
      });
      
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }
      
      const data = await response.json();
      
      // Parse different API response formats
      if (data.unixtime) {
        return data.unixtime * 1000; // Convert seconds to milliseconds
      } else if (data.currentFileTime) {
        return data.currentFileTime;
      } else if (data.datetime) {
        return new Date(data.datetime).getTime();
      } else if (data.timestamp) {
        return data.timestamp;
      } else {
        throw new Error('Unknown API response format');
      }
    } catch (error) {
      throw new Error(`API error: ${error.message}`);
    }
  }

  /**
   * Get corrected time (accounting for drift)
   * @returns {number} Corrected timestamp in milliseconds
   */
  getCorrectedTime() {
    return Date.now() + this.timeDrift;
  }

  /**
   * Get corrected time as ISO string
   * @returns {string} Corrected ISO timestamp
   */
  getCorrectedISO() {
    return new Date(this.getCorrectedTime()).toISOString();
  }

  /**
   * Get time status
   * @returns {object} Time synchronization status
   */
  getStatus() {
    return {
      lastSync: this.lastSync,
      timeDrift: this.timeDrift,
      isDriftExcessive: Math.abs(this.timeDrift) > this.maxDrift,
      isSyncing: this.syncInterval !== null,
      correctedTime: this.getCorrectedISO(),
      systemTime: timeUtils.now(),
      isTimeAccurate: this.isTimeAccurate()
    };
  }

  /**
   * Validate time accuracy
   * @returns {boolean} True if time is accurate
   */
  isTimeAccurate() {
    return Math.abs(this.timeDrift) <= this.maxDrift;
  }

  /**
   * Force immediate time sync
   */
  async forceSync() {
    console.log(`${timeUtils.logTimestamp()} Forcing time synchronization...`);
    await this.syncTime();
  }
}

// Create singleton instance
const timeSync = new TimeSync();

// Export both class and instance
export { TimeSync, timeSync };
export default timeSync;

// CLI usage
if (import.meta.url === `file://${process.argv[1]}`) {
  console.log('🕐 IDIOT Token Time Synchronization');
  console.log('=====================================\n');
  
  // Start sync
  timeSync.startSync(30000); // Sync every 30 seconds
  
  // Show status every 10 seconds
  const statusInterval = setInterval(() => {
    const status = timeSync.getStatus();
    console.log(`\n📊 Time Status:`);
    console.log(`   Last Sync: ${status.lastSync || 'Never'}`);
    console.log(`   Time Drift: ${status.timeDrift}ms`);
    console.log(`   Accurate: ${status.isTimeAccurate() ? '✅' : '❌'}`);
    console.log(`   Corrected Time: ${status.correctedTime}`);
    console.log(`   System Time: ${status.systemTime}`);
  }, 10000);
  
  // Handle graceful shutdown
  process.on('SIGINT', () => {
    console.log('\n\n🛑 Shutting down time sync...');
    timeSync.stopSync();
    clearInterval(statusInterval);
    process.exit(0);
  });
  
  // Keep running
  process.on('uncaughtException', (error) => {
    console.error('❌ Uncaught exception:', error);
    timeSync.stopSync();
    clearInterval(statusInterval);
    process.exit(1);
  });
}
