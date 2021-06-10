//
//  WavecellClient+Contact.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import Foundation
import Wavecell

extension WavecellClient {
    
    func setupContactResolver() {

        VoiceSDK.contactResolverCallback = { context, completion in
            log.adhoc.info("\(context.callerId)")
            
            let contact = ContactInfo(contactId: context.callerId, displayName: context.callerName, avatarUrl: nil, phoneNumber: nil)
            completion?(contact)
        }
        
    }
    
}
