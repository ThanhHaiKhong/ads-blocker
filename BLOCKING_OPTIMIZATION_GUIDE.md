# Ad Blocking Optimization Guide

## Overview

This guide explains how to improve and test the ad blocking effectiveness of the AdsBlocker Safari extension, including upgrading from basic rules to comprehensive AdGuard Safari-optimized filter lists.

---

## Current Implementation Status

### Initial State (Before Optimization)
- **Blocking Effectiveness**: 28% on https://iblockads.net/test
- **Filter Lists**: Basic EasyList and EasyPrivacy
- **Total Rules**: ~1,170 rules (563 ads + 607 tracking)

### After Comprehensive Rules Generation
- **New Rules**: 40 comprehensive Safari declarativeNetRequest rules
- **Coverage**: Major ad networks, analytics, session replay, mobile attribution
- **Key Additions**:
  - Google Ads ecosystem (DoubleClick, AdSense, etc.)
  - Facebook tracking and ads
  - Native ad networks (Taboola, Outbrain, Revcontent, MGID)
  - Programmatic ad exchanges (Criteo, Rubicon, PubMatic)
  - Analytics platforms (GA, Mixpanel, Hotjar, Amplitude, FullStory)
  - Session replay tools (LogRocket, SessionCam, CrazyEgg)
  - Mobile attribution (Branch, Adjust, AppsFlyer)
  - URL tracking parameters (utm_, fbclid, gclid)

---

## Blocking Effectiveness Testing

### Test Site: https://iblockads.net/test

This site tests your ad blocker against various ad networks and tracking scripts.

**How to Test**:

1. **Enable Extension in Safari**:
   - Safari → Settings → Extensions
   - Enable "AdsBlocker"
   - Ensure it's allowed on all websites

2. **Visit Test Site**:
   ```
   https://iblockads.net/test
   ```

3. **Review Results**:
   - Green checks = Blocked successfully
   - Red X = Missed/loaded
   - Percentage shown at top

4. **Expected Results**:
   - **Before optimization**: ~28% blocked
   - **After comprehensive rules**: 50-70% blocked (estimated)
   - **After AdGuard filters**: 85-95% blocked (goal)

### Other Test Sites

- **https://d3ward.github.io/toolz/adblock.html** - Comprehensive test with 90+ checks
- **https://canyoublockit.com/testing/** - Extensive ad blocker test suite
- **https://blockads.fivefilters.org/** - Tests specific ad network blocking

---

## Upgrading to AdGuard Safari-Optimized Filters

### Why AdGuard Filters?

Based on analysis of the wBlock project (a production-ready Safari ad blocker), AdGuard's Safari-optimized filters provide:

1. **Pre-optimized for Safari**: Already converted to declarativeNetRequest format
2. **Comprehensive coverage**: 100,000+ rules across multiple categories
3. **Regular updates**: Maintained by AdGuard team
4. **Proven effectiveness**: Used by wBlock and other successful ad blockers

### Download AdGuard Filters

Run the download script:

```bash
cd /Users/thanhhaikhong/Documents/ads-blocker
./scripts/download-adguard-filters.sh
```

This downloads:
- **AdGuard Base Filter** (2_optimized.txt) - Primary ad blocking
- **AdGuard Tracking Protection Filter** (3_optimized.txt) - Privacy/tracking
- **EasyPrivacy** (118_optimized.txt) - Additional privacy protection
- **Peter Lowe's Blocklist** (204_optimized.txt) - Ads and tracking servers
- **d3Host List** - Comprehensive blocklist
- **Online Security Filter** (208_optimized.txt) - Phishing/malware protection

### Filter Statistics

After download, the script shows rule counts:

```
Filter Statistics:
-----------------
adguard-base.txt          ~35,000 rules
adguard-tracking.txt      ~15,000 rules
easyprivacy.txt           ~20,000 rules
peter-lowe.txt            ~3,000 rules
d3host.txt                ~5,000 rules
security.txt              ~2,000 rules
```

---

## Converting Filter Lists to Safari JSON

### Option 1: Manual Conversion (Quick, Limited)

Use the comprehensive rules generator:

```bash
./scripts/generate-comprehensive-rules.sh
```

**Pros**:
- No dependencies
- Immediate results
- 40 high-impact rules

**Cons**:
- Limited coverage compared to full filter lists
- Manual maintenance required

### Option 2: adblock-rust CLI (Recommended)

Install adblock-rust CLI:

