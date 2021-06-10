//
//  CallConnectingViewController.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit
import Wavecell

class CallConnectingViewController: UIViewController,
                                    CallSessionCallStateObserverProtocol,
                                    CallSessionNetworkReachabilityObserverProtocol {

    @IBOutlet private weak var backButton: UIButton!
    
    // MARK: -
    
    @IBOutlet private weak var callInfoContainer: UIView!
    private(set) var callInfoView: CallInfoView?
    private(set) var avatarView: ContactAvatarView?
    
    var bannerLabel: UILabel? {
        return callInfoView?.bannerLabel
    }

    var nameLabel: UILabel? {
        return callInfoView?.nameLabel
    }

    var callStateLabel: UILabel? {
        return callInfoView?.stateLabel
    }
    
    var callDurationLabel: UILabel? {
        return callInfoView?.durationLabel
    }

    var progressIndicator: UIActivityIndicatorView? {
        return callInfoView?.progressIndicator
    }

    // MARK: -
    
    @IBOutlet private weak var hangupButtonContainer: UIView!
    
    // MARK: -
    
    private(set) weak var session: CallSession?
    private(set) var hangupButton: CallControl?
    
    // MARK: -

    private var timer: Timer?

    // MARK: -
    
    convenience init(with session: CallSession) {
        self.init()
        self.session = session
        subscribe()
    }

    deinit {
        timer?.invalidate()
        unsubscribe()
    }
    
    // MARK: -
    
    private func subscribe() {
        session?.viewModel.addObserver(self)
    }
    
    private func unsubscribe() {
        session?.viewModel.removeObserver(self)
    }

    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TBD
        log.call.info("")
        backButton.setTemplatedImage("navigate-back-action")
        
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

        // setup hangup button
        hangupButton = CallControl(with: .hangup, theme: .light)
        hangupButton?.embed(in: hangupButtonContainer)
        hangupButton?.actionHandler = { [weak self] control in
            guard let self = self else { return }
            self.handleHangupAction()
        }
        hangupButton?.applyAppearance()
        
        updateCallInfo()
        startTimer()
    }
    
    // MARK: -
    
    private func handleHangupAction() {
        session?.performAction(for: .hangup)
    }

    @IBAction func handleBackAction(_ sender: UIButton) {
        session?.dismissUI(shouldRemoveSession: false)
    }

    // MARK: -
    
    func handleCallStateChanged(_ model: CallSession.Model, _ state: VoiceCallState) {
        callStateLabel?.text = "\(state)"
        
        switch state {
        case .connectPending, .holdPending:
            progressIndicator?.startAnimating()
        default:
            progressIndicator?.stopAnimating()
        }
    }
    
    func handleNetworkReachabilityChanged(_ model: CallSession.Model, _ status: ReachabilityStatus) {
        switch status {
        case .notReachable:
            bannerLabel?.text = "No internet connection"
        default:
            bannerLabel?.text = ""
        }
    }

    // MARK: -

    private func updateCallInfo() {
        guard let session = session else {
            return
        }
        
        nameLabel?.text = session.call.contactDisplayName()
        
        updateAvatar()
        updateCallDuration()
        
        handleCallStateChanged(session.viewModel, session.viewModel.callState)
        handleNetworkReachabilityChanged(session.viewModel, session.viewModel.networkReachabilityStatus)
    }

    private func updateAvatar() {
        if let path = session?.call.contact?.avatarUrl, let url = URL(string: path) {
            avatarView?.setup(with: url)
            return
        }
        avatarView?.setup(with: nil)
    }

    // MARK: -
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.updateCallDuration()
        }
    }
    
    private func updateCallDuration() {
        callDurationLabel?.text = session?.call.humanReadableDuration()
    }

}
