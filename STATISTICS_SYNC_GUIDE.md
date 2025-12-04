# Statistics Sync Testing Guide

## Overview
This guide helps you test and verify the statistics synchronization between the Safari extension and the host app via App Groups.

---

## Prerequisites

1. **App is built and running** (macOS or iOS)
2. **Extension is enabled in Safari**
3. **App Groups are properly configured** (already done in previous setup)

---

## How Statistics Sync Works

```
Extension → Native Message → SafariWebExtensionHandler → App Group (statistics.json) → Host App
```

1. **Extension** tracks blocked ads/trackers in `browser.storage.local`
2. **Background script** syncs statistics every 30 seconds to App Group
3. **Native handler** (`SafariWebExtensionHandler.swift`) writes to shared container
4. **Host app** reads from shared container when it launches or refreshes

---

## Testing Steps

### Step 1: Verify Extension is Loaded

1. Open **Safari**
2. Go to **Safari → Settings → Extensions**
3. Find **AdsBlocker** in the list
4. Make sure it's **enabled** (checkbox checked)
5. Click on **AdsBlocker** to see details
6. You should **NOT** see these errors anymore:
   ```
   ❌ Unable to find "rules/ads.json"
   ❌ Unable to find "ruleLoader.js"
   ```

### Step 2: Add Test Statistics

1. In Safari, click the **AdsBlocker extension icon** in the toolbar
2. The popup should open showing:
   - Total Blocked: 0
   - Toggle switches for Ads and Trackers
   - Current site information
3. Scroll down to the bottom
4. Click **"[Dev] Add 100 Test Blocks"**
5. You should see:
   - Notification: "Added 100 test blocks"
   - Total Blocked: **100**

### Step 3: Manually Sync to App Group

1. In the same popup, click **"[Dev] Sync to App Now"**
2. Watch for the notification:
   - ✅ Success: "Statistics synced to app!"
   - ❌ Failure: "Native messaging not available" or error message

3. **Check Safari's Web Inspector for logs:**
   - Safari → Develop → Web Extension Background Pages → AdsBlocker Extension
   - Look for console messages:
     ```
     [Popup] Manually syncing statistics to App Group...
     [Popup] Current stats: {totalBlocked: 100, ...}
     [Popup] Native message response: {success: true, message: "Data written successfully"}
     ```

### Step 4: Verify in Host App

1. **Reopen the AdsBlocker host app** (quit and restart)
2. Check the **Console.app** or Xcode console for messages:
   ```
   [App] Loading statistics from extension...
   [App] Looking for statistics at: /Users/.../Group Containers/group.com.orlproducts.AdsBlocker/statistics.json
   ```

3. **Expected outcomes:**

   **If sync worked:**
   ```
   [App] Successfully loaded statistics from App Group
   [App] Successfully updated statistics display
   Total Blocked: 100
   Ads: 60 | Trackers: 40
   ```

   **If file doesn't exist yet:**
   ```
   [App] Statistics file does not exist yet
   [App] Loading default statistics...
   Total Blocked: 0
   ```

### Step 5: Check the Statistics File Directly

1. Open **Terminal**
2. Run this command to check if the file exists:
   ```bash
   ls -la ~/Library/Group\ Containers/group.com.orlproducts.AdsBlocker/statistics.json
   ```

3. **If file exists**, view its contents:
   ```bash
   cat ~/Library/Group\ Containers/group.com.orlproducts.AdsBlocker/statistics.json
   ```

4. **Expected content:**
   ```json
   {
     "totalBlocked": 100,
     "blockedByDomain": {},
     "blockedByRuleset": {
       "ads_ruleset": 60,
       "tracking_ruleset": 40
     },
     "lastReset": "2025-12-04T08:00:00.000Z"
   }
   ```

---

## Troubleshooting

### Issue: "Native messaging not available"

**Possible causes:**
1. Extension not properly signed
2. Safari security restrictions
3. App Group entitlements not applied

**Solutions:**

1. **Check entitlements are applied:**
   ```bash
   codesign -d --entitlements - ~/Library/Developer/Xcode/DerivedData/AdsBlocker-*/Build/Products/Debug/AdsBlocker\ Extension.appex
   ```

   Should show:
   ```xml
   <key>com.apple.security.application-groups</key>
   <array>
       <string>group.com.orlproducts.AdsBlocker</string>
   </array>
   ```

2. **Enable unsigned extensions (macOS only):**
   - Safari → Develop → **Allow Unsigned Extensions**

