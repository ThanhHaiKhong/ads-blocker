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
                // The extension will handle this via background script
                // This is a passthrough to trigger background.js
                responseData = [
                    "action": "getStatistics",
                    "success": true
                ]

            case "ping":
                responseData = [
                    "action": "ping",
                    "success": true,
                    "message": "Native host is available"
                ]

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

}
