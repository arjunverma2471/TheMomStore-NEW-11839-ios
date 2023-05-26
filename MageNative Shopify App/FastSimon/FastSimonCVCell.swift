//
//  FastSimonCVCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 13/07/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit



class FastSimonCVCell : UICollectionViewCell {
  
  var specialPriceHide = false;
  //    var delegate:wishListProductDelegate?
  var isGridView = true
  var productHeadingColor = UIColor(hexString: "#050505")
  var productSubheadingColor = UIColor(hexString: "#6B6B6B")
  var secondaryColor = UIColor(hexString: "#383838")
  
  lazy var outerView : UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.translatesAutoresizingMaskIntoConstraints = false
    view.cardView()
    view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
    view.layer.borderWidth = 0.5
    return view
  }()
  
  lazy var productImage : UIImageView = {
    let imgView = UIImageView()
    // imgView.contentMode = .scaleToFill
    imgView.clipsToBounds = true
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
  
  
  lazy var productSubheading : UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = mageFont.regularFont(size: 10.0)
    label.textColor = productSubheadingColor
    label.numberOfLines = 0
    return label
  }()
  
  lazy var productPrice : UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 2
    return label
  }()
  
  lazy var wishlistButton : UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(named: "wishlist-image"), for: .normal)
    //        button.addTarget(self, action: #selector(addItemToWishList(_:)), for: .touchUpInside)
      button.backgroundColor = UIColor.viewBackgroundColor()
      button.layer.cornerRadius = 15
      button.layer.borderWidth = 0.8
     button.layer.borderColor = UIColor(hexString: "#d1d1d1", alpha: 1).cgColor
    return button
  }()
  
  lazy var shareButton : UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(named: "productShare"), for: .normal)
    return button
  }()
  
  lazy var addToCartButton : UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(named: "bag"), for: .normal)
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
  
  var priceColor = UIColor.black;
  var specialPriceFont = mageFont.regularFont(size: 14.0)
  var specialPriceColor = UIColor.red;
  var priceFont = mageFont.regularFont(size: 14.0)
    var delegate:wishListProductDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  func initView() {
    let screenWidth = self.frame.width
    addSubview(outerView)
    outerView.anchor(top: topAnchor, left: leadingAnchor, bottom: bottomAnchor, right: trailingAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4)
    addSubview(productImage)
    productImage.anchor(top: outerView.topAnchor, left: outerView.leadingAnchor,  right: outerView.trailingAnchor, paddingTop: 4, paddingLeft: 4, paddingRight: 4)
    addSubview(productHeading)
    addSubview(productSubheading)
    addSubview(productPrice)
    addSubview(addToCartButton)
    addSubview(shareButton)
    addToCartButton.anchor(top: productImage.bottomAnchor, right: outerView.trailingAnchor, paddingTop: 4, paddingRight: 8, width: 30, height: 30)
    productHeading.anchor(top: productImage.bottomAnchor, left: outerView.leadingAnchor, right: addToCartButton.leadingAnchor, paddingTop: 0, paddingLeft: 4, paddingRight: 4, height: 35)
    productSubheading.anchor(top: productHeading.bottomAnchor, left: outerView.leadingAnchor, right: outerView.trailingAnchor, paddingTop: 0, paddingLeft: 4, paddingRight: 4, height: 35)
    productPrice.anchor(top: productSubheading.bottomAnchor, left: outerView.leadingAnchor, bottom: outerView.bottomAnchor, right: outerView.trailingAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 2, paddingRight: 4, height : 40)
    addSubview(wishlistButton)
    wishlistButton.anchor(top: productImage.topAnchor, right: productImage.trailingAnchor, paddingTop: 8, paddingRight: 8, width: 30, height: 30)
    
    shareButton.anchor(bottom: productImage.bottomAnchor, right: productImage.trailingAnchor, paddingBottom: 4, paddingRight: 8, width: 30, height: 30)
    
    
    addSubview(outOfStockLabel)
    outOfStockLabel.anchor(left: productImage.leadingAnchor, bottom: productImage.bottomAnchor, paddingLeft: 0, paddingBottom: 0, width: (0.75*screenWidth), height: 30)
    
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
  
      func setupView(model:ProductViewModel) {
          productImage.setImageFrom(model.images.items.first?.url)
          productHeading.text = model.title
          if model.summary.htmlToString != "" {
              productSubheading.text = model.summary.htmlToString
              productSubheading.numberOfLines = 2
          }
          else {
              productSubheading.text = ""
              productSubheading.numberOfLines = 0
          }
          if isGridView {
              productHeading.font = mageFont.mediumFont(size: 12.0)
              productSubheading.font = mageFont.mediumFont(size: 10.0)
          }
          else {
              productHeading.font = mageFont.mediumFont(size: 14.0)
              productSubheading.font = mageFont.mediumFont(size: 12.0)
          }
  
          productPrice.attributedText = self.calculatePrice(model: model)
          let wishProduct = CartProduct(product: model, variant: WishlistManager.shared.getVariant(model.variants.items.first!))
          if WishlistManager.shared.isProductVariantinWishlist(product: wishProduct){
              wishlistButton.setImage(UIImage(named: "wishlist-filledImage"), for: .normal)
          }
          else {
              wishlistButton.setImage(UIImage(named: "wishlist-image"), for: .normal)
          }
          if model.availableForSale {
            self.outOfStockLabel.isHidden=true
              productImage.alpha = 1.0
              self.addToCartButton.isHidden = false
          }
          else {
            self.outOfStockLabel.isHidden=false
              productImage.alpha = 0.4
              self.addToCartButton.isHidden = true
          }
  
      }
  
      @objc func addItemToWishList(_ sender : UIButton) {
        //  self.delegate?.addToWishListProduct(self, didAddToWishList: sender)
      }
    
    func calculatePrice(model:ProductViewModel) -> NSMutableAttributedString {
        let finalString = NSMutableAttributedString()
        let compareAtPrice = model.variants.items.first?.compareAtPrice == nil ? "false" : ( (model.variants.items.first?.price)! < (model.variants.items.first?.compareAtPrice!)! ? Currency.stringFrom((model.variants.items.first?.compareAtPrice!)!) : "false" )
        let priceAttr = [NSAttributedString.Key.foregroundColor:UIColor(light: .black, dark: UIColor.provideColor(type: .productGridCollectionCell).priceColor),NSAttributedString.Key.font:mageFont.mediumFont(size: 14.0)]
        if  compareAtPrice != "false" && specialPriceHide == false
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
            offerString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor(hexString: "#28A138"), NSAttributedString.Key.font : mageFont.regularFont(size: 10.0)], range: NSMakeRange(0, offerString.length))
            finalString.append(NSMutableAttributedString(string : " "))
            finalString.append(offerString)
            
        }
        else {
            let attr = [NSAttributedString.Key.foregroundColor:UIColor(light: .black, dark: UIColor.provideColor(type: .productGridCollectionCell).priceColor),NSAttributedString.Key.font:mageFont.mediumFont(size: 14.0)]
          let attribute = NSAttributedString(string:  model.price, attributes: attr  as [NSAttributedString.Key : Any])
          finalString.append(attribute)
            
          return finalString
        }
        return finalString
       
    }
  
  
  
