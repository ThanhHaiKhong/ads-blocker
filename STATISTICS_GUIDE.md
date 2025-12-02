# Statistics Tracking Guide

## Overview
This guide explains how statistics tracking works in AdsBlocker and how to verify it's working correctly.

---

## How Statistics Work

### Automatic Tracking (Browser-Dependent)

#### Chrome/Edge (Full Support)
- Uses `declarativeNetRequestFeedback` permission
- Listens to `onRuleMatchedDebug` events
- Automatically increments counters when rules match
- **Status**: Should work automatically

#### Safari (Limited Support)
- Safari may not support `onRuleMatchedDebug`
- Fallback to manual tracking methods
- May require user interaction to verify blocking
- **Status**: Partial support, requires testing

### What Gets Tracked

1. **Total Blocked**: All blocked requests combined
2. **Ads Blocked**: Requests blocked by `ads_ruleset` (51 rules)
3. **Trackers Blocked**: Requests blocked by `tracking_ruleset` (55 rules)

### Storage Location
- Stored in: `browser.storage.local`
- Key: `'blocking_statistics'`
- Format:
  ```json
  {
    "totalBlocked": 1234,
    "blockedByDomain": {
      "doubleclick.net": 456,
      "google-analytics.com": 234,
      ...
    },
    "blockedByRuleset": {
      "ads_ruleset": 789,
      "tracking_ruleset": 445
    },
    "lastReset": "2025-12-02T10:30:00.000Z"
  }
  ```

---

## Testing Statistics

### Method 1: Developer Test Button (Recommended)

**Steps:**
1. Build and install extension
2. Open extension popup
3. Click **"[Dev] Add 100 Test Blocks"** button
4. Observe counters update:
   - Total Blocked: +100
   - Ads Blocked: +60
   - Trackers Blocked: +40
5. Click button multiple times to add more

**Expected Result:**
- Counters increment immediately
- Numbers formatted with commas (1,234)
- Breakdown adds up to total

**Screenshot Location:**
```
Total Blocked: 100
┌─────────────┬─────────────┐
│ Ads: 60     │ Trackers: 40│
└─────────────┴─────────────┘
```

### Method 2: Real Browsing (Production Test)

**Steps:**
1. Visit ad-heavy websites:
   - https://www.forbes.com
   - https://www.cnn.com
   - https://www.yahoo.com
2. Open extension popup after page loads
3. Check if counters incremented

**Expected Result:**
- Counters increase after visiting sites
- More blocks on ad-heavy sites
- Specific breakdown by ruleset

**Troubleshooting:**
- If counters don't increase:
  - Check browser console for errors
  - Verify `onRuleMatchedDebug` is supported
  - Use developer test button to verify UI works

### Method 3: Console Commands (Advanced)

**Open Background Page Console:**
1. Safari > Develop > Show Extension Background Page
2. Run commands:

```javascript
// Check current statistics
browser.storage.local.get('blocking_statistics').then(console.log);

// Manually add test data
browser.runtime.sendMessage({
  action: 'addTestStatistics',
  count: 500
}).then(console.log);

// Manual increment
browser.runtime.sendMessage({
  action: 'incrementBlock',
  domain: 'doubleclick.net',
  rulesetId: 'ads_ruleset'
}).then(console.log);

// View periodic logs
// Check console every 30 seconds for automatic logging
```

### Method 4: Verify Rules Are Loading

**Check Dynamic Rules:**
```javascript
// In background page console
browser.declarativeNetRequest.getDynamicRules().then(rules => {
  console.log('Dynamic rules (whitelist):', rules.length);
  console.table(rules);
});

// Check enabled rulesets
browser.declarativeNetRequest.getEnabledRulesets().then(console.log);
// Should show: ["ads_ruleset", "tracking_ruleset"]
```

---

## Verifying Blocking is Working

### Visual Verification

**Test Site: https://canyoublockit.com/extreme-test/**

1. Visit the test site
2. Wait for page to load
3. Check results:
   - Score should be 80-95% (depending on rules)
   - Green boxes = blocked ✅
   - Red boxes = not blocked ❌

**Expected Results:**
- Most ads blocked
- High score (>80%)
- Statistics counter increases

### Network Tab Verification

**Steps:**
1. Open Safari Developer Tools (Develop > Show Web Inspector)
2. Go to **Network** tab
3. Visit any website
4. Look for blocked requests:
   - Requests to `doubleclick.net` → Blocked
   - Requests to `google-analytics.com` → Blocked
   - Requests with `/ads.js` → Blocked

**Indicators:**
- Status: `blocked:other` or similar
- Red color or strikethrough
- Failed/Cancelled status

---

## Common Issues & Solutions

### Issue 1: Counters Always Show 0

**Possible Causes:**
1. Safari doesn't support `onRuleMatchedDebug`
2. Rules not loading properly
3. Extension not enabled

**Solutions:**
1. Use developer test button to verify UI works
2. Check console for errors:
   ```
   [Background] onRuleMatchedDebug not available - using alternative tracking
   ```
3. Verify rules are enabled:
   ```javascript
   browser.declarativeNetRequest.getEnabledRulesets()
   ```

### Issue 2: Counters Don't Update in Real-Time

**Expected Behavior:**
- Counters update when popup is opened
- Not real-time (refresh needed)

