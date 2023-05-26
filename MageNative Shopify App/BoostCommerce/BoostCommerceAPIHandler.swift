//
//  BoostCommerceAPIHandler.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 15/07/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation

class BoostCommerceAPIHandler{
  
  var boostCommerceAPIHandler: BoostCommerceAPIHandler?
  var bcSearchProductsModel  : BCSearchProductsModel?
    var bcFilterDataModel: BCFilterModel?
  let decoder                = JSONDecoder()
  
  func getInstantSearchResults(_ forQuery: [String:String],
                               completion: @escaping (BCSearchProductsModel?)->()){
    var postString   = BoostCommerceEndPoints.instantSearchAPI
    postString      += self.getParams(params: forQuery)
    
    SharedNetworking.shared.sendRequestUpdated(api: postString,type: .GET) { [weak self] (result) in
      switch result{
      case .success(let data):
        do{
          let json                     = try JSON(data: data)
          print("getInstantSearchResults==",json)
          self?.bcSearchProductsModel  = try self?.decoder.decode(BCSearchProductsModel.self, from: data)
          completion(self?.bcSearchProductsModel)
        }catch let error {
          print(error)
          completion(nil)
        }
      case .failure(let error):
          print(error)
        completion(nil)
      }
    }
  }
    //  MARK: For BoostCommerce Filter
    func getInstantFilterResults(_ forQuery: [String:Any],staticData: [String:String] = [:],
                                 completion: @escaping (BCFilterModel?)->()){
        var postString   = BoostCommerceEndPoints.boostFilterAPI
        postString += FastSimonHelper.shared.getParamString(params: staticData)
      postString      += self.getParamString(params: forQuery)
      
      SharedNetworking.shared.sendRequestUpdated(api: postString,type: .GET) { [weak self] (result) in
        switch result{
        case .success(let data):
          do{
            let json                     = try JSON(data: data)
            print("getInstantSearchResults==",json)
              self?.bcFilterDataModel = BCFilterModel(json: json)
            completion(self?.bcFilterDataModel)
          }catch let error {
            print(error)
            completion(nil)
          }
        case .failure(let error):
            print(error)
          completion(nil)
        }
      }
    }
    
    
     func getParamString(params:[String:Any])->String{
         var postString = String()
         _ = params.map{ key,value in
             if let val = value as? [String]{
                 val.forEach{
                     postString += "&" + key + "[]=" + $0
                 }
             }else{
                 postString += "&" + key + "[]=" + (value as! String)
             }
         }
         return postString
       }
    
    func getParams(params:[String:Any])->String{
        var postString = String()
        _ = params.map{ key,value in
            if let val = value as? [String]{
                val.forEach{
                    postString += "&" + key + "=" + $0
                }
            }else{
                postString += "&" + key + "=" + (value as! String)
            }
        }
        return postString
      }
     
    
}

