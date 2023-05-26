//
//  NewCartProductCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 22/04/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
protocol cartQuantityChange {
  func updateCartQuantity(sender:NewCartProductCell,quantity:Int,model:CartLineItemViewModel?)
}


class NewCartProductCell : UITableViewCell {
    
    @IBOutlet weak var incrementQty: UIButton!
    @IBOutlet weak var decrementQty: UIButton!
    @IBOutlet weak var productQty: UITextField!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var variantTitle: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var deleteProduct: UIButton!
    @IBOutlet weak var moveToWishlist: UIButton!
    @IBOutlet weak var quantityError: UILabel!
    
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var qtyStack: UIStackView!
    var parent=NewCartViewController()
    var model:CartLineItemViewModel?
    var disposeBag = DisposeBag()
    var delegate:cartQuantityChange?
    var priceColor = UIColor.gray;
    var specialPriceColor = UIColor.red;
    var itemTitleColor = UIColor.black;
    
    
    override func awakeFromNib() {
      super.awakeFromNib()
        self.buttonStackView.backgroundColor = UIColor(light: UIColor(hexString: "#F2F2F2"),dark: UIColor(hexString: "#F2F2F2"))
        productImage.backgroundColor = UIColor(light: UIColor.white, dark: UIColor.provideColor(type: .cartVc).backGroundColor)
        self.contentView.backgroundColor = UIColor(light: UIColor.white, dark: UIColor.provideColor(type: .cartVc).backGroundColor)
        productQty.isUserInteractionEnabled = false
      productQty.textAlignment = .center;
        variantTitle.numberOfLines = 0
      incrementQty.addTarget(self, action: #selector(self.incrementQty(sender:)), for: .touchUpInside)
      decrementQty.addTarget(self, action: #selector(self.decrementQty(sender:)), for: .touchUpInside)
      deleteProduct.addTarget(self, action: #selector(self.deleteProduct(sender:)), for: .touchUpInside)
      productImage.layer.cornerRadius = 8.0
      productImage.clipsToBounds=true
        productImage.contentMode = .scaleAspectFit
        if customAppSettings.sharedInstance.inAppWishlist {
            moveToWishlist.isHidden = false
        }
        else {
            moveToWishlist.isHidden = true
        }
        decrementQty.titleLabel?.font = mageFont.regularFont(size: 18)
        incrementQty.titleLabel?.font = mageFont.regularFont(size: 18)
        
        productQty.font = mageFont.regularFont(size: 14)
        moveToWishlist.setTitle("Move To Wishlist".localized, for: .normal)
        deleteProduct.setTitle("Remove".localized, for: .normal)
        moveToWishlist.titleLabel?.font = mageFont.regularFont(size: 12)
        moveToWishlist.setTitleColor(UIColor(hexString: "#6B6B6B"), for: .normal)
        deleteProduct.titleLabel?.font = mageFont.regularFont(size: 12)
        deleteProduct.setTitleColor(UIColor(hexString: "#6B6B6B"), for: .normal)
        qtyStack.layer.cornerRadius = 4.0
        qtyStack.clipsToBounds = true
    }
    
    
    func configure(from model:CartLineItemViewModel){
      self.model = model
      self.productImage.setImageFrom(model.image)
      self.productTitle.text = model.productTitle
      
      if model.variantTitle == "Default Title"
      {
        self.variantTitle.text =  ""
      }
      else
      {
        self.variantTitle.text =  model.variantTitle
      }
    
        if model.sellingPlanString != "" {
            self.variantTitle.text = model.sellingPlanString
        }
    
      self.productPrice.attributedText = self.calCulatePrice(model)
      self.productQty.text =  String(model.quantity)
      
      if !(model.currentlyNotInStock) {
        self.checkForQuantityError(model: model)
      }
        self.productTitle.textColor = UIColor(light: UIColor(hexString: "#050505"), dark: UIColor.provideColor(type: .cartVc).textColor)
        self.variantTitle.textColor = UIColor(light: UIColor(hexString: "#6B6B6B"), dark: UIColor.provideColor(type: .cartVc).textColor)
        self.productTitle.font = mageFont.regularFont(size: 14.0)
        self.variantTitle.font = mageFont.regularFont(size: 15.0)
        self.productQty.font = mageFont.regularFont(size: 14.0)
        self.incrementQty.titleLabel?.font = mageFont.regularFont(size: 18.0)
        self.decrementQty.titleLabel?.font = mageFont.regularFont(size: 18.0)
        self.productQty.backgroundColor = UIColor(hexString: "#143F6B")
        self.incrementQty.backgroundColor = UIColor(hexString: "#143F6B")
        self.decrementQty.backgroundColor = UIColor(hexString: "#143F6B")
        self.qtyStack.backgroundColor = UIColor(hexString: "#143F6B")
        self.productQty.textColor = UIColor(hexString: "#FFFFFF")
        self.incrementQty.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
        self.decrementQty.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
        moveToWishlist.rx.tap.bind{ [weak self] in
            self?.parent.view.addLoader()
            let proId = self?.parent.cartManager.getCartProductID(product: model) ?? ""
            Client.shared.fetchSingleProduct(of: proId){[weak self]
              response,error   in
              if let response = response {
                  self?.parent.view.stopLoader()
                  let selectedVariant = model.variantId
                  
                if let variants = response.variants.items.filter({$0.id == selectedVariant}).first {

                  
                  let product = CartProduct(product: response, variant: WishlistManager.shared.getVariant(variants))
                  guard let _ = response.model?.viewModel else {return}
                    if !(WishlistManager.shared.isProductVariantinWishlist(product: product)) {
                        WishlistManager.shared.addToWishList(product)
                    }
                    self?.parent.cartManager.deleteCartQty(model)
                    
                 // DBManager.shared.removeFromCart(product: self!.products[sender.tag])
                    self?.parent.applyDiscountCode=""
                    self?.parent.checkForCartUpdate()
                    self?.parent.setupTabbarCount()
                }
              }
              else {
                print("error")
                //self.showErrorAlert(error: error?.localizedDescription)
              }
            }
            
        }.disposed(by: disposeBag)
        
    }
      override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
      }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
      // Configure the view for the selected state
    }
    
    
    func checkForQuantityError(model:CartLineItemViewModel) {
      
      if model.availableQuantity == 0
      {
        self.incrementQty.isHidden=true
        self.decrementQty.isHidden=true
        self.quantityError.isHidden=false
       // self.quantityError.text = "The product is currently not in stock".localized
      }
      
      else if model.availableQuantity < 0
      {
        self.incrementQty.isHidden=false
        self.decrementQty.isHidden=false
        self.quantityError.isHidden=true
        self.quantityError.text = ""
      }
      
      else if model.quantity > model.availableQuantity
      {
        self.incrementQty.isHidden=true
        self.decrementQty.isHidden=false
        self.quantityError.isHidden=false
        self.quantityError.text = "Available Quantity : ".localized+"\(model.availableQuantity)"
      }
      else
      {
        self.incrementQty.isHidden=false
        self.decrementQty.isHidden=false
        self.quantityError.isHidden=true
        self.quantityError.text = ""
      }
        self.quantityError.font = mageFont.regularFont(size: 15.0)
    }
    
    @objc func decrementQty(sender:UIButton){
      guard let qtyText = self.productQty.text else {return}
      guard  var qty = Int(qtyText) else {return}
      qty -= 1
      if qty < 1  {return}
      delegate?.updateCartQuantity(sender: self, quantity:qty, model: self.model)
    }
    
    
    @objc func incrementQty(sender:UIButton)
    {
      guard let qtyText = self.productQty.text else {return}
      guard  var qty = Int(qtyText) else {return}
      if self.model?.currentlyNotInStock == true {
        qty += 1
        delegate?.updateCartQuantity(sender: self, quantity:qty, model: self.model)
      }
      else {
        let variantQty = self.model?.availableQuantity
        if qty == variantQty {
          self.parent.view.makeToast("Only".localized + " \(variantQty ?? 0) " + "Quantities Available".localized, duration: 1.5, position: .center)
          return;
        }
        qty += 1
        delegate?.updateCartQuantity(sender: self, quantity:qty, model: self.model)
      }
    }
    
    
    func calCulatePrice(_ model:CartLineItemViewModel) -> NSMutableAttributedString?
    {
      let price = NSMutableAttributedString()
      let attr1 = [NSAttributedString.Key.foregroundColor:specialPriceColor,NSAttributedString.Key.font : mageFont.regularFont(size: 15.0)]
      //let specialPrice = model.variants.items.first?.compareAtPrice
      let compareAtPrice = model.compareAtPrice == nil ? "false" : ((model.individualPrice) < (model.compareAtPrice) ? Currency.stringFrom((model.compareAtPrice)) : "false")
      if  compareAtPrice != "false"
      {
        let attribute1 = NSAttributedString(string:  Currency.stringFrom((model.individualPrice)), attributes: attr1  as [NSAttributedString.Key : Any])
        price.append(attribute1)
        
        let attr = [NSAttributedString.Key.strikethroughStyle:1,NSAttributedString.Key.foregroundColor:priceColor,NSAttributedString.Key.font : mageFont.regularFont(size: 15.0)] as [NSAttributedString.Key : Any]
        price.append(NSAttributedString(string: " "))
        let attribute = NSAttributedString(string:  compareAtPrice, attributes: attr)
        price.append(attribute)
        
        let minusPrice = ((model.compareAtPrice)-(model.individualPrice))
        let percentage = ((minusPrice/(model.compareAtPrice))*100)
        let val = String(format: "%.0f", Double(truncating : percentage as? NSNumber ?? 0))
          let offerString: NSMutableAttributedString =  NSMutableAttributedString(string: "(\(val)% "+"OFF".localized+")")
        offerString.addAttribute(NSAttributedString.Key.foregroundColor,value: UIColor.systemGreen, range: NSMakeRange(0, offerString.length))
        price.append(NSMutableAttributedString(string : "  "))
        price.append(offerString)
        
        return price
      }
      else {
          let attr = [NSAttributedString.Key.foregroundColor:priceColor, NSAttributedString.Key.font : mageFont.regularFont(size: 15.0)]
        let attribute = NSAttributedString(string:  Currency.stringFrom((model.individualPrice)), attributes: attr  as [NSAttributedString.Key : Any])
        price.append(attribute)
        return price
      }
    }
    
    @objc func deleteProduct(sender:UIButton){
      
      SweetAlert().showAlert("Warning".localized, subTitle: "Do you want to remove this item from \n Bag?".localized, style: AlertStyle.warning, buttonTitle:"No".localized, buttonColor:UIColor(hexString: "#cd7b72") , otherButtonTitle:  "Yes".localized, otherButtonColor:UIColor(hexString: "#29b456")) { (isOtherButton) -> Void in
        if isOtherButton == true {
          print("Cancel Button  Pressed")
        }
        else {
          self.delegate?.updateCartQuantity(sender: self, quantity:0, model: self.model)
          _ = SweetAlert().showAlert("Deleted!".localized, subTitle: "The Item has been Deleted!".localized, style: AlertStyle.success)
        }
      }
    }
    
}
