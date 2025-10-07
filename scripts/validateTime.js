// scripts/validateTime.js - Time validation and testing script
// Ensures all time handling is accurate and consistent

import { timeUtils } from './utils/timeUtils.js';
import { timeSync } from './timeSync.js';

/**
 * Comprehensive time validation and testing
 */
class TimeValidator {
  constructor() {
    this.tests = [];
    this.results = [];
  }

  /**
   * Run all time validation tests
   */
  async runAllTests() {
    console.log('🕐 IDIOT Token Time Validation Suite');
    console.log('=====================================\n');

    // Start time sync
    timeSync.startSync(30000);
    
    // Wait for initial sync
    await new Promise(resolve => setTimeout(resolve, 2000));

    // Run tests
    await this.testBasicTimeFunctions();
    await this.testTimeFormatting();
    await this.testVestingCalculations();
    await this.testTimeSync();
    await this.testTimezoneHandling();
    await this.testEdgeCases();

    // Show results
    this.showResults();
    
    // Stop time sync
    timeSync.stopSync();
  }

  /**
   * Test basic time functions
   */
  async testBasicTimeFunctions() {
    console.log('📋 Testing Basic Time Functions...');
    
    const tests = [
      {
        name: 'now() returns valid ISO string',
        test: () => {
          const now = timeUtils.now();
          return /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z$/.test(now);
        }
      },
      {
        name: 'unix() returns valid timestamp',
        test: () => {
          const unix = timeUtils.unix();
          return typeof unix === 'number' && unix > 0 && unix < 1e12;
        }
      },
      {
        name: 'unixMs() returns valid millisecond timestamp',
        test: () => {
          const unixMs = timeUtils.unixMs();
          return typeof unixMs === 'number' && unixMs > 0 && unixMs > 1e12;
        }
      },
      {
        name: 'isValid() correctly validates timestamps',
        test: () => {
          return timeUtils.isValid(1234567890) && 
                 timeUtils.isValid('2023-01-01T00:00:00Z') &&
                 timeUtils.isValid(new Date()) &&
                 !timeUtils.isValid('invalid') &&
                 !timeUtils.isValid(null);
        }
      }
    ];

    this.runTests('Basic Time Functions', tests);
  }

  /**
   * Test time formatting
   */
  async testTimeFormatting() {
    console.log('📋 Testing Time Formatting...');
    
    const now = new Date();
    const unix = Math.floor(now.getTime() / 1000);
    
    const tests = [
      {
        name: 'format() with ISO format',
        test: () => {
          const formatted = timeUtils.format(now, 'iso');
          return /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z$/.test(formatted);
        }
      },
      {
        name: 'format() with short format',
        test: () => {
          const formatted = timeUtils.format(now, 'short');
          return /^\d{4}-\d{2}-\d{2}$/.test(formatted);
        }
      },
      {
        name: 'format() with time format',
        test: () => {
          const formatted = timeUtils.format(now, 'time');
          return /^\d{2}:\d{2}:\d{2}$/.test(formatted);
        }
      },
      {
        name: 'format() with datetime format',
        test: () => {
          const formatted = timeUtils.format(now, 'datetime');
          return /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/.test(formatted);
        }
      },
      {
        name: 'unixToDate() converts correctly',
        test: () => {
          const date = timeUtils.unixToDate(unix);
          return typeof date === 'string' && date.includes('GMT');
        }
      },
      {
        name: 'unixToISO() converts correctly',
        test: () => {
          const iso = timeUtils.unixToISO(unix);
          return /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z$/.test(iso);
        }
      }
    ];

    this.runTests('Time Formatting', tests);
  }

  /**
   * Test vesting calculations
   */
  async testVestingCalculations() {
    console.log('📋 Testing Vesting Calculations...');
    
    const now = timeUtils.unix();
    const startTime = now - 86400; // 1 day ago
    const duration = 2592000; // 30 days
    
    const tests = [
      {
        name: 'vestingProgress() calculates correctly',
        test: () => {
          const progress = timeUtils.vestingProgress(startTime, duration);
          return progress.progress > 0 && 
                 progress.progress < 100 && 
                 progress.isActive && 
                 !progress.isCompleted;
        }
      },
      {
        name: 'timeRemaining() calculates correctly',
        test: () => {
          const future = now + 86400; // 1 day from now
          const remaining = timeUtils.timeRemaining(future);
          return remaining.total > 0 && 
                 remaining.days >= 0 && 
                 remaining.hours >= 0;
        }
      },
      {
        name: 'timeElapsed() calculates correctly',
        test: () => {
          const past = now - 86400; // 1 day ago
          const elapsed = timeUtils.timeElapsed(past);
          return elapsed.total > 0 && 
                 elapsed.days >= 0 && 
                 elapsed.hours >= 0;
        }
      },
      {
        name: 'vestingProgress() handles completed vesting',
        test: () => {
          const oldStart = now - 2592000; // 30 days ago
          const progress = timeUtils.vestingProgress(oldStart, duration);
          return progress.isCompleted && 
                 progress.progress === 100;
        }
      },
      {
        name: 'vestingProgress() handles pending vesting',
        test: () => {
          const futureStart = now + 86400; // 1 day from now
          const progress = timeUtils.vestingProgress(futureStart, duration);
          return progress.isPending && 
                 progress.progress === 0;
        }
      }
    ];

    this.runTests('Vesting Calculations', tests);
  }