/*  func setupView(model: Item){
    productImage.setImageFrom(URL(string: model.t ?? ""))
    productHeading.text = model.l
    productSubheading.numberOfLines = 2
    productSubheading.text = model.d
    
    if isGridView {
      productHeading.font = mageFont.mediumFont(size: 12.0)
      productSubheading.font = mageFont.mediumFont(size: 10.0)
    }
    else {
      productHeading.font = mageFont.mediumFont(size: 14.0)
      productSubheading.font = mageFont.mediumFont(size: 12.0)
    }
//    productPrice.text = model.p ?? ""
    productPrice.attributedText = calCulatePrice(productPrice: model.p ?? "", compareAtPrice: model.pC ?? "0.00")
  }  */
  
  
  func setupViewForBoostCommerceProduct(model: Product){
    productImage.setImageFrom(URL(string: model.images?["1"] ?? ""))
    productHeading.text = model.title
    productSubheading.numberOfLines = 2
    productSubheading.text = model.bodyHTML
    
    if isGridView {
      productHeading.font = mageFont.mediumFont(size: 12.0)
      productSubheading.font = mageFont.mediumFont(size: 10.0)
    }
    else {
      productHeading.font = mageFont.mediumFont(size: 14.0)
      productSubheading.font = mageFont.mediumFont(size: 12.0)
    }
//    productPrice.text = model.p ?? ""
//    productPrice.attributedText = calCulatePrice(productPrice: model.priceMax ?? "", compareAtPrice: model.compareAtPriceMin?.description ?? "0.00")
  }
  
  func calCulatePrice(productPrice: String, compareAtPrice: String) -> NSMutableAttributedString?{
      let symbol = Currencies.currency(for: CurrencyCode.shared.getCurrencyCode())!.shortestSymbol
    let price = NSMutableAttributedString()
      let attr1 = [NSAttributedString.Key.foregroundColor:specialPriceColor,NSAttributedString.Key.font:specialPriceFont]
    
      if compareAtPrice != "0.00" && specialPriceHide == false{
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

