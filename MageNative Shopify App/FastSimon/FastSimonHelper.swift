//
//  FastSimonHelper.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 12/07/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation

class FastSimonHelper{
  
  static let shared   = FastSimonHelper()
  let defaults        = UserDefaults.standard
  
  func saveCDNKey(key: String){
    print("Saving CDNKey == \(key) to user defaults")
    defaults.setValue(key, forKey: Client.fastSimonUUID)
  }
  
  func getCDNKey()->String?{
    return defaults.value(forKey: Client.fastSimonUUID) as? String
  }
  
  func getParamString(params:[String:Any])->String{
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
    

    func convertParamsToJSON(params:[String : Any])->String{
           var jsonString = String()
           if let theJSONData = try? JSONSerialization.data(
               withJSONObject: params,
               options: []) {
               let theJSONText = String(data: theJSONData,
                                        encoding: .ascii)
               print("JSON string = \(theJSONText!)")
               guard let theJSONTextFinal = theJSONText else {return ""}
               jsonString = theJSONTextFinal
           }
           return jsonString
       }

}
