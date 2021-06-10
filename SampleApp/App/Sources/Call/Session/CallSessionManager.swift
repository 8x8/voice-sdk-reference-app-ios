//
//  CallSessionManager.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit
import Wavecell

class CallSessionManager: CallSetObserverProtocol,
                          NetworkReachabilityObserverProtocol,
                          WavecellClientObserverProtocol {
    
    static let shared = CallSessionManager()
    
    // MARK: -
    
    private(set) var sessions = [CallSession]() {
        didSet {
            adjustDeviceProximityTracking()
        }
    }
    
    // MARK: -
    
    private init() {
    }
    
    // MARK: -

    func attach(to userContext: UserContextProtocol) {
        userContext.wavecellClient.addObserver(self)
        userContext.wavecellClient.sdk.addObserver(self)
    }
    
    // MARK: -
    
    private func session(for call: VoiceCall) -> CallSession? {
        for object in sessions where object.match(by: call.uuid) {
            return object
        }
        return nil
    }

    private func add(_ session: CallSession) {
        session.presentationDismissBlock = { session, shouldRemoveSession in
            self.dismissUI(for: session, shouldRemoveSession: shouldRemoveSession)
        }
        sessions.append(session)
    }
    
    func remove(_ session: CallSession) {
        for (index, object) in sessions.enumerated()
            where object === session {
                sessions.remove(at: index)
        }
    }

    // MARK: -
    
    func presentUI(for call: VoiceCall) {
        var object = session(for: call)
        if object == nil {
            let session = CallSession(with: call)
            add(session)
            object = session
        }
        if let object = object {
            presentUI(for: object)
        }
    }

    // MARK: -
    
    func handleCallAdded(_ call: VoiceCall) {
        log.call.info("\(call.uuid)")
        if call.direction == .inbound {
            presentUI(for: call)
        }
    }
    
    func handleCallRemoved(_ call: VoiceCall) {
        log.call.info("\(call.uuid)")
        
        guard let session = self.session(for: call) else {
            return
        }
        
        if call.state == .failed {
            // display error
            return
        }
        dismissUI(for: session, shouldRemoveSession: true)
    }
    
    // MARK: -
    
    func handleNetworkReachabilityStatusChanged(_ status: ReachabilityStatus) {
        for object in sessions {
            object.viewModel.networkReachabilityStatus = status
        }
    }
    
    // MARK: -
    
    private func presentUI(for session: CallSession) {
        log.call.info("\(session.call.uuid)")
        Presenter.shared.presentCallSessionViewScreen(session.presentingController)
    }

    private func dismissUI(for session: CallSession, shouldRemoveSession: Bool) {
        log.call.info("\(session.call.uuid)")
        Presenter.shared.presentMainScreen()
        
        if !shouldRemoveSession {
            // preserve session for active call
            let included = UserContext.shared.wavecellClient.sdk.calls.contains { $0.uuid == session.call.uuid }
            if included {
                return
            }
        }
        remove(session)
    }

    // MARK: -
    
    func outgoingCallDidStart(_ call: VoiceCall) {
        presentUI(for: call)
    }
    
    // MARK: -
    
    private func adjustDeviceProximityTracking() {
        UIDevice.current.isProximityMonitoringEnabled = sessions.count > 0
    }
    
}
