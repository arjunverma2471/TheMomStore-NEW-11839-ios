//
//  FastSimonProductPageCVCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 14/07/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit


class FastSimonProductPageCVCell : UICollectionViewCell {
    
    var headingColor    = UIColor(hexString: "#050505")
    var subHeadingColor = UIColor(hexString: "#6B6B6B")
    
    lazy var outerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.cardView()
        view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    lazy var productImage : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var productHeading : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.mediumFont(size: 14.0)
        label.numberOfLines = 1
        label.textColor = headingColor
        return label
    }()
    
    lazy var productSubHeading : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.mediumFont(size: 12.0)
        label.textColor = subHeadingColor
        label.numberOfLines = 0
        return label
    }()
    
    lazy var productPrice : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.mediumFont(size: 12.0)
        label.textColor = subHeadingColor
        label.numberOfLines = 0
        return label
    }()
    
    lazy var wishlistButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "wishlist-image"), for: .normal)
        button.isHidden = false
        
        return button
    }()
    
    lazy var addToCartButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "bag"), for: .normal)
        button.isHidden = false
        return button
    }()
    
    
    var product : ProductViewModel!
    var parent=ProductVC()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initView() {
        let height = self.bounds.height
        addSubview(outerView)
        addSubview(productImage)
        addSubview(productHeading)
        addSubview(productSubHeading)
        addSubview(productPrice)
       // addSubview(wishlistButton)
       // addSubview(addToCartButton)
        outerView.anchor(top: safeAreaLayoutGuide.topAnchor, left: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        //wishlistButton.anchor(top: outerView.topAnchor, right: trailingAnchor, paddingTop: 8, paddingRight: 8, width: 30, height: 30)
        
        productImage.anchor(top: outerView.topAnchor, left: leadingAnchor,right: trailingAnchor, paddingTop: 4, paddingLeft: 4, paddingRight: 4, height : (height*0.65))
        productHeading.anchor(top: productImage.bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 0, paddingLeft: 4, paddingRight: 4)
        productSubHeading.anchor(top: productHeading.bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 0, paddingLeft: 4, paddingRight: 4)
        productPrice.anchor(top: productSubHeading.bottomAnchor, left: leadingAnchor, bottom: outerView.bottomAnchor, right: trailingAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 4, paddingRight: 4)
        
       
        //addToCartButton.anchor(bottom: outerView.bottomAnchor, right: trailingAnchor, paddingBottom: 8, paddingRight: 8, width: 30, height: 30)
        
      //  wishlistButton.addTarget(self, action: #selector(addProductToWishlist(_:)), for: .touchUpInside)
      //  addToCartButton.addTarget(self, action: #selector(addToCart(_:)), for: .touchUpInside)
    }
    
    func setupView(model:ProductViewModel) {
        productImage.setImageFrom(model.images.items.first?.url)
       // productImage.contentMode = .scaleAspectFill
        productHeading.text = model.vendor
        productSubHeading.text = model.title
        productPrice.attributedText = self.calculatePrice(model: model)
        //product = model
        //self.reloadView()
    }

    func reloadView() {
        print("load first time")
       
        let product = CartProduct(product: self.product, variant: WishlistManager.shared.getVariant(self.product.variants.items.first!))
        if WishlistManager.shared.isProductVariantinWishlist(product: product) {
            wishlistButton.setImage(UIImage(named: "wishlist-filledImage"), for: .normal)
        }
        else {
            wishlistButton.setImage(UIImage(named: "wishlist-image"), for: .normal)
        }
    }
    func calculatePrice(model:ProductViewModel) -> NSMutableAttributedString {
        let finalString = NSMutableAttributedString()
        let compareAtPrice = model.variants.items.first?.compareAtPrice == nil ? "false" : ( (model.variants.items.first?.price)! < (model.variants.items.first?.compareAtPrice!)! ? Currency.stringFrom((model.variants.items.first?.compareAtPrice!)!) : "false" )
        let priceAttr = [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:mageFont.mediumFont(size: 14.0)]
        if  compareAtPrice != "false"
        {
            let attribute1 = NSAttributedString(string:  model.price, attributes: priceAttr  as [NSAttributedString.Key : Any])
            finalString.append(attribute1)
            let attr = [NSAttributedString.Key.strikethroughStyle:1,NSAttributedString.Key.font: mageFont.mediumFont(size: 12.0 ),NSAttributedString.Key.foregroundColor:UIColor.darkGray] as [NSAttributedString.Key : Any]
            finalString.append(NSAttributedString(string: " "))
            let attribute = NSAttributedString(string:  model.compareAtPrice, attributes: attr)
            finalString.append(attribute)
            let minusPrice = ((model.variants.items.first?.compareAtPrice ?? 0.0)-(model.variants.items.first?.price ?? 0.0))
            let percentage = ((minusPrice/(model.variants.items.first?.compareAtPrice ?? 0.0))*100)
            let val = String(format: "%.0f", Double(truncating : percentage as? NSNumber ?? 0))
            let offerString: NSMutableAttributedString =  NSMutableAttributedString(string: "(\(val)% "+"OFF".localized+")")
            offerString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor(hexString: "#28A138"), NSAttributedString.Key.font : mageFont.mediumFont(size: 12.0)], range: NSMakeRange(0, offerString.length))
            finalString.append(NSMutableAttributedString(string : " "))
            finalString.append(offerString)
        }
        else {
          let attr = [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:mageFont.mediumFont(size: 14.0)]
          let attribute = NSAttributedString(string:  model.price, attributes: attr  as [NSAttributedString.Key : Any])
          finalString.append(attribute)
          return finalString
        }
        return finalString
       
    }
    @objc func addProductToWishlist(_ sender : UIButton) {
        print("Add to WISHLIST")
        let product = CartProduct(product: self.product, variant: WishlistManager.shared.getVariant(self.product.variants.items.first!))
        if WishlistManager.shared.isProductVariantinWishlist(product: product) {
            WishlistManager.shared.removeFromWishList(product)
            wishlistButton.setImage(UIImage(named: "wishlist-image"), for: .normal)
        }
        else {
            WishlistManager.shared.addToWishList(product)
            if product.variant.title == "Default Title" {
                let msg = "You have added ".localized + self.product.title + " to your wishlist.".localized
                self.showmsg(msg: msg)
            }
            else {
                let msg = "You have added ".localized + product.variant.title + " of product ".localized + self.product.title + " to your wishlist.".localized
                self.showmsg(msg: msg)
            }
            
          wishlistButton.setImage(UIImage(named: "wishlist-filledImage"), for: .normal)
        }

        self.parent.setupTabbarCount()
    }
    
    @objc func addToCart(_ sender : UIButton) {
        print("Add to CART")
        print("product id ===> ", self.product.id)
        print("poduct title ==> ", self.product.title)
        let item = CartProduct(product: product, variant: WishlistManager.shared.getVariant(self.product.variants.items.first!), quantity: 1)
        CartManager.shared.addToCart(item)
        self.showmsg(msg: product.title + " Added to cart".localized)
        self.parent.setupTabbarCount()
    }
}

