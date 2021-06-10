//
//  PhoneTableViewCell.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit

class PhoneTableViewCell: NibTableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var value: UILabel!
    
    // MARK: -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        resetData()
    }
    
    func setup(name: String, value: String) {
        self.name.text = name
        self.value.text = value
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetData()
    }
    
    private func resetData() {
        name.text = nil
        value.text = nil
    }
    
}
