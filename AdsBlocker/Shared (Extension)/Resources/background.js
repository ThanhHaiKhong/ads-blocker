import {
  initializeRulesets,
  toggleRuleset,
  getRulesetPreferences,
  getStatistics,
  incrementBlockedCount,
  resetStatistics,
  getRulesetInfo,
  getBlockingAnalytics,
  RULESETS
} from './ruleLoader.js';

import {
  getWhitelistedDomains,
  isWhitelisted,
  addToWhitelist,
  removeFromWhitelist,
  rebuildWhitelistRules,
  getCurrentTabUrl,
  getCurrentTabDomain,
  extractDomain
} from './whitelistManager.js';

// Initialize rulesets when extension is installed or updated
browser.runtime.onInstalled.addListener(async (details) => {
  console.log('Extension installed/updated:', details.reason);

  if (details.reason === 'install' || details.reason === 'update') {
    const result = await initializeRulesets();
    console.log('Rulesets initialization result:', result);

    // Rebuild whitelist rules
    const whitelistResult = await rebuildWhitelistRules();
    console.log('Whitelist rebuild result:', whitelistResult);
  }
});

// Handle messages from popup and content scripts
browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
  console.log("Received request:", request);

  // Handle async operations properly
  (async () => {
    try {
      switch (request.action) {
        case 'toggleRuleset':
          const toggleResult = await toggleRuleset(request.rulesetId, request.enabled);
          sendResponse(toggleResult);
          break;

        case 'getPreferences':
          const preferences = await getRulesetPreferences();
          sendResponse({ success: true, preferences });
          break;

        case 'getStatistics':
          const statistics = await getStatistics();
          sendResponse({ success: true, statistics });
          break;

        case 'resetStatistics':
          const resetStats = await resetStatistics();
          sendResponse({ success: true, statistics: resetStats });
          break;

        case 'getRulesetInfo':
          const rulesetInfo = getRulesetInfo();
          sendResponse({ success: true, rulesetInfo });
          break;

        case 'getAnalytics':
          const analytics = await getBlockingAnalytics();
          sendResponse({ success: true, analytics });
          break;

        case 'addTestStatistics':
          // Developer tool to add test statistics
          const stats = await getStatistics();
          stats.totalBlocked = (stats.totalBlocked || 0) + (request.count || 100);
          stats.blockedByRuleset.ads_ruleset = (stats.blockedByRuleset.ads_ruleset || 0) + Math.floor((request.count || 100) * 0.6);
          stats.blockedByRuleset.tracking_ruleset = (stats.blockedByRuleset.tracking_ruleset || 0) + Math.floor((request.count || 100) * 0.4);
          await saveStatistics(stats);
          sendResponse({ success: true, statistics: stats });
          break;

        case 'incrementBlock':
          // Manual increment for testing
          const incrementResult = await incrementBlockedCount(request.domain, request.rulesetId);
          sendResponse({ success: true, statistics: incrementResult });
          break;

        case 'checkWhitelist':
          if (request.domain) {
            const isWhitelistedDomain = await isWhitelisted(request.domain);
            sendResponse({ success: true, isWhitelisted: isWhitelistedDomain });
          } else {
            sendResponse({ success: false, error: 'No domain provided' });
          }
          break;

        case 'toggleWhitelist':
          if (!request.domain) {
            sendResponse({ success: false, error: 'No domain provided' });
            break;
          }

          const isDomainWhitelisted = await isWhitelisted(request.domain);

          if (isDomainWhitelisted) {
            // Remove from whitelist
            const removeResult = await removeFromWhitelist(request.domain);
            if (removeResult.success) {
              sendResponse({ success: true, message: `Removed ${request.domain} from whitelist`, isWhitelisted: false });
            } else {
              sendResponse({ success: false, error: removeResult.error });
            }
          } else {
            // Add to whitelist
            const addResult = await addToWhitelist(request.url || `https://${request.domain}`);
            if (addResult.success) {
              sendResponse({ success: true, message: `Added ${request.domain} to whitelist`, isWhitelisted: true });
            } else {
              sendResponse({ success: false, error: addResult.error });
            }
          }
          break;

        case 'getWhitelist':
          const whitelist = await getWhitelistedDomains();
          sendResponse({ success: true, whitelist });
          break;

        case 'removeFromWhitelist':
          const removeWhitelistResult = await removeFromWhitelist(request.domain);
          if (removeWhitelistResult.success) {
            sendResponse({ success: true, message: `Removed ${request.domain} from whitelist` });
          } else {
            sendResponse({ success: false, error: removeWhitelistResult.error });
          }
          break;

        // Legacy support
        case 'hello':
          sendResponse({ farewell: 'goodbye' });
          break;

        default:
          sendResponse({ success: false, error: 'Unknown action' });
      }
    } catch (error) {
      console.error('Error handling message:', error);
      sendResponse({ success: false, error: error.message });
    }
  })();

  // Return true to indicate we'll send response asynchronously
  return true;
});

// Track blocked requests for statistics
// Note: Safari may not support onRuleMatchedDebug, so we'll try both methods
if (browser.declarativeNetRequest.onRuleMatchedDebug) {
  // Chrome/Edge style
  browser.declarativeNetRequest.onRuleMatchedDebug.addListener(async (details) => {
    console.log('[Background] Rule matched:', details);

    // Determine which ruleset was triggered
    const ruleId = details.rule.rulesetId;

    // Increment statistics
    await incrementBlockedCount(null, ruleId);
  });
} else {
  console.log('[Background] onRuleMatchedDebug not available - using alternative tracking');

  // Alternative: Use webRequest to detect blocked requests (if available)
  // This is a fallback for Safari which may not support onRuleMatchedDebug
  if (browser.webRequest && browser.webRequest.onBeforeRequest) {
    console.log('[Background] Using webRequest for tracking');

    // This won't work perfectly in Manifest V3, but we'll try
    // In production, statistics will need to be tracked differently
  }
}

// Periodic statistics sync (every 30 seconds)
setInterval(async () => {
  try {
    const stats = await getStatistics();
    console.log('[Background] Current statistics:', stats);
  } catch (error) {
    console.error('[Background] Error syncing statistics:', error);
  }
}, 30000);
