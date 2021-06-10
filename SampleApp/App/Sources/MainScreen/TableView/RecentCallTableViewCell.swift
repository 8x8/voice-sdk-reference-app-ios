//
//  RecentCallTableViewCell.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit
import Wavecell

class RecentCallTableViewCell: NibTableViewCell {
    
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var direction: UIImageView!
    
    // MARK: -
    
    private(set) var call: VoiceCall? {
        didSet {
            if let object = call {
                
                if let value = object.contact?.displayName, !value.isEmpty {
                    displayNameLabel.text = value
                    displayNameLabel.isHidden = false
                } else {
                    displayNameLabel.isHidden = true
                }
                
                if let value = object.contact?.contactId, !value.isEmpty {
                    userIdLabel.text = value
                    userIdLabel.isHidden = false
                } else {
                    userIdLabel.isHidden = true
                }
                
                if object.direction == .inbound {
                    direction.image = UIImage(named: "phone-arrow-in")
                } else {
                    direction.image = UIImage(named: "phone-arrow-out")
                }
                
                durationLabel.text = object.humanReadableDuration()
                dateLabel.text = object.humanReadableDate()
            } else {
                displayNameLabel.text = nil
                userIdLabel.text = nil
                direction.image = nil
                durationLabel.text = nil
                dateLabel.text = nil
            }
        }
    }

    // MARK: -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        resetData()
    }
    
    func setup(with call: VoiceCall) {
        self.call = call
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetData()
    }
    
    private func resetData() {
        call = nil
    }
    
}
