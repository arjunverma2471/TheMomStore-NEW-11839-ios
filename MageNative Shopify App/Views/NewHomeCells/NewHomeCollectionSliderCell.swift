//
//  NewHomeCollectionSliderCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 16/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class NewHomeCollectionSliderCell: UICollectionViewCell {

    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    @IBOutlet weak var categoryTitle: UILabel!
  @IBOutlet weak var categoryImage: UIImageView!
  @IBOutlet weak var categoryTitleHeight: NSLayoutConstraint!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        categoryImage.contentMode = .scaleAspectFill
        categoryImage.clipsToBounds = true
        categoryImage.backgroundColor =  .randomAlpha
        categoryTitle.backgroundColor = .clear
        // Initialization code
    }

}
