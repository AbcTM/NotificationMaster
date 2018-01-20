//
//  AppDelegate.swift
//  Notification
//
//  Created by feng on 2018/1/15.
//  Copyright © 2018年 feng. All rights reserved.
//

import UIKit
import UserNotifications
import CoreTelephony

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        uploadMyServer(notiid: "didFinishLaunchingWithOptions")
        
        // 首先配置用户交互。
        configureUserInteractions()
        
        // 启动其他服务
        otherApplication(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        // 注册通知
        UIApplication.shared.registerForRemoteNotifications()
        // 取消注册通知
        //UIApplication.shared.unregisterForRemoteNotifications
        // 是否注册过通知(只读)
        //UIApplication.shared.isRegisteredForRemoteNotifications
        
        // 请求通知权限
        if #available(iOS 10.0, *) {//iOS 10以上
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            // 创建并注册一个通知类型（一个类别最多有四个自定义操作）
            center.setNotificationCategories(configiOS10LaterNotiCategories())
            center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                
            }
        } else {//iOS8-9
            // Fallback on earlier versions
            let settings = UIUserNotificationSettings.init(types: [.alert, .sound, .badge], categories: configiOS8To9NotiCategories())
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        // 清楚所有通知
        if #available(iOS 10.0, *) {
            //能移除所有的通知，但是移出不了角标
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            UIApplication.shared.applicationIconBadgeNumber = 0
        }else{
            UIApplication.shared.cancelAllLocalNotifications()
            UIApplication.shared.applicationIconBadgeNumber = 1
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
        

        
        
        // 根据用户状态启动后台刷新
        //if  { // 登录中
            application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        //}else{ //用户退出时，就不需要获取新数据的需要了，这样可以节省资源
                //application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalNever)
        //}
    
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        uploadMyServer(notiid: "applicationWillResignActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        uploadMyServer(notiid: "applicationDidEnterBackground")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        uploadMyServer(notiid: "applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        uploadMyServer(notiid: "applicationDidBecomeActive")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        uploadMyServer(notiid: "applicationWillTerminate")
    }


}

extension AppDelegate {
    
    /// 首先配置用户交互。
    func configureUserInteractions() {
        let cellularData = CTCellularData()
        let state = cellularData.restrictedState
        
        switch state {
        case .notRestricted:
            print("当前数据网络权限授权")
            break
        case .restrictedStateUnknown:
            print("当前数据网络权限未知")
            break
        case .restricted:
            print("当前数据网络权限已被拒绝")
            break
        }
        
        //监听网络权限变化
        cellularData.cellularDataRestrictionDidUpdateNotifier = { (state: CTCellularDataRestrictedState) in
            switch state {
            case .notRestricted:
                print("当前数据网络权限授权")
                break
            case .restrictedStateUnknown:
                print("当前数据网络权限未知")
                break
            case .restricted:
                print("当前数据网络权限已被拒绝")
                break
            }
        }
    }
}

// 注册通知响应类型
extension AppDelegate {
    @available(iOS 10.0, *)
    func configiOS10LaterNotiCategories() -> Set<UNNotificationCategory> {
        var categorys = Set<UNNotificationCategory>()
        let generalCategory = UNNotificationCategory(identifier: "GENERAL",
                                                     actions: [],
                                                     intentIdentifiers: [],
                                                     options: .customDismissAction)
        
        // Create the custom actions for the TIMER_EXPIRED category.
        let snoozeAction = UNNotificationAction(identifier: "SNOOZE_ACTION",
                                                title: "Snooze",
                                                options: UNNotificationActionOptions(rawValue: 0))//在后台处理
        let stopAction = UNNotificationAction(identifier: "STOP_ACTION",
                                              title: "Stop",
                                              options: .foreground)//点击后进入前台
        
        let expiredCategory = UNNotificationCategory(identifier: "TIMER_EXPIRED",
                                                     actions: [snoozeAction, stopAction],
                                                     intentIdentifiers: [],
                                                     options: UNNotificationCategoryOptions(rawValue: 0))
        
        categorys.insert(generalCategory)
        categorys.insert(expiredCategory)
        return categorys
    }
    
