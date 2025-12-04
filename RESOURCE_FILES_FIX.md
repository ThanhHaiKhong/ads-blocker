# Resource Files Fix - Extension Bundle Issue

## Problem
Safari extension showed errors in Settings:
```
Unable to find "rules/ads.json" in the extension's resources. It is an invalid path.
Unable to find "rules/tracking.json" in the extension's resources. It is an invalid path.
Unable to find "ruleLoader.js" in the extension's resources. It is an invalid path.
Unable to find "whitelistManager.js" in the extension's resources. It is an invalid path.
```

## Root Cause
The Xcode project's `PBXFileSystemSynchronizedBuildFileExceptionSet` was missing the new resource files, so they weren't being copied into the extension bundle during build.

## Solution
Updated `AdsBlocker.xcodeproj/project.pbxproj` to include missing files in the extension bundle.

### Changes Made

#### 1. Updated iOS Extension Membership Exceptions
Added to `7F86F4152EDE8F030008C21C` (iOS Extension):
```
Resources/debug.js
Resources/ruleLoader.js
Resources/rules
Resources/whitelistManager.js
```

#### 2. Updated macOS Extension Membership Exceptions
Added to `7F86F4162EDE8F030008C21C` (macOS Extension):
```
Resources/debug.js
Resources/ruleLoader.js
Resources/rules
Resources/whitelistManager.js
```

#### 3. Added Rules Folder to Explicit Folders
Added to `7F86F3A82EDE8F020008C21C` (Shared Extension):
```
explicitFolders = (
    Resources/_locales,
    Resources/images,
    Resources/rules,  // <-- ADDED
);
```

## Verification

### Files Now Included in Extension Bundle

**macOS Extension** (`AdsBlocker Extension.appex/Contents/Resources/`):
```
✅ background.js
✅ content.js
✅ debug.js
✅ ruleLoader.js
✅ whitelistManager.js
✅ manifest.json
✅ popup.js
✅ popup.html
✅ popup.css
✅ _locales/
✅ images/
✅ rules/
   ✅ ads.json
   ✅ tracking.json
```

**iOS Extension** (`AdsBlocker Extension.appex/`):
```
✅ background.js
✅ content.js
✅ debug.js
✅ ruleLoader.js
✅ whitelistManager.js
✅ manifest.json
✅ popup.js
✅ popup.html
✅ popup.css
✅ _locales/
✅ images/
✅ rules/
   ✅ ads.json
   ✅ tracking.json
```

### Build Status
- ✅ iOS Build: **SUCCEEDED**
- ✅ macOS Build: **SUCCEEDED**

## How to Verify

### After Building
1. Build the project in Xcode
2. Check the built extension bundle:

**For macOS:**
```bash
ls -la ~/Library/Developer/Xcode/DerivedData/AdsBlocker-*/Build/Products/Debug/AdsBlocker\ Extension.appex/Contents/Resources/
```

**For iOS Simulator:**
```bash
ls -la ~/Library/Developer/Xcode/DerivedData/AdsBlocker-*/Build/Products/Debug-iphonesimulator/AdsBlocker\ Extension.appex/
```

### In Safari
1. Enable Safari Developer menu (Safari → Settings → Advanced → Show Develop menu)
2. macOS: Develop → Allow Unsigned Extensions
3. Open Safari Settings → Extensions
4. The extension should load without path errors

## Why This Happened

Xcode's "File System Synchronized Root Group" feature requires explicitly listing:
1. All files you want included via `membershipExceptions`
2. All directories containing resources via `explicitFolders`

When new files are added to the project, they need to be manually added to these lists in `project.pbxproj`.

## Future Additions

When adding new resource files to `Shared (Extension)/Resources/`, update both:

1. **membershipExceptions** (in both iOS and macOS extension targets)
2. **explicitFolders** (if adding a new directory)

Example for adding a new file `newScript.js`:

```xml
membershipExceptions = (
    Resources/_locales,
    Resources/background.js,
    Resources/content.js,
    Resources/debug.js,
    Resources/images,
    Resources/manifest.json,
    Resources/newScript.js,  // <-- ADD HERE
    Resources/popup.css,
    Resources/popup.html,
    Resources/popup.js,
    Resources/ruleLoader.js,
    Resources/rules,
    Resources/whitelistManager.js,
    SafariWebExtensionHandler.swift,
);
```

## Related Files
- `AdsBlocker/AdsBlocker.xcodeproj/project.pbxproj` (modified)
- `AdsBlocker/Shared (Extension)/Resources/rules/ads.json` (now included)
- `AdsBlocker/Shared (Extension)/Resources/rules/tracking.json` (now included)
- `AdsBlocker/Shared (Extension)/Resources/ruleLoader.js` (now included)
- `AdsBlocker/Shared (Extension)/Resources/whitelistManager.js` (now included)
- `AdsBlocker/Shared (Extension)/Resources/debug.js` (now included)

## Next Steps
1. ✅ Rebuild the project (both platforms build successfully)
2. ✅ Run on macOS or iOS
3. ✅ Verify extension loads without errors in Safari Settings
4. ✅ Test ad blocking functionality
5. ✅ Test statistics tracking

All resource files are now properly included in the extension bundle!
