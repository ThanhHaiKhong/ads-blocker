# AdsBlocker Testing Guide

## Overview
This document outlines the comprehensive testing strategy for AdsBlocker Safari extension.

## Testing Checklist

### 1. Installation & Setup
- [ ] Extension builds successfully in Xcode (iOS & macOS)
- [ ] Extension appears in Safari preferences
- [ ] Extension can be enabled/disabled
- [ ] Extension icon appears in Safari toolbar
- [ ] Popup opens when clicking extension icon
- [ ] Native app opens and displays correctly

### 2. Core Blocking Functionality

#### Ad Blocking Tests
Test Sites:
- [ ] **https://canyoublockit.com/extreme-test/** - Comprehensive blocker test
- [ ] **https://www.forbes.com** - Heavy display ads, sponsored content
- [ ] **https://www.cnn.com** - Video ads, banner ads
- [ ] **https://www.yahoo.com** - Various ad formats
- [ ] **https://www.youtube.com** - Pre-roll video ads (limited blocking)

Expected Results:
- Banner ads should be blocked or hidden
- Pop-ups should be prevented
- Sponsored content sections reduced
- Page load speed should improve
- Statistics counter should increment

#### Tracking Protection Tests
Test Sites:
- [ ] **https://webbkoll.dataskyddsmyndigheten.se/en** - Privacy checker
- [ ] **https://coveryourtracks.eff.org** - Tracking detection
- [ ] Any major e-commerce site (Amazon, eBay)
- [ ] Any news site with analytics

Expected Results:
- Analytics scripts (Google Analytics, etc.) blocked
- Tracking pixels blocked
- Third-party cookies reduced
- Tracking statistics increment

### 3. Whitelist Functionality

#### Adding Sites to Whitelist
- [ ] Open popup on a regular website
- [ ] Click "Add to Whitelist" button
- [ ] Verify site appears in whitelist section
- [ ] Reload page - ads should now appear
- [ ] Status should show "Protection disabled on this site"

#### Removing Sites from Whitelist
- [ ] Click "Remove from Whitelist" button
- [ ] Verify site removed from whitelist section
- [ ] Reload page - ads should be blocked again
- [ ] Status should show "Protected"

#### Whitelist Persistence
- [ ] Add multiple sites to whitelist
- [ ] Close browser completely
- [ ] Reopen Safari
- [ ] Verify whitelist persists across sessions

### 4. Statistics & Analytics

#### Statistics Counter
- [ ] Initial statistics show 0
- [ ] Visit ad-heavy site
- [ ] Statistics increment appropriately
- [ ] Ads blocked count increases
- [ ] Trackers blocked count increases
- [ ] Total blocked = ads + trackers

#### Statistics Reset
- [ ] Click "Reset Statistics" button
- [ ] Confirm reset dialog
- [ ] All counters return to 0
- [ ] Reset persists after popup close/reopen

#### Statistics Persistence
- [ ] Accumulate blocking statistics
- [ ] Close browser
- [ ] Reopen browser
- [ ] Verify statistics persist

### 5. UI/UX Testing

#### Popup Interface
- [ ] All elements render correctly
- [ ] Toggle switches work smoothly
- [ ] Statistics display formatted numbers (1,234 not 1234)
- [ ] Current site domain displays correctly
- [ ] Whitelist section expands/collapses properly
- [ ] Buttons have hover states
- [ ] Dark mode works correctly

#### Native App Interface
- [ ] App opens successfully
- [ ] Extension status displays correctly
- [ ] Statistics display in native app
- [ ] Refresh button updates statistics
- [ ] Settings button opens Safari preferences
- [ ] Dark mode matches system preference

### 6. Edge Cases & Error Handling

