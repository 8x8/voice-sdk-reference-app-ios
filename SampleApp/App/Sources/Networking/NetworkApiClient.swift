//
//  NetworkApiClient.swift
//  SampleApp
//
//  Created by Alexander Trishyn on 3/20/23.
//  Copyright © 2023 8x8, Inc. All rights reserved.
//

import Foundation
import Alamofire
import Combine

struct TokenResponse: Decodable {
    let token: String
}

protocol NetworkApiClientProtocol {
    @discardableResult
    func createJwt(url: URL, userId: String, accountId: String,
                   completion: @escaping ((Result<TokenResponse, Error>) -> Void)) -> AnyCancellable?
}

// MARK: -

class NetworkApiClient: NetworkApiClientProtocol {
    
    @discardableResult
    func createJwt(url: URL, userId: String, accountId: String,
                   completion: @escaping ((Result<TokenResponse, Error>) -> Void)) -> AnyCancellable? {
        let parameters: [String: Any] = ["userId": userId,
                                         "accountId": accountId]
        let request = AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
          .validate()
          .responseDecodable(of: TokenResponse.self) { response in
            switch response.result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return AnyCancellable { request.cancel() }
    }
    
}
