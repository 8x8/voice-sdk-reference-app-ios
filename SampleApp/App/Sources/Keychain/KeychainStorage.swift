//
//  KeychainStorage.swift
//  SampleApp
//
//  Copyright © 2023 8x8, Inc. All rights reserved.
//

import Foundation
import KeychainSwift

protocol KeychainStorageProtocol: AnyObject {
    var userDeviceId: String { get }
    var jwtToken: String? { get set }
}

// MARK: -

class KeychainStorage: KeychainStorageProtocol {
    
    // MARK: -
    
    static let shared = KeychainStorage()
    
    // MARK: -
    
    let keychain = KeychainSwift()
    
    // MARK: -
    
    var userDeviceId: String {
        if let value = keychain.get(ConstantKeys.Keychain.userDeviceID), !value.isEmpty {
            log.general.info("use existing device id (\(value))")
            return value
        }

        let value = UUID().uuidString
        keychain.set(value, forKey: ConstantKeys.Keychain.userDeviceID, withAccess: .accessibleAfterFirstUnlock)
        log.general.info("created a new device id (\(value))")
        return value
    }

    // MARK: -
    
    var jwtToken: String? {
        get {
            keychain.get(ConstantKeys.Keychain.accessToken)
        }
        set {
            if let value = newValue {
                keychain.set(value, forKey: ConstantKeys.Keychain.accessToken, withAccess: .accessibleAfterFirstUnlock)
            } else {
                keychain.delete(ConstantKeys.Keychain.accessToken)
            }
        }
    }

}
