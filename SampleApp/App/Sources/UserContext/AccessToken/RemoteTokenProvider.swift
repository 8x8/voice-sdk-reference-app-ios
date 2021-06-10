//
//  RemoteTokenProvider.swift
//  SampleApp
//
//  Copyright © 2023 8x8, Inc. All rights reserved.
//

import Foundation
import Combine

class RemoteTokenProvider: TokenProviderProtocol {
    
    let url: URL
    
    // MARK: -
    
    let networkApiClient: NetworkApiClientProtocol
    
    // MARK: -
    
    private(set) var pendingRequest: AnyCancellable?
    
    var hasPendingRequest: Bool {
        pendingRequest != nil
    }
    
    // MARK: -
    
    init(with url: URL, networkApiClient: NetworkApiClientProtocol) {
        self.url = url
        self.networkApiClient = networkApiClient
    }
    
    // MARK: -
    
    func requestToken(userId: String, accountId: String, completion: @escaping (String?) -> Void) {
        pendingRequest?.cancel()
        pendingRequest = networkApiClient.createJwt(url: url, userId: userId, accountId: accountId) { [weak self] result in
            self?.pendingRequest = nil
            switch result {
            case .success(let response):
                completion(response.token)
            case .failure:
                completion(nil)
            }
        }
    }

}
