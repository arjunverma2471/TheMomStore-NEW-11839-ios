//
//  HomeCollectionSliderCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 02/09/19.
//  Copyright © 2019 MageNative. All rights reserved.
//

import UIKit

class HomeCollectionSliderCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
  
    @IBOutlet weak var categoryTitleHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryImage.backgroundColor = .randomAlpha
        categoryTitle.textAlignment = .center
       
    }
}
