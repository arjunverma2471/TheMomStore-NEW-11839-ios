//
//  CartCheckoutUserErrors.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 23/04/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
class CartCheckoutUserErrors : ViewModel {
    typealias ModelType = MobileBuySDK.Storefront.CartUserError
    let model:  ModelType?
    let errorMessage:String
    let errorFields:[String]?
    required init(from model:ModelType) {
        self.model = model
        self.errorMessage = model.message
        self.errorFields = model.field
    }
}

extension MobileBuySDK.Storefront.CartUserError: ViewModeling {
    typealias ViewModelType = CartCheckoutUserErrors
}
