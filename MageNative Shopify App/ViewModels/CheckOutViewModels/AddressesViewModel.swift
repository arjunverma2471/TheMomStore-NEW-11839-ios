//
//  AddressesViewModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 13/08/18.
//  Copyright © 2018 MageNative. All rights reserved.
//

import Foundation
import Foundation


final class AddressesViewModel: ViewModel {
    
    typealias ModelType = MobileBuySDK.Storefront.MailingAddressEdge
    
    let model:  ModelType?
    let id:          GraphQL.ID?
    let name:        String?
    let firstName:   String?
    let lastName:    String?
    let phone:       String?
    
    let address1:    String?
    let address2:    String?
    let city:        String?
    let country:     String?
    let countryCode: String?
    let province:    String?
    let zip:         String?
    
    // ----------------------------------
    //  MARK: - Init -
    //
    required init(from model: ModelType) {
        self.model       = model
        
        self.id          = model.node.id
        self.firstName   = model.node.firstName
        self.lastName    = model.node.lastName
        self.phone       = model.node.phone
        self.name        = model.node.name
        
        self.address1    = model.node.address1
        self.address2    = model.node.address2
        self.city        = model.node.city
        self.country     = model.node.country
        self.countryCode = model.node.countryCodeV2?.rawValue
        self.province    = model.node.province
        self.zip         = model.node.zip
    }
}

extension MobileBuySDK.Storefront.MailingAddressEdge: ViewModeling {
    typealias ViewModelType = AddressesViewModel
}
