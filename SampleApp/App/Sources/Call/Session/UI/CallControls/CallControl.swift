//
//  CallControl.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit

class CallControlView: UIView {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    // MARK: -
    
    var actionHandler: ((CallControlView) -> Void)?
    
    // MARK: -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // round button
        button.layer.borderWidth = 1.5
        button.layer.cornerRadius = button.frame.size.height / 2
    }

    // MARK: -
    
    @IBAction func handleAction(_ sender: UIButton) {
        actionHandler?(self)
    }

}

// MARK: -

class CallControl {
    
    var type: CallControlActionType
    var theme: CallControlTheme {
        didSet {
            handleThemeChanged(theme)
        }
    }
    
    // MARK: -
    
    private(set) var view: CallControlView
    
    var enabled: Bool = true {
        didSet {
            if enabled != oldValue {
                view.button.isEnabled = enabled
                view.label.isEnabled = enabled
                applyAppearance()
            }
        }
    }
    
    // MARK: -
    
    var actionHandler: ((CallControl) -> Void)?
    
    // MARK: -
    
    init(with type: CallControlActionType,
         theme: CallControlTheme) {
        self.type = type
        self.theme = theme
        
        // setup view
        view = CallControlView.fromNib()
        view.heightAnchor.constraint(greaterThanOrEqualToConstant: view.bounds.height).isActive = true
        view.widthAnchor.constraint(greaterThanOrEqualToConstant: view.bounds.width).isActive = true
        view.actionHandler = { [weak self] view in
            guard let self = self else { return }
            self.handleAction()
        }
        view.label.text = type.title
        view.button.setTemplatedImage(type.icon)
    }
    
    // MARK: -
    
    func embed(in container: UIView) {
        view.embed(in: container)
    }

    // MARK: -
    
    func handleAction() {
        actionHandler?(self)
    }

    // MARK: -
    
    func handleThemeChanged(_ theme: CallControlTheme) {
        applyAppearance()
    }
    
    func applyAppearance() {
        let appearance = type.appearance(for: theme, enabled)
        view.button.backgroundColor = appearance.backgroundColor
        view.button.tintColor = appearance.tintColor
        view.button.layer.borderColor = appearance.borderColor.cgColor
        view.label.textColor = appearance.textColor
    }
    
}
