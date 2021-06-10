//
//  AppDelegate+DeviceLock.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit
import KeychainSwift

extension AppDelegate {
    
    func executeWhenProtectedDataAvailable(callback: @escaping () -> Void) {
        if canAccessProtectedData() {
            log.general.info("protected data is available")
            callback()
            return
        }
        log.general.info("protected data is unavailable")
        
        var observer: Any?
        let block: (Notification) -> Void = { _ in
            log.general.info("protected data become available")
            callback()
            if let observer = observer {
                NotificationCenter.default.removeObserver(observer)
            }
        }
        observer = NotificationCenter.default.addObserver(forName: UIApplication.protectedDataDidBecomeAvailableNotification,
                                                          object: nil, queue: .main,
                                                          using: block)
    }
    
    // MARK: -
    
    private func canAccessProtectedData() -> Bool {
        if UIApplication.shared.isProtectedDataAvailable {
            return true
        }
        
        // check if app can access the data marked
        // as available after first unlock
        let keychain = KeychainSwift()
        _ = keychain.get(ConstantKeys.Keychain.userDeviceID)
        let result = keychain.lastResultCode == errSecSuccess
        log.general.info("getting \(keychain.lastResultCode) code when trying to read device UDID")
        return result
    }
        
}