```bash
# Install Rust if not already installed
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install adblock-rust CLI
cargo install adblock

# Convert downloaded filters to Safari JSON
adblock convert safari -i filter-lists/adguard-base.txt -o AdsBlocker/Shared\ \(Extension\)/Resources/rules/ads.json
adblock convert safari -i filter-lists/adguard-tracking.txt -o AdsBlocker/Shared\ \(Extension\)/Resources/rules/tracking.json
```

**Pros**:
- Full filter list coverage
- Proper conversion to Safari format
- Handles complex filter syntax

**Cons**:
- Requires Rust toolchain installation
- Slower initial setup

### Option 3: Online Converter

Some online tools can convert filter lists:
- FilterLists.com converters
- AdGuard filter converter tools

---

## Safari declarativeNetRequest Limitations

Safari imposes limits on content blockers:

### Rule Limits per Extension
- **Maximum rules per JSON file**: 150,000
- **Maximum rules across all rulesets**: 150,000
- **Recommended per file**: 30,000-50,000 for performance

### Workarounds for Large Filter Lists

1. **Split into Multiple Rulesets**:
   ```javascript
   // manifest.json
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
       },
       {
         "id": "annoyances_ruleset",
         "enabled": false,
         "path": "rules/annoyances.json"
       }
     ]
   }
   ```

2. **Prioritize High-Impact Rules**:
   - Focus on major ad networks first
   - Include most-visited websites' ad patterns
   - Combine similar patterns into broader rules

3. **Use Domain-Based Blocking**:
   ```json
   {
     "action": { "type": "block" },
     "trigger": {
       "url-filter": ".*",
       "if-domain": ["*doubleclick.net", "*googlesyndication.com"],
       "resource-type": ["script", "image"]
     }
   }
   ```

---

## Ruleset Categories (Based on wBlock)

### Core Rulesets (Always Enabled)
- **ads_ruleset**: Primary ad blocking (ads.json)
- **tracking_ruleset**: Privacy/analytics blocking (tracking.json)

### Optional Rulesets
- **annoyances_ruleset**: Cookie notices, popups, social widgets
- **security_ruleset**: Phishing, malware, suspicious sites
- **mobile_ruleset**: iOS-specific ad blocking (if targeting iOS)

### Foreign Language Rulesets
wBlock includes 50+ regional filter lists for:
- Chinese, Japanese, Korean, Russian
- European languages (German, French, Spanish, etc.)
- Middle Eastern languages (Arabic, Persian, Hebrew)

---

## Performance Optimization

### Rule Efficiency Tips

1. **Use Specific Domains Over Broad Patterns**:
   ```json
   // GOOD - Specific and fast
   {
     "trigger": {
       "url-filter": ".*",
       "if-domain": ["*doubleclick.net"]
     }
   }

   // AVOID - Slow regex matching
   {
     "trigger": {
       "url-filter": ".*doubleclick.*"
     }
   }
   ```

2. **Limit Resource Types**:
   ```json
   {
     "trigger": {
       "url-filter": ".*",
       "if-domain": ["*ads.example.com"],
       "resource-type": ["script", "image"] // More efficient than "other"
     }
   }
   ```

3. **Combine Similar Rules**:
   ```json
   // GOOD - Single rule for multiple domains
   {
     "trigger": {
       "url-filter": ".*",
       "if-domain": [
         "*doubleclick.net",
         "*googlesyndication.com",
         "*googleadservices.com"
       ]
     }
   }

   // AVOID - Multiple rules for same network
   // (3 separate rules for each domain)
   ```

### Testing Performance

Check extension performance:

```bash
# View Safari extension console
Safari → Develop → Web Extension Background Pages → AdsBlocker Extension

# Monitor rule matching
# (Safari may not support onRuleMatchedDebug, but check anyway)
```

---

## Troubleshooting

### Issue: Low Blocking Percentage

**Symptoms**: Test site shows <50% blocking

**Solutions**:
1. Verify rules files exist:
   ```bash
   ls -lh AdsBlocker/Shared\ \(Extension\)/Resources/rules/
   ```

2. Check JSON syntax:
   ```bash
   cat AdsBlocker/Shared\ \(Extension\)/Resources/rules/ads.json | python3 -m json.tool
   ```

3. Rebuild project:
   ```bash
   xcodebuild -workspace AdsBlocker.xcworkspace -scheme "AdsBlocker (macOS)" clean build
   ```

4. Reload extension in Safari:
   - Safari → Settings → Extensions
   - Disable and re-enable "AdsBlocker"

### Issue: Extension Not Loading Rules

