//
//  Constants+UIColors.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit

private extension String {
    
    func color() -> UIColor {
        return UIColor(named: self) ?? .clear
    }
    
}

// MARK: -

extension UIColor {
    static let appDarkBlue = "dark-blue-color".color()
    static let appSoftBlue = "soft-blue-color".color()
    static let appSoftRed = "soft-red-color".color()
    static let appSoftGreen = "soft-green-color".color()
    static let appSoftGold = "soft-gold-color".color()
}
