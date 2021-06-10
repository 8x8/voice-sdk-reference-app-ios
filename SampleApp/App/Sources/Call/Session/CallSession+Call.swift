//
//  CallSession+Call.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import Foundation
import Wavecell

extension CallSession: VoiceCallStateObserverProtocol,
                       VoiceCallConnectionQualityObserverProtocol,
                       VoiceCallMutedStateObserverProtocol {
    
    // MARK: -
    
    func handleCallStateChanged(_ call: VoiceCall, _ new: VoiceCallState, _ old: VoiceCallState) {
        viewModel.callState = new
        adjustSessionState(for: new)
    }
    
    // MARK: -
    
    func handleCallConnectionQualityChanged(_ call: VoiceCall) {
        viewModel.connectionQuality = call.connectionQuality
    }
    
    // MARK: -
    
    func handleCallMutedStateChanged(_ call: VoiceCall, _ new: CallMutedState, _ old: CallMutedState) {
        viewModel.mutedState = new
    }
    
}
