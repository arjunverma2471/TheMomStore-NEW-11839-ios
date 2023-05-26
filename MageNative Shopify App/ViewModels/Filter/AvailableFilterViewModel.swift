//
//  AvailableFilterViewModel.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 10/03/22.
//  Copyright © 2022 MageNative. All rights reserved.
//
import Foundation
import MobileBuySDK

final class AvailableFilterViewModel:ViewModel {
  
    
    typealias ModelType = MobileBuySDK.Storefront.Filter
    let model:             ModelType?
    let filterId:          String
    let filterLabel:       String
    let filterType:        String
    let values: [AvailableFilterValuesViewModel]
    
    required init(from model:ModelType) {
        self.model = model
        self.filterId = model.id
        self.filterType = model.type.rawValue
        self.filterLabel = model.label
        self.values = model.values.viewModels
    }
    
}

extension MobileBuySDK.Storefront.Filter: ViewModeling {
    
    typealias ViewModelType = AvailableFilterViewModel
}
