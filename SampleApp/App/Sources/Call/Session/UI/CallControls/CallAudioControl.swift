//
//  CallAudioControl.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit

class CallAudioControl: CallControl {

    enum AudioPort {
        case speaker
        case bluetooth
        case phone
    }

    // MARK: -
    
    private var audioRouteButton: AVRoutePickerView?
    private var audioPort: AudioPort = .phone {
        didSet {
            if audioPort != oldValue {
                updateUI()
            }
        }
    }

    // MARK: -
    
    override init(with type: CallControlActionType, theme: CallControlTheme) {
        super.init(with: type, theme: theme)
        
        audioPort = getAudioPort()
        
        if hasBluetooth() {
            let button = AVRoutePickerView()
            button.tintColor = .clear
            button.activeTintColor = .clear
            button.backgroundColor = .clear

            attach(button)
            audioRouteButton = button
        }

        NotificationCenter.default.addObserver(self, selector: #selector(handleAudioRouteChanged(_:)),
                                               name: AVAudioSession.routeChangeNotification,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: -
    
    private func subType() -> CallControlActionType {
        var value: CallControlActionType = .audio
        switch audioPort {
        case .speaker:
            value = .speaker
        case .bluetooth:
            value = .bluetooth
        default: break
        }
        return value
    }
    
    // MARK: -
    
    @objc
    private func handleAudioRouteChanged(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.audioPort = self.getAudioPort()
        }
    }
    
    // MARK: -
    
    override func handleAction() {
        let route: AVAudioSession.PortOverride = (audioPort != .speaker) ? .speaker : .none
        do {
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(route)
        } catch let error {
            log.call.error("\(error)")
        }
    }

    // MARK: -
    
    override func handleThemeChanged(_ theme: CallControlTheme) {
        let type = subType()
        let appearance = type.appearance(for: theme, enabled)
        switch type {
        case .audio, .speaker, .bluetooth:
            view.button.setTemplatedImage(type.icon, appearance.tintColor)
        default: break
        }
        view.button.backgroundColor = appearance.backgroundColor
        view.button.layer.borderColor = appearance.borderColor.cgColor
        view.label.textColor = appearance.textColor
        
        if let button = audioRouteButton {
            button.tintColor = .clear
            button.activeTintColor = .clear
            button.backgroundColor = .clear
        }
    }

    override func applyAppearance() {
        let appearance = subType().appearance(for: theme, enabled)
        view.button.backgroundColor = appearance.backgroundColor
        view.button.tintColor = appearance.tintColor
        view.button.layer.borderColor = appearance.borderColor.cgColor
        view.label.textColor = appearance.textColor
    }

    private func updateUI() {
        handleThemeChanged(theme)
    }

    // MARK: -

    private func attach(_ button: AVRoutePickerView) {
        button.frame = view.button.frame
        view.addSubview(button)
        
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .right, .left]
        NSLayoutConstraint.activate(attributes.map {
            NSLayoutConstraint(item: button, attribute: $0,
                               relatedBy: .equal, toItem: view.button,
                               attribute: $0, multiplier: 1, constant: 0)
        })
    }

    // MARK: -
    
    private func getAudioPort() -> AudioPort {
        var audioPort: AudioPort = .phone
        let outputs = AVAudioSession.sharedInstance().currentRoute.outputs
        for output in outputs {
            if output.portType.rawValue.lowercased().contains("bluetooth") {
                audioPort = .bluetooth
            } else if output.portType.rawValue.lowercased() == "speaker" {
                audioPort = .speaker
            }
        }
        return audioPort
    }

    private func hasBluetooth() -> Bool {
        guard let inputs = AVAudioSession.sharedInstance().availableInputs else {
            return false
        }
        for input in inputs where input.portType.rawValue.lowercased().contains("bluetooth") {
            return true
        }
        return false
    }

}
