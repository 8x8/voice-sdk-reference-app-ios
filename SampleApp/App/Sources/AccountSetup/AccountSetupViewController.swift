//
//  AccountSetupViewController.swift
//  SampleApp
//
//  Copyright © 2023 8x8, Inc. All rights reserved.
//

import UIKit
import SwiftUI
import Popovers

class AccountSetupViewController: UIViewController,
                                  UITextFieldDelegate {
    
    @IBOutlet private weak var accountIdLabel: UILabel!
    @IBOutlet private weak var accountIdField: UITextField!
    @IBOutlet private weak var accountIdBorderView: UIView!

    @IBOutlet private weak var serviceUrlLabel: UILabel!
    @IBOutlet private(set) weak var serviceUrlField: UITextField!
    @IBOutlet private weak var serviceUrlBorderView: UIView!
    @IBOutlet private(set) weak var serviceUrlOptionsLabel: UILabel!
    @IBOutlet private(set) weak var serviceUrlOptionsButton: UIButton!
    
    @IBOutlet private weak var jwtUrlLabel: UILabel!
    @IBOutlet private(set) weak var jwtUrlField: UITextField!
    @IBOutlet private weak var jwtUrlBorderView: UIView!
    
    @IBOutlet private(set) weak var container: UIView!
    
    // MARK: -

    var serviceUrlOptionsMenu: Templates.UIKitMenu?

    // MARK: -
    
    var account = Account(accountId: "", serviceUrl: "", tokenUrl: "https://eoijkffr781ce74.m.pipedream.net")
    
    var synthesizedAccount: Account {
        var object = account
        object.accountId = accountIdField.text ?? ""
        object.serviceUrl = serviceUrlField.text ?? ""
        object.tokenUrl = jwtUrlField.text ?? ""
        return object
    }
    
    // MARK: -
    
    var onDoneBlock: ((Account) -> Void)?
    
    // MARK: -
    
    private(set) var userContext: UserContextProtocol!

    // MARK: -
    
    convenience init(with userContext: UserContextProtocol) {
        self.init()
        self.userContext = userContext

        // adjust state
        if let account = userContext.account {
            self.account = account
        }
    }
    
    // MARK: -
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        hideKeyboard()
    }

    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Setup Account"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(handleCancelAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(handleDoneAction))

        accountIdLabel.text = "Account ID"
        accountIdField.text = account.accountId
        accountIdField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        accountIdField.delegate = self

        serviceUrlLabel.text = "Service URL"
        serviceUrlField.text = account.serviceUrl
        serviceUrlField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        serviceUrlField.delegate = self
        serviceUrlOptionsButton.setTitle("", for: .normal)
        
        jwtUrlLabel.text = "Token URL"
        jwtUrlField.text = account.tokenUrl
        jwtUrlField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        jwtUrlField.delegate = self
        
        updateAccountIdInput()
        updateServiceUrlInput()
        updateJwtUrlInput()
        updateDoneButton()
    }

    // MARK: -
    
    private func updateAccountIdInput() {
        guard let text = accountIdField.text, !text.isEmpty else {
            accountIdBorderView.backgroundColor = .appDarkBlue
            return
        }
        accountIdBorderView.backgroundColor = text.match(pattern: InputValidation.accountID.pattern) ? .appDarkBlue : .appSoftRed
    }

    private func updateServiceUrlInput() {
        guard let text = serviceUrlField.text, !text.isEmpty else {
            serviceUrlBorderView.backgroundColor = .appDarkBlue
            return
        }
        serviceUrlBorderView.backgroundColor = text.isValidURL() ? .appDarkBlue : .appSoftRed
    }

    private func updateJwtUrlInput() {
        guard let text = jwtUrlField.text, !text.isEmpty else {
            jwtUrlBorderView.backgroundColor = .appDarkBlue
            return
        }
        jwtUrlBorderView.backgroundColor = text.isValidURL() ? .appDarkBlue : .appSoftRed
    }

    private func updateDoneButton() {
        var enabled = false
        if let accoundId = accountIdField.text, !accoundId.isEmpty,
           let serviceUrl = serviceUrlField.text, !serviceUrl.isEmpty,
           let jwtUrl = jwtUrlField.text, !jwtUrl.isEmpty {
            enabled = accoundId.match(pattern: InputValidation.accountID.pattern) &&
                      serviceUrl.isValidURL() && jwtUrl.isValidURL()
        }
        navigationItem.rightBarButtonItem?.isEnabled = enabled && (synthesizedAccount != account)
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        if textField == accountIdField {
            updateAccountIdInput()
        } else if textField == serviceUrlField {
            updateServiceUrlInput()
        } else if textField == jwtUrlField {
            updateJwtUrlInput()
        }
        updateDoneButton()
    }
    
    // MARK: -

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == accountIdField {
            serviceUrlField.becomeFirstResponder()
        } else if textField == serviceUrlField {
            jwtUrlField.becomeFirstResponder()
        } else if textField == jwtUrlField {
            if let value = navigationItem.rightBarButtonItem?.isEnabled, value {
                handleDoneAction()
            }
        }
        return true
    }

    // MARK: -
    
    private func validator(for textField: UITextField) -> InputValidation {
        if textField == accountIdField {
            return InputValidation.accountID
        } else if textField == serviceUrlField {
            return InputValidation.serviceUrl
        }
        return InputValidation.jwtUrl
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let validator = self.validator(for: textField)
        guard let text = textField.text as NSString?,
              text.replacingCharacters(in: range, with: string).count <= validator.maxLength else {
            return false
        }
        return (string.rangeOfCharacter(from: validator.characterSet.inverted) == nil)
    }

    // MARK: -
    
    func hideKeyboard() {
        accountIdField.resignFirstResponder()
        serviceUrlField.resignFirstResponder()
        jwtUrlField.resignFirstResponder()
    }

    // MARK: -
    
    @objc
    private func handleCancelAction() {
        hideKeyboard()
        dismiss(animated: true, completion: nil)
    }

    @objc
    private func handleDoneAction() {
        hideKeyboard()
        
        let object = synthesizedAccount
        let block = onDoneBlock
        dismiss(animated: true) {
            block?(object)
        }
    }

}
