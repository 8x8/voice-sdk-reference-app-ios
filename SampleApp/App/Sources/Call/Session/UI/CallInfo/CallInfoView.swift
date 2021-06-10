//
//  CallInfoView.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit

class CallInfoView: UIView {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var bannerContainer: UIView!
    @IBOutlet weak var nameContainer: UIView!
    @IBOutlet weak var avatarContainer: UIView!
    @IBOutlet weak var stateContainer: UIView!
    @IBOutlet weak var durationContainer: UIView!
    @IBOutlet weak var progressContainer: UIView!
    
    // MARK: -
    
    @IBOutlet weak var bannerHolder: UIView!
    @IBOutlet weak var avatarHolder: UIView!
    
    // MARK: -
    
    @IBOutlet weak var bannerLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    
    // MARK: -
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
