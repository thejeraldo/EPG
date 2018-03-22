//
//  EPGCollectionViewCell.swift
//  EPG
//
//  Created by Jerald Abille on 3/22/18.
//  Copyright © 2018 Jerald Abille. All rights reserved.
//

import UIKit

class EPGCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var titleLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  func setup() {
    self.titleLabel.text = "1"
    self.backgroundColor = UIColor.orange
  }
}
