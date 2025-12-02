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

        case 'getCurrentSite':
          const currentDomain = await getCurrentTabDomain();
          if (currentDomain && currentDomain !== 'Error') {
            // Don't check whitelist for special pages
            if (currentDomain === 'Browser Page' || currentDomain === 'No Active Tab') {
              sendResponse({ success: true, domain: currentDomain, isWhitelisted: false });
            } else {
              const whitelisted = await isWhitelisted(currentDomain);
              sendResponse({ success: true, domain: currentDomain, isWhitelisted: whitelisted });
            }
          } else {
            sendResponse({ success: false, error: 'Could not get current tab', domain: 'Error' });
          }
          break;

        case 'getWhitelist':
          const whitelist = await getWhitelistedDomains();
          sendResponse({ success: true, whitelist });
          break;

        case 'toggleCurrentSiteWhitelist':
          const tabDomain = await getCurrentTabDomain();
          if (!tabDomain) {
            sendResponse({ success: false, error: 'Could not get current tab' });
            break;
          }

          const isCurrentlyWhitelisted = await isWhitelisted(tabDomain);
          let toggleMessage;

          if (isCurrentlyWhitelisted) {
            const removeResult = await removeFromWhitelist(tabDomain);
            if (removeResult.success) {
              toggleMessage = `Removed ${tabDomain} from whitelist`;
              sendResponse({ success: true, message: toggleMessage, isWhitelisted: false });
            } else {
              sendResponse({ success: false, error: removeResult.error });
            }
          } else {
            const tabUrl = await getCurrentTabUrl();
            const addResult = await addToWhitelist(tabUrl);
            if (addResult.success) {
              toggleMessage = `Added ${tabDomain} to whitelist`;
              sendResponse({ success: true, message: toggleMessage, isWhitelisted: true });
            } else {
              sendResponse({ success: false, error: addResult.error });
            }
          }
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
