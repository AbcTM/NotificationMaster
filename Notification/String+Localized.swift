//
//  String+Localized.swift
//  Notification
//
//  Created by feng on 2018/1/17.
//  Copyright © 2018年 feng. All rights reserved.
//

import Foundation


extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func localized(withComment:String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: withComment)
    }
    
    func localized(tableName: String) -> String{
        return NSLocalizedString(self, tableName: tableName, bundle: Bundle.main, value: "", comment: "")
    }
}

