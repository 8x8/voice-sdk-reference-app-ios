//
//  CallSession.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit
import Wavecell

class CallSession {

    enum State: Int {
        case initial
        case connecting
        case call
        case failed
    }
    
    private(set) var state: State = .initial {
        didSet {
            if oldValue != state {
                handleStateChanged(state, oldValue)
            }
        }
    }

    // MARK: -
    
    private(set) var call: VoiceCall
    private(set) var viewModel: Model
    private(set) var presentingController: CallSessionViewController!
    
    // MARK: -
    
    private weak var uiActionRunner: CallControlActionRunnerProtocol?
    
    // MARK: -
    
    var presentationDismissBlock: ((_ session: CallSession, _ shouldRemoveSession: Bool) -> Void)?
    
    // MARK: -
    
    init(with call: VoiceCall) {
        self.call = call
        self.viewModel = Model(with: call.state,
                               mutedState: call.muted,
                               connectionQuality: call.connectionQuality)
        self.presentingController = CallSessionViewController(with: self)
        self.presentingController.loadViewIfNeeded()
        
        // adjust presentation
        adjustSessionState(for: call.state)
        
        subscribe()
    }
    
    deinit {
        unsubscribe()
    }
    
    // MARK: -
    
    private func subscribe() {
        call.addObserver(self)
    }

    private func unsubscribe() {
       call.removeObserver(self)
    }

    // MARK: -
    
    func match(by uuid: UUID) -> Bool {
        if call.uuid == uuid {
            return true
        }
        return false
    }

    // MARK: -
    
    func performAction(for actionType: CallControlActionType) {
        log.adhoc.info("\(actionType)")
        switch actionType {
        case .showKeypad, .hideKeypad, .showMore, .hideMore:
            uiActionRunner?.performCallControlAction(actionType)
        case .mute:
            call.muted = .on
        case .unmute:
            call.muted = .off
        case .hold:
            viewModel.block(actionType)
            call.hold { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.unblock(actionType)
            }
        case .unhold:
            viewModel.block(actionType)
            call.resume { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.unblock(actionType)
            }
        case .hangup:
            viewModel.block(actionType)
            call.hangup { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.unblock(actionType)
            }
        default: break
        }
    }

    // MARK: -

    func dismissUI(shouldRemoveSession: Bool = false) {
        presentationDismissBlock?(self, shouldRemoveSession)
    }

    // MARK: -
    
    func adjustSessionState(for callState: VoiceCallState) {
        log.adhoc.info("\(callState)")
        switch callState {
        case .unknown:
            state = .initial
        case .incoming, .outgoing, .ringing:
            state = .connecting
        case .connected, .hold, .connectPending, .holdPending:
            state = .call
        case .failed:
            state = .failed
        default: break
        }
    }
    
    private func handleStateChanged(_ new: State, _ old: State) {
        var child: UIViewController?
        switch new {
        case .connecting:
            child = CallConnectingViewController(with: self)
        case .call:
            let object = CallViewController(with: self)
            uiActionRunner = object
            child = object
        case .failed:
            child = CallFailedViewController(with: self)
        default: break
        }
        
        guard let controller = child else {
            return
        }
        if presentingController.children.count > 0 {
            presentingController.presentChild(controller, in: presentingController.content)
        } else {
            presentingController.addChild(controller, to: presentingController.content)
        }
    }
    
}
