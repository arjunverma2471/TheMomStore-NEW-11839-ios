//
//  CartLineItemViewModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 21/04/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import MobileBuySDK

class CartLineItemViewModel: ViewModel {
    
    typealias ModelType = MobileBuySDK.Storefront.BaseCartLineEdge
    let model:  ModelType?
    let id:String
    
    let image:URL?
    let individualPrice: Decimal
    let compareAtPrice: Decimal
    let variantTitle:String
    let productTitle : String
    let productId : String
    let quantity : Int
    let availableQuantity : Int
    let currentlyNotInStock : Bool
    let variantId : String
    let sellingPlanId : String
    let sellingPlanString : String
    
    
    required init(from model: ModelType) {
        self.model = model
        self.id = model.node.id.rawValue
        self.quantity = Int(model.node.quantity)
        self.sellingPlanId = model.node.sellingPlanAllocation?.sellingPlan.id.rawValue ?? ""
        self.sellingPlanString = model.node.sellingPlanAllocation?.sellingPlan.name ?? ""
        
       
        if let merchant = model.node.merchandise as? MobileBuySDK.Storefront.ProductVariant {
            self.variantId=merchant.id.rawValue
            self.individualPrice = merchant.price.amount
            self.compareAtPrice = merchant.price.amount
            let currencyCode = merchant.price.currencyCode.rawValue
            CurrencyCode.shared.saveCurrencyCode(code: currencyCode)
            self.variantTitle = merchant.title
            self.image = merchant.image?.url
            self.productTitle = merchant.product.title
            self.productId = merchant.product.id.rawValue
            self.availableQuantity = Int(merchant.quantityAvailable ?? 0)
            self.currentlyNotInStock = merchant.currentlyNotInStock
        }
        else {
            self.variantId=""
            self.image = URL(string: "")!
            self.individualPrice = 0.0
            self.compareAtPrice = 0.0
            self.variantTitle = ""
            self.productTitle = ""
            self.productId = ""
            self.availableQuantity = 0
            self.currentlyNotInStock = false
        }
        
        
    }
    
    
    
}

extension MobileBuySDK.Storefront.BaseCartLineEdge: ViewModeling {
    typealias ViewModelType = CartLineItemViewModel
}
