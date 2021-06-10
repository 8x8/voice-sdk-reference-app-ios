//
//  CallSession+Model+ControlState.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import Foundation

extension CallSession.Model {

    class CallControlActionModel {
        let type: CallControlActionType
        var enabled: Bool = true {
            didSet {
                onStateChangedBlock?(enabled)
            }
        }
        private var onStateChangedBlock: ((Bool) -> Void)?
        
        init(with type: CallControlActionType, handler: ((Bool) -> Void)? = nil) {
            self.type = type
            self.onStateChangedBlock = handler
        }
    }
    
    // MARK: -
    
    func controlState(for controlActionType: CallControlActionType) -> Bool {
        if controlActionType == .noaudio {
            return false
        }
        return controlStateForTransactionStack(controlActionType) &&
            controlStateForNetworkStatus(controlActionType) &&
            controlStateForCallState(controlActionType)
    }

    // MARK: -
    
    private func controlStateForTransactionStack(_ controlActionType: CallControlActionType) -> Bool {
        return !blockedControls.contains(controlActionType)
    }

    // MARK: -
    
    private func controlStateForNetworkStatus(_ controlActionType: CallControlActionType) -> Bool {
        var enabled = true
        if case .notReachable = networkReachabilityStatus {
            enabled = false
        }
        return enabled
    }

    // MARK: -
    
    func controlStateForCallState(_ controlActionType: CallControlActionType) -> Bool {
        var enabled = true
        switch controlActionType {
        case .hangup:
            enabled = true
        case .showKeypad, .hideKeypad:
            switch callState {
            case .connected:
                enabled = true
            default:
                enabled = false
            }
        case .audio:
            switch callState {
            case .outgoing, .incoming, .ringing, .hold, .connected:
                enabled = true
            default:
                enabled = false
            }
        default:
            switch callState {
            case .hold, .connected:
                enabled = true
            default:
                enabled = false
            }
        }
        return enabled
    }
    
}
