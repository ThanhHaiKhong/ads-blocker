/**
 * Debug Helper Module
 * Utilities for testing and debugging the extension
 */

// Debug mode flag (set to false for production)
const DEBUG_MODE = true;

/**
 * Debug logger with categorization
 */
class DebugLogger {
  constructor(prefix, enabled = DEBUG_MODE) {
    this.prefix = prefix;
    this.enabled = enabled;
  }

  log(...args) {
    if (!this.enabled) return;
    console.log(`[${this.prefix}]`, ...args);
  }

  info(...args) {
    if (!this.enabled) return;
    console.info(`[${this.prefix}] ℹ️`, ...args);
  }

  warn(...args) {
    if (!this.enabled) return;
    console.warn(`[${this.prefix}] ⚠️`, ...args);
  }

  error(...args) {
    if (!this.enabled) return;
    console.error(`[${this.prefix}] ❌`, ...args);
  }

  success(...args) {
    if (!this.enabled) return;
    console.log(`[${this.prefix}] ✅`, ...args);
  }

  time(label) {
    if (!this.enabled) return;
    console.time(`[${this.prefix}] ${label}`);
  }

  timeEnd(label) {
    if (!this.enabled) return;
    console.timeEnd(`[${this.prefix}] ${label}`);
  }

  group(label) {
    if (!this.enabled) return;
    console.group(`[${this.prefix}] ${label}`);
  }

  groupEnd() {
    if (!this.enabled) return;
    console.groupEnd();
  }

  table(data) {
    if (!this.enabled) return;
    console.table(data);
  }
}

/**
 * Performance monitor
 */
class PerformanceMonitor {
  constructor() {
    this.metrics = {};
  }

  start(label) {
    this.metrics[label] = {
      startTime: performance.now(),
      endTime: null,
      duration: null
    };
  }

  end(label) {
    if (!this.metrics[label]) {
      console.error(`No performance metric started for: ${label}`);
      return null;
    }

    this.metrics[label].endTime = performance.now();
    this.metrics[label].duration = this.metrics[label].endTime - this.metrics[label].startTime;

    return this.metrics[label].duration;
  }

  get(label) {
    return this.metrics[label];
  }

  getAll() {
    return this.metrics;
  }

  report() {
    console.group('Performance Report');
    Object.entries(this.metrics).forEach(([label, metric]) => {
      if (metric.duration !== null) {
        console.log(`${label}: ${metric.duration.toFixed(2)}ms`);
      } else {
        console.log(`${label}: In progress...`);
      }
    });
    console.groupEnd();
  }

  clear() {
    this.metrics = {};
  }
}

/**
 * Rule effectiveness tracker
 */
class RuleTracker {
  constructor() {
    this.blockedRequests = [];
    this.allowedRequests = [];
  }

  trackBlocked(url, ruleId, resourceType) {
    this.blockedRequests.push({
      url,
      ruleId,
      resourceType,
      timestamp: new Date().toISOString()
    });
  }

  trackAllowed(url, resourceType) {
    this.allowedRequests.push({
      url,
      resourceType,
      timestamp: new Date().toISOString()
    });
  }

  getBlockedCount() {
    return this.blockedRequests.length;
  }

  getAllowedCount() {
    return this.allowedRequests.length;
  }

  getBlockedByRuleId(ruleId) {
    return this.blockedRequests.filter(req => req.ruleId === ruleId);
  }

  getBlockedByResourceType(resourceType) {
    return this.blockedRequests.filter(req => req.resourceType === resourceType);
  }

  getMostBlockedDomains(limit = 10) {
    const domainCounts = {};

    this.blockedRequests.forEach(req => {
      try {
        const url = new URL(req.url);
        const domain = url.hostname;
        domainCounts[domain] = (domainCounts[domain] || 0) + 1;
      } catch (e) {
        // Invalid URL
      }
    });

    return Object.entries(domainCounts)
      .sort((a, b) => b[1] - a[1])
      .slice(0, limit)
      .map(([domain, count]) => ({ domain, count }));
  }

  getReport() {
    return {
      totalBlocked: this.getBlockedCount(),
      totalAllowed: this.getAllowedCount(),
      blockRate: (this.getBlockedCount() / (this.getBlockedCount() + this.getAllowedCount()) * 100).toFixed(2) + '%',
      topBlockedDomains: this.getMostBlockedDomains(5),
      recentBlocked: this.blockedRequests.slice(-10)
    };
  }