3. **Rebuild the project:**
   ```bash
   cd /Users/thanhhaikhong/Documents/ads-blocker
   xcodebuild -workspace AdsBlocker.xcworkspace -scheme "AdsBlocker (macOS)" clean build
   ```

### Issue: "Statistics file does not exist"

**This means the extension hasn't written to App Group yet.**

**Solutions:**

1. **Check extension console for errors:**
   - Safari → Develop → Web Extension Background Pages → AdsBlocker Extension
   - Look for errors in `syncStatisticsToAppGroup()` function

2. **Manually trigger sync:**
   - Open extension popup
   - Click **"[Dev] Sync to App Now"**
   - Check the notification message

3. **Wait for automatic sync:**
   - The background script syncs every 30 seconds
   - Wait 30 seconds and check again

### Issue: App shows "0" even after syncing

**Possible causes:**
1. App was already running when sync happened
2. App doesn't auto-refresh statistics

**Solutions:**

1. **Restart the host app** after syncing
2. Check the file was created:
   ```bash
   cat ~/Library/Group\ Containers/group.com.orlproducts.AdsBlocker/statistics.json
   ```

---

## Automatic Sync Behavior

The extension automatically syncs statistics in these scenarios:

1. **On startup** - Immediately when extension loads
2. **Every 30 seconds** - Periodic sync
3. **After adding test statistics** - Via "[Dev] Add 100 Test Blocks" button

To trigger a manual sync at any time, use the **"[Dev] Sync to App Now"** button.

---

## Debugging with Console Logs

### Extension Logs (Safari Web Inspector)

Safari → Develop → Web Extension Background Pages → AdsBlocker Extension

Look for:
```
[Background] Syncing statistics to App Group: {...}
[Background] Statistics synced to App Group successfully
```

Or errors:
```
[Background] Native messaging not available or error: ...
```

### App Logs (Xcode Console or Console.app)

Filter by process name: **AdsBlocker**

Look for:
```
[App] Loading statistics from extension...
[App] Looking for statistics at: .../statistics.json
[App] Successfully loaded statistics from App Group
```

Or:
```
[App] Statistics file does not exist yet
[App] Failed to get shared container URL
```

### Native Handler Logs

In Xcode Console, filter by **SafariWebExtensionHandler**:

```
Received native message: {...} (profile: ...)
Native message action: writeToAppGroup
Statistics written to: .../statistics.json
```

Or errors:
```
Failed to get App Group container URL
Failed to write statistics: ...
```

---

## Expected File Locations

### macOS

**App Group Container:**
```
~/Library/Group Containers/group.com.orlproducts.AdsBlocker/
```

**Statistics File:**
```
~/Library/Group Containers/group.com.orlproducts.AdsBlocker/statistics.json
```

### iOS Simulator

**App Group Container:**
```
~/Library/Developer/CoreSimulator/Devices/[DEVICE_ID]/data/Containers/Shared/AppGroup/[GROUP_ID]/
```

**Statistics File:**
```
[...]/statistics.json
```

---

## Success Criteria

✅ Extension loads without path errors
✅ Can add test statistics via popup
✅ "[Dev] Sync to App Now" shows success
✅ statistics.json file is created
✅ Host app reads statistics on launch
✅ Automatic sync works every 30 seconds

---

## Next Steps After Verification

Once statistics sync is working:

1. **Real ad blocking statistics** will accumulate as you browse
2. **Remove test/dev buttons** before App Store submission
3. **Add UI refresh** in host app to update without restart
4. **Add error handling** for App Group failures

---

## Quick Test Script

Run this in Terminal to quickly verify the sync:

```bash
#!/bin/bash

echo "=== Statistics Sync Test ==="
echo ""

# Check if file exists
STATS_FILE=~/Library/Group\ Containers/group.com.orlproducts.AdsBlocker/statistics.json

if [ -f "$STATS_FILE" ]; then
    echo "✅ Statistics file exists"
    echo ""
    echo "Contents:"
    cat "$STATS_FILE" | python3 -m json.tool
else
    echo "❌ Statistics file does not exist"
    echo ""
    echo "Expected location:"
    echo "$STATS_FILE"
    echo ""
    echo "Steps to create:"
    echo "1. Open Safari extension popup"
    echo "2. Click '[Dev] Add 100 Test Blocks'"
    echo "3. Click '[Dev] Sync to App Now'"
fi
```

Save as `test-stats-sync.sh`, make executable with `chmod +x test-stats-sync.sh`, and run!
