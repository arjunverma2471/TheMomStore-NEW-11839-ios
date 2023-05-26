//
//  SimilarProductsSliderCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 03/06/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import UIKit

protocol similarWishlistDelegate {
    func addToWishListProduct(_ cell: SimilarProductsSliderCell, didAddToWishList sender: Any)
}

class SimilarProductsSliderCell: UICollectionViewCell {
    
    @IBOutlet weak var addToWishList: UIButton!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var addToCart: UIButton!
    @IBOutlet weak var bottomWishlist: UIButton!
    
    var priceFont = mageFont.regularFont(size: 12.0)
    var specialPriceFont = mageFont.regularFont(size: 12.0)
    var itemNameFont = mageFont.regularFont(size: 13.0)
    var priceColor = UIColor(light: .black,dark: UIColor.provideColor(type: .cartVc).textColor)
    var specialPriceColor = UIColor.red;
    var itemTitleColor = UIColor(light: .black,dark: UIColor.provideColor(type: .cartVc).textColor)
    var specialPriceHide = false;
    var delegate:similarWishlistDelegate?
    
    var shimmeringAnimatedItems: [UIView] {
            [
                addToWishList,
                productName,
                productImage,
                productPrice,
                addToCart
            ]
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addToWishList.addTarget(self, action: #selector(self.addItemToWishList(_:)), for: .touchUpInside)
        bottomWishlist.addTarget(self, action: #selector(self.addItemToWishList(_:)), for: .touchUpInside)
        productPrice.numberOfLines = 0
        productName.numberOfLines = 2
       
    }
    
    func setupView(_ model:ProductViewModel)
    {
        if customAppSettings.sharedInstance.inAppWishlist {
            self.addToWishList.isHidden = false;
        }
        
        
        if customAppSettings.sharedInstance.inAppAddToCart {
            if self.addToCart != nil {
                self.addToCart.isHidden = false;
                if bottomWishlist != nil {
                    self.addToWishList.isHidden = true;
                    self.bottomWishlist.isHidden = false;
                }
            }
        }
        model.id
        productName?.text = model.title
        productName.font = itemNameFont
        productName.textColor = itemTitleColor
        
        productPrice.attributedText =  self.calCulatePrice(model)
        productImage.setImageFrom(model.images.items.first?.url)
        let wishProduct = CartProduct(product: model, variant: WishlistManager.shared.getVariant(model.variants.items.first!))
        if WishlistManager.shared.isProductVariantinWishlist(product: wishProduct) {
            addToWishList.setImage(#imageLiteral(resourceName: "heartFilled"), for: .normal)
            if bottomWishlist != nil {
                bottomWishlist.setImage(#imageLiteral(resourceName: "heartFilled"), for: .normal)
            }
        }
        else {
            addToWishList.setImage(#imageLiteral(resourceName: "heartEmpty"), for: .normal)
            if bottomWishlist != nil {
                bottomWishlist.setImage(#imageLiteral(resourceName: "heartEmpty"), for: .normal)
            }
        }
    }
    
    @objc func addItemToWishList(_ sender:UIButton){
        self.delegate?.addToWishListProduct(self, didAddToWishList: sender)
    }
    
    func calCulatePrice(_ model:ProductViewModel) -> NSMutableAttributedString?{
        let price = NSMutableAttributedString()
        let attr1 = [NSAttributedString.Key.foregroundColor:specialPriceColor,NSAttributedString.Key.font:specialPriceFont]
        
        if model.compareAtPrice != "false" && specialPriceHide == false{
            let attribute1 = NSAttributedString(string:  model.price, attributes: attr1  as [NSAttributedString.Key : Any])
            price.append(attribute1)
            
            let attr = [NSAttributedString.Key.strikethroughStyle:1,NSAttributedString.Key.font: priceFont,NSAttributedString.Key.foregroundColor:priceColor] as [NSAttributedString.Key : Any]
            price.append(NSAttributedString(string: " "))
            let attribute = NSAttributedString(string:  model.compareAtPrice, attributes: attr)
            price.append(attribute)
            
            let minusPrice = ((model.variants.items.first?.compareAtPrice ?? 0.0)-(model.variants.items.first?.price ?? 0.0))
            let percentage = ((minusPrice/(model.variants.items.first?.compareAtPrice ?? 0.0))*100)
            let val = String(format: "%.0f", Double(truncating : percentage as NSNumber))
            let offerString: NSMutableAttributedString =  NSMutableAttributedString(string: "(\(val)% "+"OFF".localized+")")
            offerString.addAttribute(NSAttributedString.Key.foregroundColor,value: UIColor.systemGreen, range: NSMakeRange(0, offerString.length))
            price.append(NSMutableAttributedString(string : "  "))
            price.append(offerString)
            return price
        }
        else {
            let attr = [NSAttributedString.Key.foregroundColor:priceColor,NSAttributedString.Key.font:priceFont]
            let attribute = NSAttributedString(string:  model.price, attributes: attr  as [NSAttributedString.Key : Any])
            price.append(attribute)
            return price
        }
    }
}
