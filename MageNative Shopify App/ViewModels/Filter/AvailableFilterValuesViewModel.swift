//
//  AvailableFilterValuesViewModel.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 10/03/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
final class AvailableFilterValuesViewModel:ViewModel {
    
    typealias ModelType = MobileBuySDK.Storefront.FilterValue
    
    let model:      ModelType?
    
    let id:         String
    let label:      String
    let count:      Int
    let input:      String
    
    required init(from model:ModelType) {
        self.model = model
        self.id = model.id
        self.input = model.input
        self.label = model.label
        self.count = Int(model.count)
        
    }
    
}

extension MobileBuySDK.Storefront.FilterValue: ViewModeling {
    
    typealias ViewModelType = AvailableFilterValuesViewModel
}
extension String  {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        
    } }
