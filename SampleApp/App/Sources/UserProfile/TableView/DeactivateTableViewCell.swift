//
//  DeactivateTableViewCell.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit

class DeactivateTableViewCell: NibTableViewCell {
  
  @IBOutlet private weak var label: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    label.textColor = .appSoftRed
    resetView()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    resetView()
  }
  
  private func resetView() {
    label.text = ""
  }
  
  // MARK: -
  
  func setup(text: String) {
    label.text = text
  }
  
}
