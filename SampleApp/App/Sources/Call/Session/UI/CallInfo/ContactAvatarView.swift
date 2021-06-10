//
//  ContactAvatarView.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit

class ContactAvatarView: UIView {
    
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        icon.backgroundColor = .appSoftGold
    }
    
    // MARK: -
    
    func setup(with url: URL?) {
        icon.image = UIImage(named: "contact-default-avatar")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        icon.layer.cornerRadius = icon.frame.size.height / 2
    }
    
}
