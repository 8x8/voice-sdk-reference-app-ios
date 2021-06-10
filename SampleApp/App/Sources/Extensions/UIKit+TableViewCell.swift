//
//  UIKit+TableViewCell.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit

class NibTableViewCell: UITableViewCell {
    
    override internal var reuseIdentifier: String? {
        return String(describing: type(of: self).self)
    }
    
}

class NibTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    override internal var reuseIdentifier: String? {
        return String(describing: type(of: self).self)
    }
    
}

// MARK: -

extension UITableViewCell {
    
    class func identifier() -> String {
        return String(describing: self)
    }
    
}

extension UITableViewHeaderFooterView {
    
    class func identifier() -> String {
        return String(describing: self)
    }
    
}

// MARK: -

extension UITableView {
    
    func registerNibCell<T: NibTableViewCell>(type: T.Type) {
        register(UINib(nibName: type.identifier(), bundle: nil), forCellReuseIdentifier: type.identifier())
    }
    
    func registerNibHeaderFooter<T: NibTableViewHeaderFooterView>(type: T.Type) {
        register(UINib(nibName: type.identifier(), bundle: nil), forHeaderFooterViewReuseIdentifier: type.identifier())
    }
    
    // swiftlint:disable force_cast
    func dequeueReusableCell<T: NibTableViewCell>() -> T {
        return dequeueReusableCell(withIdentifier: T.identifier()) as! T
    }
    
    func dequeueReusableCell<T: NibTableViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier(), for: indexPath) as! T
    }
    
    func dequeueReusableHeaderFooterView<T: NibTableViewHeaderFooterView>() -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: T.identifier()) as! T
    }
    // swiftlint:enable force_cast
    
}
