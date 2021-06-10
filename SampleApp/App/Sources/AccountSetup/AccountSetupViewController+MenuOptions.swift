//
//  AccountSetupViewController+MenuOptions.swift
//  SampleApp
//
//  Copyright © 2023 8x8, Inc. All rights reserved.
//

import UIKit
import SwiftUI
import Popovers

extension AccountSetupViewController {
    
    var defaultMenuWidth: CGFloat {
        container.bounds.width * 0.9
    }
    
    func createMenuItemText(_ value: String) -> Text {
        Text(value).font(Font.custom("Rubik-Regular", size: 12.0))
    }
    
    // MARK: -
    
    func createServiceUrlOptionsMenu() -> Templates.UIKitMenu {
        let object = Templates.UIKitMenu(sourceView: serviceUrlOptionsLabel,
                                         configuration: { $0.width = self.defaultMenuWidth },
                                         content: {
            var array = [AnyView]()
            [UserContext.Config.defaultServiceUrl].forEach { url in
                let text = self.createMenuItemText("\(url)")
                let item = Templates.MenuButton(text: text) { [weak self] in
                    self?.handleServiceUrlOptionSelection(url)
                }
                array.append(AnyView(item))
            }
            return array
        })
        return object
    }
    
    // MARK: -

    @IBAction func handleServiceUrlOptions(_ sender: UIButton) {
        serviceUrlOptionsMenu = createServiceUrlOptionsMenu()

        hideKeyboard()
        serviceUrlOptionsMenu?.present()
    }
    
    private func handleServiceUrlOptionSelection(_ value: String) {
        serviceUrlField.text = value
        serviceUrlField.sendActions(for: .editingChanged)
    }
    
}
