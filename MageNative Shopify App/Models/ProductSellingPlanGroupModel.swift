//
//  ProductSellingPlanGroupModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 19/04/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
class ProductSellingPlanGroupModel : ViewModel {
    typealias ModelType = MobileBuySDK.Storefront.SellingPlanGroupEdge
    
    let model : ModelType?
    let name : String
    let sellingPlans : PageableArray<ProductSellingPlanModel>
    
    required init(from model: ModelType) {
        self.model = model
        self.name = model.node.name
        self.sellingPlans = PageableArray(with: model.node.sellingPlans.edges, pageInfo: model.node.sellingPlans.pageInfo)
       
        
    }
}

extension MobileBuySDK.Storefront.SellingPlanGroupEdge: ViewModeling {
   
    
    typealias ViewModelType = ProductSellingPlanGroupModel
}
