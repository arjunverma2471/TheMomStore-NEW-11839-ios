//
//  CartCheckoutViewModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 21/04/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
final class CartCheckoutViewModel: ViewModel {
    typealias ModelType = MobileBuySDK.Storefront.Cart
    let model:  ModelType?
    let id:String
    let checkoutUrl:URL
    let lineItems:        [CartLineItemViewModel]
    let subtotalPrice:    Decimal
    let totalTax:         Decimal
    let totalPrice:       Decimal
    let currencyCode : String
//    let discountAmount:Decimal?
//    let discountCodeAmount : Decimal?
//    let discountAutomaticAmount : Decimal?
//    let discountCustomAmount:Decimal?
    
    required init(from model: ModelType) {
        self.model = model
        self.id = model.id.rawValue
        self.checkoutUrl=model.checkoutUrl
        self.lineItems=model.lines.edges.viewModels
        self.subtotalPrice=model.cost.subtotalAmount.amount
        self.totalPrice=model.cost.totalAmount.amount
        self.totalTax=model.cost.totalTaxAmount?.amount ?? 0
        self.currencyCode = model.cost.totalAmount.currencyCode.rawValue
        
        
    }
    
}
extension MobileBuySDK.Storefront.Cart: ViewModeling {
    typealias ViewModelType = CartCheckoutViewModel
}
