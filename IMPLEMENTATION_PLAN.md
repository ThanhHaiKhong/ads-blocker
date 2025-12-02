# Safari Content Blocker Implementation Plan

## Executive Summary

This plan outlines the implementation of ad blocking functionality using Safari's Content Blocking API with declarativeNetRequest for the AdsBlocker Safari extension on iOS and macOS.

## Architecture Overview

### Safari Content Blocking Approaches

Safari supports two primary approaches for content blocking:

1. **declarativeNetRequest API** (Manifest V3 - Recommended)
   - Modern, cross-browser compatible approach
   - Rules defined in JSON format
   - Efficient, runs in browser process
   - Supports dynamic rule updates

2. **Legacy Content Blocker Extension** (Safari-specific)
   - Uses `SFContentBlockerManager` (Swift)
   - Separate app extension type
   - Less flexible, requires app updates for rule changes

**Chosen Approach**: declarativeNetRequest API (Manifest V3) for cross-platform compatibility and modern standards.

## Implementation Phases

### Phase 1: Core Infrastructure Setup

#### 1.1 Update Extension Manifest
**File**: `AdsBlocker/Shared (Extension)/Resources/manifest.json`

**Changes**:
- Add `declarativeNetRequest` and `declarativeNetRequestWithHostAccess` permissions
- Remove or update content_scripts to match all URLs
- Add `host_permissions` for all websites
- Define `declarative_net_request` rules configuration

**Example**:
```json
{
  "manifest_version": 3,
  "permissions": [
    "declarativeNetRequest",
    "declarativeNetRequestWithHostAccess",
    "storage"
  ],
  "host_permissions": [
    "<all_urls>"
  ],
  "declarative_net_request": {
    "rule_resources": [
      {
        "id": "ads_ruleset",
        "enabled": true,
        "path": "rules/ads.json"
      },
      {
        "id": "tracking_ruleset",
        "enabled": true,
        "path": "rules/tracking.json"
      }
    ]
  }
}
```

#### 1.2 Create Rules Directory Structure
**New Directory**: `AdsBlocker/Shared (Extension)/Resources/rules/`

**Files to Create**:
- `rules/ads.json` - Advertisement blocking rules
- `rules/tracking.json` - Tracking/analytics blocking rules
- `rules/social.json` - Social media widget blocking rules (optional)
- `rules/annoyances.json` - Cookie banners, popups, etc. (optional)

#### 1.3 Rule JSON Format
Each rule file follows this structure:
```json
[
  {
    "id": 1,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "||ads.example.com^",
      "resourceTypes": ["script", "image", "xmlhttprequest"]
    }
  },
  {
    "id": 2,
    "priority": 1,
    "action": {
      "type": "block"
    },
    "condition": {
      "urlFilter": "||doubleclick.net^",
      "resourceTypes": ["script", "subdocument"]
    }
  }
]
```

**Rule Components**:
- `id`: Unique identifier (1-based, must be unique across all rulesets)
- `priority`: Higher priority rules override lower (default: 1)
- `action.type`: `block`, `allow`, `redirect`, `upgradeScheme`, `modifyHeaders`
- `condition.urlFilter`: Pattern matching syntax (similar to EasyList)
- `condition.resourceTypes`: What to block (script, image, stylesheet, etc.)

### Phase 2: Rule Management System

#### 2.1 Rule Loader Module
**New File**: `AdsBlocker/Shared (Extension)/Resources/ruleLoader.js`

**Responsibilities**:
- Load rule files from extension bundle
- Validate rule format
- Handle rule updates
- Manage rule enable/disable state

**Key Functions**:
```javascript
async function loadRulesets() {
  // Load all rule files
}

async function updateDynamicRules(ruleset, enabled) {
  // Enable/disable specific rulesets
}

async function getRuleStats() {
  // Get blocking statistics
}
```

#### 2.2 Update Background Script
**File**: `AdsBlocker/Shared (Extension)/Resources/background.js`

**New Functionality**:
- Initialize rules on extension install/update
- Listen for rule toggle requests from popup
- Track blocking statistics
- Handle rule updates

**Implementation**:
```javascript
// Initialize rules on install
chrome.runtime.onInstalled.addListener(async (details) => {
  if (details.reason === 'install' || details.reason === 'update') {
    await initializeRules();
  }
});

// Track blocked requests
chrome.declarativeNetRequest.onRuleMatchedDebug.addListener((details) => {
  updateBlockingStats(details);
});

// Handle messages from popup
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  if (request.action === 'toggleRuleset') {
    toggleRuleset(request.rulesetId, request.enabled);
  } else if (request.action === 'getStats') {
    sendResponse(getBlockingStats());
  }
});
```

