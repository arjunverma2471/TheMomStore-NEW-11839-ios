//
//  NetworkHandler.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 27/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
public class NetworkHandler {
    
    private init() {}
    
    public static let shared = NetworkHandler()
    
    public func sendRequestUpdated(api: String, type: RequestType = .GET, params: [String:String] = [String:String](),controller: UIViewController? = nil,includePureURLString: Bool = false,token: String? = nil,completion: @escaping(Result<Data,Error>)->()){
     
      if controller != nil {
        controller?.view.addLoader()
      }
      
      var makeRequest: URLRequest
      
      if includePureURLString{
        makeRequest = URLRequest(url: URL(string: api)!)
      }else{
        makeRequest = URLRequest(url: URL(string: api)!)
      }
      print("✅RequestURL==✅",makeRequest.url.debugDescription)
      makeRequest.httpMethod = type.rawValue
      
//      var stringToPost = [String:[String:String]]()
//      var postJsonString  = ""
      
//      switch type{
//      case .GET:
        if(params.count > 0){
          var postString1 = ""
          for (key,value) in params
          {
            postString1 += "&" + key + "=" + value
          }
          print(postString1)
          makeRequest.httpBody = postString1.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue));
          
        }
        print(params)
        if token != nil{
          makeRequest.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        }
   /*   case .POST, .DELETE, .PATCH:
            stringToPost        = ["parameters":[:]]
            for (key,value) in params
            {
                _ = stringToPost["parameters"]?.updateValue(value, forKey:key)
            }
            postJsonString      = params.convtToJson() as String
        makeRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if token != nil{
          makeRequest.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        }
        
            //request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        makeRequest.httpBody = postJsonString.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        print("POSTJSONSTRING==",postJsonString)
      }*/
      
      AF.request(makeRequest).responseData(completionHandler: {
        response in
        if controller != nil {
          controller?.view.stopLoader()
        }
        
        DispatchQueue.main.async {
          switch response.result {
              
          case .success:
            guard let data = response.data else {
              return
            }
            completion(.success(data))
          case .failure(let error):
            print("API==",makeRequest.url?.absoluteString)
            print("❌From NetworkingClass❌",error.localizedDescription)
            completion(.failure(error))
          }
        }
      })
    }
}
