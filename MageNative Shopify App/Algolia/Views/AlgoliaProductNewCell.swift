//
//  AlgoliaProductNewCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 22/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
class AlgoliaProductNewCell : UICollectionViewCell {
   
    
    var isGridView = true
    var productHeadingColor = UIColor(hexString: "#050505")
    var productSubheadingColor = UIColor(hexString: "#6B6B6B")
    var secondaryColor = UIColor(hexString: "#383838")
    var priceColor = UIColor.black;
    var specialPriceColor = UIColor.red;
    var itemTitleColor = UIColor.black;
    var specialPriceHide = false;
    var priceFont = mageFont.regularFont(size: 14.0)
    var specialPriceFont = mageFont.regularFont(size: 14.0)
    var itemNameFont = mageFont.regularFont(size: 15.0)
    var delegate:algoliaWishlistDelegate?
  
    lazy var outerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var productImage : UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    
    lazy var productHeading : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.mediumFont(size: 12.0)
        label.textColor = productHeadingColor
        label.numberOfLines = 1
        return label
    }()
    
    
   
    
    lazy var productPrice : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var wishlistButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "wishlist-image"), for: .normal)
        button.addTarget(self, action: #selector(addItemToWishList(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var shareButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "icons8-share-25"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .black
        return button
    }()
    
    lazy var addToCartButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "union"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = secondaryColor
        return button
    }()
    
    lazy var outOfStockLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Out of Stock".localized
        label.textAlignment = .center
        label.font = mageFont.mediumFont(size: 12.0)
        label.backgroundColor = UIColor(hexString: "#F55353").withAlphaComponent(0.7)
        label.textColor = UIColor.white
        label.layer.maskedCorners = Client.locale == "ar" ? [.layerMinXMinYCorner] : [.layerMaxXMinYCorner]
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        addSubview(outerView)
        outerView.anchor(top: topAnchor, left: leadingAnchor, bottom: bottomAnchor, right: trailingAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4)
        addSubview(productImage)
        productImage.anchor(top: outerView.topAnchor, left: outerView.leadingAnchor,  right: outerView.trailingAnchor, paddingTop: 4, paddingLeft: 4, paddingRight: 4)
