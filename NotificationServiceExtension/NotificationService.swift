//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by feng on 2018/1/15.
//  Copyright © 2018年 feng. All rights reserved.
//

import UserNotifications


// aps 中 "mutable-content":1, 支持自定义
class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        uploadMyServer(notiid: "NotificationService_didReceive_withContentHandler")
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}


extension NotificationService {
    func uploadMyServer(notiid: String) {
        let task = URLSession.shared.dataTask(with: URL.init(string: "http://192.168.20.12:8080/\(notiid)")!) { (data, response, error) in
            
        }
        task.resume()
    }
}
