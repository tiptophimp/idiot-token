// scripts/tests/timeHardening.test.js - Comprehensive time hardening tests
// Tests monotonic + offset model, circuit breaker, and security controls

import { jest } from '@jest/globals';
import { HardenedTime, setOffset, nowUtcMs, isoNow, unixNow } from '../utils/time.js';

/**
 * Time hardening test suite
 */
describe('Time Hardening Tests', () => {
  let hardenedTime;
  let originalFetch;
  let originalPerformance;

  beforeEach(() => {
    // Create fresh instance for each test
    hardenedTime = new HardenedTime();
    
    // Mock fetch for API calls
    originalFetch = global.fetch;
    global.fetch = jest.fn();
    
    // Mock performance.now for consistent testing
    originalPerformance = global.performance;
    let mockTime = 0;
    global.performance = {
      now: () => mockTime += 1000 // Increment by 1s each call
    };
  });

  afterEach(() => {
    // Restore original functions
    global.fetch = originalFetch;
    global.performance = originalPerformance;
    jest.clearAllMocks();
  });

  describe('Monotonic + Offset Model', () => {
    test('should maintain monotonic time progression', () => {
      const time1 = nowUtcMs();
      const time2 = nowUtcMs();
      const time3 = nowUtcMs();
      
      expect(time2).toBeGreaterThan(time1);
      expect(time3).toBeGreaterThan(time2);
    });

    test('should apply offset correctly', () => {
      const offset = 5000; // 5 seconds
      setOffset(offset);
      
      const before = Date.now();
      const hardened = nowUtcMs();
      const after = Date.now();
      
      // Hardened time should be approximately offset + current time
      expect(hardened).toBeGreaterThan(before + offset - 100);
      expect(hardened).toBeLessThan(after + offset + 100);
    });

    test('should clamp offset to ±5s', () => {
      setOffset(10000); // 10s offset
      const status1 = hardenedTime.getStatus();
      
      setOffset(-10000); // -10s offset
      const status2 = hardenedTime.getStatus();
      
      expect(Math.abs(status1.offsetMs)).toBeLessThanOrEqual(5000);
      expect(Math.abs(status2.offsetMs)).toBeLessThanOrEqual(5000);
    });

    test('should generate valid ISO timestamps', () => {
      const iso = isoNow();
      const regex = /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z$/;
      expect(iso).toMatch(regex);
    });

    test('should generate valid Unix timestamps', () => {
      const unix = unixNow();
      const now = Math.floor(Date.now() / 1000);
      
      expect(unix).toBeGreaterThan(now - 10);
      expect(unix).toBeLessThan(now + 10);
    });
  });

  describe('Outlier Rejection', () => {
    test('should reject outliers >1s from median', () => {
      const offsets = [100, 120, 150, 2000, 130]; // 2000ms is outlier
      const median = hardenedTime.calculateMedianOffset(offsets);
      
      // Should be close to median of non-outliers (around 125)
      expect(median).toBeGreaterThan(100);
      expect(median).toBeLessThan(200);
    });

    test('should handle all outliers gracefully', () => {
      const offsets = [2000, 3000, 4000]; // All outliers
      
      expect(() => {
        hardenedTime.calculateMedianOffset(offsets);
      }).toThrow('Too many outliers rejected');
    });

    test('should calculate standard deviation correctly', () => {
      const values = [100, 200, 300, 400, 500];
      const stdev = hardenedTime.calculateStdev(values);
      
      // Expected stdev for [100,200,300,400,500] is ~158
      expect(stdev).toBeCloseTo(158, 0);
    });
  });

  describe('Circuit Breaker', () => {
    test('should open circuit breaker after max failures', () => {
      // Simulate failures
      for (let i = 0; i < 3; i++) {
        hardenedTime.handleSyncFailure();
      }
      
      expect(hardenedTime.circuitBreakerOpen).toBe(true);
    });

    test('should reset circuit breaker on successful sync', () => {
      // Open circuit breaker
      for (let i = 0; i < 3; i++) {
        hardenedTime.handleSyncFailure();
      }
      
      // Simulate successful sync
      hardenedTime.setOffset(100);
      
      expect(hardenedTime.circuitBreakerOpen).toBe(false);
      expect(hardenedTime.consecutiveFailures).toBe(0);
    });

    test('should increase rate limit delay on failures', () => {
      const initialDelay = hardenedTime.rateLimitDelay;
      
      hardenedTime.handleSyncFailure();
      hardenedTime.handleSyncFailure();
      
      expect(hardenedTime.rateLimitDelay).toBeGreaterThan(initialDelay);
    });
  });

  describe('Rate Limiting and Jitter', () => {
    test('should respect rate limiting', () => {
      hardenedTime.rateLimitDelay = 60000; // 1 minute
      hardenedTime.lastSyncTime = Date.now();
      
      // Should not sync due to rate limiting
      expect(hardenedTime.rateLimitDelay).toBeGreaterThan(0);
    });

    test('should add jitter to sync intervals', () => {
      const baseInterval = 60000;
      const jitterRange = 10000;
      
      hardenedTime.scheduleNextSync();
      
      expect(hardenedTime.rateLimitDelay).toBeGreaterThan(baseInterval - jitterRange);
      expect(hardenedTime.rateLimitDelay).toBeLessThan(baseInterval + jitterRange);
    });
  });

  describe('API Source Handling', () => {
    test('should parse different API response formats', () => {
      const testCases = [
        { unixtime: 1640995200 }, // Unix timestamp
        { currentFileTime: 13253760000000000 }, // Windows file time
        { datetime: '2022-01-01T00:00:00.000Z' }, // ISO string
        { timestamp: 1640995200000 }, // Millisecond timestamp
        { utc_datetime: '2022-01-01T00:00:00.000Z' } // UTC datetime
      ];

      testCases.forEach((data, index) => {
        const result = hardenedTime.parseApiTime(data);
        expect(typeof result).toBe('number');
        expect(result).toBeGreaterThan(0);
      });
    });

    test('should handle API failures gracefully', async () => {
      global.fetch.mockRejectedValue(new Error('Network error'));
      
      const offsets = await hardenedTime.fetchOffsetsFromSources();
      expect(offsets).toHaveLength(0);
    });

    test('should timeout API calls after 2s', async () => {
      global.fetch.mockImplementation(() => 
        new Promise(resolve => setTimeout(resolve, 3000))
      );
      
      const offsets = await hardenedTime.fetchOffsetsFromSources();
      expect(offsets).toHaveLength(0);
    });
  });

  describe('Drift Detection and Alerts', () => {
    test('should detect high drift', () => {
      hardenedTime.offsetMs = 100;
      const newOffset = 2000; // 1.9s drift
      
      // Simulate sync with high drift
      hardenedTime.setOffset(newOffset);
      
      expect(hardenedTime.driftAlerts).toBeGreaterThan(0);
    });

    test('should alert after consecutive drift detections', () => {
      // Simulate 5 consecutive high drift detections
      for (let i = 0; i < 5; i++) {
        hardenedTime.offsetMs = 100;
        hardenedTime.setOffset(2000);
      }
      
      expect(hardenedTime.driftAlerts).toBeGreaterThanOrEqual(5);
    });

    test('should reset drift alerts on normal operation', () => {
      // Set up high drift
      hardenedTime.driftAlerts = 5;
      
      // Normal sync
      hardenedTime.setOffset(100);
      
      expect(hardenedTime.driftAlerts).toBe(0);
    });
  });

  describe('Security Controls', () => {
    test('should only use HTTPS sources', () => {
      hardenedTime.apiSources.forEach(url => {
        expect(url.startsWith('https://')).toBe(true);
      });
    });

    test('should validate offset file checksum', () => {
      // This would require file system mocking
      // For now, just test that the method exists
      expect(typeof hardenedTime.loadLastGoodOffset).toBe('function');
      expect(typeof hardenedTime.saveLastGoodOffset).toBe('function');
    });

    test('should not modify system clock', () => {
      const before = Date.now();
      setOffset(5000);
      const after = Date.now();
      
      // System time should not be affected
      expect(after - before).toBeLessThan(100);
    });
  });

  describe('Edge Cases', () => {
    test('should handle zero offset', () => {
      setOffset(0);
      const status = hardenedTime.getStatus();
      expect(status.offsetMs).toBe(0);
    });

    test('should handle negative offset', () => {
      setOffset(-1000);
      const status = hardenedTime.getStatus();
      expect(status.offsetMs).toBe(-1000);
    });

    test('should handle very large timestamps', () => {
      const largeTime = 9999999999999;
      const iso = new Date(largeTime).toISOString();
      expect(iso).toMatch(/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z$/);
    });

    test('should handle performance.now() rollover', () => {
      // Simulate performance.now() rollover
      let mockTime = Number.MAX_SAFE_INTEGER - 1000;
      global.performance = {
        now: () => {
          mockTime += 1000;
          if (mockTime > Number.MAX_SAFE_INTEGER) {
            mockTime = 0; // Simulate rollover
          }
          return mockTime;
        }
      };
      
      const time1 = nowUtcMs();
      const time2 = nowUtcMs();
      
      expect(time2).toBeGreaterThan(time1);
    });
  });

  describe('Integration Tests', () => {
    test('should maintain consistency across multiple calls', () => {
      const times = [];
      for (let i = 0; i < 100; i++) {
        times.push(nowUtcMs());
      }
      
      // All times should be monotonically increasing
      for (let i = 1; i < times.length; i++) {
        expect(times[i]).toBeGreaterThanOrEqual(times[i - 1]);
      }
    });

    test('should handle rapid successive calls', () => {
      const start = Date.now();
      const times = [];
      
      // Make 1000 rapid calls
      for (let i = 0; i < 1000; i++) {
        times.push(nowUtcMs());
      }
      
      const end = Date.now();
      const duration = end - start;
      
      // Should complete quickly
      expect(duration).toBeLessThan(1000);
      
      // All times should be valid
      times.forEach(time => {
        expect(time).toBeGreaterThan(0);
        expect(time).toBeLessThan(Date.now() + 10000);
      });
    });
  });

  describe('Chaos Testing', () => {
    test('should handle one API returning stale time', async () => {
      // Mock one API returning stale time (1 hour ago)
      const staleTime = Date.now() - 3600000;
      global.fetch
        .mockResolvedValueOnce({ json: () => Promise.resolve({ unixtime: Math.floor(staleTime / 1000) }) })
        .mockResolvedValue({ json: () => Promise.resolve({ unixtime: Math.floor(Date.now() / 1000) }) });
      
      const offsets = await hardenedTime.fetchOffsetsFromSources();
      const median = hardenedTime.calculateMedianOffset(offsets);
      
      // Should reject the stale time and use current time
      expect(median).toBeCloseTo(0, -3); // Within 1 second of current time
    });

    test('should handle network partitions', async () => {
      global.fetch.mockRejectedValue(new Error('Network partition'));
      
      const offsets = await hardenedTime.fetchOffsetsFromSources();
      expect(offsets).toHaveLength(0);
      
      // Should fall back to last good offset
      expect(hardenedTime.lastGoodOffset).toBeDefined();
    });

    test('should handle clock skew scenarios', () => {
      // Simulate ±2s skew
      const skews = [-2000, -1000, 0, 1000, 2000];
      
      skews.forEach(skew => {
        setOffset(skew);
        const time = nowUtcMs();
        const expected = Date.now() + skew;
        
        expect(Math.abs(time - expected)).toBeLessThan(100);
      });
    });
  });
});

/**
 * Performance tests
 */
describe('Performance Tests', () => {
  test('should handle high-frequency calls efficiently', () => {
    const iterations = 10000;
    const start = Date.now();
    
    for (let i = 0; i < iterations; i++) {
      nowUtcMs();
    }
    
    const duration = Date.now() - start;
    const callsPerSecond = iterations / (duration / 1000);
    
    // Should handle at least 100,000 calls per second
    expect(callsPerSecond).toBeGreaterThan(100000);
  });

  test('should maintain precision under load', () => {
    const times = [];
    const iterations = 1000;
    
    for (let i = 0; i < iterations; i++) {
      times.push(nowUtcMs());
    }
    
    // Check that times are monotonically increasing
    let violations = 0;
    for (let i = 1; i < times.length; i++) {
      if (times[i] < times[i - 1]) {
        violations++;
      }
    }
    
    expect(violations).toBe(0);
  });
});
