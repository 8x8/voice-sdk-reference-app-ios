//
//  CallFailedViewController.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit
import Wavecell

class CallFailedViewController: UIViewController {

    @IBOutlet private weak var doneButton: UIButton!
    
    // MARK: -

    @IBOutlet private weak var callInfoContainer: UIView!
    private(set) var callInfoView: CallInfoView?
    private(set) var avatarView: ContactAvatarView?
    
    var nameLabel: UILabel? {
        return callInfoView?.nameLabel
    }

    var callStateLabel: UILabel? {
        return callInfoView?.stateLabel
    }
    
    var progressIndicator: UIActivityIndicatorView? {
        return callInfoView?.progressIndicator
    }

    var callDurationLabel: UILabel? {
        return callInfoView?.durationLabel
    }

    // MARK: -
    
    private(set) weak var session: CallSession?

    // MARK: -
    
    convenience init(with session: CallSession) {
        self.init()
        self.session = session
    }

    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        log.call.info("")
        doneButton.cornerRadius = doneButton.bounds.height / 2
        
        // sync with model
        if session == nil {
            return
        }
        
        // setup info container
        let info = CallInfoView.fromNib()
        info.embed(in: callInfoContainer)

        // setup avatar view
        let avatar = ContactAvatarView.fromNib()
        avatar.embed(in: info.avatarHolder)
        
        avatarView = avatar
        callInfoView = info

        updateCallInfo()
    }
    
    // MARK: -
    
    @IBAction func handleDoneAction(_ sender: UIButton) {
        session?.dismissUI(shouldRemoveSession: true)
    }
    
    // MARK: -

    private func updateCallInfo() {
        guard let session = session else {
            return
        }
        
        updateAvatar()
        
        nameLabel?.text = session.call.contactDisplayName()
        callStateLabel?.text = "\(session.viewModel.callState)"
        callDurationLabel?.text = session.call.humanReadableDuration()
        progressIndicator?.stopAnimating()
    }

    private func updateAvatar() {
        if let path = session?.call.contact?.avatarUrl, let url = URL(string: path) {
            avatarView?.setup(with: url)
            return
        }
        avatarView?.setup(with: nil)
    }

}
