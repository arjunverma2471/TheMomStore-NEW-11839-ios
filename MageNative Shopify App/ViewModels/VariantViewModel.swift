//
//  VariantViewModel.swift
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
import MobileBuySDK

final class VariantViewModel: ViewModel {
    
    typealias ModelType = MobileBuySDK.Storefront.ProductVariantEdge
    
    let model:  ModelType?
    let cursor: String
    let id:     String
    let title:  String
    let price:  Decimal
    let compareAtPrice:Decimal?
    let image:URL?
    var selectedOptions:[OptionViewModel]
    let availableForSale:Bool
    let availableQuantity : String
    let currentlyNotInStock:Bool
    let sku : String?
    var sellingPlan=[MobileBuySDK.Storefront.SellingPlan]()
 //   let storeAvailability : [MobileBuySDK.MobileBuySDK.Storefront.StoreAvailabilityEdge]?
    
    // ----------------------------------
    //  MARK: - Init -
    //
    required init(from model: ModelType) {
      self.model  = model
      self.cursor = model.cursor
      self.id     = model.node.id.rawValue
        self.title  = model.node.title
        self.price  = model.node.price.amount
   //   self.price  = model.node.presentmentPrices.edges.first?.node.price.amount ?? 0 as Decimal
      let options = model.node.selectedOptions.map({
        OptionViewModel(from: $0)
      })
      
      self.selectedOptions = options
      self.availableQuantity = model.node.quantityAvailable?.description ?? ""
        self.compareAtPrice = model.node.compareAtPrice?.amount
    //  self.compareAtPrice = model.node.presentmentPrices.edges.first?.node.compareAtPrice?.amount
      self.availableForSale = model.node.availableForSale
      self.image = model.node.image?.url
      self.currentlyNotInStock = model.node.currentlyNotInStock
        self.sku = model.node.sku
        _ = model.node.sellingPlanAllocations.edges.map({
            self.sellingPlan.append($0.node.sellingPlan)
        })
     //   let plan = model.node.sellingPlanAllocations.edges.first?.node.sellingPlan
     //   self.storeAvailability = model.node.storeAvailability.edges
     //   let address = model.node.storeAvailability.edges.first?.node.location.address.address1

    }
}

extension MobileBuySDK.Storefront.ProductVariantEdge: ViewModeling {
    typealias ViewModelType = VariantViewModel
}
