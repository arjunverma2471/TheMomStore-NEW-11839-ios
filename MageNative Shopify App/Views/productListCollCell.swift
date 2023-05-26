//
//  productListCollCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 22/04/21.
//  Copyright © 2021 MageNative. All rights reserved.
//
/*
import UIKit


class productListCollCell: UICollectionViewCell {
  
  @IBOutlet weak var moreButton: UIButton!
  @IBOutlet weak var outerView: UIView!
  @IBOutlet weak var productImage: UIImageView!
  @IBOutlet weak var productPrice: UILabel!
  @IBOutlet weak var productName: UILabel!
  @IBOutlet weak var addToCart: UIButton!
  @IBOutlet weak var productDesc: UILabel!  
  @IBOutlet weak var outOfStockLabel: UILabel!
  
  
  var priceFont = mageFont.regularFont(size: 14.0)
  var specialPriceFont = mageFont.regularFont(size: 14.0)
    var itemNameFont = mageFont.regularFont(size: 15.0)
  var priceColor = UIColor.red;
  var specialPriceColor = UIColor.black;
  var itemTitleColor = UIColor.black;
  var specialPriceHide = false;
  var gridCellCheck = false
   
  
  @IBOutlet weak var imgOuterView: UIView!
  
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    productPrice.numberOfLines = 0
    productName.numberOfLines = 2
    productDesc.numberOfLines = 2
//    imgOuterView.layer.cornerRadius = imgOuterView.frame.width/2
//    productImage.layer.cornerRadius = productImage.frame.width/2
    if customAppSettings.sharedInstance.inAppAddToCart {
      self.addToCart.isHidden = false;
    }
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          self.contentView.setTemplateWithSubviews(false)
      }
  }
  
  func setupView(_ model:ProductViewModel){
    productName?.text = model.title
      productName.font = itemNameFont
    productName.textColor = itemTitleColor
    productDesc.text = model.summary.htmlToString
      productDesc.font = itemNameFont
    productPrice.attributedText =  self.calCulatePrice(model)
    productImage.setImageFrom(model.images.items.first?.url)
    productImage.contentMode = .scaleToFill
    
    if self.outOfStockLabel != nil {
      if model.availableForSale {
        self.outOfStockLabel.isHidden=true
      }
      else {
        self.outOfStockLabel.isHidden=false
      }
    }
  }
  
  func calCulatePrice(_ model:ProductViewModel) -> NSMutableAttributedString?{
    let price = NSMutableAttributedString()
      let attr1 = [NSAttributedString.Key.foregroundColor:specialPriceColor,NSAttributedString.Key.font:specialPriceFont]
    if(gridCellCheck){
      //let specialPrice = model.variants.items.first?.compareAtPrice
      let compareAtPrice = model.variants.items.first?.compareAtPrice == nil ? "false" : ( (model.variants.items.first?.price)! < (model.variants.items.first?.compareAtPrice!)! ? Currency.stringFrom((model.variants.items.first?.compareAtPrice!)!) : "false" )
      if  compareAtPrice != "false" && specialPriceHide == false{
        let attribute1 = NSAttributedString(string:  model.price, attributes: attr1  as [NSAttributedString.Key : Any])
        price.append(attribute1)
        
          let attr = [NSAttributedString.Key.strikethroughStyle:1,NSAttributedString.Key.font: priceFont,NSAttributedString.Key.foregroundColor:priceColor] as [NSAttributedString.Key : Any]
        price.append(NSAttributedString(string: " "))
        let attribute = NSAttributedString(string:  compareAtPrice, attributes: attr)
        price.append(attribute)
        return price
      }
      else {
          let attr = [NSAttributedString.Key.foregroundColor:priceColor,NSAttributedString.Key.font:priceFont]
        let attribute = NSAttributedString(string:  model.price, attributes: attr  as [NSAttributedString.Key : Any])
        price.append(attribute)
        return price
      }
    }
    else{
      if model.compareAtPrice != "false" && specialPriceHide == false{
        let attribute1 = NSAttributedString(string:  model.price, attributes: attr1  as [NSAttributedString.Key : Any])
        price.append(attribute1)
        
          let attr = [NSAttributedString.Key.strikethroughStyle:1,NSAttributedString.Key.font: priceFont,NSAttributedString.Key.foregroundColor:priceColor] as [NSAttributedString.Key : Any]
        price.append(NSAttributedString(string: " "))
        let attribute = NSAttributedString(string:  model.compareAtPrice, attributes: attr)
        price.append(attribute)
        
        return price
        
      }else {
          let attr = [NSAttributedString.Key.foregroundColor:priceColor,NSAttributedString.Key.font:priceFont]
        let attribute = NSAttributedString(string:  model.price, attributes: attr  as [NSAttributedString.Key : Any])
        price.append(attribute)
        return price
      }
    }
  }
}

*/
