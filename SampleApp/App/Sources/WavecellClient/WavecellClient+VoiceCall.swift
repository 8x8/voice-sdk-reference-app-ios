//
//  WavecellClient+VoiceCall.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import Foundation
import Wavecell

extension VoiceCallState: CustomStringConvertible {
    
    public var description: String {
        var value = ""
        switch self {
        case .incoming:
            value = "incoming"
        case .outgoing:
            value = "outgoing"
        case .ringing:
            value = "ringing"
        case .connected:
            value = "connected"
        case .hold:
            value = "hold"
        case .connectPending:
            value = "connectPending"
        case .holdPending:
            value = "holdPending"
        case .disconnected:
            value = "disconnected"
        case .failed:
            value = "failed"
        case .unknown:
            value = "unknown"
        @unknown default:
            break
        }
        return value
    }
    
}

// MARK: -

extension VoiceCall {
    
    func contactDisplayName() -> String {
//        if let value = contact?.displayName, !value.isEmpty {
//            return value
//        }
        if let value = contact?.contactId, !value.isEmpty {
            return value
        }
        return "n/a"
    }
    
    func humanReadableDuration() -> String {
        var endTime = UInt(Date().timeIntervalSince1970)

        switch state {
        case .disconnected, .failed:
            endTime = deactivatedTime
        default: break
        }
        
        if callStartTime == 0 {
            return "n/a"
        }
        
        let timeInterval = endTime - callStartTime
        
        let minutes = timeInterval / 60
        let seconds = timeInterval % 60
        return String.localizedStringWithFormat("%d:%02d", minutes, seconds)
    }

    func humanReadableDate() -> String {
        if callStartTime == 0 {
            return "n/a"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm:ss a"
        return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(callStartTime)))
    }
    
    func humanReadableDelays() -> String? {
        guard let context = context else {
            return nil
        }
        let backendDelay = (context.remoteTimestamp - context.callStartTimestamp)
        let deliveryDelay = (context.localTimestamp - context.remoteTimestamp)
        let delay = backendDelay + deliveryDelay
        return String.localizedStringWithFormat("(%.2fs, %.2fs, %.2fs)",
                                                Double(delay)/1000,
                                                Double(backendDelay)/1000,
                                                Double(deliveryDelay)/1000)
    }
    
    // MARK: -
    
    private var callStartTime: UInt {
        var time: UInt = startTime
        switch direction {
        case .inbound:
            if let value = context?.callStartTimestamp {
               time = value / 1000
            }
        default: break
        }
        return time
    }
    
}

// MARK: -

extension InboundCallPath {
    
    var info: String {
        var value = ""
        switch self {
        case .voipWithFallbackToPSTN:
            value = "voip \u{2192} pstn"
        case .voip:
            value = "voip"
        case .pstn:
            value = "pstn"
        @unknown default:
            break
        }
        return value
    }
    
}
