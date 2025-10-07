// scripts/utils/timeUtils.js - Centralized time handling utilities
// Ensures consistent, accurate time across all scripts and dashboard

/**
 * Get current timestamp in various formats
 * Always uses UTC to avoid timezone issues
 */
class TimeUtils {
  constructor() {
    this.timezone = 'UTC';
  }

  /**
   * Get current timestamp as ISO string (UTC)
   * @returns {string} ISO timestamp string
   */
  now() {
    return new Date().toISOString();
  }

  /**
   * Get current timestamp as Unix timestamp (seconds)
   * @returns {number} Unix timestamp in seconds
   */
  unix() {
    return Math.floor(Date.now() / 1000);
  }

  /**
   * Get current timestamp as Unix timestamp (milliseconds)
   * @returns {number} Unix timestamp in milliseconds
   */
  unixMs() {
    return Date.now();
  }

  /**
   * Format timestamp for display
   * @param {Date|string|number} timestamp - Input timestamp
   * @param {string} format - Format type ('iso', 'readable', 'short', 'time')
   * @returns {string} Formatted timestamp
   */
  format(timestamp, format = 'iso') {
    let date;
    
    if (typeof timestamp === 'number') {
      // Handle both seconds and milliseconds
      date = new Date(timestamp < 1e10 ? timestamp * 1000 : timestamp);
    } else if (typeof timestamp === 'string') {
      date = new Date(timestamp);
    } else if (timestamp instanceof Date) {
      date = timestamp;
    } else {
      date = new Date();
    }

    // Validate date
    if (isNaN(date.getTime())) {
      console.warn('Invalid timestamp provided to TimeUtils.format:', timestamp);
      return 'Invalid Date';
    }

    switch (format) {
      case 'iso':
        return date.toISOString();
      
      case 'readable':
        return date.toUTCString();
      
      case 'short':
        return date.toISOString().split('T')[0]; // YYYY-MM-DD
      
      case 'time':
        return date.toISOString().split('T')[1].split('.')[0]; // HH:MM:SS
      
      case 'datetime':
        return date.toISOString().replace('T', ' ').split('.')[0]; // YYYY-MM-DD HH:MM:SS
      
      case 'local':
        return date.toLocaleString('en-US', { 
          timeZone: 'UTC',
          year: 'numeric',
          month: '2-digit',
          day: '2-digit',
          hour: '2-digit',
          minute: '2-digit',
          second: '2-digit',
          hour12: false
        });
      
      default:
        return date.toISOString();
    }
  }

  /**
   * Convert Unix timestamp to readable date
   * @param {number} unixTimestamp - Unix timestamp in seconds
   * @returns {string} Formatted date string
   */
  unixToDate(unixTimestamp) {
    return this.format(unixTimestamp, 'readable');
  }

  /**
   * Convert Unix timestamp to ISO string
   * @param {number} unixTimestamp - Unix timestamp in seconds
   * @returns {string} ISO timestamp string
   */
  unixToISO(unixTimestamp) {
    return this.format(unixTimestamp, 'iso');
  }

  /**
   * Get time remaining until a future timestamp
   * @param {number} futureTimestamp - Future Unix timestamp in seconds
   * @returns {object} Time remaining object
   */
  timeRemaining(futureTimestamp) {
    const now = this.unix();
    const remaining = Math.max(0, futureTimestamp - now);
    
    const days = Math.floor(remaining / 86400);
    const hours = Math.floor((remaining % 86400) / 3600);
    const minutes = Math.floor((remaining % 3600) / 60);
    const seconds = remaining % 60;

    return {
      total: remaining,
      days,
      hours,
      minutes,
      seconds,
      formatted: `${days}d ${hours}h ${minutes}m ${seconds}s`,
      expired: remaining === 0
    };
  }

  /**
   * Get time elapsed since a past timestamp
   * @param {number} pastTimestamp - Past Unix timestamp in seconds
   * @returns {object} Time elapsed object
   */
  timeElapsed(pastTimestamp) {
    const now = this.unix();
    const elapsed = Math.max(0, now - pastTimestamp);
    
    const days = Math.floor(elapsed / 86400);
    const hours = Math.floor((elapsed % 86400) / 3600);
    const minutes = Math.floor((elapsed % 3600) / 60);
    const seconds = elapsed % 60;

    return {
      total: elapsed,
      days,
      hours,
      minutes,
      seconds,
      formatted: `${days}d ${hours}h ${minutes}m ${seconds}s`
    };
  }

  /**
   * Calculate vesting progress
   * @param {number} startTimestamp - Vesting start timestamp
   * @param {number} durationSeconds - Vesting duration in seconds
   * @returns {object} Vesting progress object
   */
  vestingProgress(startTimestamp, durationSeconds) {
    const now = this.unix();
    const elapsed = Math.max(0, now - startTimestamp);
    const progress = Math.min(100, (elapsed / durationSeconds) * 100);
    const remaining = Math.max(0, durationSeconds - elapsed);
    
    return {
      progress: Math.round(progress * 100) / 100, // Round to 2 decimal places
      elapsed: this.timeElapsed(startTimestamp),
      remaining: this.timeRemaining(startTimestamp + durationSeconds),
      startDate: this.unixToISO(startTimestamp),
      endDate: this.unixToISO(startTimestamp + durationSeconds),
      isActive: now >= startTimestamp && now < (startTimestamp + durationSeconds),
      isCompleted: now >= (startTimestamp + durationSeconds),
      isPending: now < startTimestamp
    };
  }

  /**
   * Get current time for logging
   * @returns {string} Formatted timestamp for logs
   */
  logTimestamp() {
    return `[${this.format(null, 'datetime')} UTC]`;
  }

  /**
   * Validate timestamp
   * @param {any} timestamp - Timestamp to validate
   * @returns {boolean} True if valid timestamp
   */
  isValid(timestamp) {
    if (typeof timestamp === 'number') {
      return timestamp > 0 && timestamp < 1e12; // Reasonable range
    }
    if (typeof timestamp === 'string') {
      return !isNaN(Date.parse(timestamp));
    }
    if (timestamp instanceof Date) {
      return !isNaN(timestamp.getTime());
    }
    return false;
  }

  /**
   * Get timezone info
   * @returns {object} Timezone information
   */
  getTimezoneInfo() {
    const now = new Date();
    return {
      timezone: this.timezone,
      offset: now.getTimezoneOffset(),
      utc: now.toUTCString(),
      local: now.toLocaleString(),
      iso: now.toISOString()
    };
  }
}

// Create singleton instance
const timeUtils = new TimeUtils();

// Export both class and instance
module.exports = {
  TimeUtils,
  timeUtils,
  // Convenience functions
  now: () => timeUtils.now(),
  unix: () => timeUtils.unix(),
  format: (timestamp, format) => timeUtils.format(timestamp, format),
  timeRemaining: (futureTimestamp) => timeUtils.timeRemaining(futureTimestamp),
  timeElapsed: (pastTimestamp) => timeUtils.timeElapsed(pastTimestamp),
  vestingProgress: (startTimestamp, durationSeconds) => timeUtils.vestingProgress(startTimestamp, durationSeconds),
  logTimestamp: () => timeUtils.logTimestamp(),
  isValid: (timestamp) => timeUtils.isValid(timestamp)
};

// For ES modules
export { TimeUtils, timeUtils };
export default timeUtils;
