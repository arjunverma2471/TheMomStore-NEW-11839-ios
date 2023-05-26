//
//  CheckoutViewModel.swift
//  Storefront
//
//  Created by Shopify.
//  Copyright (c) 2017 Shopify Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation


final class CheckoutViewModel: ViewModel {
    
    typealias ModelType = MobileBuySDK.Storefront.Checkout
    
    let model:  ModelType?
    
    enum PaymentType: String {
        case applePay   = "apple_pay"
        case creditCard = "credit_card"
    }
    
    let id:               String
    let ready:            Bool
    let requiresShipping: Bool
    let taxesIncluded:    Bool
    let shippingAddress:  AddressViewModel?
    let shippingRate:     ShippingRateViewModel?
    let availableShippingRate : [ShippingRateViewModel]?
    let note:             String?
    let webURL:           URL
    let lineItemsTotal: Decimal
    let lineItems:        [LineItemViewModel]
    let currencyCode:     String
    let subtotalPrice:    Decimal
    let totalTax:         Decimal
    let totalPrice:       Decimal
    let paymentDue:       Decimal
    var checkId:          GraphQL.ID
    var giftCardId:       GraphQL.ID?
    var discountPercentage : Double?
    var discountAmount : Decimal?
    let discountAPplication : DiscountApplication?
    // ----------------------------------
    //  MARK: - Init -
    //
    required init(from model: ModelType) {
        self.model            = model
        
        self.id               = model.id.rawValue
        self.ready            = model.ready
        self.requiresShipping = model.requiresShipping
        self.taxesIncluded    = model.taxesIncluded
        self.shippingAddress  = model.shippingAddress?.viewModel
        self.shippingRate     = model.shippingLine?.viewModel
        self.giftCardId       =  model.appliedGiftCards.first?.id
        self.note             = model.note
        self.webURL           = model.webUrl
        self.availableShippingRate = model.availableShippingRates?.shippingRates?.viewModels
        self.lineItems        = model.lineItems.edges.viewModels
        self.lineItemsTotal   = model.lineItemsSubtotalPrice.amount
        self.currencyCode     = model.currencyCode.rawValue
        self.subtotalPrice    = model.subtotalPrice.amount
        self.totalTax         = model.totalTax.amount
        self.totalPrice       = model.totalPrice.amount
        self.paymentDue       = model.paymentDue.amount
        self.checkId          = model.id
        if let percentage = model.discountApplications.edges.first?.node.value as? MobileBuySDK.Storefront.PricingPercentageValue {
            self.discountPercentage = percentage.percentage
        }
        if let amount = model.discountApplications.edges.first?.node.value as? MobileBuySDK.Storefront.MoneyV2 {
            self.discountAmount = amount.amount
        }
        self.discountAPplication = model.discountApplications.edges.first?.node
    
    }
}

extension MobileBuySDK.Storefront.Checkout: ViewModeling {
    typealias ViewModelType = CheckoutViewModel
}
