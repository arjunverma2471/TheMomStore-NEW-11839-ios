//
//  FastSimonEndpoints.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 12/07/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation

struct FastSimonEndpoints{
  
  static let uuid    = Client.fastSimonUUID
  static let storeId = Client.fastSimonStoreId
  static let mandatoryString = "UUID=\(uuid)&store_id=\(storeId)"
  
  static let siteConfiguration   = "https://api.instantsearchplus.com/load?\(mandatoryString)"
  static let autoCompleteProduct = "https://api.instantsearchplus.com/ac?\(mandatoryString)"
  static let lookalikeProducts   = "https://api.instantsearchplus.com/lookalike?\(mandatoryString)"
  static let upsellCrossSellProducts   = "https://api.fastsimon.com/related_products_suggest?\(mandatoryString)"
  static let eventTrackingProductSelectedFromAutoComplete = "https://ping.instantsearchplus.com/post_load_ac?"
}
