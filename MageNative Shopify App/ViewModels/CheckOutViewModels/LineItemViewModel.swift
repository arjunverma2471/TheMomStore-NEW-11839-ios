//
//  LineItemViewModel.swift
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


final class LineItemViewModel: ViewModel {
  
  typealias ModelType = MobileBuySDK.Storefront.CheckoutLineItemEdge
  
  let model:    ModelType?
  let cursor:   String
  
  let variantID:       String?
  let title:           String
  let quantity:        Int
  var individualPrice: Decimal
  var compareAtPrice: Decimal?
  let totalPrice:      Decimal
  let id:              String
  let image:           URL?
  let variantTitle:    String?
    let variantOptions: [MobileBuySDK.Storefront.SelectedOption]?
  let availableQuantity : Int
  let currentlyNotInStock : Bool
    let productId : String
    var collectionIds : [String]?
  // ----------------------------------
  //  MARK: - Init -
  //
  required init(from model: ModelType) {
    self.image           = model.node.variant?.image?.url
    self.id              = model.node.variant!.id.rawValue
    self.model           = model
    self.cursor          = model.cursor
    self.variantID       = model.node.variant!.id.rawValue
      self.title           = model.node.variant?.product.title ?? ""
      self.variantOptions = model.node.variant?.selectedOptions
    self.quantity        = Int(model.node.quantity)
      self.individualPrice = model.node.variant!.price.amount
      self.compareAtPrice = model.node.variant!.compareAtPrice?.amount
      let currencyCode = model.node.variant!.price.currencyCode.rawValue 
      CurrencyCode.shared.saveCurrencyCode(code: currencyCode)
 //   self.individualPrice = model.node.variant!.presentmentPrices.edges.first?.node.price.amount ?? 0
 //   self.compareAtPrice = model.node.variant!.presentmentPrices.edges.first?.node.compareAtPrice?.amount ?? 0
    self.totalPrice      = self.individualPrice * Decimal(self.quantity)
    self.variantTitle    = model.node.variant?.title
    self.availableQuantity =  Int(model.node.variant?.quantityAvailable ?? 0)
    self.currentlyNotInStock = model.node.variant?.currentlyNotInStock ?? false
      self.productId=model.node.variant?.product.id.rawValue ?? ""
      if model.node.variant?.product.collections.edges.count ?? 0 > 0 {
          model.node.variant?.product.collections.edges.forEach{ $0
              collectionIds?.append($0.node.id.rawValue)
          }
      }
      
    
  }
}

extension MobileBuySDK.Storefront.CheckoutLineItemEdge: ViewModeling {
  typealias ViewModelType = LineItemViewModel
}

