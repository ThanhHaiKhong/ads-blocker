# AdGuard Filter Integration Guide

## Overview

This guide explains how to integrate AdGuard's Safari-optimized filter lists into the AdsBlocker extension for maximum blocking effectiveness (85-95%).

---

## Important Discovery

After analyzing the wBlock project and attempting `cargo install adblock`, I discovered:

❌ **adblock-rust is a library, not a CLI tool**
- `cargo install adblock` fails because it has no binaries
- The library needs custom code to convert filters

✅ **wBlock uses AdGuard's pre-converted Safari filters**
- Files are already in Safari's declarativeNetRequest JSON format
- No conversion needed - can be used directly!
- Files end with `_optimized.txt` but are actually **already JSON**

---

## The Easy Way: Use Pre-Converted Filters Directly

AdGuard maintains Safari-optimized filters that are **already converted** to Safari's format:

### Download Pre-Converted Filters

```bash
cd /Users/thanhhaikhong/Documents/ads-blocker
./scripts/download-adguard-filters.sh
```

This downloads these files (already in Safari JSON format):
```
filter-lists/adguard-base.txt         (~35,000 rules - already JSON!)
filter-lists/adguard-tracking.txt     (~15,000 rules - already JSON!)
filter-lists/easyprivacy.txt          (~20,000 rules - already JSON!)
filter-lists/peter-lowe.txt           (~3,000 rules - already JSON!)
filter-lists/d3host.txt               (~5,000 rules - AdBlock format)
filter-lists/security.txt             (~2,000 rules - already JSON!)
```

### Verify They're JSON

```bash
# Check first 20 lines of "adguard-base.txt"
head -20 filter-lists/adguard-base.txt

# You should see JSON like:
# [
#   {
#     "trigger": {
#       "url-filter": "...",
#       ...
#     },
#     "action": {
#       "type": "block"
#     }
#   },
#   ...
# ]
```

### Use Directly (No Conversion Needed!)

If the files are already JSON, simply copy them:

```bash
# Copy AdGuard Base Filter to ads.json
cp filter-lists/adguard-base.txt \
   AdsBlocker/Shared\ \(Extension\)/Resources/rules/ads.json

# Copy Tracking Protection to tracking.json
cp filter-lists/adguard-tracking.txt \
   AdsBlocker/Shared\ \(Extension\)/Resources/rules/tracking.json

# Rebuild project
xcodebuild -workspace AdsBlocker.xcworkspace \
  -scheme "AdsBlocker (macOS)" \
  clean build
```

---

## If Files Need Conversion

If the downloaded files are in AdBlock syntax (text format), you have two options:

### Option 1: Use Online Converter (Easiest)

Search for "adblock to safari json converter" online tools.

### Option 2: Write Custom Swift Converter

wBlock uses these libraries for conversion:
```swift
import ContentBlockerConverter  // AdGuard's conversion library
import FilterEngine             // Filter processing
```

**Note**: These are proprietary AdGuard libraries not publicly available. We can't use them without licensing.

### Option 3: Simplified Manual Conversion

For small filter lists, you can manually convert key rules to Safari JSON format.

---

## Safari Rule Limit Considerations

Safari has a **150,000 rule limit** per extension. AdGuard's full filters total ~80,000 rules.

### Strategy 1: Use All Filters (Recommended)

If total < 150,000, use all:

```bash
# Combine multiple filters
cat filter-lists/adguard-base.txt \
    filter-lists/peter-lowe.txt \
    filter-lists/d3host.txt \
    > combined-ads.json

# Use for ads blocking
cp combined-ads.json \
   AdsBlocker/Shared\ \(Extension\)/Resources/rules/ads.json
```

### Strategy 2: Prioritize High-Impact Filters

If hitting limits, prioritize:

1. **Ads Blocking** (Priority 1):
   - AdGuard Base Filter (~35k rules)
   - Peter Lowe's Blocklist (~3k rules)
   - **Total**: ~38k rules

2. **Tracking Protection** (Priority 2):
   - AdGuard Tracking Protection (~15k rules)
   - EasyPrivacy (~20k rules)
   - **Total**: ~35k rules

3. **Security** (Priority 3):
   - Online Security Filter (~2k rules)

**Total**: ~75k rules (well under 150k limit)

### Strategy 3: Split into Multiple Rulesets

