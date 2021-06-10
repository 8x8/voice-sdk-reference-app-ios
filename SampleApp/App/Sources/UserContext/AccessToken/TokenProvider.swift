//
//  TokenProvider.swift
//  SampleApp
//
//  Copyright © 2023 8x8, Inc. All rights reserved.
//

import Foundation

protocol TokenProviderProtocol: AnyObject {
    var hasPendingRequest: Bool { get }
    func requestToken(userId: String, accountId: String, completion: @escaping (String?) -> Void)
}
