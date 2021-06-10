//
//  TokenTracker.swift
//  SampleApp
//
//  Copyright © 2023 8x8, Inc. All rights reserved.
//

import UIKit

class TokenTracker {
    
    let account: Account
    let userId: String
    
    // MARK: -
    
    let tokenProvider: TokenProviderProtocol
    
    // MARK: -
    
    var jwtToken: String? {
        get {
            keychain.jwtToken
        }
        set {
            keychain.jwtToken = newValue
            if let value = newValue {
                onTokenChangedBlock?(value)
            }
        }
    }
    
    var onTokenChangedBlock: ((String) -> Void)?
    
    var validToken: String? {
        guard let value = jwtToken,
              let exp = UserContext.JWT(from: value).exp, exp > Date() else {
            return nil
        }
        return value
    }
    
    // MARK: -
    
    private(set) var keychain: KeychainStorageProtocol
    
    // MARK: -
    
    init(with account: Account, userId: String,
         tokenProvider: TokenProviderProtocol,
         keychain: KeychainStorageProtocol) {
        self.account = account
        self.userId = userId
        self.tokenProvider = tokenProvider
        self.keychain = keychain
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // MARK: -
    
    func requestToken(allowCached: Bool = false, completion: ((String?) -> Void)? = nil) {
        if allowCached {
            if let value = validToken {
                log.general.info("use cached token [\(value.truncated())…]")
                completion?(value)
                return
            }
        }
        log.general.info("requesting token…")
        tokenProvider.requestToken(userId: userId, accountId: account.accountId) { [weak self] token in
            guard let token = token else {
                log.general.error("failed to get token")
                completion?(nil)
                return
            }
            log.general.info("got new token [\(token.truncated())…]")
            self?.jwtToken = token
            completion?(token)
        }
    }
    
    // MARK: -
    
    @objc
    private func willEnterForeground() {
        if (validToken != nil) || tokenProvider.hasPendingRequest {
            return
        }
        requestToken()
    }

}
