//
//  BoostCommerceEndpoints.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 15/07/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation


struct BoostCommerceEndPoints{
    
    fileprivate static let baseURl = "https://services.mybcapps.com"
    static let mandatoryString = "shop=\(Client.shopUrl)"
    static let boostFilterAPI = baseURl + "/bc-sf-filter/filter?\(mandatoryString)&build_filter_tree=true"
    static let instantSearchAPI = baseURl + "/bc-sf-filter/search/suggest?\(mandatoryString)"
}

