//
//  Preferences+Profile.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import Foundation
import Wavecell

protocol UserProfilePreferencesProtocol: PreferencesProtocol {
    var account: Account? { get set }
    var userDeviceRegistered: Bool { get set }
    var profile: Profile? { get set }
    var callKit: CallKitOptions? { get set }
    var phoneNumber: String? { get set }
    var inboundCallPath: InboundCallPath { get set }
}
    
// MARK: -

extension CallKitOptions: ModelObject {}
    
// MARK: -

extension Preferences: UserProfilePreferencesProtocol {

    var account: Account? {
        get {
            get(for: ConstantKeys.Preferences.account)
        }
        set {
            set(object: newValue, for: ConstantKeys.Preferences.account)
        }
    }

    var userDeviceRegistered: Bool {
        get {
            return prefs.bool(forKey: ConstantKeys.Preferences.userDeviceRegistered)
        }
        set {
            prefs.set(newValue, forKey: ConstantKeys.Preferences.userDeviceRegistered)
        }
    }
    
    var profile: Profile? {
        get {
            return get(for: ConstantKeys.Preferences.userProfile)
        }
        set {
            set(object: newValue, for: ConstantKeys.Preferences.userProfile)
        }
    }

    var callKit: CallKitOptions? {
        get {
            return get(for: ConstantKeys.Preferences.callKit)
        }
        set {
            set(object: newValue, for: ConstantKeys.Preferences.callKit)
        }
    }

    var phoneNumber: String? {
        get {
            return prefs.string(forKey: ConstantKeys.Preferences.phoneNumber)
        }
        set {
            prefs.set(newValue, forKey: ConstantKeys.Preferences.phoneNumber)
        }
    }

    var inboundCallPath: InboundCallPath {
        get {
            if let val = prefs.string(forKey: ConstantKeys.Preferences.inboundCallPath), let value = InboundCallPath(rawValue: val) {
                return value
            }
            return .voip
        }
        set {
            prefs.set(newValue.rawValue, forKey: ConstantKeys.Preferences.inboundCallPath)
        }
    }
}
