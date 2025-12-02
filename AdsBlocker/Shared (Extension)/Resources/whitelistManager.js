/**
 * Whitelist Manager Module
 * Manages site-specific whitelisting and dynamic rule creation
 */

const STORAGE_KEYS = {
  whitelist: 'whitelisted_domains'
};

// Dynamic rule ID range: 100000-109999 (reserved for whitelist rules)
const DYNAMIC_RULE_ID_START = 100000;
const DYNAMIC_RULE_PRIORITY = 100; // Higher priority than blocking rules

/**
 * Get whitelisted domains from storage
 */
async function getWhitelistedDomains() {
  const result = await browser.storage.local.get(STORAGE_KEYS.whitelist);
  return result[STORAGE_KEYS.whitelist] || [];
}

/**
 * Save whitelisted domains to storage
 */
async function saveWhitelistedDomains(domains) {
  await browser.storage.local.set({
    [STORAGE_KEYS.whitelist]: domains
  });
}

/**
 * Extract domain from URL
 */
function extractDomain(url) {
  try {
    const urlObj = new URL(url);
    return urlObj.hostname;
  } catch (error) {
    console.error('Error extracting domain:', error);
    return null;
  }
}

/**
 * Check if domain is whitelisted
 */
async function isWhitelisted(domain) {
  const whitelist = await getWhitelistedDomains();
  return whitelist.includes(domain);
}

/**
 * Add domain to whitelist
 */
async function addToWhitelist(url) {
  const domain = extractDomain(url);
  if (!domain) {
    return { success: false, error: 'Invalid URL' };
  }

  const whitelist = await getWhitelistedDomains();

  if (whitelist.includes(domain)) {
    return { success: false, error: 'Domain already whitelisted' };
  }

  whitelist.push(domain);
  await saveWhitelistedDomains(whitelist);

  // Create dynamic rule to allow this domain
  await createWhitelistRule(domain, whitelist.length - 1);

  return { success: true, domain };
}

/**
 * Remove domain from whitelist
 */
async function removeFromWhitelist(domain) {
  const whitelist = await getWhitelistedDomains();
  const index = whitelist.indexOf(domain);

  if (index === -1) {
    return { success: false, error: 'Domain not in whitelist' };
  }

  whitelist.splice(index, 1);
  await saveWhitelistedDomains(whitelist);

  // Remove the dynamic rule for this domain
  await removeWhitelistRule(index);

  return { success: true, domain };
}

/**
 * Create a dynamic allow rule for a whitelisted domain
 */
async function createWhitelistRule(domain, index) {
  try {
    const ruleId = DYNAMIC_RULE_ID_START + index;

    const rule = {
      id: ruleId,
      priority: DYNAMIC_RULE_PRIORITY,
      action: {
        type: 'allow'
      },
      condition: {
        urlFilter: `||${domain}^`,
        resourceTypes: [
          'main_frame',
          'sub_frame',
          'script',
          'image',
          'stylesheet',
          'xmlhttprequest'
        ]
      }
    };

    await browser.declarativeNetRequest.updateDynamicRules({
      addRules: [rule],
      removeRuleIds: []
    });

    console.log(`Created whitelist rule for ${domain} (ID: ${ruleId})`);
    return { success: true, ruleId };
  } catch (error) {
    console.error('Error creating whitelist rule:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Remove a dynamic whitelist rule
 */
async function removeWhitelistRule(index) {
  try {
    const ruleId = DYNAMIC_RULE_ID_START + index;

    await browser.declarativeNetRequest.updateDynamicRules({
      addRules: [],
      removeRuleIds: [ruleId]
    });

    console.log(`Removed whitelist rule ID: ${ruleId}`);
    return { success: true };
  } catch (error) {
    console.error('Error removing whitelist rule:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Rebuild all whitelist rules (useful after extension update/reinstall)
 */
async function rebuildWhitelistRules() {
  try {
    // Clear all existing dynamic rules
    const existingRules = await browser.declarativeNetRequest.getDynamicRules();
    const ruleIdsToRemove = existingRules.map(rule => rule.id);

    if (ruleIdsToRemove.length > 0) {
      await browser.declarativeNetRequest.updateDynamicRules({
        addRules: [],
        removeRuleIds: ruleIdsToRemove
      });
    }

    // Recreate rules for all whitelisted domains
    const whitelist = await getWhitelistedDomains();
    const rulesToAdd = [];

    whitelist.forEach((domain, index) => {
      const ruleId = DYNAMIC_RULE_ID_START + index;
      rulesToAdd.push({
        id: ruleId,
        priority: DYNAMIC_RULE_PRIORITY,
        action: {
          type: 'allow'
        },
        condition: {
          urlFilter: `||${domain}^`,
          resourceTypes: [
            'main_frame',
            'sub_frame',
            'script',
            'image',
            'stylesheet',
            'xmlhttprequest'
          ]
        }
      });
    });

    if (rulesToAdd.length > 0) {
      await browser.declarativeNetRequest.updateDynamicRules({
        addRules: rulesToAdd,
        removeRuleIds: []
      });
    }

    console.log(`Rebuilt ${rulesToAdd.length} whitelist rules`);
    return { success: true, count: rulesToAdd.length };
  } catch (error) {
    console.error('Error rebuilding whitelist rules:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Clear all whitelisted domains
 */
async function clearWhitelist() {
  try {
    // Remove all dynamic rules
    const existingRules = await browser.declarativeNetRequest.getDynamicRules();
    const ruleIdsToRemove = existingRules.map(rule => rule.id);

    if (ruleIdsToRemove.length > 0) {
      await browser.declarativeNetRequest.updateDynamicRules({
        addRules: [],
        removeRuleIds: ruleIdsToRemove
      });
    }

    // Clear storage
    await saveWhitelistedDomains([]);

    return { success: true };
  } catch (error) {
    console.error('Error clearing whitelist:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Get current tab URL
 */
async function getCurrentTabUrl() {
  try {
    const tabs = await browser.tabs.query({ active: true, currentWindow: true });
    if (tabs.length > 0) {
      return tabs[0].url;
    }
    return null;
  } catch (error) {
    console.error('Error getting current tab URL:', error);
    return null;
  }
}

/**
 * Get current tab domain
 */
async function getCurrentTabDomain() {
  const url = await getCurrentTabUrl();
  if (url) {
    return extractDomain(url);
  }
  return null;
}

// Export functions
export {
  STORAGE_KEYS,
  DYNAMIC_RULE_ID_START,
  DYNAMIC_RULE_PRIORITY,
  getWhitelistedDomains,
  saveWhitelistedDomains,
  extractDomain,
  isWhitelisted,
  addToWhitelist,
  removeFromWhitelist,
  createWhitelistRule,
  removeWhitelistRule,
  rebuildWhitelistRules,
  clearWhitelist,
  getCurrentTabUrl,
  getCurrentTabDomain
};
