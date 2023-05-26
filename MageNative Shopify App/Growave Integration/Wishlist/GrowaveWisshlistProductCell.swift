//
//  GrowaveWisshlistProductCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 25/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import UIKit

class GrowaveWishlistProductCell: UICollectionViewCell {
    let reuseID = "GrowaveWishlistProductCell"
    var removeProduct: (()->())?
    var moveToDifferentBoard: (()->())?
    var addToBag: (()->())?
    var specialPriceHide = false;
    var isGridView = true
    var productHeadingColor = UIColor(hexString: "#050505")
    var productSubheadingColor = UIColor(hexString: "#6B6B6B")
    var secondaryColor = UIColor(hexString: "#383838")
    
    var selectedVariant: VariantViewModel!
    
    lazy var outerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(light: .white, dark: UIColor.provideColor(type: .productGridCollectionCell).backGroundColor)
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.cardView()
        //        view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        //        view.layer.borderWidth = 0.5
        return view
    }()
    
    lazy var productImage : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    
    lazy var productHeading : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.mediumFont(size: 12.0)
        label.textColor = UIColor(light: productHeadingColor,dark: UIColor.provideColor(type: .productGridCollectionCell).productHeadingColor)
        label.numberOfLines = 2
        return label
    }()
    
    
    lazy var productSubheading : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.regularFont(size: 10.0)
        label.textColor = UIColor(light: productSubheadingColor,dark: UIColor.provideColor(type: .productGridCollectionCell).productSubHeadingColor)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var productPrice : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    lazy var deleteButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "closeLight")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(removeItemToWishList(_:)), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.clipsToBounds = true
        //  button.backgroundColor = UIColor.viewBackgroundColor()
        //        button.layer.cornerRadius = 15
        //        button.layer.borderWidth = 0.8
        //       button.layer.borderColor = UIColor(hexString: "#d1d1d1", alpha: 1).cgColor
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
        button.setTitle("Add To Bag".localized, for: .normal)
        button.backgroundColor = UIColor.AppTheme()
        button.setTitleColor(UIColor.textColor(), for: .normal)
        button.layer.cornerRadius = 2
        button.titleLabel?.font = mageFont.regularFont(size: 14)
        button.clipsToBounds = true
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(addToBagTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var changeBoardButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(" Change Board ".localized, for: .normal)
        button.backgroundColor = UIColor.textColor()
        button.setTitleColor(UIColor.AppTheme(), for: .normal)
        button.layer.cornerRadius = 2
        button.titleLabel?.font = mageFont.regularFont(size: 14)
        button.clipsToBounds = true;
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(changeBoardButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var outOfStockLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Out of Stock".localized
        label.textAlignment = .center
        label.font = mageFont.regularFont(size: 14)
        label.textColor = UIColor(hexString: "#F88282")
        label.backgroundColor = UIColor(hexString: "#F0F0F0")
        label.layer.cornerRadius = 2
        label.clipsToBounds = true;
        label.isHidden = true
        return label
    }()
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImage.contentMode = .scaleAspectFit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        self.isMultipleTouchEnabled = true;
        backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .productGridCollectionCell).backGroundColor)
        
        addSubview(outerView)
        outerView.anchor(top: topAnchor, left: leadingAnchor, bottom: bottomAnchor, right: trailingAnchor, paddingTop: 0, paddingLeft: 2, paddingBottom: 0, paddingRight: 2)
        
        
        addSubview(productImage)
        addSubview(shareButton)
        addSubview(productPrice)
        addSubview(productHeading)
        addSubview(productSubheading)
        //        addSubview(shareButton)
        
        productImage.anchor(top: outerView.topAnchor, left: outerView.leadingAnchor,  right: outerView.trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0)
        
        shareButton.bottomAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 0).isActive = true
        shareButton.trailingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: -8).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        //      shareButton.anchor(right: outerView.trailingAnchor, paddingRight: 12, width: 30, height: 30)
        
        
        addSubview(deleteButton)
        deleteButton.anchor(top: productImage.topAnchor, right: productImage.trailingAnchor, paddingTop: 0, paddingRight: 10, width: 15, height: 15)
        
        //        shareButton.anchor(right: outerView.trailingAnchor, paddingRight: 12, width: 30, height: 30)
        //        shareButton.centerY(inView: productPrice)
        
        
        productSubheading.anchor(left: outerView.leadingAnchor,bottom: productPrice.topAnchor, right: outerView.trailingAnchor, paddingLeft: 4, paddingBottom: 0,paddingRight: 4,height: 20)
        
        
        
        //productPrice.anchor(top: productSubheading.bottomAnchor, left: outerView.leadingAnchor, right: outerView.trailingAnchor, paddingTop: 4, paddingLeft: 4, paddingRight: 4,height: 30)
        
        
        if(customAppSettings.sharedInstance.inAppAddToCart){
            addSubview(changeBoardButton)
            changeBoardButton.anchor(top: productPrice.bottomAnchor, left: outerView.leadingAnchor, bottom: outerView.bottomAnchor, right: outerView.centerXAnchor, paddingTop: 4, paddingLeft: 0, paddingRight: 4, height: 40)
            addSubview(addToCartButton)
            addToCartButton.anchor(top: productPrice.bottomAnchor, left: outerView.centerXAnchor, bottom: outerView.bottomAnchor, right: outerView.trailingAnchor, paddingTop: 4, paddingLeft: 4, paddingRight: 0, height: 35)
            addSubview(outOfStockLabel)
            outOfStockLabel.anchor(top: productPrice.bottomAnchor, left: outerView.leadingAnchor, bottom: outerView.bottomAnchor, right: outerView.trailingAnchor, paddingTop: 4, paddingBottom: 4, paddingRight: 0, height: 35)
            productPrice.anchor(left: outerView.leadingAnchor,  right: outerView.trailingAnchor,paddingLeft: 4,paddingRight: 4,height: 25)//, height: 30
            productHeading.anchor(top: productImage.bottomAnchor,left: outerView.leadingAnchor,bottom: productSubheading.topAnchor, right: outerView.trailingAnchor,paddingTop: 4,  paddingLeft: 4,paddingBottom: 4, paddingRight: 4,height: 20)
        }
        else{
            addSubview(outOfStockLabel)
            outOfStockLabel.anchor(left: outerView.leadingAnchor, bottom: productImage.bottomAnchor, right: outerView.trailingAnchor, paddingBottom: 4, paddingRight: 0, height: 35)
            productHeading.anchor(top: outOfStockLabel.bottomAnchor,left: outerView.leadingAnchor,bottom: productSubheading.topAnchor, right: outerView.trailingAnchor,paddingTop: 4,  paddingLeft: 4,paddingBottom: 4, paddingRight: 4,height: 20)
            productPrice.anchor(top: productSubheading.bottomAnchor, left: outerView.leadingAnchor, bottom: outerView.bottomAnchor,right: outerView.trailingAnchor,  paddingTop: 4, paddingLeft: 4, paddingBottom: 4,paddingRight: 4,height: 25)//, height: 30
        }
        
        //        if customAppSettings.sharedInstance.inAppAddToCart {
        //            self.addToCartButton.isHidden = false
        //        }
        //        else {
        //            self.addToCartButton.isHidden = true
        //        }
        
        
        
        if customAppSettings.sharedInstance.outOfStocklabel {
//            self.outOfStockLabel.isHidden = false
        }
        else {
            self.outOfStockLabel.isHidden = true
        }
    }
    
    func setupView(model:ProductViewModel) {
        if model.sellingPlansGroups.items.count > 0 {
            addToCartButton.setTitle("Subscribe".localized, for: .normal)
        }else{
            addToCartButton.setTitle("Add To Bag".localized, for: .normal)
        }
        
        
        
        
        productImage.sd_setImage(with: model.images.items.first?.url)
        
        selectedVariant = model.variants.items.first
        
        productHeading.text = model.title
        if customAppSettings.sharedInstance.inAppWishlist {
            self.deleteButton.isHidden = false;
        }
        else {
            self.deleteButton.isHidden = true;
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
        
        
        //        if model.model?.description != "" {
        //            productSubheading.text = model.model?.description ?? ""
        //            productSubheading.numberOfLines = 1
        //        }
        //        else {
        //            productSubheading.text = ""
        //            productSubheading.numberOfLines = 0
        //        }
        
        productHeading.font = mageFont.mediumFont(size: 14.0)
        productSubheading.font = mageFont.regularFont(size: 12.0)
        
        
        productPrice.attributedText = self.calculatePrice(model: model)
        let wishProduct = CartProduct(product: model, variant: WishlistManager.shared.getVariant(model.variants.items.first!))
        
        if customAppSettings.sharedInstance.outOfStocklabel {
            
            //                   if !self.selectedVariant.currentlyNotInStock {
            //                              if self.selectedVariant.availableQuantity != "" {
            //                                  // || self.selectedVariant.availableQuantity.hasPrefix("-")
            //                                  if self.selectedVariant.availableQuantity == "0" &&  !self.selectedVariant.availableForSale{
            //                                      self.outOfStockLabel.isHidden=false
            //                                        productImage.alpha = 0.4
            //                                        if(customAppSettings.sharedInstance.inAppAddToCart){
            //                                            self.addToCartButton.isHidden = true
            //                                        }
            //                                  }
            //                                  else {
            //                                      self.outOfStockLabel.isHidden=true
            //                                        productImage.alpha = 1.0
            //                                        if(customAppSettings.sharedInstance.inAppAddToCart){
            //                                            self.addToCartButton.isHidden = false
            //                                        }
            //                                  }
            //                          }
            //                              else {
            //                                  self.outOfStockLabel.isHidden=true
            //                                    productImage.alpha = 1.0
            //                                    if(customAppSettings.sharedInstance.inAppAddToCart){
            //                                        self.addToCartButton.isHidden = false
            //                                    }
            //                              }
            //                          }
            //                   else {
            //                       self.outOfStockLabel.isHidden=true
            //                         productImage.alpha = 1.0
            //                         if(customAppSettings.sharedInstance.inAppAddToCart){
            //                             self.addToCartButton.isHidden = false
            //                         }
            //                   }
            
            // Product Based check
            if model.availableForSale{
                self.outOfStockLabel.isHidden=true
                productImage.alpha = 1.0
                if(customAppSettings.sharedInstance.inAppAddToCart){
                    self.addToCartButton.isHidden = false
                    changeBoardButton.isHidden = false
                }
            }else{
                self.outOfStockLabel.isHidden=false
                productImage.alpha = 0.4
                if(customAppSettings.sharedInstance.inAppAddToCart){
                    self.addToCartButton.isHidden = true
                    changeBoardButton.isHidden = true
                }
            }
        }
        else {
            self.outOfStockLabel.isHidden=true
            productImage.alpha = 1.0
            if(customAppSettings.sharedInstance.inAppAddToCart){
                self.addToCartButton.isHidden = false
                changeBoardButton.isHidden = false
            }
        }
        productImage.contentMode = .scaleAspectFit
        
    }
    
    @objc func removeItemToWishList(_ sender : UIButton) {
        removeProduct?()
    }
    
    @objc func addToBagTapped() {
        addToBag?()
    }
    
    @objc func changeBoardButtonTapped() {
        moveToDifferentBoard?()
    }
    
    func calculatePrice(model: ProductViewModel) -> NSMutableAttributedString {
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
}
