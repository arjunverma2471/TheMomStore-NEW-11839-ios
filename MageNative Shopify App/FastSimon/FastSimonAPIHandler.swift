//
//  FastSimonAPIHandler.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 12/07/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation

class FastSimonAPIHandler{
  
  var fastSimonAutoCompleteProductModel: FastSimonAutoCompleteProductModel?
  var fastSimonUpCrossSellProuductModel: FastSimonUpCrossSellProductModel?
  let decoder                          = JSONDecoder()
  
  init(){
    if FastSimonHelper.shared.getCDNKey() == nil || FastSimonHelper.shared.getCDNKey() == ""{
      getSiteConfiguration()
    }
  }
  
  func getSiteConfiguration(){
    
    SharedNetworking.shared.sendRequestUpdated(api: FastSimonEndpoints.siteConfiguration,type: .GET) { [weak self] (result) in
      switch result{
      case .success(let data):
        do{
          let json                     = try JSON(data: data)
          print("getSiteConfiguration==",json)
          FastSimonHelper.shared.saveCDNKey(key: json["cdn_cache_key"].stringValue)
        }catch let error {
          print(error)
        }
      case .failure(let error):
          print(error)
      }
    }
  }
  
  
  func getAutoCompleteProducts(_ searchString: String,
                               completion: @escaping (FastSimonAutoCompleteProductModel?)->()){
  
    guard let cdnKey = FastSimonHelper.shared.getCDNKey() else {return debugPrint("Could not get cdnKey")}
    var postString   = FastSimonEndpoints.autoCompleteProduct
    
    let params = [
                  "cdn_cache_key" :cdnKey,
                  "q"             :searchString
                 ]
    
    postString += FastSimonHelper.shared.getParamString(params: params)
    
    SharedNetworking.shared.sendRequestUpdated(api: postString,type: .GET) { [weak self] (result) in
      switch result{
      case .success(let data):
        do{
          let json                     = try JSON(data: data)
          print("getAutoCompleteProducts==",json)
          self?.fastSimonAutoCompleteProductModel = try self?.decoder.decode(FastSimonAutoCompleteProductModel.self, from: data)
      
          completion(self?.fastSimonAutoCompleteProductModel)
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
  
  
    func getLookALikeProducts(pid: String,completion: @escaping(JSON?)->()){
    
    var postString   = FastSimonEndpoints.lookalikeProducts
        let params       = ["product_id"    :pid,"UUID":Client.fastSimonUUID, "store_id":Client.fastSimonStoreId]
    postString      += FastSimonHelper.shared.getParamString(params: params)
    
    SharedNetworking.shared.sendRequestUpdated(api: postString,type: .GET) { [weak self] (result) in
      switch result{
      case .success(let data):
        do{
          let json                     = try JSON(data: data)
          print("getLookALikeProducts==",json)
            completion(json)
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
  
    func getUpsellCrossSellProducts(pid:String,completion: @escaping (FastSimonUpCrossSellProductModel?)->()){
    
    var postString   = FastSimonEndpoints.upsellCrossSellProducts
    
        let sources      = [["sources":"related_views,similar_products,related_recently_viewed,related_cart,related_purchase","max_suggest":"10","widget_id":"isp-related-widget-1","title":"You May Also Like"]].convtToJson().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
      
      let productIds = DBManager.shared.recentlyProducts
      var productId = [String]()
      if productIds?.count ?? 0 > 0 {
          for items in productIds! {
              let id = items.id.components(separatedBy: "/").last ?? ""
              productId.append(id)
          }
      }
        
        var urlToReq = postString
        urlToReq += "&specs=\(sources)"
        urlToReq += "&product_id=\(pid)"
        urlToReq += "&products=\(productId.convtToJson().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
    
    SharedNetworking.shared.sendRequestUpdated(api: urlToReq,type: .GET, includePureURLString: true) { [weak self] (result) in
      switch result{
      case .success(let data):
        do{
          let json                     = try JSON(data: data)
          self?.fastSimonUpCrossSellProuductModel = try self?.decoder.decode(FastSimonUpCrossSellProductModel.self, from: data)
          print("fastSimonUpCrossSellProuductModel==",json)
          completion(self?.fastSimonUpCrossSellProuductModel)
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
  
  //Shopper Activity Monitoring Related
  //
  
  func trackProductSelectedFromAutoComplete(pid: String){
    
    var postString   = FastSimonEndpoints.eventTrackingProductSelectedFromAutoComplete
    
    let params = ["":""]
    
//    let params       = ["store_id":instantSearchPlusStoreID,//Required
//                        "UUID":instantSearchPlusStoreUUID,//Required
//                        "host":Client.shopUrl,//Required
//                        "st":userToken,//Required
//                        "session":sessionStartTime,//Required
//                        "id":productID,
//                        "original_search_query":searchTermTyped,//Required
//                        "cart_token":platformCartToken,
//                        "prev_up_type":"3",//Required
//                        "q":productID::variantID
//    ]
    
    postString      += FastSimonHelper.shared.getParamString(params: params)
    
    SharedNetworking.shared.sendRequestUpdated(api: postString,type: .GET) { [weak self] (result) in
      switch result{
      case .success(let data):
        do{
          let json                     = try JSON(data: data)
        }catch let error {
          print(error)
        }
      case .failure(let error):
          print(error)
      }
    }
  }
}
