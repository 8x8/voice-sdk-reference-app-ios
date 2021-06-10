//
//  PhoneViewController.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit
import Wavecell

class PhoneViewController: UIViewController,
                           UITextFieldDelegate {
    
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var phoneTextField: UITextField!
    
    // MARK: -

    var onDoneBlock: (() -> Void)?

    // MARK: -
    
    private(set) var userContext: UserContextProtocol!
    var wavecell: VoiceSDK {
        return userContext.wavecellClient.sdk
    }

    // MARK: -
    
    convenience init(with userContext: UserContextProtocol) {
        self.init()
        self.userContext = userContext
    }
    
    // MARK: -
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        hideKeyboard()
    }
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Phone"
        
        label.text = "Phone Number"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(handleCancelAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(handleDoneAction))

        if let value = userContext.phoneNumber {
            phoneTextField.text = value
        }
    }
    
    // MARK: -
    
    private func hideKeyboard() {
        phoneTextField.resignFirstResponder()
    }

    // MARK: -
    
    private func savePhoneNumber() {
        let phone = phoneTextField.text ?? ""
        userContext.phoneNumber = phone.isEmpty ? nil : phone
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

        savePhoneNumber()
        
        let block = onDoneBlock
        dismiss(animated: true) {
            block?()
        }
    }

}
