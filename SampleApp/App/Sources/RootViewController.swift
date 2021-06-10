//
//  RootViewController.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit
import MBProgressHUD

class RootViewController: UIViewController,
                          UITextFieldDelegate,
                          UserContextObserverProtocol {
    
    @IBOutlet private weak var logoView: UIView!
    @IBOutlet private(set) weak var middleView: UIView!
    @IBOutlet private weak var btnSignIn: UIButton!

    @IBOutlet private weak var accountIdLabel: UILabel!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var userIdTextField: UITextField!
    
    @IBOutlet private weak var btnAccountSetup: UIButton!
    @IBOutlet private weak var labelAccountSetup: UILabel!
    
    // MARK: -
    
    var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    // MARK: -
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    // MARK: -
    
    private(set) var userContext: UserContextProtocol!
    
    // MARK: -

    convenience init(with userContext: UserContextProtocol) {
        self.init()
        self.userContext = userContext
        subscribe()
    }
    
    deinit {
        unsubscribe()
    }

    // MARK: -

    private func subscribe() {
        userContext.addObserver(self)
    }

    private func unsubscribe() {
        userContext.removeObserver(self)
    }

    // MARK: -

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        hideKeyboard()
    }

    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()

        btnSignIn.cornerRadius = btnSignIn.bounds.height / 2
        btnAccountSetup.setTitle("", for: .normal)
        
        // adjust state
        updateSignInButton()
        handleStateChanged(userContext.state)
    }

    // MARK: -

    @IBAction func handleSignIn(_ sender: UIButton) {
        register()
    }
    
    // MARK: -

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            userIdTextField.becomeFirstResponder()
        } else if textField == userIdTextField {
            register()
        }
        return true
    }
    
    // MARK: -

    private func register() {
        guard let accountId = userContext.account?.accountId,
            let name = nameTextField.text, let userId = userIdTextField.text,
            !name.isEmpty, !userId.isEmpty else {
            return
        }
        
        hideKeyboard()
        
        // apply profile
        let profile = Profile(accountId: accountId, userId: userId, displayName: name)
        userContext.profile = profile
        
        MBProgressHUD.showAdded(to: middleView, animated: true)
        userContext.register { [weak self] in
            guard let self = self else { return }
            MBProgressHUD.hide(for: self.middleView, animated: true)
        }
    }
    
    // MARK: -
    
    private func hideKeyboard() {
        nameTextField.resignFirstResponder()
        userIdTextField.resignFirstResponder()
    }
    
    // MARK: -
    
    func handleStateChanged(_ state: UserContext.State) {
        switch state {
        case .registered:
            statusBarStyle = .default
            middleView?.isHidden = true
            logoView?.isHidden = true
            accountIdLabel?.isHidden = true
            labelAccountSetup.isHidden = true
            btnAccountSetup.isHidden = true
        case .unregistered:
            statusBarStyle = .lightContent
            middleView?.isHidden = false
            logoView?.isHidden = false
            accountIdLabel?.isHidden = false
            labelAccountSetup.isHidden = false
            btnAccountSetup.isHidden = false
        default: break
        }
    }
    
    // MARK: -
    
    @IBAction func handleSetupAccountAction(_ sender: UIButton) {
        log.general.info("")

        let setup = AccountSetupViewController(with: userContext)
        setup.onDoneBlock = { [weak self] account in
            self?.handleAccountSelection(account)
        }
        let controller = UINavigationController(rootViewController: setup)
        controller.modalPresentationStyle = .currentContext
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
    }
    
    private func handleAccountSelection(_ account: Account) {
        log.general.info("\(account.accountId)")
        userContext.account = account
        updateSignInButton()
    }

    private func updateSignInButton() {
        if let value = userContext.account?.accountId, !value.isEmpty {
            accountIdLabel.text = value
            accountIdLabel.textColor = .white
            btnSignIn.isEnabled = true
        } else {
            accountIdLabel.text = "Incomplete account setup!"
            accountIdLabel.textColor = .appSoftRed
            btnSignIn.isEnabled = false
        }

    }
    
}
