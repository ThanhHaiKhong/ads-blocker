//
//  ViewController.swift
//  Shared (App)
//
//  Created by Thanh Hai Khong on 2/12/25.
//

import WebKit

#if os(iOS)
import UIKit
typealias PlatformViewController = UIViewController
#elseif os(macOS)
import Cocoa
import SafariServices
typealias PlatformViewController = NSViewController
#endif

let extensionBundleIdentifier = "com.thanhhaikhong.AdsBlocker.Extension"

class ViewController: PlatformViewController, WKNavigationDelegate, WKScriptMessageHandler {

    @IBOutlet var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.navigationDelegate = self

#if os(iOS)
        self.webView.scrollView.isScrollEnabled = false
#endif

        self.webView.configuration.userContentController.add(self, name: "controller")

        self.webView.loadFileURL(Bundle.main.url(forResource: "Main", withExtension: "html")!, allowingReadAccessTo: Bundle.main.resourceURL!)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
#if os(iOS)
        webView.evaluateJavaScript("show('ios')")
#elseif os(macOS)
        webView.evaluateJavaScript("show('mac')")

        SFSafariExtensionManager.getStateOfSafariExtension(withIdentifier: extensionBundleIdentifier) { (state, error) in
            guard let state = state, error == nil else {
                // Insert code to inform the user that something went wrong.
                return
            }

            DispatchQueue.main.async {
                if #available(macOS 13, *) {
                    webView.evaluateJavaScript("show('mac', \(state.isEnabled), true)")
                } else {
                    webView.evaluateJavaScript("show('mac', \(state.isEnabled), false)")
                }
            }
        }
#endif
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let messageBody = message.body as? String else {
            return
        }

#if os(macOS)
        switch messageBody {
        case "open-preferences":
            openPreferences()

        case "get-statistics":
            loadStatisticsFromExtension()

        default:
            print("Unknown message: \(messageBody)")
        }
#endif
    }

#if os(macOS)
    private func openPreferences() {
        SFSafariApplication.showPreferencesForExtension(withIdentifier: extensionBundleIdentifier) { error in
            guard error == nil else {
                // Insert code to inform the user that something went wrong.
                return
            }

            DispatchQueue.main.async {
                NSApp.terminate(self)
            }
        }
    }

    private func loadStatisticsFromExtension() {
        print("[App] Loading statistics from extension...")

        // Get the extension's data container
        guard let containerURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.com.thanhhaikhong.AdsBlocker"
        ) else {
            print("[App] Failed to get shared container URL")
            // Try loading from local storage instead
            loadStatisticsFromLocalStorage()
            return
        }

        let storageURL = containerURL.appendingPathComponent("Library/WebKit/WebsiteData/LocalStorage/safari-extension___\(extensionBundleIdentifier)")

        print("[App] Looking for extension data at: \(storageURL.path)")

        // For now, we'll use a simpler approach - send a message to get statistics
        // This would require the extension to expose statistics via native messaging
        // For this phase, we'll use dummy data as a demonstration

        let dummyStatistics: [String: Any] = [
            "totalBlocked": 1234,
            "blockedByRuleset": [
                "ads_ruleset": 789,
                "tracking_ruleset": 445
            ]
        ]

        updateWebViewWithStatistics(dummyStatistics)
    }

    private func loadStatisticsFromLocalStorage() {
        print("[App] Attempting to load from local storage...")

        // This is a placeholder - in a production app, you would:
        // 1. Use App Groups to share data between app and extension
        // 2. Or use native messaging to request data from the extension
        // 3. Or use SFSafariExtension.getBaseURI() to access extension resources

        let dummyStatistics: [String: Any] = [
            "totalBlocked": 0,
            "blockedByRuleset": [
                "ads_ruleset": 0,
                "tracking_ruleset": 0
            ]
        ]

        updateWebViewWithStatistics(dummyStatistics)
    }

    private func updateWebViewWithStatistics(_ statistics: [String: Any]) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: statistics, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                let script = "updateStatisticsDisplay(\(jsonString))"
                print("[App] Executing script: \(script)")

                webView.evaluateJavaScript(script) { result, error in
                    if let error = error {
                        print("[App] Error updating statistics: \(error)")
                    } else {
                        print("[App] Successfully updated statistics display")
                    }
                }
            }
        } catch {
            print("[App] Error serializing statistics: \(error)")
        }
    }
#endif

}
