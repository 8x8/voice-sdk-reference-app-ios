//
//  CallControl+Appearance.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit

extension CallControlActionType {
    
    func appearance(for theme: CallControlTheme, _ enabled: Bool) -> CallControlAppearance {
        var value: CallControlAppearance
        switch theme {
        case .light:
            value = CallControlAppearance.light(self, enabled)
        case .dark:
            value = CallControlAppearance.dark(self, enabled)
        }
        return value
    }
    
}

// MARK: -

extension CallControlAppearance {
    
    static func light(_ actionType: CallControlActionType, _ enabled: Bool) -> CallControlAppearance {
        var value: CallControlAppearance
        switch actionType {
        case .hangup:
            value = CallControlAppearance(backgroundColor: .appSoftRed,
                                          borderColor: .appSoftRed,
                                          tintColor: .white,
                                          textColor: .appDarkBlue)
        case .unmute, .speaker, .unhold:
            value = CallControlAppearance(backgroundColor: .appDarkBlue,
                                          borderColor: .appDarkBlue,
                                          tintColor: .white,
                                          textColor: .appDarkBlue)
        default:
            value = CallControlAppearance(backgroundColor: .clear,
                                          borderColor: .appDarkBlue,
                                          tintColor: .appDarkBlue,
                                          textColor: .appDarkBlue)
        }
        return value
    }
    
    // MARK: -
    
    static func dark(_ actionType: CallControlActionType, _ enabled: Bool) -> CallControlAppearance {
        var value: CallControlAppearance
        switch actionType {
        case .hangup:
            value = CallControlAppearance(backgroundColor: .red,
                                          borderColor: .red,
                                          tintColor: .white,
                                          textColor: .white)
        case .unmute, .speaker, .unhold:
            value = CallControlAppearance(backgroundColor: .blue,
                                          borderColor: .blue,
                                          tintColor: .white,
                                          textColor: .white)
        default:
            value = CallControlAppearance(backgroundColor: .clear,
                                          borderColor: enabled ? .white : .lightGray,
                                          tintColor: .white,
                                          textColor: .white)
        }
        return value

    }
    
}
