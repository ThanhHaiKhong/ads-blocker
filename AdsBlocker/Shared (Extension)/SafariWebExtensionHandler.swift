//
//  SafariWebExtensionHandler.swift
//  Shared (Extension)
//
//  Created by Thanh Hai Khong on 2/12/25.
//

import SafariServices
import os.log

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        let request = context.inputItems.first as? NSExtensionItem

        let profile: UUID?
        if #available(iOS 17.0, macOS 14.0, *) {
            profile = request?.userInfo?[SFExtensionProfileKey] as? UUID
        } else {
            profile = request?.userInfo?["profile"] as? UUID
        }

        let message: Any?
        if #available(iOS 15.0, macOS 11.0, *) {
            message = request?.userInfo?[SFExtensionMessageKey]
        } else {
            message = request?.userInfo?["message"]
        }

        os_log(.default, "Received native message: %@ (profile: %@)", String(describing: message), profile?.uuidString ?? "none")

        // Handle different message types
        var responseData: [String: Any] = [:]

        if let messageDict = message as? [String: Any],
           let action = messageDict["action"] as? String {

            os_log(.default, "Native message action: %@", action)

            switch action {
            case "getStatistics":
                // Request statistics from extension storage
                // The background script should handle this and return via storage
                responseData = [
                    "action": "getStatistics",
                    "success": true,
                    "message": "Statistics request received. Use browser.storage.local to retrieve."
                ]

            case "ping":
                responseData = [
                    "action": "ping",
                    "success": true,
                    "message": "Native host is available"
                ]

            case "writeToAppGroup":
                // Write data to App Group container for sharing with host app
                if let data = messageDict["data"] as? [String: Any] {
                    let written = writeToAppGroupContainer(data: data)
                    responseData = [
                        "action": "writeToAppGroup",
                        "success": written,
                        "message": written ? "Data written successfully" : "Failed to write data"
                    ]
                } else {
                    responseData = [
                        "action": "writeToAppGroup",
                        "success": false,
                        "error": "No data provided"
                    ]
                }

            default:
                responseData = [
                    "error": "Unknown action",
                    "success": false
                ]
            }
        } else {
            // Legacy echo behavior for compatibility
            responseData = [ "echo": message ?? "no message" ]
        }

        let response = NSExtensionItem()
        if #available(iOS 15.0, macOS 11.0, *) {
            response.userInfo = [ SFExtensionMessageKey: responseData ]
        } else {
            response.userInfo = [ "message": responseData ]
        }

        context.completeRequest(returningItems: [ response ], completionHandler: nil)
    }

    // Helper function to write statistics to App Group container
    private func writeToAppGroupContainer(data: [String: Any]) -> Bool {
        guard let containerURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.com.orlproducts.AdsBlocker"
        ) else {
            os_log(.error, "Failed to get App Group container URL")
            return false
        }

        let statisticsFile = containerURL.appendingPathComponent("statistics.json")

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            try jsonData.write(to: statisticsFile, options: .atomic)
            os_log(.default, "Statistics written to: %@", statisticsFile.path)
            return true
        } catch {
            os_log(.error, "Failed to write statistics: %@", error.localizedDescription)
            return false
        }
    }

}
