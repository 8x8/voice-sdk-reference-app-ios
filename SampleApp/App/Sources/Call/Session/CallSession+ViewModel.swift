//
//  CallSession+Model.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit
import Wavecell

protocol CallSessionCallStateObserverProtocol: AnyObject {
    func handleCallStateChanged(_ model: CallSession.Model, _ state: VoiceCallState)
}

protocol CallSessionMutedStateObserverProtocol: AnyObject {
    func handleMutedStateChanged(_ model: CallSession.Model, _ state: CallMutedState)
}

protocol CallSessionNetworkReachabilityObserverProtocol: AnyObject {
    func handleNetworkReachabilityChanged(_ model: CallSession.Model, _ status: ReachabilityStatus)
}

protocol CallSessionConnectionQualityObserverProtocol: AnyObject {
    func handleConnectionQualityChanged(_ model: CallSession.Model, _ quality: CallConnectionQuality)
}

protocol CallSessionThemeObserverProtocol: AnyObject {
    func handleThemeChanged(_ model: CallSession.Model, _ theme: CallControlTheme)
}

protocol CallSessionControlEnabledStateObserverProtocol: AnyObject {
    func handleControlEnabledStateChanged(_ model: CallSession.Model, _ type: CallControlActionType, _ enabled: Bool)
}

// MARK: -

extension CallSession {
    
    class Model: Observable {
        
        var callState: VoiceCallState {
            didSet {
                handleCallStateChanged()
            }
        }
        
        var mutedState: CallMutedState {
            didSet {
                handleMutedStateChanged()
            }
        }

        // MARK: -
        
        var networkReachabilityStatus: ReachabilityStatus = .unknown {
            didSet {
                if oldValue != networkReachabilityStatus {
                    handleNetworkReachabilityChanged()
                }
            }
        }
        
        // MARK: -
        
        var connectionQuality: CallConnectionQuality = .unknown {
            didSet {
                if oldValue != connectionQuality {
                    handleConnectionQualityChanged()
                }
            }
        }
        
        // MARK: -
        
        var theme: CallControlTheme = .light {
            didSet {
                if theme != oldValue {
                    handleThemeChanged()
                }
            }
        }

        // MARK: -
        
        var blockedControls = Set<CallControlActionType>() // blocked by active transactions

        // MARK: -

        private(set) var controls = [CallControlActionType: CallControlActionModel]()
        
        // MARK: -
        
        var observers = WeakObjectCollection<AnyObject>()

        // MARK: -
        
        init(with callState: VoiceCallState,
             mutedState: CallMutedState,
             connectionQuality: CallConnectionQuality) {
            self.callState = callState
            self.mutedState = mutedState
            self.connectionQuality = connectionQuality
            
            for type in CallControlActionType.AllCases() {
                controls[type] = CallControlActionModel(with: type, handler: { [weak self] state in
                    guard let self = self else { return }
                    self.handleCallControlActionStateChanged(type, state)
                })
            }
        }
        
        deinit {
        }
        
        // MARK: -
        
        func updateControlState(for type: CallControlActionType) {
            let state = controlState(for: type)
            setControlState(for: type, enabled: state)
        }
        
        private func setControlState(for type: CallControlActionType, enabled: Bool) {
            guard let model = controls[type] else {
                return
            }
            model.enabled = enabled
        }

        // MARK: -

        func block(_ controlType: CallControlActionType) {
            blockedControls.insert(controlType)
            updateControlState(for: controlType)
        }
        
        func unblock(_ controlType: CallControlActionType) {
            blockedControls.remove(controlType)
            updateControlState(for: controlType)
        }

        // MARK: -

        private func handleCallStateChanged() {
            notifyObservers { (observer: CallSessionCallStateObserverProtocol) in
                observer.handleCallStateChanged(self, self.callState)
            }
            updateControlStates()
        }
        
        private func handleMutedStateChanged() {
            notifyObservers { (observer: CallSessionMutedStateObserverProtocol) in
                observer.handleMutedStateChanged(self, self.mutedState)
            }
        }

        private func handleNetworkReachabilityChanged() {
            log.call.info("")
            notifyObservers { (observer: CallSessionNetworkReachabilityObserverProtocol) in
                observer.handleNetworkReachabilityChanged(self, self.networkReachabilityStatus)
            }
            updateControlStates()
        }

        private func handleConnectionQualityChanged() {
            log.call.info("")
            notifyObservers { (observer: CallSessionConnectionQualityObserverProtocol) in
                observer.handleConnectionQualityChanged(self, self.connectionQuality)
            }
        }
        
        private func handleThemeChanged() {
            notifyObservers { (observer: CallSessionThemeObserverProtocol) in
                observer.handleThemeChanged(self, self.theme)
            }
        }

        // MARK: -
        
        private func updateControlStates() {
            for (type, _) in controls {
                updateControlState(for: type)
            }
        }

        private func handleCallControlActionStateChanged(_ type: CallControlActionType, _ enabled: Bool) {
            notifyObservers { (observer: CallSessionControlEnabledStateObserverProtocol) in
                observer.handleControlEnabledStateChanged(self, type, enabled)
            }
        }

    }
    
}
