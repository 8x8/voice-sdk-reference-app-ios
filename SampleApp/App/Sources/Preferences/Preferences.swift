//
//  Preferences.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import Foundation
import Prephirences

protocol PreferencesProtocol: AnyObject {
    func deviceId() -> String
    func reset()
}

// MARK: -

class Preferences: Observable {
    
    var prefs: MutablePreferencesType
    
    // MARK: -
    
    static var shared: Preferences!
    
    // MARK: -
    
    private var udid: String
    
    // set of keys ignored during clean
    private var preserved: [String] = [String]()

    // MARK: -
    
    var observers = WeakObjectCollection<AnyObject>()
    
    // MARK: -

    init(udid: String, implementation: MutablePreferencesType, preserved: [String] = []) {
        self.udid = udid
        self.prefs = implementation
        self.preserved = preserved
    }
    
    // MARK: -
    
    @discardableResult
    static func initialize(with udid: String, preserved: [String] = []) -> Preferences {
        if let object = shared {
            return object
        }
        
        let implementation = MutableProxyPreferences(preferences: UserDefaults.standard,
                                                     key: "\(udid)", separator: ".")
        shared = Preferences(udid: udid,
                             implementation: implementation,
                             preserved: preserved)
        return shared
    }
    
    // MARK: -
    
    func deviceId() -> String {
        return udid
    }
    
    // MARK: -

    func reset() {
        for (key, _) in prefs.dictionary() {
            if preserved.contains(key) {
                continue
            }
            prefs.removeObject(forKey: key)
        }
    }
    
    // MARK: -
    
    func set<T: ModelObject>(object: T?, for key: String) {
        if let object = object {
            prefs[key] = object.json
        } else {
            prefs.removeObject(forKey: key)
        }
    }
    
    func get<T: ModelObject>(for key: String) -> T? {
        if let data = prefs.dictionary(forKey: key) {
            return try? T(json: data)
        }
        return nil
    }
    
}
