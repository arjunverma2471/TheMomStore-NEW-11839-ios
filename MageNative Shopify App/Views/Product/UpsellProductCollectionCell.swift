//
//  UpsellProductCollectionCell.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 29/03/20.
//  Copyright © 2020 MageNative. All rights reserved.
//

import UIKit

class UpsellProductCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!    
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var variationStack: UIStackView!
  
  @IBOutlet weak var outOfStockImage: UIImageView!
  var productVariants:PageableArray<VariantViewModel>!
    var selectedVariant:VariantViewModel!
    var product: ProductViewModel?
    
    func configure(){
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1.0;
    }
}
