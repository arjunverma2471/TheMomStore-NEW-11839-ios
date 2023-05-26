//
//  SearchCollectionCell.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 17/03/20.
//  Copyright © 2020 MageNative. All rights reserved.
//

import UIKit

protocol wishListCellDelegate {
  func addToWishListProduct(_ cell: SearchCollectionCell, didAddToWishList sender: Any)
}

class SearchCollectionCell: UICollectionViewCell {
  
  @IBOutlet weak var cellView: UIView!
  @IBOutlet weak var productImageView: UIImageView!
  @IBOutlet weak var productName: UILabel!
  @IBOutlet weak var productDescription: UILabel!
  @IBOutlet weak var outOfStock: UIImageView!
  @IBOutlet weak var priceLabel: UILabel!
  
  func configure(from model: ProductListViewModel){
    if(model.images.items.count>0){
      productImageView.setImageFrom(model.images.items[0].url)
    }
    productName.text = model.title
    productDescription.sizeToFit()
    productDescription.numberOfLines = 0
    productDescription.lineBreakMode = .byWordWrapping
      productName.font = mageFont.regularFont(size: 15.0)
      
      let attr1 = [NSMutableAttributedString.Key.font:mageFont.regularFont(size: 13.0)]
    let attribute =  "\(model.summary)".htmlToAttributedString
      attribute?.addAttributes(attr1 as [NSAttributedString.Key : Any], range: NSRange(location: 0, length: attribute?.length ?? 0))
    productDescription.attributedText = attribute
      priceLabel.font = mageFont.regularFont(size: 14.0)
    priceLabel.attributedText =  self.calCulatePrice(model)
    
    if customAppSettings.sharedInstance.outOfStocklabel {
      if model.availableForSale == true {
        self.outOfStock.isHidden=true
      }
      else {
        self.outOfStock.isHidden=false
      }
    }
    else {
      self.outOfStock.isHidden=true
    }
  }

  func calCulatePrice(_ model:ProductListViewModel) -> NSMutableAttributedString?{
    let price = NSMutableAttributedString()
      let attr1 = [NSAttributedString.Key.foregroundColor:UIColor.red,NSAttributedString.Key.font:mageFont.regularFont(size: 15.0)]
    
    if model.compareAtPrice != "false"{
      let attribute1 = NSAttributedString(string:  model.price, attributes: attr1  as [NSAttributedString.Key : Any])
      price.append(attribute1)
      
        let attr = [NSAttributedString.Key.strikethroughStyle:1,NSAttributedString.Key.font:mageFont.regularFont(size: 14.0),NSAttributedString.Key.foregroundColor:UIColor.black] as [NSAttributedString.Key : Any]
      price.append(NSAttributedString(string: " "))
      let attribute = NSAttributedString(string:  model.compareAtPrice, attributes: attr)
      price.append(attribute)
      
      let minusPrice = ((model.variants.items.first?.compareAtPrice ?? 0.0)-(model.variants.items.first?.price ?? 0.0))
      //let averagePrice = (((model.variants.items.first?.compareAtPrice ?? 0.0)+(model.variants.items.first?.price ?? 0.0))/2)
      let percentage = ((minusPrice/(model.variants.items.first?.compareAtPrice ?? 0.0))*100)
      let val = String(format: "%.0f", Double(truncating : percentage as? NSNumber ?? 0))
        let offerString: NSMutableAttributedString =  NSMutableAttributedString(string: "(\(val)% "+"OFF".localized+")")
      offerString.addAttribute(NSAttributedString.Key.foregroundColor,value: UIColor.systemGreen, range: NSMakeRange(0, offerString.length))
      price.append(NSMutableAttributedString(string : "  "))
      price.append(offerString)
      return price
    }
    else {
        let attr = [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:mageFont.regularFont(size: 14.0)] as [NSAttributedString.Key : Any]
      let attribute = NSAttributedString(string:  model.price, attributes: attr  as [NSAttributedString.Key : Any])
      price.append(attribute)
      return price
    }
  }
}
