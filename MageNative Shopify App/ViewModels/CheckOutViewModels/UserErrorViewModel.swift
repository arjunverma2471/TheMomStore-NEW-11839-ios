//
//  UserErrorViewModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 03/08/18.
//  Copyright © 2018 MageNative. All rights reserved.
//

import Foundation

final class UserErrorViewModel:ViewModel{
    
    typealias ModelType = MobileBuySDK.Storefront.CheckoutUserError
    let model:  ModelType?
    let errorMessage:String
    let errorFields:[String]?
    required init(from model:ModelType) {
        self.model = model
        self.errorMessage = model.message
        self.errorFields = model.field
    }
}

extension MobileBuySDK.Storefront.CheckoutUserError: ViewModeling {
    typealias ViewModelType = UserErrorViewModel
}
