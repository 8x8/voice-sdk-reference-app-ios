//
//  UserContext+Auth.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import Foundation
import JWTDecode

extension UserContext {

    enum Config {
        static let defaultServiceUrl = "https://voip-api.wavecell.com/api/v1"
        static let defaultTokenUrl = "https://eoijkffr781ce74.m.pipedream.net"
    }
    
    // MARK: -
        
    struct JWT {
        let claims: [String: Any]

        init(from string: String) {
            claims = (try? decode(jwt: string).body) ?? [:]
        }

        var exp: Date? {
            (claims["exp"] as? TimeInterval).map { Date(timeIntervalSince1970: $0) }
        }
    }

    // MARK: -
    
    func getTokenProvider(for account: Account) -> TokenProviderProtocol? {
        guard let url = URL(string: account.tokenUrl) else {
            return nil
        }
        return RemoteTokenProvider(with: url, networkApiClient: networkApiClient)
    }
    
    func refreshToken() {
        log.general.info("token refresh is requested")
        tokenTracker?.requestToken()
    }

}