**Symptoms**: Safari shows "Unable to find rules/ads.json"

**Solutions**:
1. Check files are in project:
   ```bash
   find AdsBlocker -name "*.json" -path "*/rules/*"
   ```

2. Verify project.pbxproj includes files:
   ```bash
   grep -A5 "membershipExceptions" AdsBlocker/AdsBlocker.xcodeproj/project.pbxproj | grep rules
   ```

3. Re-add files to Xcode if needed (already fixed in project)

### Issue: Rules Not Blocking Specific Site

**Diagnosis**:
1. Check Safari Web Inspector:
   ```
   Safari → Develop → Web Extension Background Pages → AdsBlocker Extension
   ```

2. Look for console errors or blocked requests

3. Check if site is whitelisted:
   - Extension popup → Current Site section
   - Verify site not in whitelist

**Solutions**:
1. Add site-specific rules to ads.json or tracking.json
2. Test in Safari private window (no cached content)
3. Clear Safari cache and reload

---

## Maintenance and Updates

### Regular Filter Updates

**Recommended Schedule**: Weekly or bi-weekly

```bash
# Re-download latest AdGuard filters
./scripts/download-adguard-filters.sh

# Convert to Safari JSON (if using adblock-rust)
adblock convert safari -i filter-lists/adguard-base.txt -o AdsBlocker/Shared\ \(Extension\)/Resources/rules/ads.json

# Rebuild project
xcodebuild -workspace AdsBlocker.xcworkspace -scheme "AdsBlocker (macOS)" build

# Test blocking effectiveness
open https://iblockads.net/test
```

### Automated Updates (Future Enhancement)

Consider implementing auto-update logic similar to wBlock's `SharedAutoUpdateManager.swift`:

- Download filter lists every 6 hours
- Use ETag/If-Modified-Since for conditional requests
- Only reconvert if filters actually changed
- Store filters in App Group container
- Notify user of updates

---

## Comparison with wBlock

### wBlock's Approach (Reference)

**Default Enabled Filters**:
1. AdGuard Base Filter (~35k rules)
2. AdGuard Tracking Protection Filter (~15k rules)
3. EasyPrivacy (~20k rules)
4. Online Security Filter (~2k rules)
5. Peter Lowe's Blocklist (~3k rules)
6. d3Host List (~5k rules)
7. Anti-Adblock List
8. AdGuard Annoyances Filter

**Total**: ~80k+ rules across multiple categories

**Our Current Implementation**:
- Comprehensive manual rules: 40 rules
- Focus on high-impact domains and patterns
- Room to grow with AdGuard filters

**Path Forward**:
1. ✅ Generate comprehensive manual rules (Done)
2. ⏭️ Download AdGuard filters (Script ready)
3. ⏭️ Convert using adblock-rust CLI
4. ⏭️ Test and optimize for rule limit
5. ⏭️ Implement auto-update mechanism

---

## Key Takeaways

1. **Current rules (40)** provide immediate improvement from 28% baseline
2. **AdGuard filters** can increase effectiveness to 85-95%
3. **Safari has limits** - be strategic about which rules to include
4. **Test regularly** on https://iblockads.net/test and other test sites
5. **Monitor performance** - too many rules can slow browsing
6. **Update filters regularly** - ad networks evolve constantly

---

## Next Steps

1. **Test Current Implementation**:
   ```bash
   open -a Safari https://iblockads.net/test
   ```

2. **Download AdGuard Filters** (when ready for more coverage):
   ```bash
   ./scripts/download-adguard-filters.sh
   ```

3. **Convert to Safari JSON** (requires adblock-rust):
   ```bash
   cargo install adblock
   # Then convert each filter list
   ```

4. **Rebuild and Test**:
   ```bash
   xcodebuild -workspace AdsBlocker.xcworkspace -scheme "AdsBlocker (macOS)" build
   ```

5. **Document Results**:
   - Record blocking percentage before/after
   - Note any performance issues
   - Identify sites that still show ads

---

## References

- **wBlock Project**: FilterListLoader.swift (lines 136-252) for default filter configuration
- **AdGuard Filters Registry**: https://github.com/AdguardTeam/FiltersRegistry
- **adblock-rust**: https://github.com/brave/adblock-rust
- **Safari Content Blocking**: https://developer.apple.com/documentation/safariservices/creating_a_content_blocker
- **Test Sites**:
  - https://iblockads.net/test
  - https://d3ward.github.io/toolz/adblock.html
  - https://canyoublockit.com/testing/