#### 2.3 Storage Management
**Purpose**: Persist user preferences and statistics

**Storage Schema**:
```javascript
{
  "preferences": {
    "rulesets": {
      "ads_ruleset": true,
      "tracking_ruleset": true,
      "social_ruleset": false
    }
  },
  "statistics": {
    "totalBlocked": 0,
    "blockedByDomain": {},
    "lastReset": "2025-12-02T00:00:00Z"
  }
}
```

### Phase 3: User Interface

#### 3.1 Enhanced Popup UI
**File**: `AdsBlocker/Shared (Extension)/Resources/popup.html`

**New Features**:
- Display blocking statistics (total blocked, this page, etc.)
- Toggle switches for each ruleset
- "Disable on this site" whitelist option
- Clear statistics button
- Link to full settings page

**UI Sections**:
```html
<!-- Statistics Display -->
<div class="stats-section">
  <h2>Blocked on This Page</h2>
  <div class="stat-number" id="page-blocked">0</div>
  <div class="stat-label">Total Blocked: <span id="total-blocked">0</span></div>
</div>

<!-- Ruleset Toggles -->
<div class="rulesets-section">
  <h3>Protection</h3>
  <label>
    <input type="checkbox" id="toggle-ads" checked>
    Block Advertisements
  </label>
  <label>
    <input type="checkbox" id="toggle-tracking" checked>
    Block Trackers
  </label>
</div>

<!-- Site Controls -->
<div class="site-controls">
  <button id="whitelist-site">Disable on This Site</button>
</div>
```

#### 3.2 Popup Script Enhancement
**File**: `AdsBlocker/Shared (Extension)/Resources/popup.js`

**New Functionality**:
```javascript
// Load and display current statistics
async function loadStats() {
  const stats = await chrome.runtime.sendMessage({ action: 'getStats' });
  document.getElementById('total-blocked').textContent = stats.totalBlocked;
}

// Handle ruleset toggles
document.getElementById('toggle-ads').addEventListener('change', (e) => {
  chrome.runtime.sendMessage({
    action: 'toggleRuleset',
    rulesetId: 'ads_ruleset',
    enabled: e.target.checked
  });
});

// Handle site whitelisting
document.getElementById('whitelist-site').addEventListener('click', async () => {
  const tab = await getCurrentTab();
  await whitelistDomain(tab.url);
});
```

#### 3.3 Popup Styling
**File**: `AdsBlocker/Shared (Extension)/Resources/popup.css`

**Design Considerations**:
- Clean, modern interface
- Clear visual feedback for toggles
- Readable statistics display
- Responsive layout (works on different popup sizes)

### Phase 4: Advanced Features

#### 4.1 Site Whitelisting
**Implementation**: Dynamic rules for allowing specific domains

**Approach**:
- Use `chrome.declarativeNetRequest.updateDynamicRules()`
- Create high-priority `allow` rules for whitelisted domains
- Store whitelist in `chrome.storage.sync`

**Example Rule**:
```javascript
{
  id: 100000, // High ID range for dynamic rules
  priority: 100, // Higher than block rules
  action: { type: "allow" },
  condition: {
    urlFilter: "||example.com^",
    resourceTypes: ["main_frame", "sub_frame"]
  }
}
```

#### 4.2 Custom Filter Lists
**Feature**: Allow users to add custom blocking rules

**Implementation**:
- Text area in settings for custom rules
- Parse custom rules and convert to declarativeNetRequest format
- Validate and add as dynamic rules
- Support EasyList syntax subset

#### 4.3 Statistics and Analytics
**Metrics to Track**:
- Total requests blocked
- Blocked requests per domain
- Blocked requests per ruleset
- Blocked requests per page
- Bandwidth saved estimate

**Storage**:
```javascript
{
  "stats": {
    "totalBlocked": 1234,
    "byDomain": {
      "doubleclick.net": 45,
      "google-analytics.com": 89
    },
    "byRuleset": {
      "ads_ruleset": 678,
      "tracking_ruleset": 556
    },
    "lastUpdated": "2025-12-02T10:00:00Z"
  }
}
```

#### 4.4 Settings Page
**New File**: `AdsBlocker/Shared (Extension)/Resources/settings.html`

**Features**:
- Detailed statistics with charts
- Advanced ruleset configuration
- Custom filter list management
- Whitelist management
- Export/import settings
- Reset statistics

### Phase 5: Native App Integration

#### 5.1 Update Host App UI
**File**: `AdsBlocker/Shared (App)/Resources/Base.lproj/Main.html`

