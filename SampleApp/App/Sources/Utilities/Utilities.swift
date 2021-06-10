//
//  Utilities.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import Foundation
import KeychainSwift

class Utilities {
    
    static func appVersion() -> String {
        guard let info = Bundle.main.infoDictionary,
            let version = info["CFBundleShortVersionString"] as? String,
            let build = info["CFBundleVersion"] as? String else {
                return ""
        }
        return "\(version)-b(\(build))"
    }
    
    static func appFullVersion() -> String {
        guard let info = Bundle.main.infoDictionary,
            let version = info["CFBundleFullVersionString"] as? String else {
                return ""
        }
        return version
    }
    
    // MARK: -
    
    static func shouldUseSandboxPushEnvironment() -> Bool {
        guard let info = Bundle.main.infoDictionary,
            let value = info["CFProductDistributionType"] as? String else {
                return false
        }
        return value == "development"
    }

}
