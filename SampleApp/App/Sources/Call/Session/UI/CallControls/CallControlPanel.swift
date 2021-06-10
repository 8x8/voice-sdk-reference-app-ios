//
//  CallControlPanel.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit
import Wavecell

class CallControlPanel: CallControlPanelContainerDataSourceProtocol,
                        CallSessionControlEnabledStateObserverProtocol,
                        CallSessionCallStateObserverProtocol,
                        CallSessionMutedStateObserverProtocol,
                        CallSessionThemeObserverProtocol {
    
    private(set) var controls = [CallControlActionType: CallControl]()
    private(set) var activeControls = [CallControlActionType]() {
        didSet {
            onActiveControlsUpdateBlock?()
        }
    }

    // MARK: -

    private(set) var theme: CallControlTheme = .light {
        didSet {
            if theme != oldValue {
                handleThemeChanged(theme)
            }
        }
    }

    // MARK: -
    
    var onActiveControlsUpdateBlock: (() -> Void)?
    var onActiveControlReplaceBlock: ((Int, UIView) -> Void)?
    
    // MARK: -
    
    private(set) weak var session: CallSession?
    
    // MARK: -
    
    init(with session: CallSession) {
        self.session = session
        
        // create control set
        for item in CallControlActionType.base() {
            let control = item == .audio ? CallAudioControl(with: item, theme: .light) :
                                           CallControl(with: item, theme: .light)
            control.actionHandler = { [weak self] object in
                self?.handleCallControlAction(object.type)
            }
            control.theme = theme
            controls[item] = control
            
        }
        
        // listen for changes
        subscribe()
    }
    
    deinit {
        log.adhoc.info("")
        unsubscribe()
    }
    
    // MARK: -
    
    private func subscribe() {
        session?.viewModel.addObserver(self)
    }

    private func unsubscribe() {
        session?.viewModel.removeObserver(self)
    }

    // MARK: -
    
    func setup(with types: [CallControlActionType]) {
        activeControls = types
        
        // restore state
        guard let model = session?.viewModel else {
            return
        }
        for (type, control) in controls {
            if let model = model.controls[type] {
                control.enabled = model.enabled
            }
        }
        handleCallStateChanged(model, model.callState)
    }

    // MARK: -
    
    private func handleCallControlAction(_ type: CallControlActionType) {
       session?.performAction(for: type)
    }
    
    // MARK: -
    
    func numberOfCells(for container: CallControlPanelContainer) -> Int {
        return activeControls.count
    }
    
    func cellSize(for container: CallControlPanelContainer) -> CGSize {
        guard let control = controls.values.first else {
            return CGSize(width: 0, height: 0)
        }
        return control.view.bounds.size
    }
    
    func cell(for container: CallControlPanelContainer, at index: Int) -> UIView? {
        let actionType = activeControls[index]
        return controls[actionType]?.view
    }
 
    // MARK: -
    
    func handleCallStateChanged(_ model: CallSession.Model, _ state: VoiceCallState) {
        switch state {
        case .hold:
            handleCallHoldStateChanged(true)
        default:
            handleCallHoldStateChanged(false)
        }
    }
    
    func handleControlEnabledStateChanged(_ model: CallSession.Model,
                                          _ type: CallControlActionType,
                                          _ enabled: Bool) {
        if let control = controls[type] {
            control.enabled = enabled
        }
    }
    
    func handleMutedStateChanged(_ model: CallSession.Model, _ state: CallMutedState) {
        let value = activeControls.firstIndex(of: .mute) ?? activeControls.firstIndex(of: .unmute)
        guard let index = value else {
            return
        }
        if let control = controls[state == .on ? .unmute : .mute], control.type != activeControls[index] {
            activeControls[index] = control.type
            replaceControl(at: index, with: control)
        }
    }
    
    func handleThemeChanged(_ model: CallSession.Model, _ theme: CallControlTheme) {
        self.theme = theme
    }
    
    // MARK: -
    
    private func handleThemeChanged(_ theme: CallControlTheme) {
        for (_, control) in controls {
            control.theme = theme
        }
    }

    private func handleCallHoldStateChanged(_ hold: Bool) {
        let value = activeControls.firstIndex(of: .hold) ?? activeControls.firstIndex(of: .unhold)
        guard let index = value else {
            return
        }
        if let control = controls[hold ? .unhold : .hold], control.type != activeControls[index] {
            activeControls[index] = control.type
            replaceControl(at: index, with: control)
        }
    }

    private func replaceControl(at index: Int, with control: CallControl) {
        onActiveControlReplaceBlock?(index, control.view)
    }

}
