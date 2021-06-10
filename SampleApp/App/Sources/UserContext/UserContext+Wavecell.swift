//
//  UserContext+Wavecell.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import Foundation
import Wavecell

extension UserContext {

    func defaultCallKitOptions() -> CallKitOptions {
        var config = CallKitOptions.defaultOptions()
        config.iconFileName = "callkit-logo"
        return config
    }
    
    // MARK: -
    
    func updateWavecellConfiguration() {
        wavecellClient.updateConfiguration()
    }
    
    func updatePhoneNumber(_ number: String?) {
        wavecellClient.updatePhoneNumber(number)
    }

    func updateInboundCallPath(_ path: InboundCallPath) {
        wavecellClient.updateInboundCallPath(path)
    }

}

// MARK: -

extension UserContext: VoiceSDKObserverProtocol {
 
    func handleStateChanged(_ state: VoiceSDK.State) {
        switch state {
        case .active:
            self.state = .registered
        case .inactive:
            self.state = .unregistered
        default: break
        }
    }
    
}
