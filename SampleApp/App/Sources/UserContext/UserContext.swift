//
//  UserContext.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import Foundation
import Wavecell

protocol UserContextObserverProtocol: AnyObject {
    func handleStateChanged(_ state: UserContext.State)
}

// MARK: -

protocol UserContextProtocol: Observable {
    var state: UserContext.State { get }
    var wavecellClient: WavecellClient { get }
    var account: Account? { get set }
    var profile: Profile? { get set }
    var callKit: CallKitOptions? { get set }
    var phoneNumber: String? { get set }
    var inboundCallPath: InboundCallPath { get set }
    func register(completion: (() -> Void)?)
    func unregister(completion: ((Bool) -> Void)?)
}

// MARK: -

class UserContext: UserContextProtocol {
    
    enum State {
        case unregistered, registering, registered, unregistering
    }

    var state: State = .unregistered {
        didSet {
            if state != oldValue {
                handleStateChanged(state, oldValue)
            }
        }
    }
    
    // MARK: -
    
    static let shared = UserContext(with: Preferences.shared,
                                    networkApiClient: NetworkApiClient(),
                                    keychain: KeychainStorage.shared)
    
    // MARK: -
    
    var account: Account? {
        didSet {
            preferences.account = account
        }
    }

    var profile: Profile? {
        didSet {
            preferences.profile = profile
            updateWavecellConfiguration()
        }
    }

    var callKit: CallKitOptions? {
        didSet {
            preferences.callKit = callKit
            updateWavecellConfiguration()
        }
    }

    var phoneNumber: String? {
        didSet {
            preferences.phoneNumber = phoneNumber
            updatePhoneNumber(phoneNumber)
        }
    }
    
    var inboundCallPath: InboundCallPath {
        didSet {
            preferences.inboundCallPath = inboundCallPath
            updateInboundCallPath(inboundCallPath)
        }
    }

    var registered: Bool {
        get {
            return preferences.userDeviceRegistered
        }
        set {
            preferences.userDeviceRegistered = newValue
        }
    }

    // MARK: -
    
    private(set) var preferences: UserProfilePreferencesProtocol
    private(set) var keychain: KeychainStorageProtocol
    private(set) var networkApiClient: NetworkApiClientProtocol

    // MARK: -

    private(set) var wavecellClient: WavecellClient
    
    // MARK: -
    
    private(set) var tokenTracker: TokenTracker?

    // MARK: -
    
    var observers = WeakObjectCollection<AnyObject>()
    
    // MARK: -
    
    private init(with preferences: UserProfilePreferencesProtocol,
                 networkApiClient: NetworkApiClientProtocol,
                 keychain: KeychainStorageProtocol) {
        self.preferences = preferences
        self.networkApiClient = networkApiClient
        self.keychain = keychain
        self.account = preferences.account
        self.profile = preferences.profile
        self.callKit = preferences.callKit
        self.phoneNumber = preferences.phoneNumber
        self.inboundCallPath = preferences.inboundCallPath
        
        // init wavecell
        self.wavecellClient = WavecellClient(with: preferences)
        self.wavecellClient.sdk.addObserver(self)
        
        // adjust state
        if account == nil {
            // TBD?
        }
        
        state = registered ? .registered : .unregistered
    }
    
    // MARK: -
    
    func register(completion: (() -> Void)?) {
        guard let account = account,
              let userId = profile?.userId else {
            completion?()
            return
        }
        
        guard let provider = getTokenProvider(for: account) else {
            completion?()
            return
        }
        
        tokenTracker = TokenTracker(with: account, userId: userId, tokenProvider: provider, keychain: keychain)
        tokenTracker?.onTokenChangedBlock = { [weak self] token in
            self?.wavecellClient.sdk.authenticationContext.jwtToken = token
        }
        tokenTracker?.requestToken(allowCached: true) { [weak self] token in
            guard let token = token else {
                completion?()
                return
            }
            self?.register(with: account, userId: userId, jwtToken: token, completion: completion)
        }
    }
    
    private func register(with account: Account,
                          userId: String,
                          jwtToken: String,
                          completion: (() -> Void)?) {
        // setup callkit
        if callKit == nil {
            callKit = defaultCallKitOptions()
        }
        
        wavecellClient.sdk.authenticationContext.jwtToken = jwtToken
        wavecellClient.sdk.authenticationContext.callback = { [weak self] token in
            self?.refreshToken()
        }
        
        wavecellClient.activate {
            completion?()
        }
    }

    func unregister(completion: ((Bool) -> Void)?) {
        wavecellClient.deactivate { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.reset()
                completion?(true)
            case .failure:
                completion?(false)
            }
        }
    }
    
    // MARK: -

    private func reset() {
        profile = nil
        callKit = nil
        tokenTracker = nil
        phoneNumber = nil
        inboundCallPath = .voipWithFallbackToPSTN
        wavecellClient.sdk.authenticationContext.callback = nil
        keychain.jwtToken = nil
        preferences.reset()
    }

    // MARK: -
    
    private func handleStateChanged(_ new: State, _ old: State) {
        log.general.info("\(old) => \(new)")
        
        switch state {
        case .registered:
            registered = true
        case .unregistered:
            registered = false
        default: break
        }

        // notify observers
        notifyObservers { [weak self] (observer: UserContextObserverProtocol) in
            guard let self = self else { return }
            observer.handleStateChanged(self.state)
        }
    }
    
}
