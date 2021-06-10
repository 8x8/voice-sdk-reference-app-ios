//
//  Foundation+Dictionary.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import Foundation

extension Dictionary where Value: Any {
    
    mutating func add<T: Any>(value: T?, for key: Dictionary.Key) {
        guard let value = value else {
            return
        }
        
        if let val = value as? Dictionary.Value {
            updateValue(val, forKey: key)
        }
    }

}
