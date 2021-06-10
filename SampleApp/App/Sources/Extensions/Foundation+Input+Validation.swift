//
//  Foundation+Input+Validation.swift
//  SampleApp
//
//  Copyright © 2021 8x8, Inc. All rights reserved.
//

import UIKit

struct InputValidation {
    let pattern: String
    let characterSet: CharacterSet
    let maxLength: Int
}

// MARK: -

extension InputValidation {
    
    static let accountID = InputValidation(pattern: .regexPatternAccountId,
                                           characterSet: .accountId,
                                           maxLength: 20)

    static let serviceUrl = InputValidation(pattern: "",
                                            characterSet: .serviceUrl,
                                            maxLength: 160)

    static let jwtUrl = InputValidation(pattern: "",
                                        characterSet: .jwtUrl,
                                        maxLength: 160)

}

// MARK: -

extension String {

    static let regexPatternAccountId = "^[a-zA-Z0-9&&[^pP]]([_](?![_])|[a-zA-Z0-9&&[^pP]]){3,18}[a-zA-Z0-9&&[^pP]]$"

    // MARK: -
    
    func match(pattern: String) -> Bool {
        return range(of: pattern, options: .regularExpression) != nil
    }
    
    func isValidURL() -> Bool {
        if let value = URL(string: self) {
            return value.isValid
        }
        return false
    }
    
}

// MARK: -

extension CharacterSet {
    
    static let accountId: CharacterSet = {
        var set = CharacterSet.alphanumerics
        set.formUnion(CharacterSet(charactersIn: "_"))
        set.subtract(CharacterSet(charactersIn: "pP"))
        return set
    }()

    static let serviceUrl: CharacterSet = {
        var set = CharacterSet.urlHostAllowed
        set.formUnion(.urlPathAllowed)
        return set
    }()

    static let jwtUrl: CharacterSet = {
        var set = CharacterSet.urlHostAllowed
        set.formUnion(.urlPathAllowed)
        return set
    }()

}

// MARK: -

extension URL {
    var isValid: Bool {
        (scheme == "http" || scheme == "https") &&
        (host != nil) &&
        UIApplication.shared.canOpenURL(self)
    }
}
