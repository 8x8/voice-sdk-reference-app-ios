//
//  Foundation+Strings.swift
//  SampleApp
//
//  Copyright © 2019 8x8, Inc. All rights reserved.
//

import Foundation

extension String {
    
    func truncated(to max: Int = 10) -> String {
        var value = substring(to: min(count, max))
        value.append("…")
        return value
    }

    // MARK: -
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }
    
    func substring(with range: Range<Int>) -> String {
        let startIndex = index(from: range.lowerBound)
        let endIndex = index(from: range.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
    func contains(_ characterSet: CharacterSet) -> Bool {
        return self.rangeOfCharacter(from: characterSet) != nil
    }

    // MARK: -
    
    var unescaped: String {
        let entities = ["\0": "\\0",
                        "\t": "\\t",
                        "\n": "\\n",
                        "\r": "\\r",
                        "\"": "\\\"",
                        "\'": "\\'"]
        
        return entities
            .reduce(self) { string, entity in
                string.replacingOccurrences(of: entity.value, with: entity.key)
            }
            .replacingOccurrences(of: "\\\\", with: "\\")
    }
}
