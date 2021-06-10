//
//  UIKit+View+Xib.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit

extension UIView {
    
   var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    class func fromNib(name: String? = nil) -> Self {
        return fromNib(name: name, type: self)
    }
    
    class func fromNib<T: UIView>(name: String? = nil, type: T.Type) -> T {
        let value: T? = fromNib(nibNameOrNil: name, type: T.self)
        return value!
    }
    
    class func fromNib<T: UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T? {
        var view: T?
        let nibViews = Bundle.main.loadNibNamed(nibNameOrNil ?? nibName, owner: nil, options: nil)
        for item in nibViews! {
            if let ref = item as? T {
                view = ref
            }
        }
        return view
    }
    
    class var nibName: String {
        return String(describing: self)
    }
    
    // MARK: -
    
    func embed(in view: UIView, attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .right, .left]) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        let attributes: [NSLayoutConstraint.Attribute] = attributes
        NSLayoutConstraint.activate(attributes.map {
            NSLayoutConstraint(item: self, attribute: $0,
                               relatedBy: .equal, toItem: view,
                               attribute: $0, multiplier: 1, constant: 0)
        })
    }

}
