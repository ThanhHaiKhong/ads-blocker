# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Safari browser extension for iOS and macOS designed to block advertisements. The project uses a hybrid architecture combining Swift for native app components and JavaScript for browser extension logic.

## Build and Development Commands

### Building
```bash
# Build for iOS
xcodebuild -workspace AdsBlocker.xcworkspace -scheme "AdsBlocker (iOS)" -configuration Debug build

# Build for macOS
xcodebuild -workspace AdsBlocker.xcworkspace -scheme "AdsBlocker (macOS)" -configuration Debug build

# Build Features Swift package
xcodebuild -workspace AdsBlocker.xcworkspace -scheme "Features" build
```

### Testing
```bash
# Run tests for iOS
xcodebuild test -workspace AdsBlocker.xcworkspace -scheme "AdsBlocker (iOS)" -destination 'platform=iOS Simulator,name=iPhone 15'

# Run tests for macOS
xcodebuild test -workspace AdsBlocker.xcworkspace -scheme "AdsBlocker (macOS)" -destination 'platform=macOS'
```

### Opening in Xcode
```bash
open AdsBlocker.xcworkspace
```

## Architecture

### Multi-Platform Structure

The project is organized into platform-specific and shared components:

- **Shared (App)**: Common app code used by both iOS and macOS host applications
- **Shared (Extension)**: Common extension code, including `SafariWebExtensionHandler.swift` for native messaging
- **iOS (App)** / **macOS (App)**: Platform-specific app implementations
- **iOS (Extension)** / **macOS (Extension)**: Platform-specific extension bundles
- **Features/**: Swift Package for modular feature development

### Key Components

**Extension Bundle ID**: `com.thanhhaikhong.AdsBlocker.Extension`

**Native-JS Bridge**:
- `SafariWebExtensionHandler.swift` handles native messaging via `browser.runtime.sendNativeMessage()`
- Supports both legacy (iOS 14/macOS 10) and modern (iOS 15+/macOS 11+) Safari APIs
- Messages are echoed back with profile UUID tracking

**App Host**:
- `ViewController.swift` manages WebKit view displaying extension status
- Uses `SFSafariExtensionManager` to check extension state
- Communicates with WebKit via `WKScriptMessageHandler` for preference opening
- Platform detection via compile-time `#if os(iOS)` / `#if os(macOS)` directives

**Browser Extension** (Manifest V3):
- `background.js`: Service worker for message handling
- `content.js`: Injected into web pages (currently only `*://example.com/*`)
- `popup.html/js/css`: Extension toolbar popup UI
- Message passing between content/background/native via `browser.runtime.sendMessage()`

### Important Files

- `AdsBlocker/Shared (Extension)/Resources/manifest.json` - Extension manifest, defines permissions and content script matches
- `AdsBlocker/Shared (Extension)/SafariWebExtensionHandler.swift` - Native messaging bridge
- `AdsBlocker/Shared (App)/ViewController.swift` - Host app view controller with extension state management
- `AdsBlocker/Shared (App)/Resources/Script.js` - WebKit UI logic for showing extension status

## Development Notes

### Content Script Scope
Currently the extension only runs on `example.com` (see manifest.json:24). To enable ad blocking across all sites, modify the `matches` pattern in the content_scripts section.

### Platform Conditionals
The codebase uses Swift's conditional compilation extensively. When modifying shared code, ensure iOS and macOS code paths are both handled using `#if os(iOS)` and `#if os(macOS)`.

### Extension State Management
macOS 13+ uses different Settings terminology vs earlier versions. The app dynamically adjusts UI text via `useSettingsInsteadOfPreferences` parameter (Script.js:4-9).

### Swift Package Integration
The Features package is integrated via Xcode workspace. Add new feature modules as targets in `Features/Package.swift`.
