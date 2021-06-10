//
//  AppDelegate.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import Foundation

extension AppDelegate {
    
    func setupAppLogger() {
        setupFrameworkLoggers()
        log.general.info("first log line")
    }

    // MARK: -
    
    private func setupFrameworkLoggers() {
        WavecellClient.setupLog()
    }
    
}
