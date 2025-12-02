/**
 * Popup Script for AdsBlocker
 * Handles UI interactions and displays blocking statistics
 */

// DOM Elements
let totalBlockedElement;
let adsToggleElement;
let trackingToggleElement;
let resetButtonElement;
let currentDomainElement;
let siteStatusElement;
let toggleWhitelistButton;
let whitelistContainer;
let whitelistItemsElement;

// Initialize popup when DOM is loaded
document.addEventListener('DOMContentLoaded', async () => {
  console.log('Popup loaded');

  // Get DOM elements
  totalBlockedElement = document.getElementById('total-blocked');
  adsToggleElement = document.getElementById('toggle-ads');
  trackingToggleElement = document.getElementById('toggle-tracking');
  resetButtonElement = document.getElementById('reset-stats');
  currentDomainElement = document.getElementById('current-domain');
  siteStatusElement = document.getElementById('site-status');
  toggleWhitelistButton = document.getElementById('toggle-whitelist');
  whitelistContainer = document.getElementById('whitelist-container');
  whitelistItemsElement = document.getElementById('whitelist-items');

  // Load initial data
  await loadStatistics();
  await loadPreferences();
  await loadCurrentSiteInfo();
  await loadWhitelistInfo();

  // Set up event listeners
  setupEventListeners();
});

/**
 * Load and display statistics
 */
async function loadStatistics() {
  try {
    const response = await browser.runtime.sendMessage({ action: 'getStatistics' });

    if (response.success) {
      const stats = response.statistics;
      updateStatisticsDisplay(stats);
    } else {
      console.error('Failed to load statistics:', response.error);
    }
  } catch (error) {
    console.error('Error loading statistics:', error);
  }
}

/**
 * Update statistics display in UI
 */
function updateStatisticsDisplay(statistics) {
  if (totalBlockedElement) {
    totalBlockedElement.textContent = formatNumber(statistics.totalBlocked || 0);
  }

  // Update breakdown if elements exist
  const adsBlockedElement = document.getElementById('ads-blocked');
  const trackingBlockedElement = document.getElementById('tracking-blocked');

  if (adsBlockedElement && statistics.blockedByRuleset) {
    adsBlockedElement.textContent = formatNumber(statistics.blockedByRuleset.ads_ruleset || 0);
  }

  if (trackingBlockedElement && statistics.blockedByRuleset) {
    trackingBlockedElement.textContent = formatNumber(statistics.blockedByRuleset.tracking_ruleset || 0);
  }
}

/**
 * Load and apply user preferences
 */
async function loadPreferences() {
  try {
    const response = await browser.runtime.sendMessage({ action: 'getPreferences' });

    if (response.success) {
      const preferences = response.preferences;

      if (adsToggleElement) {
        adsToggleElement.checked = preferences.ads_ruleset !== false;
      }

      if (trackingToggleElement) {
        trackingToggleElement.checked = preferences.tracking_ruleset !== false;
      }
    } else {
      console.error('Failed to load preferences:', response.error);
    }
  } catch (error) {
    console.error('Error loading preferences:', error);
  }
}

/**
 * Set up event listeners for UI interactions
 */
function setupEventListeners() {
  // Ads toggle
  if (adsToggleElement) {
    adsToggleElement.addEventListener('change', async (event) => {
      await handleToggleChange('ads_ruleset', event.target.checked);
    });
  }

  // Tracking toggle
  if (trackingToggleElement) {
    trackingToggleElement.addEventListener('change', async (event) => {
      await handleToggleChange('tracking_ruleset', event.target.checked);
    });
  }

  // Reset statistics button
  if (resetButtonElement) {
    resetButtonElement.addEventListener('click', async () => {
      await handleResetStatistics();
    });
  }

  // Whitelist toggle button
  if (toggleWhitelistButton) {
    toggleWhitelistButton.addEventListener('click', async () => {
      await handleToggleWhitelist();
    });
  }
}

/**
 * Handle toggle switch changes
 */
async function handleToggleChange(rulesetId, enabled) {
  try {
    const response = await browser.runtime.sendMessage({
      action: 'toggleRuleset',
      rulesetId: rulesetId,
      enabled: enabled
    });

    if (response.success) {
      console.log(`Ruleset ${rulesetId} ${enabled ? 'enabled' : 'disabled'}`);
      showNotification(`${enabled ? 'Enabled' : 'Disabled'} ${getRulesetName(rulesetId)}`);
    } else {
      console.error('Failed to toggle ruleset:', response.error);
      showNotification('Failed to update settings', true);
      // Revert toggle on failure
      if (rulesetId === 'ads_ruleset' && adsToggleElement) {
        adsToggleElement.checked = !enabled;
      } else if (rulesetId === 'tracking_ruleset' && trackingToggleElement) {
        trackingToggleElement.checked = !enabled;
      }
    }
  } catch (error) {
    console.error('Error toggling ruleset:', error);
    showNotification('Error updating settings', true);
  }
}

/**
 * Handle reset statistics button click
 */
