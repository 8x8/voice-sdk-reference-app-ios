//
//  UIKit+UIButton.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setTemplatedImage(_ name: String,
                           _ tint: UIColor,
                           _ renderingMode: UIImage.RenderingMode = .alwaysTemplate) {
        let image = UIImage(named: name)?.withRenderingMode(renderingMode)
        setImage(image, for: .normal)
        tintColor = tint
    }
    
    func setTemplatedImage(_ name: String, _ renderingMode: UIImage.RenderingMode = .alwaysTemplate) {
        let image = UIImage(named: name)?.withRenderingMode(renderingMode)
        setImage(image, for: .normal)
    }
    
}