#### Special Pages
- [ ] Browser internal pages (about:, chrome://, safari://)
- [ ] Extension popup on these pages shows "Not Available"
- [ ] Local file URLs (file:///)
- [ ] Data URLs (data:text/html,...)

#### Network Conditions
- [ ] Test with slow network connection
- [ ] Test with offline mode
- [ ] Test with intermittent connectivity
- [ ] Verify extension doesn't crash

#### Large Whitelists
- [ ] Add 50+ sites to whitelist
- [ ] Verify performance remains good
- [ ] Verify UI renders all entries
- [ ] Verify scrolling works in whitelist

#### Rapid Toggling
- [ ] Rapidly toggle ad blocking on/off
- [ ] Rapidly toggle tracking protection on/off
- [ ] Rapidly add/remove sites from whitelist
- [ ] Verify no race conditions or crashes

### 7. Performance Testing

#### Page Load Speed
Test on popular sites with/without extension:
- [ ] Measure load time without extension
- [ ] Enable extension
- [ ] Measure load time with extension
- [ ] Calculate improvement percentage

Expected: 10-30% faster load times on ad-heavy sites

#### Memory Usage
- [ ] Check Safari memory before enabling extension
- [ ] Enable extension
- [ ] Browse normally for 30 minutes
- [ ] Check memory usage
- [ ] Verify no memory leaks

Expected: <50MB additional memory usage

#### CPU Usage
- [ ] Monitor CPU usage during browsing
- [ ] Visit various sites
- [ ] Verify CPU usage remains reasonable

Expected: <5% CPU usage on average

### 8. Compatibility Testing

#### Safari Versions
- [ ] Safari 17+ (macOS 14+)
- [ ] Safari 16+ (macOS 13+)
- [ ] Safari on iOS 17+
- [ ] Safari on iOS 16+

#### Operating Systems
- [ ] macOS Sonoma (14.x)
- [ ] macOS Ventura (13.x)
- [ ] iOS 17.x
- [ ] iOS 16.x (if supported)

### 9. Rule Effectiveness Testing

#### Specific Network Tests
Verify these networks are blocked:
- [ ] doubleclick.net
- [ ] googlesyndication.com
- [ ] google-analytics.com
- [ ] facebook.com/tr
- [ ] taboola.com
- [ ] outbrain.com
- [ ] criteo.com
- [ ] amazon-adsystem.com

#### Pattern Matching Tests
Verify these patterns are blocked:
- [ ] /ads.js
- [ ] /analytics.js
- [ ] /tracking.js
- [ ] /pixel.gif
- [ ] Any URL with /ads/* path

### 10. Data Integrity Testing

#### Storage Tests
- [ ] Preferences persist across browser restarts
- [ ] Statistics persist across browser restarts
- [ ] Whitelist persists across browser restarts
- [ ] No data corruption after extension update

#### Migration Tests
- [ ] Update extension to newer version
- [ ] Verify existing data migrates correctly
- [ ] Verify no data loss

## Testing Tools

### Browser Developer Tools
1. **Network Tab**: Monitor blocked requests
   - Blocked requests show as "blocked:other" or similar
   - Verify correct resources are blocked

2. **Console**: Check for errors
   - No JavaScript errors in popup
   - No errors in background page
   - Warnings are acceptable, errors are not

3. **Storage Inspector**: Verify data
   - Check browser.storage.local
   - Verify preferences structure
   - Verify statistics structure

### Extension Debugging
1. **Safari Web Inspector**
   - Enable Develop menu in Safari
   - Develop > Show Extension Background Page
   - Inspect popup: right-click popup > Inspect Element

2. **Console Logging**
   - Check popup console for `[Popup]` logs
   - Check background console for `[Background]` logs
   - Verify no timeout errors

## Test Sites Catalog

### Heavy Ad Sites (Good for Testing)
- forbes.com
- cnn.com
- weather.com
- youtube.com
- twitch.tv
- dailymail.co.uk
- huffpost.com

### Privacy Test Sites
- canyoublockit.com/extreme-test/
- webbkoll.dataskyddsmyndigheten.se/en
- coveryourtracks.eff.org
- browserleaks.com

### Normal Sites (Should Work Fine)
- github.com
- stackoverflow.com
- wikipedia.org
- reddit.com
- twitter.com/x.com

## Known Limitations

### By Design
- YouTube video ads may still appear (complex to block)
- Some native ads appear as regular content (can't distinguish)
- First-party analytics on websites may work (same domain)
- Paywalls and anti-adblock measures may trigger

### Technical Limitations
- Can't block ads in other apps (Safari only)
- Can't modify page content (declarativeNetRequest only)
- Maximum ~30,000 rules per ruleset (we use 106)
- Some sites may detect ad blocking

## Reporting Issues

When reporting issues, include:
1. **Safari version**: Help > About Safari
2. **macOS/iOS version**: System Settings > General > About
3. **Extension version**: Check manifest.json
4. **Steps to reproduce**
5. **Expected vs actual behavior**
6. **Screenshots if applicable**
7. **Console errors** (if any)

## Success Criteria

The extension passes testing if:
- ✅ All core blocking functionality works
- ✅ Whitelist works reliably
- ✅ Statistics track accurately
- ✅ No crashes or errors
- ✅ Performance impact < 100ms average
- ✅ Memory usage < 50MB
- ✅ UI is responsive and polished
- ✅ Blocks at least 80% of ads on test sites
- ✅ Works on Safari 16+ (macOS 13+)

## Next Steps After Testing

1. Document all discovered issues
2. Prioritize critical bugs
3. Fix high-priority issues
4. Retest after fixes
5. Update documentation
6. Prepare for Phase 8 (Distribution)
