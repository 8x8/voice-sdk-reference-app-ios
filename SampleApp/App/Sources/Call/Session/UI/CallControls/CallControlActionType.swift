//
//  CallControlActionType.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import Foundation

enum CallControlActionType: CaseIterable {
    
    case hangup
    case hold
    case unhold
    case mute
    case unmute
    case showKeypad
    case hideKeypad
    case showMore
    case hideMore
    case audio
    case noaudio
    case speaker
    case bluetooth
    
    static func base() -> [CallControlActionType] {
        return [mute, unmute, hold, unhold, audio]
    }
}

// MARK: -

extension CallControlActionType {
    
    var title: String {
        var value = ""
        switch self {
        case .hangup:
            value = "Hangup"
        case .mute:
            value = "Mute"
        case .unmute:
            value = "Unmute"
        case .hold:
            value = "Hold"
        case .unhold:
            value = "Unhold"
        case .showMore, .hideMore:
            value = "More"
        case .showKeypad, .hideKeypad:
            value = "Keypad"
        case .audio, .speaker, .noaudio, .bluetooth:
            value = "Audio"
        }
        return value
    }
    
}

// MARK: -

extension CallControlActionType {
    
    var icon: String {
        var value = ""
        switch self {
        case .mute, .unmute:
            value = "call-control-mute"
        case .hold, .unhold:
            value = "call-control-hold"
        case .showMore, .hideMore:
            value = "call-control-more"
        case .showKeypad, .hideKeypad:
            value = "call-control-keypad"
        case .audio, .speaker:
            value = "call-control-audio"
        case .noaudio:
            value = "call-control-no-audio"
        case .bluetooth:
            value = "call-control-bluetooth"
        case .hangup:
            value = "call-control-hangup"
        }
        return value
    }
    
}

// MARK: -

protocol CallControlActionRunnerProtocol: AnyObject {
    func performCallControlAction(_ action: CallControlActionType)
}