async function handleResetStatistics() {
  if (!confirm('Are you sure you want to reset all statistics?')) {
    return;
  }

  try {
    const response = await browser.runtime.sendMessage({ action: 'resetStatistics' });

    if (response.success) {
      updateStatisticsDisplay(response.statistics);
      showNotification('Statistics reset successfully');
    } else {
      console.error('Failed to reset statistics:', response.error);
      showNotification('Failed to reset statistics', true);
    }
  } catch (error) {
    console.error('Error resetting statistics:', error);
    showNotification('Error resetting statistics', true);
  }
}

/**
 * Get human-readable ruleset name
 */
function getRulesetName(rulesetId) {
  const names = {
    'ads_ruleset': 'Ad Blocking',
    'tracking_ruleset': 'Tracking Protection'
  };
  return names[rulesetId] || rulesetId;
}

/**
 * Format number with thousands separators
 */
function formatNumber(num) {
  return num.toLocaleString();
}

/**
 * Show notification message
 */
function showNotification(message, isError = false) {
  const notificationElement = document.getElementById('notification');
  if (notificationElement) {
    notificationElement.textContent = message;
    notificationElement.className = isError ? 'notification error' : 'notification success';
    notificationElement.style.display = 'block';

    setTimeout(() => {
      notificationElement.style.display = 'none';
    }, 3000);
  } else {
    console.log('Notification:', message);
  }
}

/**
 * Load current site information
 */
async function loadCurrentSiteInfo() {
  try {
    const response = await browser.runtime.sendMessage({ action: 'getCurrentSite' });

    if (response.success) {
      const { domain, isWhitelisted } = response;

      if (currentDomainElement) {
        currentDomainElement.textContent = domain || 'Unknown';
      }

      if (siteStatusElement) {
        if (isWhitelisted) {
          siteStatusElement.textContent = 'Protection disabled on this site';
          siteStatusElement.className = 'site-status-text whitelisted';
        } else {
          siteStatusElement.textContent = 'Protected';
          siteStatusElement.className = 'site-status-text protected';
        }
      }

      if (toggleWhitelistButton) {
        if (isWhitelisted) {
          toggleWhitelistButton.textContent = 'Remove from Whitelist';
          toggleWhitelistButton.classList.add('whitelisted');
        } else {
          toggleWhitelistButton.textContent = 'Add to Whitelist';
          toggleWhitelistButton.classList.remove('whitelisted');
        }
      }
    }
  } catch (error) {
    console.error('Error loading current site info:', error);
    if (currentDomainElement) {
      currentDomainElement.textContent = 'Error loading site';
    }
  }
}

/**
 * Load whitelist information
 */
async function loadWhitelistInfo() {
  try {
    const response = await browser.runtime.sendMessage({ action: 'getWhitelist' });

    if (response.success) {
      const whitelist = response.whitelist;

      if (whitelist.length > 0) {
        displayWhitelistItems(whitelist);
        if (whitelistContainer) {
          whitelistContainer.style.display = 'block';
        }
      } else {
        if (whitelistContainer) {
          whitelistContainer.style.display = 'none';
        }
      }
    }
  } catch (error) {
    console.error('Error loading whitelist:', error);
  }
}

/**
 * Display whitelist items
 */
function displayWhitelistItems(whitelist) {
  if (!whitelistItemsElement) return;

  whitelistItemsElement.innerHTML = '';

  if (whitelist.length === 0) {
    whitelistItemsElement.innerHTML = '<div class="whitelist-empty">No whitelisted sites</div>';
    return;
  }

  whitelist.forEach(domain => {
    const itemElement = document.createElement('div');
    itemElement.className = 'whitelist-item';

    const domainElement = document.createElement('div');
    domainElement.className = 'whitelist-item-domain';
    domainElement.textContent = domain;

    const removeButton = document.createElement('button');
    removeButton.className = 'whitelist-item-remove';
    removeButton.textContent = '×';
    removeButton.title = 'Remove from whitelist';
    removeButton.addEventListener('click', async () => {
      await handleRemoveFromWhitelist(domain);
    });

    itemElement.appendChild(domainElement);
    itemElement.appendChild(removeButton);
    whitelistItemsElement.appendChild(itemElement);
  });
}

/**
 * Handle whitelist toggle button click
 */
async function handleToggleWhitelist() {
  try {
    const response = await browser.runtime.sendMessage({ action: 'toggleCurrentSiteWhitelist' });

    if (response.success) {
      showNotification(response.message);
      await loadCurrentSiteInfo();
      await loadWhitelistInfo();
    } else {
      showNotification(response.error || 'Failed to update whitelist', true);
    }
  } catch (error) {
    console.error('Error toggling whitelist:', error);
    showNotification('Error updating whitelist', true);
  }
}

/**
 * Handle remove from whitelist
 */
async function handleRemoveFromWhitelist(domain) {
  try {
    const response = await browser.runtime.sendMessage({
      action: 'removeFromWhitelist',
      domain: domain
    });

    if (response.success) {
      showNotification(`Removed ${domain} from whitelist`);
      await loadCurrentSiteInfo();
      await loadWhitelistInfo();
    } else {
      showNotification(response.error || 'Failed to remove from whitelist', true);
    }
  } catch (error) {
    console.error('Error removing from whitelist:', error);
    showNotification('Error removing from whitelist', true);
  }
}
