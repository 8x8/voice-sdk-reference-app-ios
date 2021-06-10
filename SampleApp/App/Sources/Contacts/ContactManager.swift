//
//  ContactManager.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import Foundation
import Wavecell

struct ContactInfo: Contact {
    
    var contactId: String
    var displayName: String?
    var avatarUrl: String?
    var phoneNumber: String?

    // MARK: -
    
    init(contactId: String, displayName: String? = nil,
         avatarUrl: String? = nil, phoneNumber: String? = nil) {
        self.contactId = contactId
        self.displayName = displayName
        self.avatarUrl = avatarUrl
        self.phoneNumber = phoneNumber
    }
    
}