    @available(iOS, introduced: 8.0, deprecated: 10.0, message: "只提供iOS8-9使用")
    func configiOS8To9NotiCategories() -> Set<UIUserNotificationCategory> {
        var categorys = Set<UIUserNotificationCategory>()
        
        // 设置通知行为
        let mutiUserNotiAction = UIMutableUserNotificationAction.init()
        mutiUserNotiAction.behavior = UIUserNotificationActionBehavior.textInput
        mutiUserNotiAction.identifier = "inputAction"
        mutiUserNotiAction.activationMode = .background
        
        // 设置通知策略
        let mutiNotiCategory = UIMutableUserNotificationCategory()
        mutiNotiCategory.identifier = "GENERAL"
        
        // 为弹窗模式设置 actions
        mutiNotiCategory.setActions([mutiUserNotiAction], for: UIUserNotificationActionContext.default)
        // 为横幅模式设置 actions
        mutiNotiCategory.setActions([mutiUserNotiAction], for: UIUserNotificationActionContext.minimal)
        categorys.insert(mutiNotiCategory)
        return categorys
    }
}


// MARK: - handleNotificationAction
extension AppDelegate {
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        
    }
}

// MARK: - shortcutItem
extension AppDelegate {
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
    }
}

// MARK: - handleEventsForBackgroundURLSession
extension AppDelegate {
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        
    }
}

@available(iOS 10.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    /// 将要弹出一个通知
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
//        uploadMyServer(notiid: "userNotificationCenter_willPresent_notification")
//        completionHandler([.sound]) //设置策略 ,.alert, .badge, 设置alert在前台也会弹出，
//    }
    
    /// 接收到用户点击通知事件
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        uploadMyServer(notiid: "userNotificationCenter_didReceive_response")
        completionHandler()
    }
}

extension AppDelegate {
    
    // 注册通知成功
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Forward the token to your provider, using a custom method.
        self.enableRemoteNotificationFeatures()
        self.forwardTokenToServer(token: deviceToken)
    }
    
    // 注册通知失败
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // The token is not currently available.
        self.disableRemoteNotificationFeatures()
    }
    
    // 接收到通知(前台)
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        uploadMyServer(notiid: "didReceiveRemoteNotification_fetchCompletionHandler")
        completionHandler(UIBackgroundFetchResult.newData)
        //UIBackgroundFetchResult.newData
        
        //例如，在收到后台更新远程通知后，您可能会开始为您的应用下载新内容。
    }
    
    // 自动更新
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        uploadMyServer(notiid: "performFetchWithCompletionHandler")
        // 网络请求后决定新内容是否可用
        //if hasNewData {
        completionHandler(.newData)//30秒来确定新内容是否可用，然后处理新内容并更新界面。30 秒时间应该足够去从网络获取数据和获取界面的缩略图，但是最多只有 30 秒。当完成了网络请求和更新界面后，你应该执行完成的回调。
        //}else{
        //completionHandler(.noData)
        
        // 网络错误等
        //completionHandler(.failed)
        
        /**
         完成回调的执行有两个目的。首先，系统会估量你的进程消耗的电量，并根据你传递的 UIBackgroundFetchResult 参数记录新数据是否可用。其次，当你调用完成的处理代码时，应用的界面缩略图会被采用，并更新应用程序切换器。当用户在应用间切换时，用户将会看到新内容。这种通过 completion handler 来报告并且生成截图的方法，在新的多任务处理 API 中是很常见的。
         在实际应用中，你应该将 completionHandler 传递到应用程序的子组件，然后在处理完数据和更新界面后调用。
         */
        
        
    }
    
    // 启动其他服务
    func otherApplication(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        
        
        guard let remoteNotiInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable : Any] else {
            return
        }
        
        // 从通知启动
        print("从通知启动应用:",remoteNotiInfo.description)
        
        uploadMyServer(notiid: "didFinishLaunchingWithOptions-Noti")
    }
    
    func enableRemoteNotificationFeatures() {
        
    }
    
    func disableRemoteNotificationFeatures() {
        
    }
    
    func forwardTokenToServer(token: Data) {
        //APN设备令牌长度可变
        let deviceTokenData = NSData(data: token)
        let deviceToken = deviceTokenData.description.replacingOccurrences(of:"<", with:"").replacingOccurrences(of:">", with:"").replacingOccurrences(of:" ", with:"")
        print("APN设备推送令牌:",deviceToken)
        
        uploadMyServer(notiid: deviceToken)
    }
    
    func uploadMyServer(notiid: String) {
        let task = URLSession.shared.dataTask(with: URL.init(string: "http://192.168.20.12:8080/\(notiid)")!) { (data, response, error) in
            if let error = error {
                print("请求错误,error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