**New Content**:
- Extension status display
- Quick stats overview
- Link to Safari extension preferences
- Tutorial/onboarding content

#### 5.2 Native Messaging for Advanced Features
**File**: `AdsBlocker/Shared (Extension)/SafariWebExtensionHandler.swift`

**Optional Features via Native Messaging**:
- Sync settings via iCloud
- Access to system-level ad blocking lists
- Advanced logging and diagnostics
- Share blocked stats with host app

### Phase 6: Rule Sources and Updates

#### 6.1 Initial Blocklists
**Recommended Sources**:

1. **EasyList** (advertisements)
   - URL: `https://easylist.to/easylist/easylist.txt`
   - Most comprehensive ad blocking list

2. **EasyPrivacy** (tracking)
   - URL: `https://easylist.to/easylist/easyprivacy.txt`
   - Blocks analytics and tracking

3. **Peter Lowe's List** (ads and tracking)
   - URL: `https://pgl.yoyo.org/adservers/serverlist.php`
   - Simple, reliable list

4. **Fanboy's Lists** (annoyances)
   - Social media widgets, cookie notices

**Conversion Process**:
- Parse EasyList format (Adblock Plus syntax)
- Convert to declarativeNetRequest JSON format
- Optimize and deduplicate rules
- Split into categories (ads, tracking, etc.)

#### 6.2 Rule Converter Tool
**New File**: `tools/convert-blocklist.js` (Node.js script)

**Purpose**: Convert EasyList format to declarativeNetRequest JSON

**Features**:
- Parse Adblock Plus filter syntax
- Convert to Safari-compatible patterns
- Handle different rule types (||, ^, |, *, etc.)
- Generate optimized JSON output
- Split rules by category

**Example Usage**:
```bash
node tools/convert-blocklist.js \
  --input easylist.txt \
  --output rules/ads.json \
  --category ads \
  --start-id 1
```

#### 6.3 Update Mechanism
**Options**:

**Option A: Manual Updates** (Simple)
- Download blocklists manually
- Run converter script
- Include updated rules in extension update
- Users get updates via App Store

**Option B: Dynamic Updates** (Advanced)
- Extension periodically checks for rule updates
- Downloads and applies new rules dynamically
- Requires server infrastructure
- More complex but better UX

**Recommended**: Start with Option A, migrate to Option B later

### Phase 7: Testing and Optimization

#### 7.1 Testing Strategy

**Functional Testing**:
- Verify ads are blocked on popular sites (YouTube, news sites, etc.)
- Test whitelisting functionality
- Verify statistics accuracy
- Test toggle switches
- Cross-platform testing (iOS and macOS)

**Performance Testing**:
- Measure extension memory usage
- Verify no slowdown in page load times
- Test with large rule sets (30k+ rules)
- Battery impact on iOS

**Test Sites**:
- `https://blockads.fivefilters.org/` - Ad blocking test page
- Popular news sites with heavy ads
- Video streaming sites
- Social media platforms

#### 7.2 Rule Optimization

**Strategies**:
- Remove duplicate rules
- Combine similar patterns
- Use broader patterns where possible
- Prioritize most-hit rules
- Stay within Safari's rule limits

**Safari Limits**:
- Static rules: 50,000 per ruleset
- Dynamic rules: 30,000 total
- Session rules: 5,000 total
- Enabled static rulesets: 50 max

#### 7.3 Performance Optimization

