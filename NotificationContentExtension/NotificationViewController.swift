//
//  NotificationViewController.swift
//  NotificationContentExtension
//
//  Created by feng on 2018/1/15.
//  Copyright © 2018年 feng. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI


// 重按通知进入大图时
class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
    }

}