//        NSLayoutConstraint(item: productImage, attribute: .height, relatedBy: .equal, toItem: outerView, attribute: .height, multiplier: 0.65, constant: 0.0).isActive = true
        addSubview(productHeading)
        addSubview(productPrice)
        addSubview(addToCartButton)
        addSubview(shareButton)
        addToCartButton.anchor(top: shareButton.bottomAnchor, right: outerView.trailingAnchor, paddingTop: 4, paddingRight: 8, width: 30, height: 30)
        productHeading.anchor(top: productImage.bottomAnchor, left: outerView.leadingAnchor, right: addToCartButton.leadingAnchor, paddingTop: 0, paddingLeft: 4, paddingRight: 4, height: 35)
        
        productPrice.anchor(top: productHeading.bottomAnchor, left: outerView.leadingAnchor, bottom: outerView.bottomAnchor, right: outerView.trailingAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 2, paddingRight: 4, height : 30)
        addSubview(wishlistButton)
        wishlistButton.anchor(top: productImage.topAnchor, right: productImage.trailingAnchor, paddingTop: 8, paddingRight: 8, width: 30, height: 30)
        
        shareButton.anchor(bottom: productImage.bottomAnchor, right: productImage.trailingAnchor, paddingBottom: -12, paddingRight: 8, width: 30, height: 30)
        addSubview(outOfStockLabel)
        outOfStockLabel.anchor(left: productImage.leadingAnchor, bottom: productImage.bottomAnchor, paddingLeft: 0, paddingBottom: 0, width: 100, height: 30)
        
        if customAppSettings.sharedInstance.inAppWishlist {
          self.wishlistButton.isHidden = false;
        }
        else {
            self.wishlistButton.isHidden = true;
        }
        
        if customAppSettings.sharedInstance.productShare {
            if isGridView {
                self.shareButton.isHidden = true
            }
            else {
                self.shareButton.isHidden = false
            }
        }
        else {
            self.shareButton.isHidden = true
        }
        
        if customAppSettings.sharedInstance.inAppAddToCart {
            self.addToCartButton.isHidden = false
        }
        else {
            self.addToCartButton.isHidden = true
        }
        
        if customAppSettings.sharedInstance.outOfStocklabel {
            self.outOfStockLabel.isHidden = false
        }
        else {
            self.outOfStockLabel.isHidden = true
        }
        
        
    }
    
    @objc func addItemToWishList(_ sender:UIButton){
      self.delegate?.addToWishListProduct(self, didAddToWishList: sender)
    }
    
    func setupView(product: [String:String]){
        
        productPrice.numberOfLines = 0
        productHeading.numberOfLines = 2
        if customAppSettings.sharedInstance.inAppWishlist {
          self.wishlistButton.isHidden = false;
        }
        if customAppSettings.sharedInstance.inAppAddToCart {
          if self.addToCartButton != nil {
            self.addToCartButton.isHidden = false;
          }
        }
        
        
       
        print(product)
        if(product["image"] != ""){
            productImage.setImageFrom(URL(string: product["image"]!))
        }
        
        productHeading.text = product["title"]!
        productPrice.attributedText =  self.calCulatePrice(productPrice: product["price"]!, compareAtPrice: product["compareAtPrice"]!)
        if self.outOfStockLabel != nil {
           if product["inventoryAvailable"] == "true"{
             self.outOfStockLabel.isHidden=true
           }
           else {
             self.outOfStockLabel.isHidden=false
           }
         }
        if let wishlistProducts = DBManager.shared.wishlistProducts{
            if wishlistProducts.contains(where: {$0.variant.id == product["variantId"]!}){
                wishlistButton.setImage(#imageLiteral(resourceName: "heartFilled"), for: .normal)
            }
            else {
                wishlistButton.setImage(#imageLiteral(resourceName: "heartEmpty"), for: .normal)
            }
        }
        
    }
    
    func calCulatePrice(productPrice: String, compareAtPrice: String) -> NSMutableAttributedString?{
        let symbol = Currencies.currency(for: CurrencyCode.shared.getCurrencyCode())!.shortestSymbol
      let price = NSMutableAttributedString()
        let attr1 = [NSAttributedString.Key.foregroundColor:specialPriceColor,NSAttributedString.Key.font:specialPriceFont]
      
        if compareAtPrice != "0.0" && specialPriceHide == false{
          let attribute1 = NSAttributedString(string:  symbol+productPrice, attributes: attr1  as [NSAttributedString.Key : Any])
          price.append(attribute1)
          
            let attr = [NSAttributedString.Key.strikethroughStyle:1,NSAttributedString.Key.font: priceFont,NSAttributedString.Key.foregroundColor:priceColor] as [NSAttributedString.Key : Any]
          price.append(NSAttributedString(string: " "))
          let attribute = NSAttributedString(string:  symbol+compareAtPrice, attributes: attr)
          price.append(attribute)
            let minusPrice = ((Decimal(string: compareAtPrice) ?? 0.0)-(Decimal(string: productPrice) ?? 0.0))
          //let averagePrice = (((model.variants.items.first?.compareAtPrice ?? 0.0)+(model.variants.items.first?.price ?? 0.0))/2)
            let percentage = ((minusPrice/(Decimal(string: compareAtPrice) ?? 0.0))*100)
            let val = String(format: "%.0f", Double(truncating : percentage as? NSNumber ?? 0))
            let offerString: NSMutableAttributedString =  NSMutableAttributedString(string: "(\(val)% "+"OFF".localized+")")
          offerString.addAttribute(NSAttributedString.Key.foregroundColor,value: UIColor.systemGreen, range: NSMakeRange(0, offerString.length))
          price.append(NSMutableAttributedString(string : "  "))
          price.append(offerString)
          return price
        }
        else {
            let attr = [NSAttributedString.Key.foregroundColor:priceColor,NSAttributedString.Key.font:priceFont]
          let attribute = NSAttributedString(string:  symbol+productPrice, attributes: attr  as [NSAttributedString.Key : Any])
          price.append(attribute)
          return price
        }
    }
    
    
    
}
protocol algoliaWishlistDelegate {
  func addToWishListProduct(_ cell: AlgoliaProductNewCell, didAddToWishList sender: Any)
}
