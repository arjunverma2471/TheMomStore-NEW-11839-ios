//
//  FeedCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 07/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class FeedCell: UICollectionViewCell {
   
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var lbl_caption: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        feedImage.backgroundColor = .randomAlpha
        // Initialization code
        
    }

}
