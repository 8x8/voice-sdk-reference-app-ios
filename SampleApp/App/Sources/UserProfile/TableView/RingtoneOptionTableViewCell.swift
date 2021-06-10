//
//  RingtoneOptionTableViewCell.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit

class RingtoneOptionTableViewCell: NibTableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    // MARK: -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        resetData()
    }
    
    func setup(name: String, selected: Bool) {
        self.name.text = name
        imgView.image = selected ? UIImage(named: "checkmark") : nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetData()
    }
    
    private func resetData() {
        name.text = nil
        imgView.image = nil
    }
    
}
