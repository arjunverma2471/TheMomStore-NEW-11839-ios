//
//  CompleteOrderViewModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 02/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
class CompleteOrderViewModel : ViewModel {
    typealias ModelType = MobileBuySDK.Storefront.Order
    let model: ModelType?
    let processedAt:String
    let customerUrl:URL?
    let totalPrice:String
    let orderNumber:String
    let statusUrl:URL?
    let fulfillmentStatus:String
    let financialStatus:String
    let shippingAddress:AddressViewModel?
    let lineItems:PageableArray<OrderLineItemViewModel>
    let name:String
    let latitude:Double?
    let longitude :Double?
    let phoneNumber:String
    let cancelAt:String
    let cancelReason:String
    var subTotal:String?
    var shippingPrice:String?
    var refundPrice:String?
    var taxPrice:String?
    var email:String?
    
    required init(from model: ModelType) {
      self.model = model
      self.customerUrl =  model.customerUrl
      self.processedAt =  model.processedAt.formatDate(with: "MMM dd yyyy")
      self.orderNumber = String(model.orderNumber)
      self.totalPrice  = Currency.stringFrom(model.totalPrice.amount)
      self.shippingAddress =  model.shippingAddress?.viewModel
      self.statusUrl = model.statusUrl
      self.name = model.shippingAddress?.name ?? ""
      self.phoneNumber = model.shippingAddress?.phone ?? ""
      self.latitude = model.shippingAddress?.latitude
      self.longitude = model.shippingAddress?.longitude
      self.fulfillmentStatus = model.fulfillmentStatus.rawValue
      self.financialStatus = model.financialStatus?.rawValue ?? ""
      self.subTotal = Currency.stringFrom(model.subtotalPrice?.amount ?? 0.0)
      self.shippingPrice = Currency.stringFrom(model.totalShippingPrice.amount)
  //    self.shippingPrice = Currency.stringFrom(model.node.totalRefundedV2.amount)
      self.taxPrice = Currency.stringFrom(model.totalTax?.amount ?? 0.0)
      self.email = model.email
      self.cancelAt = model.canceledAt?.description ?? ""
      self.cancelReason = model.cancelReason?.rawValue ?? ""
      self.lineItems =  PageableArray (
        with: model.lineItems.edges,
        pageInfo: model.lineItems.pageInfo
      )
    }
}


extension MobileBuySDK.Storefront.Order:ViewModeling{
  typealias ViewModelType = CompleteOrderViewModel
}
