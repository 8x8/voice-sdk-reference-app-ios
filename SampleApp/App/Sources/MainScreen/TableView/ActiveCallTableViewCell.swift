//
//  ActiveCallTableViewCell.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit
import Wavecell

class ActiveCallTableViewCell: NibTableViewCell,
                               VoiceCallStateObserverProtocol {
    
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var direction: UIImageView!
    
    // MARK: -

    private var timer: Timer?
    
    // MARK: -

    private(set) var call: VoiceCall? {
        willSet {
            call?.removeObserver(self)
        }
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
                
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                    guard let self = self else { return }
                    self.updateUI()
                }
                updateUI()
                object.addObserver(self)
            } else {
                displayNameLabel.text = nil
                userIdLabel.text = nil
                direction.image = nil
                durationLabel.text = nil
                dateLabel.text = nil
                timer?.invalidate()
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
    
    // MARK: -
    
    func handleCallStateChanged(_ call: VoiceCall, _ new: VoiceCallState, _ old: VoiceCallState) {
        switch new {
        case .disconnected, .failed:
            timer?.invalidate()
        default: break
        }
    }
    
    // MARK: -
    
    private func updateUI() {
        durationLabel.text = call?.humanReadableDuration()
        dateLabel.text = call?.humanReadableDate()
    }
    
}
