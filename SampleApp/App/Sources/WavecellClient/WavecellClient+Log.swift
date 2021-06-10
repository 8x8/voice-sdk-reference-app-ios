//
//  WavecellClient+Log.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import Foundation
import Wavecell

extension WavecellClient {
    
    static func setupLog() {
        // register modules
        var modules = [String]()
        
        // RTC
        modules.append(LogModule.rtc.sdk.rawValue)
        modules.append(LogModule.rtc.transaction.rawValue)
        modules.append(LogModule.rtc.vstack.rawValue)

        // Wavecell
        modules.append(LogModule.voice.sdk.rawValue)
        modules.append(LogModule.voice.network.rawValue)
        modules.append(LogModule.voice.push.rawValue)
        
        log.channel.modules.append(contentsOf: modules)
        
        // setup log message routing
        VoiceSDK.logMessageCallback = { module, message, level, context in
            guard let context = context else {
                return
            }
            log.channel.vlog(module, message, level.rawValue.uppercased(),
                             context.file, context.function, context.line)
        }
    }

}
