 //
//  wishlistCollectionCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 04/06/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MobileBuySDK

protocol QuickCartProtocol {
  func quickAddClicked(productId: String,title: String,error: Bool)
}

class wishlistCollectionCell: UICollectionViewCell {
  
  
  var disposeBag = DisposeBag()
  var delegate: QuickCartProtocol?
    var parent : WishlistViewController!
  
    @IBOutlet weak var variantLine2: UILabel!
    @IBOutlet weak var variantLine1: UILabel!
    @IBOutlet weak var moveToCart: UIButton!
  @IBOutlet weak var productName: UILabel!
  @IBOutlet weak var productImage: UIImageView!
  
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var outerView: UIView!
    var wishListData = [WishlistDetail]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productName.textColor = UIColor(light: UIColor(hexString: "#050505"),dark: UIColor(hexString: "#FFFFFF"))
        variantLine2.textColor = UIColor(light: UIColor(hexString: "#383838"),dark: UIColor(hexString: "#CCCCCC"))
        variantLine1.textColor = UIColor(light: UIColor(hexString: "#383838"),dark: UIColor(hexString: "#CCCCCC"))
        productImage.backgroundColor = .randomAlpha
        productName.font = mageFont.regularFont(size: 14.0)
        variantLine1.font = mageFont.lightFont(size: 12.0)
        variantLine2.font = mageFont.lightFont(size: 12.0)
        moveToCart.setupFont(fontType: .Medium,fontSize: 14.0)
        productName.textAlignment = Client.locale == "ar" ? .right : .left
        variantLine1.textAlignment = Client.locale == "ar" ? .right : .left
        variantLine2.textAlignment = Client.locale == "ar" ? .right : .left
    }
    
 /*   func configureData(model:WishlistDetail) {
        let url = model.variant.imageUrl.getURL()
        self.productImage.setImageFrom(url)
        self.productImage.contentMode = .scaleToFill
        self.productName.text = model.title
        self.productName.font=mageFont.mediumFont(size: 14.0)
       /* let title = NSMutableAttributedString(string: model.title)
        let space = NSMutableAttributedString(string: "\n")
        var variantNAme = NSMutableAttributedString()
        if model.variant.title != "Default Title" {
            variantNAme = NSMutableAttributedString(string: model.variant.title)
        }
        let finalText = NSMutableAttributedString()
        finalText.append(title)
        finalText.append(space)
        finalText.append(variantNAme)
        finalText.addAttributes([NSAttributedString.Key.font : mageFont.regularFont(size: 14.0)], range: NSRange(location: 0, length: finalText.length))
        self.productName.attributedText = finalText  */
        if model.variant.title != "Default Title" {
            self.variantTextLabel.text = model.variant.title
            self.variantTextLabel.font = mageFont.regularFont(size: 14.0)
        }
        else {
            self.variantTextLabel.text = ""
        }
        moveToCart.titleLabel?.font = mageFont.mediumFont(size: 15.0)
        //moveToCart.setTitle("MOVE TO CART".localized, for: .normal)
        DispatchQueue.main.async {
        Client.shared.fetchSingleProduct(of: model.id) { response, error in
            if let response = response {
                if let availableQty = response.variants.items.first?.availableQuantity, let availableForSale = response.variants.items.first?.availableForSale{
                    print("A QTY--->",availableQty)
                    //availableQty.hasPrefix("-") ||
                    if  availableQty == "0" &&  !availableForSale{
                        self.moveToCart.setTitle("Out of Stock".localized, for: .normal)
                        self.moveToCart.backgroundColor = UIColor(hexString: "#F0F0F0")
                        self.moveToCart.setTitleColor(UIColor(hexString: "#F88282"), for: .normal)
                    }
                    else{
                        self.moveToCart.setTitle("MOVE TO BAG".localized, for: .normal)
                        self.moveToCart.backgroundColor = UIColor.AppTheme()
                        self.moveToCart.setTitleColor(UIColor.textColor(), for: .normal)
                    }
                }
                
            }
        }
        }
        moveToCart.rx.tap.bind{[weak self] in
            self?.parent.view.addFullLoader()
            Client.shared.fetchSingleProduct(of: model.id) { response, error in
                if let response = response {
                    /*if response.sellingPlansGroups.items.count > 0 {
                        let productViewController=ProductVC()//:ProductViewController = self!.parent.storyboard!.instantiateViewController()
                          productViewController.productId = model.id
                          productViewController.isProductLoading = true
                          productViewController.selectedVariantID = model.variant.id
                        //  productViewController.selectedVariant = product.variant
                        self?.parent.navigationController?.pushViewController(productViewController, animated: true)
                    }
                    else {
                        
                     
                    }*/
                    print("QTY====>",response.variants.items.first?.availableQuantity ?? "")
                    
                    if let availableQty = response.variants.items.first?.availableQuantity, let availableForSale = response.variants.items.first?.availableForSale{
                        print("A QTY--->",availableQty)
//                        /availableQty.hasPrefix("-") ||
                        if  availableQty == "0" &&  !availableForSale{
                        self?.parent.view.makeToast("Product is Currently out of stock.".localized, duration: 1.5, position: .center)
                        self?.parent.view.removeFullLoader()
                        }
                        else{
                            let cartProd = CartProduct(product: response, variant: model.variant,quantity: 1)
                            var msg = ""
                            if model.variant.title == "Default Title" {
                                 msg = "You have added ".localized + response.title + " to your cart.".localized
                                
                            }
                            else {
                                 msg = "You have added ".localized + model.variant.title + " of product ".localized + response.title + " in your cart.".localized
                                
                            }
                            CartManager.shared.addToCart(cartProd)
                            WishlistManager.shared.removeFromWishList(cartProd)
                            self?.parent.view.showmsg(msg: msg)
                                
                                self?.parent.view.removeFullLoader()
                                self?.parent.loadData()
                                self?.parent.setupTabbarCount()
                            self?.parent.updateCartCount()
                            }
                        
                    }
                    
                    self?.parent.view.removeFullLoader()
//                    self?.parent.loadData()
//                    self?.parent.setupTabbarCount()
                }
                else {
                    //print(error?.localizedDescription)
                }
            }
            
        }.disposed(by: disposeBag)
        
        
    }  */
    
    
    func configureWishlistData(model:ProductViewModel,wishModel:WishlistDetail) {
        let selectedVariant = model.variants.items.filter{$0.id==wishModel.variant.id}.first
        guard let selectedVariant = selectedVariant else {return}
        if let url = selectedVariant.image {
            productImage.setImageFrom(url)
        }
        productImage.contentMode = .scaleAspectFit
        self.productName.text = model.title
        if selectedVariant.title != "Default Title" {
                var finalVariantStr = ""
                for (index,item) in selectedVariant.selectedOptions.enumerated() {
                    if index == 0 {
                        self.variantLine1.text = item.name + " : " + item.value
                    }
                    else {
                        finalVariantStr += item.name + " : " + item.value + ","
                    }
                }
                self.variantLine2.text = String(finalVariantStr.dropLast(1))
        }
        else {
            self.variantLine1.text = ""
            self.variantLine2.text = ""
        }
         let availableQty = selectedVariant.availableQuantity
         let availableForSale = selectedVariant.availableForSale
        if !selectedVariant.currentlyNotInStock {
            if selectedVariant.availableQuantity != "" {
                if  Int(availableQty) ?? 0 <= 0 &&  !availableForSale{
                    self.moveToCart.setTitle("Out of Stock".localized, for: .normal)
                    self.moveToCart.backgroundColor = UIColor(light: UIColor(hexString: "#F0F0F0"),dark: UIColor(hexString: "333333"))
                    self.moveToCart.setTitleColor(UIColor(light: UIColor(hexString: "#F88282"), dark: UIColor(hexString: "#F55353")), for: .normal)//
                    self.moveToCart.setupFont(fontType: .Medium, fontSize: 14.0)
                    productImage.alpha = 0.4
                }
                else{
                    self.moveToCart.setTitle("Move To Bag".localized, for: .normal)
                    self.moveToCart.backgroundColor = UIColor.AppTheme()
                    self.moveToCart.setTitleColor(UIColor.textColor(), for: .normal)
                    self.moveToCart.setupFont(fontType: .Medium, fontSize: 14.0)
                    productImage.alpha = 1.0
                }
            }
            else {
                self.moveToCart.setTitle("Move To Bag".localized, for: .normal)
                self.moveToCart.backgroundColor = UIColor.AppTheme()
                self.moveToCart.setTitleColor(UIColor.textColor(), for: .normal)
                self.moveToCart.setupFont(fontType: .Medium, fontSize: 14.0)
                productImage.alpha = 1.0
            }
        }
        else {
            self.moveToCart.setTitle("Move To Bag".localized, for: .normal)
            self.moveToCart.backgroundColor = UIColor.AppTheme()
            self.moveToCart.setTitleColor(UIColor.textColor(), for: .normal)
            self.moveToCart.setupFont(fontType: .Medium, fontSize: 14.0)
            productImage.alpha = 1.0
        }
        
     
        
    }
    
   
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
}
