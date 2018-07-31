//
//  APIManager+Storage.swift
//  Interview
//
//  Created by Developer on 7/31/18.
//  Copyright © 2018 Roman Ganzha. All rights reserved.
//

import Foundation

extension APIManager {
    
    class func saveToken(_ token: String?) {
        UserDefaults.standard.setValue(token, forKey: "token")
    }
    
    class func loadToken() -> String? {
        return UserDefaults.standard.value(forKey: "token") as? String
    }
    
    class func clearToken() {
        UserDefaults.standard.removeObject(forKey: "token")
    }
}
