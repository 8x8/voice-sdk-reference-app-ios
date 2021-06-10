//
//  WavecellClient+AudioSession.swift
//  SampleApp
//
//  Copyright © 2023 8x8, Inc. All rights reserved.
//

import Foundation
import Combine
import AVFoundation
import Wavecell

extension WavecellClient {
    
    var audioSessionActivated: CurrentValueSubject<Bool, Never> {
        sdk.audioSessionActivated
    }
    
    func setupAudioSessionConfigurationCallback() {
        VoiceSDK.audioSessionConfigurationCallback = { session in
            do {
                let mode: AVAudioSession.Mode = .voiceChat
                log.adhoc.info("setMode: \(mode)")
                if #available(iOS 16.4, *) {
                    try session.setCategory(.playAndRecord, mode: mode, options: [.allowBluetooth])
                } else {
                    try session.setCategory(.playAndRecord, mode: .default, options: [.allowBluetooth])
                    try session.setMode(mode)
                }
                
                try session.overrideOutputAudioPort(.none)
                try session.setPreferredIOBufferDuration(0.01)
            } catch let error {
                log.adhoc.info("\(error.localizedDescription)")
            }
        }
    }
    
}