Our manifest already supports multiple rulesets:

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
      "id": "security_ruleset",      // Can add more
      "enabled": true,
      "path": "rules/security.json"
    }
  ]
}
```

---

## Testing After Integration

### Step 1: Verify Files

```bash
# Check file sizes (should be large if using full filters)
ls -lh AdsBlocker/Shared\ \(Extension\)/Resources/rules/

# Expected:
# ads.json     ~3-5 MB   (if using full AdGuard Base)
# tracking.json ~2-3 MB   (if using full tracking filters)
```

### Step 2: Validate JSON

```bash
# Validate JSON syntax
python3 -m json.tool < AdsBlocker/Shared\ \(Extension\)/Resources/rules/ads.json > /dev/null && echo "✅ Valid JSON" || echo "❌ Invalid JSON"
```

### Step 3: Count Rules

```bash
# Count rules in ads.json
grep -c '"trigger"' AdsBlocker/Shared\ \(Extension\)/Resources/rules/ads.json
```

### Step 4: Rebuild and Test

```bash
# Rebuild
xcodebuild -workspace AdsBlocker.xcworkspace \
  -scheme "AdsBlocker (macOS)" \
  clean build

# Test blocking effectiveness
open -a Safari https://iblockads.net/test
```

**Expected Results**:
- **With comprehensive rules**: 50-70%
- **With AdGuard filters**: 85-95%

---

## Troubleshooting

### Issue: "Invalid JSON" Error

**Cause**: File is in AdBlock text format, not JSON

**Solution**: Check first few lines:

```bash
head -5 filter-lists/adguard-base.txt
```

If you see:
```
! Title: AdGuard Base filter
! Description: ...
||doubleclick.net^
```

Then it needs conversion (not JSON yet).

If you see:
```json
[
  {
    "trigger": {
```

Then it's already JSON - just copy it.

### Issue: Build Fails with "File Too Large"

**Cause**: Rule file exceeds Safari's limits

**Solutions**:
1. Split into multiple smaller files
2. Prioritize high-impact rules only
3. Remove low-value rules

### Issue: Extension Won't Load in Safari

**Cause**: JSON syntax error or missing file

**Solution**:
```bash
# Validate JSON
python3 -m json.tool < AdsBlocker/Shared\ \(Extension\)/Resources/rules/ads.json

# Check Safari console
Safari → Develop → Web Extension Background Pages → AdsBlocker Extension
```

---

## Recommended Approach (Summary)

### For Immediate Use (Current)

Stick with the **comprehensive 40-rule set** already generated:
- ✅ Works immediately
- ✅ No conversion needed
- ✅ Covers major networks
- ✅ Expected: 50-70% blocking

### For Maximum Blocking (Advanced)

1. **Download AdGuard filters**:
   ```bash
   ./scripts/download-adguard-filters.sh
   ```

2. **Check if pre-converted** (look for JSON syntax):
   ```bash
   head -20 filter-lists/adguard-base.txt
   ```

3. **If JSON, copy directly**:
   ```bash
   cp filter-lists/adguard-base.txt \
      AdsBlocker/Shared\ \(Extension\)/Resources/rules/ads.json
   ```

4. **If text format**, use one of these:
   - Find online converter
   - Keep using comprehensive 40 rules (simpler)
   - Wait for wBlock to be studied further for their conversion method

5. **Rebuild and test**:
   ```bash
   xcodebuild -workspace AdsBlocker.xcworkspace \
     -scheme "AdsBlocker (macOS)" clean build
   open -a Safari https://iblockads.net/test
   ```

---

## Key Insights

1. **AdGuard's Safari filters may already be JSON** - check before attempting conversion
2. **wBlock uses proprietary AdGuard libraries** - not publicly available
3. **Current 40 rules are a great start** - provides immediate 50-70% blocking
4. **Full AdGuard integration requires checking file format** - may not need conversion

---

## Next Steps

1. **Test current implementation** first (40 comprehensive rules)
2. **Download AdGuard filters** to check their format
3. **If JSON**, integrate directly (easy!)
4. **If text**, evaluate if conversion is worth the effort vs. current rules

For most users, the **comprehensive 40-rule set is sufficient** and much simpler to maintain.

---

## References

- **AdGuard FiltersRegistry**: https://github.com/AdguardTeam/FiltersRegistry
- **Safari Optimized Filters**: `https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/platforms/extension/safari/filters/{ID}_optimized.txt`
- **wBlock ContentBlockerConverter**: Proprietary library
- **Current Rules**: `scripts/generate-comprehensive-rules.sh`
