//
//  AppDelegate.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit
import MBProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // MARK: -

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setupAppLogger()
        setupAppearance()
        
        // activate voip push handler
        WavecellClient.preinit()

        executeWhenProtectedDataAvailable {
            self.postDidFinishLaunchingWithOptions(application, launchOptions)
        }
        return true
    }
    
    func postDidFinishLaunchingWithOptions(_ application: UIApplication,
                                           _ launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        let keychain = KeychainStorage.shared
        
        // init preferences
        Preferences.initialize(with: keychain.userDeviceId, preserved: [ConstantKeys.Preferences.account])
        
        // init user context
        let userContext = UserContext.shared
        userContext.addObserver(self)
        
        // init call manager
        let manager = CallSessionManager.shared
        manager.attach(to: userContext)
        
        // setup main window
        window = UIWindow(frame: UIScreen.main.bounds)
        let root = RootViewController(with: userContext)
        Presenter.shared.root = root
        window?.rootViewController = root
        window?.makeKeyAndVisible()
        window?.tintColor = .appSoftBlue
        
        // activate
        if userContext.registered {
            MBProgressHUD.showAdded(to: root.view, animated: true)
            userContext.register {
                MBProgressHUD.hide(for: root.view, animated: true)
                self.handleStateChanged(userContext.state)
            }
        }
    }

    // MARK: -
    
    private func setupAppearance() {
        let navigation = UINavigationBar.appearance()
        navigation.titleTextAttributes = [.font: UIFont(name: "Rubik-Medium", size: 18)!,
                                          .foregroundColor: UIColor.appDarkBlue]
        
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: UIFont(name: "Rubik-Regular", size: 16)!,
                                                             .foregroundColor: UIColor.appDarkBlue], for: .normal)
    }

}