  /**
   * Test time synchronization
   */
  async testTimeSync() {
    console.log('📋 Testing Time Synchronization...');
    
    const tests = [
      {
        name: 'timeSync starts successfully',
        test: () => {
          const status = timeSync.getStatus();
          return status.isSyncing === true;
        }
      },
      {
        name: 'timeSync provides status',
        test: () => {
          const status = timeSync.getStatus();
          return typeof status.lastSync === 'string' && 
                 typeof status.timeDrift === 'number' &&
                 typeof status.isDriftExcessive === 'boolean';
        }
      },
      {
        name: 'getCorrectedTime() returns valid timestamp',
        test: () => {
          const corrected = timeSync.getCorrectedTime();
          return typeof corrected === 'number' && corrected > 0;
        }
      },
      {
        name: 'getCorrectedISO() returns valid ISO string',
        test: () => {
          const corrected = timeSync.getCorrectedISO();
          return /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z$/.test(corrected);
        }
      }
    ];

    this.runTests('Time Synchronization', tests);
  }

  /**
   * Test timezone handling
   */
  async testTimezoneHandling() {
    console.log('📋 Testing Timezone Handling...');
    
    const tests = [
      {
        name: 'getTimezoneInfo() returns valid info',
        test: () => {
          const info = timeUtils.getTimezoneInfo();
          return typeof info.timezone === 'string' &&
                 typeof info.offset === 'number' &&
                 typeof info.utc === 'string' &&
                 typeof info.local === 'string' &&
                 typeof info.iso === 'string';
        }
      },
      {
        name: 'format() with local format works',
        test: () => {
          const now = new Date();
          const formatted = timeUtils.format(now, 'local');
          return typeof formatted === 'string' && formatted.length > 0;
        }
      }
    ];

    this.runTests('Timezone Handling', tests);
  }

  /**
   * Test edge cases
   */
  async testEdgeCases() {
    console.log('📋 Testing Edge Cases...');
    
    const tests = [
      {
        name: 'Handles invalid timestamps gracefully',
        test: () => {
          try {
            const result = timeUtils.format('invalid', 'iso');
            return result === 'Invalid Date';
          } catch (error) {
            return false;
          }
        }
      },
      {
        name: 'Handles null/undefined timestamps',
        test: () => {
          try {
            const result1 = timeUtils.format(null, 'iso');
            const result2 = timeUtils.format(undefined, 'iso');
            return typeof result1 === 'string' && typeof result2 === 'string';
          } catch (error) {
            return false;
          }
        }
      },
      {
        name: 'Handles zero timestamps',
        test: () => {
          const result = timeUtils.format(0, 'iso');
          return /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z$/.test(result);
        }
      },
      {
        name: 'Handles very large timestamps',
        test: () => {
          const large = 9999999999999; // Very large timestamp
          const result = timeUtils.format(large, 'iso');
          return /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z$/.test(result);
        }
      }
    ];

    this.runTests('Edge Cases', tests);
  }

  /**
   * Run a set of tests
   */
  runTests(category, tests) {
    let passed = 0;
    let failed = 0;

    for (const test of tests) {
      try {
        const result = test.test();
        if (result) {
          console.log(`  ✅ ${test.name}`);
          passed++;
        } else {
          console.log(`  ❌ ${test.name}`);
          failed++;
        }
      } catch (error) {
        console.log(`  ❌ ${test.name} - Error: ${error.message}`);
        failed++;
      }
    }

    this.results.push({ category, passed, failed, total: passed + failed });
    console.log(`  📊 ${category}: ${passed}/${passed + failed} passed\n`);
  }

  /**
   * Show final results
   */
  showResults() {
    console.log('📊 Time Validation Results');
    console.log('==========================\n');

    let totalPassed = 0;
    let totalFailed = 0;

    for (const result of this.results) {
      console.log(`${result.category}: ${result.passed}/${result.total} passed`);
      totalPassed += result.passed;
      totalFailed += result.failed;
    }

    console.log(`\nOverall: ${totalPassed}/${totalPassed + totalFailed} passed`);
    
    if (totalFailed === 0) {
      console.log('\n🎉 All time validation tests passed!');
      console.log('✅ Time handling is accurate and reliable.');
    } else {
      console.log(`\n⚠️  ${totalFailed} tests failed.`);
      console.log('❌ Time handling needs attention.');
    }

    // Show time sync status
    const timeStatus = timeSync.getStatus();
    console.log(`\n⏰ Time Sync Status:`);
    console.log(`   Last Sync: ${timeStatus.lastSync || 'Never'}`);
    console.log(`   Time Drift: ${timeStatus.timeDrift}ms`);
    console.log(`   Accurate: ${timeStatus.isTimeAccurate() ? '✅' : '❌'}`);
  }
}

// Run validation if called directly
if (import.meta.url === `file://${process.argv[1]}`) {
  const validator = new TimeValidator();
  validator.runAllTests().catch(console.error);
}

export { TimeValidator };
export default TimeValidator;
