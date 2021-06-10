//
//  RingtoneDataSource.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import Foundation
import FileKit

struct Ringtone {
    var filename: String
}

// MARK: -

class RingtoneDataSource {
    
    enum Constants {
        static let fileExt = ".wav"
    }
    
    // MARK: -
    
    private(set) var ringtones = [Ringtone]()
    
    // MARK: -
    
    init() {
        refresh()
    }
    
    // MARK: -
    
    func refresh() {
        let files = Path(Bundle.main.bundlePath).find(searchDepth: 1) { path in
            path.fileName.hasSuffix(Constants.fileExt)
        }
        ringtones = files.map { Ringtone(filename: $0.fileName) }.sorted { $0.filename < $1.filename }
    }
    
}
