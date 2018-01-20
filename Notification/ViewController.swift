//
//  ViewController.swift
//  Notification
//
//  Created by feng on 2018/1/15.
//  Copyright © 2018年 feng. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            localtioniOS10Noti()
        } else {
            // Fallback on earlier versions
        }
    }
    
    func localelCreate() {
        // 用标示符创建
        let locale1 = Locale.init(identifier: "zh_CN")
        
        let strSymbol = locale1.currencySymbol
        
        // 返回系统初始本地化信息
        
        
        // 一直保持在 cache 中，第一次用此方法实例化对象后，即使修改了本地化设定，也不会改变
        let locale2 = Locale.current
        
        let calendarIdentifier = locale2.calendar.identifier
        
        // 每次修改本地化设定，其实例化的对象也会随之改变 A locale which tracks the user’s current preferences.
        let locale3 = Locale.autoupdatingCurrent
    }
    
    // 设置区域
    func localelSet() {
        var calendar = Calendar.current
        calendar.locale = Locale.init(identifier: "zh_CN")
    }
    
    /// 创建本地通知
    @available(iOS 10.0, *)
    func localtioniOS10Noti() {
        let content = UNMutableNotificationContent.init()
        content.title = "本地通知测试".localized
        content.body = "mmm".localized
        content.categoryIdentifier = "TIMER_EXPIRED"
        content.sound = UNNotificationSound.default()
        
        var dateComponents = DateComponents()
        dateComponents.hour = 16
        dateComponents.minute = 22
        
        
        // UNPushNotificationTrigger,UNTimeIntervalNotificationTrigger,UNCalendarNotificationTrigger,UNLocationNotificationTrigger
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest.init(identifier: "localNoti1", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
    }

    @available(iOS, introduced: 8.0, deprecated: 10.0, message: "只提供iOS8-9使用")
    func localtioniOS8To9Noti() {
        let itemDate = Date()
        let localNoti = UILocalNotification()
        localNoti.alertTitle = "本地通知标题"
        localNoti.alertBody = "本地通知内容"
        localNoti.soundName = UILocalNotificationDefaultSoundName
        localNoti.applicationIconBadgeNumber = 1
        let infoDict = ["localNoti":"ID:10"]
        localNoti.userInfo = infoDict
        localNoti.fireDate = itemDate.addingTimeInterval(10)
        localNoti.timeZone = TimeZone.current
        
        //基于地理位置的通知，首先开启定位，在试用期间开启定位权限
        localNoti.alertBody = "你已到达xx"
        localNoti.regionTriggersOnce = false //每次跨过都发通知
        localNoti.region = CLCircularRegion.init(center: CLLocationCoordinate2D.init(latitude: 40, longitude: 116), radius: 100, identifier: "home")
        
        
        // 为通知设置类型
        localNoti.category = "GENERAL"
        
//        UIApplication.shared.presentLocalNotificationNow(localNoti)
        UIApplication.shared.scheduleLocalNotification(localNoti)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

