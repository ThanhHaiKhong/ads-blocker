/**
 * Rule Loader Module
 * Manages loading, updating, and state management of declarativeNetRequest rules
 */

const RULESETS = {
  ads: 'ads_ruleset',
  tracking: 'tracking_ruleset'
};

const STORAGE_KEYS = {
  preferences: 'ruleset_preferences',
  statistics: 'blocking_statistics'
};

/**
 * Initialize default preferences for rulesets
 */
async function getDefaultPreferences() {
  return {
    [RULESETS.ads]: true,
    [RULESETS.tracking]: true
  };
}

/**
 * Get current ruleset preferences from storage
 */
async function getRulesetPreferences() {
  const result = await browser.storage.local.get(STORAGE_KEYS.preferences);
  if (!result[STORAGE_KEYS.preferences]) {
    const defaults = await getDefaultPreferences();
    await saveRulesetPreferences(defaults);
    return defaults;
  }
  return result[STORAGE_KEYS.preferences];
}

/**
 * Save ruleset preferences to storage
 */
async function saveRulesetPreferences(preferences) {
  await browser.storage.local.set({
    [STORAGE_KEYS.preferences]: preferences
  });
}

/**
 * Toggle a specific ruleset on or off
 */
async function toggleRuleset(rulesetId, enabled) {
  try {
    await browser.declarativeNetRequest.updateEnabledRulesets({
      enableRulesetIds: enabled ? [rulesetId] : [],
      disableRulesetIds: enabled ? [] : [rulesetId]
    });

    const preferences = await getRulesetPreferences();
    preferences[rulesetId] = enabled;
    await saveRulesetPreferences(preferences);

    return { success: true, rulesetId, enabled };
  } catch (error) {
    console.error('Error toggling ruleset:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Get enabled rulesets
 */
async function getEnabledRulesets() {
  try {
    const enabledRulesets = await browser.declarativeNetRequest.getEnabledRulesets();
    return enabledRulesets;
  } catch (error) {
    console.error('Error getting enabled rulesets:', error);
    return [];
  }
}

/**
 * Initialize rulesets based on saved preferences
 */
async function initializeRulesets() {
  try {
    const preferences = await getRulesetPreferences();
    const enabledIds = [];
    const disabledIds = [];

    for (const [rulesetId, isEnabled] of Object.entries(preferences)) {
      if (isEnabled) {
        enabledIds.push(rulesetId);
      } else {
        disabledIds.push(rulesetId);
      }
    }

    if (enabledIds.length > 0 || disabledIds.length > 0) {
      await browser.declarativeNetRequest.updateEnabledRulesets({
        enableRulesetIds: enabledIds,
        disableRulesetIds: disabledIds
      });
    }

    console.log('Rulesets initialized:', { enabled: enabledIds, disabled: disabledIds });
    return { success: true, enabled: enabledIds, disabled: disabledIds };
  } catch (error) {
    console.error('Error initializing rulesets:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Get statistics from storage
 */
async function getStatistics() {
  const result = await browser.storage.local.get(STORAGE_KEYS.statistics);
  if (!result[STORAGE_KEYS.statistics]) {
    const defaultStats = {
      totalBlocked: 0,
      blockedByDomain: {},
      blockedByRuleset: {},
      lastReset: new Date().toISOString()
    };
    await saveStatistics(defaultStats);
    return defaultStats;
  }
  return result[STORAGE_KEYS.statistics];
}

/**
 * Save statistics to storage
 */
async function saveStatistics(statistics) {
  await browser.storage.local.set({
    [STORAGE_KEYS.statistics]: statistics
  });
}

/**
 * Increment blocked count
 */
async function incrementBlockedCount(domain, rulesetId) {
  const stats = await getStatistics();
  stats.totalBlocked = (stats.totalBlocked || 0) + 1;

  // Track by domain
  if (domain) {
    stats.blockedByDomain[domain] = (stats.blockedByDomain[domain] || 0) + 1;
  }

  // Track by ruleset
  if (rulesetId) {
    stats.blockedByRuleset[rulesetId] = (stats.blockedByRuleset[rulesetId] || 0) + 1;
  }

  await saveStatistics(stats);
  return stats;
}

/**
 * Reset statistics
 */
async function resetStatistics() {
  const defaultStats = {
    totalBlocked: 0,
    blockedByDomain: {},
    blockedByRuleset: {},
    lastReset: new Date().toISOString()
  };
  await saveStatistics(defaultStats);
  return defaultStats;
}

/**
 * Get ruleset information
 */
function getRulesetInfo() {
  return {
    [RULESETS.ads]: {
      id: RULESETS.ads,
      name: 'Advertisement Blocking',
      description: 'Blocks advertisements from common ad networks'
    },
    [RULESETS.tracking]: {
      id: RULESETS.tracking,
      name: 'Tracking Protection',
      description: 'Blocks analytics and tracking scripts'
    }
  };
}

// Export functions
export {
  RULESETS,
  STORAGE_KEYS,
  getDefaultPreferences,
  getRulesetPreferences,
  saveRulesetPreferences,
  toggleRuleset,
  getEnabledRulesets,
  initializeRulesets,
  getStatistics,
  saveStatistics,
  incrementBlockedCount,
  resetStatistics,
  getRulesetInfo
};
