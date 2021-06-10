//
//  Presenter.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit

class Presenter {
    
    static let shared = Presenter()
    
    // MARK: -
    
    var root: RootViewController?
    
    // MARK: -
    
    func presentMainScreen() {
        let controller = MainViewController(with: UserContext.shared)
        let navigation = UINavigationController(rootViewController: controller)
        root?.presentChild(navigation)
    }

    func presentUserProfileScreen() {
        let controller = UserProfileViewController(with: UserContext.shared)
        let navigation = UINavigationController(rootViewController: controller)
        root?.presentChild(navigation)
    }

    func presentCallViewScreen() {
        let controller = CallViewController()
        let navigation = UINavigationController(rootViewController: controller)
        root?.presentChild(navigation)
    }

    func presentPlaceCallViewScreen() {
        let controller = PlaceCallViewController(with: UserContext.shared, preferences: Preferences.shared)
        let navigation = UINavigationController(rootViewController: controller)
        root?.presentChild(navigation)
    }

    func presentCallSessionViewScreen(_ controller: UIViewController) {
        root?.presentChild(controller)
    }

    func presentRootScreen() {
        root?.removeChild()
    }

}
