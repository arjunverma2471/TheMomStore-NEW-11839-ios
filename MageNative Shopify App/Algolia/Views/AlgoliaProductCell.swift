//
//  AlgoliaProductCell.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 27/04/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

protocol algoliaWishListDelegate {
  func addToWishListProduct(_ cell: AlgoliaProductCell, didAddToWishList sender: Any)
}

class AlgoliaProductCell: UICollectionViewCell {
    @IBOutlet weak var addToWishList: UIButton!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var addToCart: UIButton!
    @IBOutlet weak var outOfStockImage: UIImageView!
    
    var priceFont = mageFont.regularFont(size: 14.0)
    var specialPriceFont = mageFont.regularFont(size: 14.0)
    var itemNameFont = mageFont.regularFont(size: 15.0)
  var priceColor = UIColor.black;
  var specialPriceColor = UIColor.red;
  var itemTitleColor = UIColor.black;
  var specialPriceHide = false;
  var delegate:algoliaWishListDelegate?
    
    override func awakeFromNib() {
      super.awakeFromNib()
        addToWishList.addTarget(self, action: #selector(self.addItemToWishList(_:)), for: .touchUpInside)
        productImage.superview?.bringSubviewToFront(outOfStockImage)
    }
    
    @objc func addItemToWishList(_ sender:UIButton){
      self.delegate?.addToWishListProduct(self, didAddToWishList: sender)
    }
    
    func setupView(product: [String:String]){
        
        productPrice.numberOfLines = 0
        productName.numberOfLines = 2
        if customAppSettings.sharedInstance.inAppWishlist {
          self.addToWishList.isHidden = false;
        }
        if customAppSettings.sharedInstance.inAppAddToCart {
          if self.addToCart != nil {
            self.addToCart.isHidden = false;
          }
        }
        productName.font = itemNameFont
        
        productName.textColor = itemTitleColor
        print(product)
        if(product["image"] != ""){
            productImage.setImageFrom(URL(string: product["image"]!))
        }
        
        productName.text = product["title"]!
        productPrice.attributedText =  self.calCulatePrice(productPrice: product["price"]!, compareAtPrice: product["compareAtPrice"]!)
        if self.outOfStockImage != nil {
           if product["inventoryAvailable"] == "true"{
             self.outOfStockImage.isHidden=true
           }
           else {
             self.outOfStockImage.isHidden=false
           }
         }
        if let wishlistProducts = DBManager.shared.wishlistProducts{
            if wishlistProducts.contains(where: {$0.variant.id == product["variantId"]!}){
                addToWishList.setImage(#imageLiteral(resourceName: "heartFilled"), for: .normal)
            }
            else {
                addToWishList.setImage(#imageLiteral(resourceName: "heartEmpty"), for: .normal)
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
struct Currencies {
   
   /// Returns the currency code. For example USD or EUD
   let code: String
   
   /// Returns currency symbols. For example ["USD", "US$", "$"] for USD, ["RUB", "₽"] for RUB or ["₴", "UAH"] for UAH
   let symbols: [String]
   
   /// Returns shortest currency symbols. For example "$" for USD or "₽" for RUB
   var shortestSymbol: String {
      return symbols.min { $0.count < $1.count } ?? ""
   }
   
   /// Returns information about a currency by its code.
   static func currency(for code: String) -> Currencies? {
      return cache[code]
   }
   
   // Global constants and variables are always computed lazily, in a similar manner to Lazy Stored Properties.
   static fileprivate var cache: [String: Currencies] = { () -> [String: Currencies] in
      var mapCurrencyCode2Symbols: [String: Set<String>] = [:]
      let currencyCodes = Set(Locale.commonISOCurrencyCodes)
      
      for localeId in Locale.availableIdentifiers {
         let locale = Locale(identifier: localeId)
         guard let currencyCode = locale.currencyCode, let currencySymbol = locale.currencySymbol else {
            continue
         }
         if currencyCode.contains(currencyCode) {
            mapCurrencyCode2Symbols[currencyCode, default: []].insert(currencySymbol)
         }
      }
      
      var mapCurrencyCode2Currency: [String: Currencies] = [:]
      for (code, symbols) in mapCurrencyCode2Symbols {
         mapCurrencyCode2Currency[code] = Currencies(code: code, symbols: Array(symbols))
      }
      return mapCurrencyCode2Currency
   }()
}
