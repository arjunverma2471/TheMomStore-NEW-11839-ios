//
//  CustomerErrorViewModel.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 13/01/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import Foundation
final class CustomerErrorViewModel:ViewModel{
    typealias ModelType = MobileBuySDK.Storefront.CustomerUserError
    let model:  ModelType?
    let errorMessage:String
    let errorFields:[String]?
    
    required init(from model:ModelType) {
        
        self.model = model
        self.errorMessage = model.message
        self.errorFields = model.field
    }
}

extension MobileBuySDK.Storefront.CustomerUserError: ViewModeling {
    typealias ViewModelType = CustomerErrorViewModel
}
