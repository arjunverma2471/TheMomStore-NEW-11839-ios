//
//  CategoryCollectionCell.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 19/05/20.
//  Copyright © 2020 MageNative. All rights reserved.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell {
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var categoryNameLabel: UILabel!
  
  @IBOutlet weak var outerView: UIView!
  
  func configureFrom(_ viewModel: CollectionViewModel){
    //self.outerView.cardView()
    self.categoryNameLabel.text = viewModel.title
    self.backgroundImageView.setImageFrom(viewModel.imageURL)
    self.backgroundImageView.contentMode = .scaleAspectFill
      self.backgroundImageView.layer.cornerRadius = self.backgroundImageView.frame.width/2
      self.backgroundImageView.clipsToBounds = true;
      //self.outerView.backgroundColor = UIColor(hexString: "#EAF2FB")
      //self.outerView.layer.cornerRadius = 6
//      self.backgroundImageView.layer.cornerRadius = 6
//      self.backgroundImageView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner]
  }
}