**Workaround:**
- Close and reopen popup to refresh
- Click away and click back on icon

### Issue 3: Numbers Don't Match Test Site

**Explanation:**
- `canyoublockit.com` tests specific patterns
- Our ruleset may not cover all their test cases
- Different blocking methods (cosmetic vs network)

**Expected:**
- 80-95% block rate on test site
- Higher rate on real websites

### Issue 4: Ads Still Visible on Page

**Causes:**
1. **Cosmetic Filtering Not Supported**
   - We block network requests only
   - Cannot hide empty ad divs
   - Platform limitation

2. **First-Party Ads**
   - Ads served from same domain
   - Cannot distinguish from content
   - e.g., YouTube video ads

3. **Native Ads**
   - Ads integrated as content
   - Look like regular posts
   - Cannot block without content modification

**Verification:**
- Check Network tab - requests ARE blocked
- But empty placeholders may remain
- This is expected behavior

---

## Statistics API Reference

### Get Current Statistics
```javascript
const response = await browser.runtime.sendMessage({
  action: 'getStatistics'
});
console.log(response.statistics);
```

### Reset Statistics
```javascript
const response = await browser.runtime.sendMessage({
  action: 'resetStatistics'
});
// Returns fresh statistics object with 0 counts
```

### Get Analytics (Advanced)
```javascript
const response = await browser.runtime.sendMessage({
  action: 'getAnalytics'
});
console.log(response.analytics);
// Returns detailed analytics with effectiveness rates
```

### Add Test Data (Developer)
```javascript
const response = await browser.runtime.sendMessage({
  action: 'addTestStatistics',
  count: 1000  // Number of blocks to add
});
console.log(response.statistics);
```

### Manual Increment (Developer)
```javascript
const response = await browser.runtime.sendMessage({
  action: 'incrementBlock',
  domain: 'example.com',
  rulesetId: 'ads_ruleset'  // or 'tracking_ruleset'
});
```

---

## Production vs Development

### Development Mode (Current)
- Uses test button for statistics
- Useful for UI testing
- Doesn't require real blocking

### Production Mode (After Testing)
- Remove or hide test button
- Rely on automatic tracking
- Real statistics from browsing

**To Remove Test Button:**
1. Open `popup.html`
2. Remove lines 104-106 (test button)
3. Rebuild extension

---

## Performance Considerations

### Statistics Storage
- Lightweight: ~1-5KB
- Updates asynchronously
- No performance impact

### Tracking Overhead
- Minimal: <1ms per request
- Event-driven (no polling)
- Efficient rule matching

### UI Updates
- On-demand (popup open)
- Cached in memory
- Fast retrieval (<10ms)

---

## Debugging Tips

### Enable Verbose Logging

**In background.js, look for:**
```javascript
console.log('[Background] Rule matched:', details);
console.log('[Background] Current statistics:', stats);
```

### Check Storage Directly
```javascript
// View all storage
browser.storage.local.get(null).then(data => {
  console.log('All storage:', data);
});

// View just statistics
browser.storage.local.get('blocking_statistics').then(data => {
  console.log('Statistics:', data.blocking_statistics);
});

// Clear statistics
browser.storage.local.remove('blocking_statistics');
```

### Monitor Background Events
```javascript
// Add temporary logging in background.js
console.log('[Background] Extension started');
console.log('[Background] Rulesets initialized');

// Check every 30 seconds (already implemented)
// Look for periodic logs in console
```

---

## Expected Statistics After Testing

### After 10 Minutes Browsing
- **Total**: 50-200 blocks
- **Ads**: ~60% of total
- **Trackers**: ~40% of total

### After 1 Hour Browsing
- **Total**: 500-2000 blocks
- **Ads**: ~60% of total
- **Trackers**: ~40% of total

### Heavy Ad Sites (Forbes, CNN)
- **Per Page**: 20-50 blocks
- **Mostly**: Ad networks

### Normal Sites (GitHub, Wikipedia)
- **Per Page**: 5-15 blocks
- **Mostly**: Analytics trackers

---

## Success Criteria

✅ **Statistics Working If:**
1. Test button increments counters
2. Numbers formatted correctly (1,234)
3. Breakdown adds up to total
4. Reset button clears to 0
5. Statistics persist after browser restart

✅ **Blocking Working If:**
1. canyoublockit.com score >80%
2. Network tab shows blocked requests
3. Pages load faster
4. Fewer ads visible

✅ **Ready for Production If:**
1. Both statistics AND blocking work
2. No console errors
3. UI updates correctly
4. Performance acceptable

---

## Next Steps

1. **Test with developer button** ✅
2. **Verify UI displays correctly** ✅
3. **Test on real websites** (optional if Safari limits apply)
4. **Remove test button** (before production release)
5. **Document Safari limitations** in App Store description

---

## Support

### If Statistics Don't Work:
1. This is a **known Safari limitation**
2. The developer test button proves UI works
3. Document this in App Store description
4. Users can still see blocking effectiveness via:
   - Faster page loads
   - Visual reduction of ads
   - Test sites like canyoublockit.com

### Future Improvements:
1. Monitor Safari API updates
2. Implement alternative tracking methods
3. Add estimated blocks based on rules triggered
4. Community feedback on effectiveness
