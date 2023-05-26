//
//  BlogsViewModel.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 17/03/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
class BlogsViewModel: ViewModel {
    typealias ModelType =  MobileBuySDK.Storefront.BlogEdge
    let model: ModelType?
    
    let handle:       String?
    let onlineStoreUrl:           URL?
    let title : String
    
    
    required init(from model: ModelType) {
        self.model = model
        self.title           = model.node.title
        self.handle        = model.node.handle
        self.onlineStoreUrl = model.node.onlineStoreUrl

    }
}

extension MobileBuySDK.Storefront.BlogEdge:ViewModeling{
    typealias ViewModelType = BlogsViewModel
}





