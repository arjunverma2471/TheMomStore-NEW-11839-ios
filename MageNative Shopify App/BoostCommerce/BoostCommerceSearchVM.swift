//
//  BoostCommerceSearchVM.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 18/07/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation



//class BoostCommerceSearchVM{
//  
//  var boostCommerceAPIHandler: BoostCommerceAPIHandler?
//  var bcSearchProductsModel  : BCSearchProductsModel?
//  let decoder                = JSONDecoder()
//  
//  
//  internal init() {
//    self.boostCommerceAPIHandler = BoostCommerceAPIHandler()
//  }
//  
//  func getInstantSearchData(for params: [String:String], completion: @escaping (Bool?)->()){
//    boostCommerceAPIHandler?.getInstantSearchResults(params, completion: { [weak self] (data) in
//      if let data = data {
//        do{
//          self?.bcSearchProductsModel  = try self?.decoder.decode(BCSearchProductsModel.self, from: data)
//          completion(true)
//        }catch let error {
//          print(error)
//          completion(false)
//        }
//      }
//    })
//  }
//  
//  
//  
//  
//  
//  
//  
//}
