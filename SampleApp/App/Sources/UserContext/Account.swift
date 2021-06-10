//
//  Account.swift
//  SampleApp
//
//  Copyright © 2023 8x8, Inc. All rights reserved.
//

import Foundation
import Elevate

struct Account: Hashable {
    var uuid: String
    var accountId: String
    var serviceUrl: String
    var tokenUrl: String
    
    init(uuid: String = UUID().uuidString,
         accountId: String,
         serviceUrl: String,
         tokenUrl: String) {
        self.uuid = uuid
        self.accountId = accountId
        self.serviceUrl = serviceUrl
        self.tokenUrl = tokenUrl
    }
    
}

// MARK: -

extension Account: ModelObject {
    
    struct KeyPath {
        static let uuid = "uuid"
        static let accountId = "accountId"
        static let serviceUrl = "serviceUrl"
        static let tokenUrl = "tokenUrl"
    }
    
    var json: Any {
        var json = [String: Any]()
        json.add(value: uuid, for: KeyPath.uuid)
        json.add(value: accountId, for: KeyPath.accountId)
        json.add(value: serviceUrl, for: KeyPath.serviceUrl)
        json.add(value: tokenUrl, for: KeyPath.tokenUrl)
        return json
    }
    
    init(json: Any) throws {
        let entity = try Parser.parseEntity(json: json) { schema in
            schema.addProperty(keyPath: KeyPath.uuid, type: .string)
            schema.addProperty(keyPath: KeyPath.accountId, type: .string)
            schema.addProperty(keyPath: KeyPath.serviceUrl, type: .string)
            schema.addProperty(keyPath: KeyPath.tokenUrl, type: .string)
        }
        
        uuid = entity <-! KeyPath.uuid
        accountId = entity <-! KeyPath.accountId
        serviceUrl = entity <-! KeyPath.serviceUrl
        tokenUrl = entity <-! KeyPath.tokenUrl
    }
    
}
