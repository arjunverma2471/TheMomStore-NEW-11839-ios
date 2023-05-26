//
//  GrowaveTokenHandler.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 25/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation

//struct GrowaveToken {
//    var clientID      = "a1872cb97ce6de3bd0937596679a3cd8"
//    var clientSecret  = "1d4f8ca905057ac92fbcb413afb51a16"
//    let grantType     = "client_credentials"
//}



class GrowaveTokenHandler {
    
    func generateTokenGrowave(completion: @escaping (String?) -> Void){
        let params = ["client_id":Client.growaveClientId,
                      "grant_type":GrowaveToken().grantType,
                      "client_secret":Client.growaveClientSecret
                   ]
      
        
        NetworkHandler.shared.sendRequestUpdated(api: "https://api.growave.io/api/access_token", type: .POST, params: params) { (result) in
            switch result{
            case .success(let data):
              do{
                let json = try JSON(data: data)
                print("growaveGenerateToken==",json)
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
    
    func searchForGrowaveUser(customerId:String,token:String,completion: @escaping (String?) -> Void) {
        NetworkHandler.shared.sendRequestUpdated(api: "https://api.growave.io/api/users/search&customer_id=\(customerId)", type: .GET,token: token) { (result) in
            switch result{
            case .success(let data):
              do{
                let json = try JSON(data: data)
                print("jsonUserFoundData==",json)
                completion(json["data"]["user_id"].stringValue)
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
    
}
