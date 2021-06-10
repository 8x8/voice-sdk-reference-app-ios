//
//  PlaceCallViewController.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit
import MBProgressHUD

class PlaceCallViewController: UIViewController,
                               UITextFieldDelegate {
    
    @IBOutlet private weak var calleeIdLabel: UILabel!
    @IBOutlet private weak var calleeIdTextField: UITextField!
    @IBOutlet private weak var callButton: UIButton!
    
    // MARK: -
    
    private(set) var userContext: UserContextProtocol!
    var wavecellClient: WavecellClient {
        return userContext.wavecellClient
    }

    // MARK: -
    
    private(set) var preferences: RecentsPreferencesProtocol!

    // MARK: -
    
    convenience init(with userContext: UserContextProtocol, preferences: RecentsPreferencesProtocol) {
        self.init()
        self.userContext = userContext
        self.preferences = preferences
    }
    
    // MARK: -
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        hideKeyboard()
    }
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Call"
        
        callButton.cornerRadius = callButton.bounds.height / 2
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigate-back-action"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(handleCancelAction))
        if let value = preferences.recentCalleeId {
            calleeIdTextField.text = value
        }
    }
    
    // MARK: -
    
    private func hideKeyboard() {
        calleeIdTextField.resignFirstResponder()
    }

    // MARK: -

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == calleeIdTextField {
            placeCall()
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        preferences.recentCalleeId = textField.text
    }
    
    // MARK: -
    
    @IBAction func handleCallAction(_ sender: UIButton) {
        placeCall()
    }
    
    // MARK: -
    
    private func placeCall() {
        guard let calleeId = calleeIdTextField.text, !calleeId.isEmpty else {
            return
        }
        
        hideKeyboard()
        
        let callee = ContactInfo(contactId: calleeId, displayName: "")
        
        MBProgressHUD.showAdded(to: view, animated: true)
        wavecellClient.placeCall(callType: .voip, to: callee) { [weak self] result in
            guard let self = self else { return }
            MBProgressHUD.hide(for: self.view, animated: true)
            switch result {
            case .success(let call):
                log.adhoc.info("\(call.uuid.uuidString)")
            case .failure(let error):
                log.adhoc.info("\(error)")
            }
        }
    }
    
    // MARK: -
    
    @objc func handleCancelAction() {
        hideKeyboard()
        Presenter.shared.presentMainScreen()
    }

}
