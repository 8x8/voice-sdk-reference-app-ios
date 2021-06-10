//
//  WavecellClient+Recents.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import Foundation
import Wavecell

protocol WavecellClientRecentsObserverProtocol: AnyObject {
    func handleRecentsChanged()
}

// MARK: -

extension WavecellClient: CallSetObserverProtocol {
   
    func handleCallAdded(_ call: VoiceCall) {
    }
    
    func handleCallRemoved(_ call: VoiceCall) {
        recents.insert(call, at: 0)
    }

    // MARK: -
    
    func handleRecentsChanged() {
        notifyObservers { (observer: WavecellClientRecentsObserverProtocol) in
            observer.handleRecentsChanged()
        }
    }
    
}
