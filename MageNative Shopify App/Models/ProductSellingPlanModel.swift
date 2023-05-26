//
//  ProductSellingPlanModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 19/04/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import MobileBuySDK
class ProductSellingPlanModel : ViewModel{
    typealias ModelType = MobileBuySDK.Storefront.SellingPlanEdge
    
    let model : ModelType?
    let name : String
    var optionNames : [String]
    var optionValues : [String]
    let id : String
    let adjustmentPercentage : Int
    let adjustmentAmount : Decimal
 //   let discountAdjustment : String
    required init(from model: ModelType) {
        self.model = model
        self.name = model.node.name
        self.id = model.node.id.rawValue
        self.optionNames = [String]()
        self.optionValues = [String]()
        
        for itms in model.node.options {
            self.optionNames.append(itms.name ?? "")
            self.optionValues.append(itms.value ?? "")
        }
        if let data = model.node.priceAdjustments.first?.adjustmentValue as? MobileBuySDK.Storefront.SellingPlanFixedAmountPriceAdjustment {
            self.adjustmentAmount = data.adjustmentAmount.amount
        }
        else {
            self.adjustmentAmount = 0.0
        }
        if let data1 = model.node.priceAdjustments.first?.adjustmentValue as? MobileBuySDK.Storefront.SellingPlanPercentagePriceAdjustment {
            self.adjustmentPercentage = Int(data1.adjustmentPercentage)
        }
        else {
            self.adjustmentPercentage = 0
        }

        
       
        
    }
}

extension MobileBuySDK.Storefront.SellingPlanEdge: ViewModeling {
    typealias ViewModelType = ProductSellingPlanModel
    
   
}
