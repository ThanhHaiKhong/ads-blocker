# Quick Testing Guide

## Test Your Blocking Effectiveness in 5 Minutes

### Step 1: Enable Extension (30 seconds)

1. Open **Safari**
2. Go to **Safari → Settings → Extensions**
3. Find **"AdsBlocker"** in the list
4. ✅ Check the box to enable it
5. Make sure it's allowed on **"All websites"**

### Step 2: Run Primary Test (2 minutes)

**Visit**: https://iblockads.net/test

**Expected Results**:
- **Before improvements**: ~28% blocked
- **After comprehensive rules**: 50-70% blocked
- **Goal with AdGuard**: 85-95% blocked

**What to Look For**:
- Green checkmarks = Successfully blocked ✅
- Red X marks = Missed/loaded ❌
- Percentage shown at the top

### Step 3: Run Extended Tests (2 minutes)

**Test Site #2**: https://d3ward.github.io/toolz/adblock.html
- More comprehensive (90+ checks)
- Shows specific networks blocked/missed

**Test Site #3**: https://canyoublockit.com/testing/
- Extensive test suite
- Tests specific ad blocking scenarios

### Step 4: Real-World Test (1 minute)

Visit these ad-heavy sites:
- https://www.cnn.com
- https://www.forbes.com
- Any news or tech blog

**Check**:
- Are banner ads gone?
- Are sidebar ads removed?
- Page loads faster?
- Cleaner reading experience?

---

## If Blocking is Still Low

### Quick Fixes

1. **Reload Extension**:
   - Safari → Settings → Extensions
   - Disable "AdsBlocker"
   - Re-enable "AdsBlocker"

2. **Clear Safari Cache**:
   - Safari → Settings → Privacy
   - Click "Manage Website Data"
   - Remove All

3. **Rebuild Project**:
   ```bash
   cd /Users/thanhhaikhong/Documents/ads-blocker
   xcodebuild -workspace AdsBlocker.xcworkspace -scheme "AdsBlocker (macOS)" clean build
   ```

### Check Rules Loaded

```bash
# Verify rules exist
ls -lh AdsBlocker/Shared\ \(Extension\)/Resources/rules/

# Check JSON syntax
cat AdsBlocker/Shared\ \(Extension\)/Resources/rules/ads.json | python3 -m json.tool | head -20
```

### View Extension Console

```
Safari → Develop → Web Extension Background Pages → AdsBlocker Extension
```

Look for errors or warnings.

---

## Upgrade to AdGuard Filters (For 85-95% Blocking)

If you want maximum blocking effectiveness:

```bash
# 1. Download AdGuard filters
./scripts/download-adguard-filters.sh

# 2. Install adblock-rust (first time only)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install adblock

# 3. Convert filters to Safari JSON
adblock convert safari \
  -i filter-lists/adguard-base.txt \
  -o AdsBlocker/Shared\ \(Extension\)/Resources/rules/ads.json

adblock convert safari \
  -i filter-lists/adguard-tracking.txt \
  -o AdsBlocker/Shared\ \(Extension\)/Resources/rules/tracking.json

# 4. Rebuild
xcodebuild -workspace AdsBlocker.xcworkspace -scheme "AdsBlocker (macOS)" build

# 5. Re-test
open -a Safari https://iblockads.net/test
```

---

## Current Rules Summary

**Ads Blocking** (20 rules):
- ✅ Google Ads (DoubleClick, AdSense, AdServices)
- ✅ Facebook Ads
- ✅ Native Ads (Taboola, Outbrain, Revcontent, MGID)
- ✅ Programmatic (Criteo, Rubicon, PubMatic, AppNexus)
- ✅ Ad Exchanges (OpenX, SmartAdServer, Yieldmo)
- ✅ Amazon Ads

**Tracking Protection** (20 rules):
- ✅ Google Analytics & Tag Manager
- ✅ Facebook Pixel & Events
- ✅ Analytics (Mixpanel, Segment, Amplitude, Heap)
- ✅ Session Replay (Hotjar, FullStory, LogRocket, CrazyEgg)
- ✅ Mobile Attribution (Branch, Adjust, AppsFlyer)
- ✅ URL Tracking Parameters (utm_, fbclid, gclid)
- ✅ Error Tracking (Sentry, Bugsnag, NewRelic)
- ✅ Fingerprinting

---

## Test Results Template

Record your results:

```
Test Date: ___________
Test Site: https://iblockads.net/test

Blocking Effectiveness: ____%

Notes:
- What was blocked well: ___________
- What was missed: ___________
- Performance: Fast/Normal/Slow
- Any broken sites: ___________

Compare with:
- Previous test: ____%
- Target: 85-95%
```

---

## Success Checklist

- [ ] Extension enabled in Safari
- [ ] Test shows > 50% blocking
- [ ] No performance issues
- [ ] No legitimate content broken
- [ ] Real-world sites load cleaner

If all checked: **Success!** ✅

If blocking < 50%: Consider AdGuard filters upgrade

---

**For full details**: See `BLOCKING_OPTIMIZATION_GUIDE.md`
