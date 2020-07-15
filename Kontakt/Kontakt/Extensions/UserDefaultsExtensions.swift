//
//  UserDefaultsExtensions.swift
//  Kontakt
//
//  Created by Filip Matić on 2018-11-15.
//  Copyright © 2018 Filip Matić. All rights reserved.
//
//  These extensions to UserDefaults are created to store user's contact & permissions information
//  in variables that can be accessed throughout the workspace.

import Foundation

extension UserDefaults {
    static private let firstNameKey = "firstNameInput"
    var firstNameInput: String {
        get { return string(forKey: UserDefaults.firstNameKey)! }
        set {
            set(newValue, forKey: UserDefaults.firstNameKey)
            synchronize()
        }
    }
    
    static private let lastNameKey = "lastNameInput"
    var lastNameInput: String {
        get { return string(forKey: UserDefaults.lastNameKey)! }
        set {
            set(newValue, forKey: UserDefaults.lastNameKey)
            synchronize()
        }
    }
    
    static private let phoneNumberKey = "phoneNumberInput"
    var phoneNumberInput: String {
        get { return string(forKey: UserDefaults.phoneNumberKey)! }
        set {
            set(newValue, forKey: UserDefaults.phoneNumberKey)
            synchronize()
        }
    }
    
    static private let emailKey = "emailInput"
    var emailInput: String {
        get { return string(forKey: UserDefaults.emailKey)! }
        set {
            set(newValue, forKey: UserDefaults.emailKey)
            synchronize()
        }
    }
    
    static private let addressKey = "addressInput"
    var addressInput: String {
        get { return string(forKey: UserDefaults.addressKey)! }
        set {
            set(newValue, forKey: UserDefaults.addressKey)
            synchronize()
        }
    }
    
    static private let contactInfoKey = "contactInfoComputed"
    var contactInfoComputed: String {
        get { return string(forKey: UserDefaults.contactInfoKey)! }
        set {
            set(newValue, forKey: UserDefaults.contactInfoKey)
            synchronize()
        }
    }
}
