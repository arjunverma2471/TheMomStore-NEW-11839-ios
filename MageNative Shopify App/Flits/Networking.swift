//
//  Networking.swift
//  Common Modules
//
//  Created by Manohar Singh Rawat on 11/10/21.
//

import Foundation
import UIKit
import Alamofire

public enum RequestType:String{
  case GET    = "GET"
  case POST   = "POST"
  case DELETE = "DELETE"
  case PATCH  = "PATCH"
  case PUT = "PUT"
}

public class Networking{
    private init(){}
    public static let shared = Networking()
    
    
    public func sendRequestUpdated(api: String, type: RequestType = .GET, params: [String:String] = [String:String](),controller: UIViewController? = nil,includePureURLString: Bool = false,completion: @escaping(Result<Data,Error>)->()){
        
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
        
        var stringToPost = [String:[String:String]]()
        var postJsonString  = ""
        
        switch type{
        case .GET:
          if(params.count > 0){
            var postString1 = ""
            for (key,value) in params
            {
              postString1 += "&" + key + "=" + value
            }
            print(postString1)
            makeRequest.httpBody = postString1.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue));
            if api.contains("getflits"){
              makeRequest.setValue(Bundle.main.displayName ?? "", forHTTPHeaderField: "x-integration-app-name")
            }
          }
          print(params)
        case .POST , .DELETE,.PATCH,.PUT:
              stringToPost        = ["parameters":[:]]
              for (key,value) in params
              {
                  _ = stringToPost["parameters"]?.updateValue(value, forKey:key)
              }
              postJsonString      = params.convtToJson() as String
          makeRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
          if api.contains("getflits"){
            makeRequest.setValue(Bundle.main.displayName ?? "", forHTTPHeaderField: "x-integration-app-name")
          }
              //request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
          makeRequest.httpBody = postJsonString.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
          
          print("POSTJSONSTRING==",postJsonString)
        }
        
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

extension Dictionary{
    func convtToJson() -> String {
        do {
            let json = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
          return String(data: json, encoding: .utf8)!
        }catch {
            return ""
        }
    }
}

extension Array{
    func convtToJson() -> String {
        do {
            let json = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
            return String(data: json, encoding: .utf8)!
        }catch {
            return ""
        }
    }
}

extension String {
    func base64Encoded() -> String? {
        return data(using: .utf8)?.base64EncodedString()
    }

    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension Bundle {
    var displayName: String? {
//        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
      let str =  Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
      return str?.replacingOccurrences(of: " ", with: "_")
    }
}

extension UIViewController
{
    @objc func convertDicTostring(str:Dictionary<String, String>) -> String
    {
        let dictionary = str
        let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        return jsonString!
    }
    @objc func convertAnyDicTostring(str:Dictionary<String, Any>) -> String
    {
        let dictionary = str
        let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        return jsonString!
    }
    @objc func convertParamsToString(params:[String : Any])->String{
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
    // MARK: - Time management Stuff

    @objc func convertParamsToJSON(params:[[String : String]])->String{
     var jsonString = String()
     if let theJSONData = try? JSONSerialization.data(
     withJSONObject: params,
     options: [.prettyPrinted]) {
     let theJSONText = String(data: theJSONData,
     encoding: .ascii)
     print("JSON string = \(theJSONText!)")
     guard let theJSONTextFinal = theJSONText else {return ""}
     jsonString = theJSONTextFinal
     }
     return jsonString
     }
    
    @objc func convertAnyParamsToJSON(params:[[String : Any]])->String{
      //  var jsonString = String()
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: params, options: []){
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            
            //      options: [.prettyPrinted]) {
            //      let theJSONText = String(data: theJSONData,
            //      encoding: .ascii)
            print("JSON string = \(theJSONText!)")
            //      guard let theJSONTextFinal = theJSONText else {return ""}
            //      jsonString = theJSONTextFinal
            return theJSONText ?? ""
        }
        return ""
    }
    
   
      
}
extension DropDown{
    func setAlignment(_ dropDown:DropDown){
        dropDown.customCellConfiguration = { (index, item, cell: DropDownCell) -> Void in
            cell.optionLabel.textAlignment = Client.locale == "ar" ? .right : .left
        }
        if #available(iOS 13.0, *) {
            dropDown.textColor = .label
            dropDown.backgroundColor = .viewBackgroundColor()
                  
        } else {
            // Fallback on earlier versions
        }
       
    }
}
