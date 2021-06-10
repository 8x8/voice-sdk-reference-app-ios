//
//  Profile.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import Foundation
import Elevate

struct Profile: Hashable {
    
    var accountId: String
    var userId: String
    var displayName: String
    var avatarUrl: String?

    init(accountId: String, userId: String, displayName: String, avatarUrl: String? = nil) {
        self.accountId = accountId
        self.userId = userId
        self.displayName = displayName
        self.avatarUrl = avatarUrl
    }
    
}

// MARK: -

extension Profile: ModelObject {
    
    struct KeyPath {
        static let accountId = "accountId"
        static let userId = "userId"
        static let displayName = "displayName"
        static let avatarUrl = "avatarUrl"
    }
    
    var json: Any {
        var json = [String: Any]()
        json.add(value: accountId, for: KeyPath.accountId)
        json.add(value: userId, for: KeyPath.userId)
        json.add(value: displayName, for: KeyPath.displayName)
        json.add(value: avatarUrl, for: KeyPath.avatarUrl)
        return json
    }
    
    init(json: Any) throws {
        let entity = try Parser.parseEntity(json: json) { schema in
            schema.addProperty(keyPath: KeyPath.accountId, type: .string)
            schema.addProperty(keyPath: KeyPath.userId, type: .string)
            schema.addProperty(keyPath: KeyPath.displayName, type: .string)
            schema.addProperty(keyPath: KeyPath.avatarUrl, type: .string, optional: true)
        }
        
        accountId = entity <-! KeyPath.accountId
        userId = entity <-! KeyPath.userId
        displayName = entity <-! KeyPath.displayName
        avatarUrl = entity <-? KeyPath.avatarUrl
    }
    
}
