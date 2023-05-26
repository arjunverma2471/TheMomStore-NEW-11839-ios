//
//  VariantSelectionManager.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 13/04/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation

protocol VariantSelectionMadeDelegate:AnyObject {
  func variantSelectionMadeDelegate()
}
class VariantSelectionManager{
  
  weak var delegate        : VariantSelectionMadeDelegate?
  public static let shared = VariantSelectionManager()
  
  var userSelectedVariants = [String:String]()
  var isVariantUnavailable = [String]()
  
  func clearUserSelectedVariants(){
    self.userSelectedVariants.removeAll()
      self.isVariantUnavailable.removeAll()
  }
  
  func setUserSelectedVariants(_ val:[String:String]){
    for (key,value) in val {
      self.userSelectedVariants[key] = value
    }
    delegate?.variantSelectionMadeDelegate()
    print(VariantSelectionManager.shared.userSelectedVariants.description)
      
  }
  
  func getCurrentVariant(_ product: ProductViewModel!)->String{
    var variantName = String()
    
    product?.model?.options.forEach({ item in
      if let variantDetails = VariantSelectionManager.shared.userSelectedVariants[item.name]{
        variantName += variantDetails
        variantName += " / "
      }
    })
    return variantName
  }
}
