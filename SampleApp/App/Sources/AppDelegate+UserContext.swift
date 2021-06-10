//
//  AppDelegate+UserContext.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import Foundation

extension AppDelegate: UserContextObserverProtocol {

    func handleStateChanged(_ state: UserContext.State) {
        switch state {
        case .registered:
            Presenter.shared.presentMainScreen()
        case .unregistered:
            Presenter.shared.presentRootScreen()
        default: break
        }
    }
    
}
