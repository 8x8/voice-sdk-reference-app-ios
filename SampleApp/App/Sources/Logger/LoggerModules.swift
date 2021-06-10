//
//  LoggerModules.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import Foundation

enum log: String, CaseIterable {

    case general = "General"
    case preferences = "Preferences"
    case call = "Call"
    case adhoc = "Adhoc"
        
    // MARK: -
    
    static var channel: Channel {
        return Channel.shared
    }
        
    // MARK: -
    
    static func allModules() -> [String] {
        var result = [String]()
        result.append(contentsOf: log.allCases.map { $0.rawValue })
        return result
    }
    
}

// MARK: -

extension log {

    class Channel {
        
        static let shared = Channel()
        
        // MARK: -
        
        var modules = [String]()
        
        // MARK: -
        
        private var timeFormatter = DateFormatter()
        
        // MARK: -
        
        init() {
            modules = allModules()
            timeFormatter.dateFormat = "HH:mm:ss.SSS"
            timeFormatter.timeZone = TimeZone.current
        }
        
        // MARK: -
        
        func vlog(_ module: String, _ message: String, _ level: String,
                  _ file: String, _ function: String, _ line: Int) {
            if !modules.contains(module) {
                return
            }

            let date = timeFormatter.string(from: Date())
            let message = format(module, message, date, file, function, line, level)
            Swift.print(message)
        }

        // MARK: -
        
        // swiftlint:disable colon
        private func format(_ module: String, _ message: String, _ date: String, _ file: String,
                            _ function: String, _ line: Int, _ level: String) -> String {
            return "\(date) [\(module)] [\(level)] [\(filename(for:file)):\(function):\(line)] \(message)"
        }
        // swiftlint:enable colon
        
        private func filename(for file: String) -> String {
            return file.components(separatedBy: "/").last ?? ""
        }
        
    }
    
    // MARK: -

    func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        Channel.shared.vlog(rawValue, message, "ERROR", file, function, line)
    }

    func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        Channel.shared.vlog(rawValue, message, "INFO", file, function, line)
    }

    func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        Channel.shared.vlog(rawValue, message, "DEBUG", file, function, line)
    }

    func verbose(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        Channel.shared.vlog(rawValue, message, "VERBOSE", file, function, line)
    }
    
}
