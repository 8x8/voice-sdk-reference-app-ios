//
//  CallControlThemeAppearance.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit

enum CallControlTheme {
    case dark, light
}

// MARK: -

struct CallControlAppearance {
    var backgroundColor: UIColor
    var borderColor: UIColor
    var tintColor: UIColor
    var textColor: UIColor
}