  clear() {
    this.blockedRequests = [];
    this.allowedRequests = [];
  }
}

/**
 * Test utilities
 */
const TestUtils = {
  /**
   * Generate test statistics data
   */
  generateTestStatistics(totalBlocked = 1000) {
    const adsBlocked = Math.floor(totalBlocked * 0.6);
    const trackingBlocked = totalBlocked - adsBlocked;

    return {
      totalBlocked,
      blockedByDomain: {
        'doubleclick.net': Math.floor(adsBlocked * 0.3),
        'google-analytics.com': Math.floor(trackingBlocked * 0.4),
        'facebook.com': Math.floor(adsBlocked * 0.2),
        'googletagmanager.com': Math.floor(trackingBlocked * 0.3),
        'taboola.com': Math.floor(adsBlocked * 0.15)
      },
      blockedByRuleset: {
        'ads_ruleset': adsBlocked,
        'tracking_ruleset': trackingBlocked
      },
      lastReset: new Date().toISOString()
    };
  },

  /**
   * Test URL matching against patterns
   */
  testUrlPattern(url, pattern) {
    try {
      // Convert declarativeNetRequest pattern to regex
      let regexPattern = pattern
        .replace(/\./g, '\\.')
        .replace(/\*/g, '.*')
        .replace(/\^/g, '[^\\w\\-.]');

      // Handle || prefix (domain anchor)
      if (regexPattern.startsWith('\\|\\|')) {
        regexPattern = '^https?:\\/\\/([^\\/]*\\.)?' + regexPattern.substring(4);
      }

      const regex = new RegExp(regexPattern);
      return regex.test(url);
    } catch (e) {
      console.error('Pattern test error:', e);
      return false;
    }
  },

  /**
   * Validate rule structure
   */
  validateRule(rule) {
    const errors = [];

    if (!rule.id) errors.push('Missing id');
    if (!rule.priority) errors.push('Missing priority');
    if (!rule.action || !rule.action.type) errors.push('Missing or invalid action');
    if (!rule.condition) errors.push('Missing condition');
    if (rule.condition && !rule.condition.urlFilter) errors.push('Missing urlFilter');

    return {
      valid: errors.length === 0,
      errors
    };
  },

  /**
   * Simulate page load with requests
   */
  async simulatePageLoad(urls) {
    const results = [];

    for (const url of urls) {
      try {
        const start = performance.now();
        // In real implementation, this would check against rules
        const blocked = url.includes('ads') || url.includes('tracking');
        const end = performance.now();

        results.push({
          url,
          blocked,
          processingTime: end - start
        });
      } catch (e) {
        results.push({
          url,
          error: e.message
        });
      }
    }

    return results;
  }
};

/**
 * Diagnostic information collector
 */
async function collectDiagnostics() {
  const diagnostics = {
    timestamp: new Date().toISOString(),
    browser: {
      userAgent: navigator.userAgent,
      vendor: navigator.vendor,
      language: navigator.language
    },
    extension: {
      manifest: browser.runtime.getManifest(),
      id: browser.runtime.id
    },
    permissions: {},
    storage: {},
    rules: {}
  };

  // Check permissions
  try {
    const permissions = await browser.permissions.getAll();
    diagnostics.permissions = permissions;
  } catch (e) {
    diagnostics.permissions.error = e.message;
  }

  // Check storage
  try {
    const storage = await browser.storage.local.get(null);
    diagnostics.storage = {
      keys: Object.keys(storage),
      size: JSON.stringify(storage).length
    };
  } catch (e) {
    diagnostics.storage.error = e.message;
  }

  // Check rules
  try {
    const dynamicRules = await browser.declarativeNetRequest.getDynamicRules();
    diagnostics.rules.dynamic = {
      count: dynamicRules.length,
      ids: dynamicRules.map(r => r.id)
    };
  } catch (e) {
    diagnostics.rules.error = e.message;
  }

  return diagnostics;
}

// Export for use in other modules
export {
  DEBUG_MODE,
  DebugLogger,
  PerformanceMonitor,
  RuleTracker,
  TestUtils,
  collectDiagnostics
};
