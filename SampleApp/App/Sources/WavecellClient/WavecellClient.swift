//
//  WavecellClient.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import Foundation
import Wavecell

extension Configuration {
    
    init(accountId: String,
         userId: String,
         displayName: String,
         phoneNumber: String?,
         inboundCallPath: InboundCallPath,
         callKit: CallKitOptions,
         url: String) {
        
        let appBundleId = Bundle.main.bundleIdentifier ?? ""
        #if targetEnvironment(simulator)
        let environment: PushNotificationEnvironment? = .sandbox
        #else
        let environment: PushNotificationEnvironment = Utilities.shouldUseSandboxPushEnvironment() ? .sandbox : .production
        #endif
        
        self.init(accountId: accountId, userId: userId, displayName: displayName,
                  phoneNumber: phoneNumber, callKit: callKit,
                  appBundleId: appBundleId, pushEnvironment: environment, inboundCallPath: inboundCallPath,
                  serviceUrl: url)
    }
    
}

// MARK: -

protocol WavecellClientObserverProtocol: AnyObject {
    func outgoingCallDidStart(_ call: VoiceCall)
}

// MARK: -

class WavecellClient: Observable {
    
    var preferences: UserProfilePreferencesProtocol
    var sdk: VoiceSDK
    
    // MARK: -

    var recents = [VoiceCall]() {
        didSet {
            handleRecentsChanged()
        }
    }
    
    // MARK: -
    
    var observers = WeakObjectCollection<AnyObject>()

    // MARK: -
    
    static func preinit() {
        VoiceSDK.preinit()
    }
    
    // MARK: -
    
    init(with preferences: UserProfilePreferencesProtocol) {
        self.preferences = preferences
        sdk = VoiceSDK.shared
        setup()
    }

    // MARK: -
    
    private func setup() {
        log.general.info("\(sdk.version())")
        log.general.info("\(sdk.voiceStackVersion())")
        
        setupContactResolver()
        setupAudioSessionConfigurationCallback()
    }
    
    // MARK: -
    
    func activate(completion: (() -> Void)? = nil) {
        guard let account = preferences.account,
              let profile = preferences.profile,
              let callKit = preferences.callKit else {
            completion?()
            return
        }

        // apply configuration
        sdk.configuration = Configuration(accountId: profile.accountId,
                                          userId: profile.userId,
                                          displayName: profile.displayName,
                                          phoneNumber: preferences.phoneNumber,
                                          inboundCallPath: preferences.inboundCallPath,
                                          callKit: callKit,
                                          url: account.serviceUrl)
        
        // subscribe for changes
        sdk.addObserver(self)
        
        sdk.activate { result in
            switch result {
            case .success:
                log.adhoc.info("success")
            case .failure:
                log.adhoc.info("failure")
            }
            completion?()
        }
    }
    
    func deactivate(completion: ((_ result: Result<Void, ErrorType>) -> Void)? = nil) {
        sdk.deactivate { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                log.adhoc.info("success")
                
                // unsubscribe
                self.sdk.removeObserver(self)
                self.recents.removeAll()
                completion?(.success(()))
            case .failure(let error):
                log.adhoc.info("failure")
                completion?(.failure(error))
            }
        }
    }

    // MARK: -
    
    func updateConfiguration() {
        guard let account = preferences.account,
              let profile = preferences.profile,
              let callKit = preferences.callKit else {
            return
        }

        // apply configuration
        sdk.configuration = Configuration(accountId: profile.accountId,
                                          userId: profile.userId,
                                          displayName: profile.displayName,
                                          phoneNumber: preferences.phoneNumber,
                                          inboundCallPath: preferences.inboundCallPath,
                                          callKit: callKit,
                                          url: account.serviceUrl)
    }
    
    // MARK: -
    
    func updatePhoneNumber(_ number: String?) {
        sdk.updatePhoneNumber(number) { _ in }
    }

    func updateInboundCallPath(_ path: InboundCallPath) {
        sdk.updateInboundCallPath(path) { _ in }
    }

    // MARK: -
    
    func placeCall(callType: CallType, to callee: Contact,
                   completion: @escaping (Result<VoiceCall, ErrorType>) -> Void) {
        let completionBlock: (Result<VoiceCall, ErrorType>) -> Void = { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let call):
                self.handleCallDidStart(call)
            default: break
            }
            completion(result)
        }
        let parameters = OutgoingCallParameters(callType: callType, callee: callee)
        sdk.placeCall(with: parameters, completion: completionBlock)
    }
    
    // MARK: -
    
    private func handleCallDidStart(_ call: VoiceCall) {
        notifyObservers { (observer: WavecellClientObserverProtocol) in
            observer.outgoingCallDidStart(call)
        }
    }
    
}