**Best Practices**:
- Use `urlFilter` instead of `regexFilter` when possible (faster)
- Group rules by domain/pattern
- Use appropriate `resourceTypes` (don't use `["main_frame"]` for scripts)
- Minimize dynamic rule updates
- Lazy load statistics data

### Phase 8: Documentation and Release

#### 8.1 User Documentation

**Create**:
- README.md with setup instructions
- User guide for features
- FAQ for common issues
- Privacy policy (no data collection statement)

#### 8.2 Developer Documentation

**Update CLAUDE.md**:
- Content blocking architecture
- Rule format and conversion
- Testing procedures
- Update mechanisms

#### 8.3 App Store Preparation

**Requirements**:
- Updated app description highlighting ad blocking
- Screenshots showing blocked ads and statistics
- Privacy policy link
- App review notes explaining content blocking approach

**App Store Description Points**:
- Blocks ads and trackers
- Faster browsing
- Privacy protection
- Battery life improvement
- Customizable blocking rules
- No data collection

## Implementation Timeline

### Sprint 1 (Week 1): Foundation
- Update manifest.json
- Create initial rule files with basic ad blocking
- Update background.js with rule loading

### Sprint 2 (Week 2): Core Blocking
- Convert major blocklists to JSON
- Implement rule loader
- Test on popular websites

### Sprint 3 (Week 3): User Interface
- Build enhanced popup UI
- Implement statistics tracking
- Add toggle functionality

### Sprint 4 (Week 4): Advanced Features
- Site whitelisting
- Settings page
- Statistics persistence

### Sprint 5 (Week 5): Polish and Testing
- Cross-platform testing
- Performance optimization
- Bug fixes

### Sprint 6 (Week 6): Documentation and Release
- Write documentation
- Prepare App Store materials
- Submit for review

## Technical Considerations

### Rule ID Management
- Reserve ID ranges for different purposes:
  - 1-10000: Ads ruleset
  - 10001-20000: Tracking ruleset
  - 20001-30000: Social ruleset
  - 30001-40000: Annoyances ruleset
  - 100000+: Dynamic rules (whitelists, custom)

### Cross-Browser Compatibility
While focusing on Safari, using declarativeNetRequest ensures potential future Chrome/Edge support with minimal changes.

### Privacy Compliance
- No data collection from users
- All blocking happens locally
- No network requests from extension (except rule updates if implemented)
- Clear privacy policy

### Performance Targets
- Page load time impact: < 5%
- Memory overhead: < 50MB
- Battery impact: Negligible
- Rule application: < 10ms per navigation

## Success Metrics

### Technical Metrics
- Successfully blocks 90%+ of known ad domains
- No false positives on top 100 websites
- Extension memory usage < 50MB
- No measurable impact on browsing speed

### User Metrics
- User-reported ad blocking effectiveness
- Number of blocked requests per session
- Feature adoption rate (whitelisting, custom rules)
- User retention after 30 days

## Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Rule limits exceeded | High | Optimize and prioritize rules |
| False positives breaking sites | High | Comprehensive testing, easy whitelist |
| Performance degradation | Medium | Profiling and optimization |
| App Store rejection | High | Follow guidelines, clear documentation |
| Blocklist update delays | Low | Start with manual updates, plan for dynamic |

## Future Enhancements

### Phase 9+ (Post-Launch)
- Automatic rule updates from server
- Machine learning for ad detection
- Custom regex filter support
- Export/import custom rules
- Sync settings via iCloud
- Widget showing blocked stats
- Siri shortcuts integration
- Safari Web Extension API features as they're added

## Resources

### Apple Documentation
- [Safari Web Extensions](https://developer.apple.com/documentation/safariservices/safari_web_extensions)
- [declarativeNetRequest API](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/API/declarativeNetRequest)

### Blocklist Sources
- EasyList: https://easylist.to/
- Peter Lowe's List: https://pgl.yoyo.org/adservers/
- Disconnect: https://disconnect.me/

### Testing Tools
- https://blockads.fivefilters.org/ - Ad blocking test
- https://d3ward.github.io/toolz/adblock.html - Comprehensive test

## Appendix: Example Rules

### Common Ad Domains
```json
[
  {"id": 1, "priority": 1, "action": {"type": "block"}, "condition": {"urlFilter": "||doubleclick.net^", "resourceTypes": ["script", "xmlhttprequest"]}},
  {"id": 2, "priority": 1, "action": {"type": "block"}, "condition": {"urlFilter": "||googleadservices.com^", "resourceTypes": ["script", "image"]}},
  {"id": 3, "priority": 1, "action": {"type": "block"}, "condition": {"urlFilter": "||googlesyndication.com^", "resourceTypes": ["script"]}},
  {"id": 4, "priority": 1, "action": {"type": "block"}, "condition": {"urlFilter": "||google-analytics.com^", "resourceTypes": ["script"]}},
  {"id": 5, "priority": 1, "action": {"type": "block"}, "condition": {"urlFilter": "||facebook.com/tr/*", "resourceTypes": ["xmlhttprequest"]}}
]
```

### Common Ad Patterns
```json
[
  {"id": 101, "priority": 1, "action": {"type": "block"}, "condition": {"urlFilter": "/ads/*", "resourceTypes": ["script", "image"]}},
  {"id": 102, "priority": 1, "action": {"type": "block"}, "condition": {"urlFilter": "/ad-*", "resourceTypes": ["script"]}},
  {"id": 103, "priority": 1, "action": {"type": "block"}, "condition": {"urlFilter": "/banner/*", "resourceTypes": ["image"]}},
  {"id": 104, "priority": 1, "action": {"type": "block"}, "condition": {"urlFilter": "/popup/*", "resourceTypes": ["script", "subdocument"]}}
]
```
