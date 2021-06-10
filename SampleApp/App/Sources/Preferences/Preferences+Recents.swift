//
//  Preferences+Recents.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import Foundation

protocol RecentsPreferencesProtocol: PreferencesProtocol {
    var recentCalleeId: String? { get set }
}

// MARK: -

extension Preferences: RecentsPreferencesProtocol {
    
    var recentCalleeId: String? {
        get {
            return prefs.string(forKey: ConstantKeys.Preferences.recentCalleeId)
        }
        set {
            prefs.set(newValue, forKey: ConstantKeys.Preferences.recentCalleeId)
        }
    }

}
