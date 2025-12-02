function show(platform, enabled, useSettingsInsteadOfPreferences) {
    document.body.classList.add(`platform-${platform}`);

    if (useSettingsInsteadOfPreferences) {
        const statusMessages = document.getElementsByClassName('status-message');
        for (let msg of statusMessages) {
            if (msg.classList.contains('state-on')) {
                msg.innerText = "AdsBlocker's extension is currently on.";
            } else if (msg.classList.contains('state-off')) {
                msg.innerText = "AdsBlocker's extension is currently off. You can turn it on in the Extensions section of Safari Settings.";
            } else if (msg.classList.contains('state-unknown')) {
                msg.innerText = "You can turn on AdsBlocker's extension in the Extensions section of Safari Settings.";
            }
        }

        const prefsButton = document.querySelector('.open-preferences');
        if (prefsButton) {
            prefsButton.innerText = "Quit and Open Safari Settings…";
        }
    }

    if (typeof enabled === "boolean") {
        document.body.classList.toggle(`state-on`, enabled);
        document.body.classList.toggle(`state-off`, !enabled);

        // Load statistics if extension is enabled
        if (enabled && platform === 'mac') {
            loadStatistics();
        }
    } else {
        document.body.classList.remove(`state-on`);
        document.body.classList.remove(`state-off`);
    }
}

function openPreferences() {
    webkit.messageHandlers.controller.postMessage("open-preferences");
}

function loadStatistics() {
    console.log('[App] Loading statistics from extension...');

    // Request statistics from Swift layer
    webkit.messageHandlers.controller.postMessage("get-statistics");
}

function refreshStatistics() {
    console.log('[App] Refreshing statistics...');
    loadStatistics();
}

function updateStatisticsDisplay(statistics) {
    console.log('[App] Updating statistics display:', statistics);

    if (!statistics) {
        console.error('[App] No statistics data provided');
        return;
    }

    const totalBlocked = statistics.totalBlocked || 0;
    const adsBlocked = (statistics.blockedByRuleset && statistics.blockedByRuleset.ads_ruleset) || 0;
    const trackersBlocked = (statistics.blockedByRuleset && statistics.blockedByRuleset.tracking_ruleset) || 0;

    const totalElement = document.getElementById('total-blocked');
    const adsElement = document.getElementById('ads-blocked');
    const trackersElement = document.getElementById('trackers-blocked');

    if (totalElement) {
        totalElement.textContent = formatNumber(totalBlocked);
    }
    if (adsElement) {
        adsElement.textContent = formatNumber(adsBlocked);
    }
    if (trackersElement) {
        trackersElement.textContent = formatNumber(trackersBlocked);
    }
}

function formatNumber(num) {
    return num.toLocaleString();
}

// Set up event listeners when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    const prefsButton = document.querySelector("button.open-preferences");
    if (prefsButton) {
        prefsButton.addEventListener("click", openPreferences);
    }
});
