//
//  RewardifyTokenHandler.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 20/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation

struct RewardifyConstants{
  var clientID      = ""
  var clientSecret  = ""
  let grantType     = "client_credentials"
}

enum RewardifyAPI: String{
  case token           = "https://api.rewardify.ca/oauth/v2/token"
  case customerAccount = "https://api.rewardify.ca/customer/"
}

class RewardifyTokenHandler{

  func rewardifyGenerateToken(completion: @escaping (String?) -> Void){
    
      let params = ["client_id":Client.rewardifyClientId,
                  "grant_type":RewardifyConstants().grantType,
                    "client_secret":Client.rewardifyClientSecret
                 ]
    
    SharedNetworking.shared.sendRequestUpdated(api: RewardifyAPI.token.rawValue, type: .POST, params: params) { [weak self] (result) in
      switch result{
      case .success(let data):
        do{
          let json                     = try JSON(data: data)
          print("rewardifyGenerateToken==",json)
          completion(json["access_token"].stringValue)
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
  
  // #1st
  func getcustomerID(completion: @escaping(String?)->()){
    Client.shared.fetchCustomerDetails(completeion: {
      response,error in
      if let response = response {
        completion(response.customerId?.components(separatedBy: "/").last ?? "")
      }
    })}
}
