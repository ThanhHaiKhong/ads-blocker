import {
  initializeRulesets,
  toggleRuleset,
  getRulesetPreferences,
  getStatistics,
  incrementBlockedCount,
  resetStatistics,
  getRulesetInfo,
  RULESETS
} from './ruleLoader.js';

// Initialize rulesets when extension is installed or updated
browser.runtime.onInstalled.addListener(async (details) => {
  console.log('Extension installed/updated:', details.reason);

  if (details.reason === 'install' || details.reason === 'update') {
    const result = await initializeRulesets();
    console.log('Rulesets initialization result:', result);
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
