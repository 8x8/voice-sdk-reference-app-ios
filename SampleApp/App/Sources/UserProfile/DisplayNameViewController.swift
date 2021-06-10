//
//  DisplayNameViewController.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit
import Wavecell

class DisplayNameViewController: UIViewController,
                                 UITextFieldDelegate {
    
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var nameTextField: UITextField!
    
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
        title = "User Name"
        
        label.text = "Name"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(handleCancelAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(handleDoneAction))

        if let value = userContext.profile?.displayName {
            nameTextField.text = value
        }
    }
    
    // MARK: -
    
    private func hideKeyboard() {
        nameTextField.resignFirstResponder()
    }

    // MARK: -
    
    private func saveDisplayName() {
        userContext.profile?.displayName = nameTextField.text ?? ""
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
        saveDisplayName()
        
        let block = onDoneBlock
        dismiss(animated: true) {
            block?()
        }
    }

}
