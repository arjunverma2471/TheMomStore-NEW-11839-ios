//
//  FlitsProfileSave.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 12/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation

class FlitsProfileManager{
  
  var customerID           : String?
  var customerEmail        : String = String()
  var flitsWishistModel    : FlitsWishlistModel?
  
  var flitsGetRuleInfoModel: FlitsGetRuleInfoModel?{
    didSet{
      self.flitsEarnedInfo?.removeAll()
      self.flitsSpendinfo?.removeAll()
      
      flitsEarnedInfo = flitsGetRuleInfoModel?.rules?.allRulesData?.filter({ info in
        return info.tabToAppend == "flits_earning_rules"
      })
      
      flitsSpendinfo = flitsGetRuleInfoModel?.rules?.allRulesData?.filter({ info in
        return info.tabToAppend == "flits_spent_rules"
      })
    }
  }
  
  var flitsEarnedInfo : [AllRulesDatum]? = [AllRulesDatum]()
  var flitsSpendinfo  : [AllRulesDatum]? = [AllRulesDatum]()
  
  
  func flitsProfileUpdate(params:[String:String]){
    self.getCustomerID { val in
      if val{
        guard let customerID = self.customerID else { return }
          Networking.shared.sendRequestUpdated(api: "https://app.getflits.com/api/1/\(Client.flitsUserId)/\(customerID)/profile_save?token=\(Client.flitsToken)", type: .POST, params: params, includePureURLString: true)  { [weak self] (result) in
          switch result{
          case .success(let data):
            do{
              let json                     = try JSON(data: data)
              print("FlitsProfileUpdate==",json)
            }catch let error {
              print(error)
            }
          case .failure(let error):
            print(error)
          }
        }
      }
    }
  }
  
  func getRules(completion: @escaping(FlitsGetRuleInfoModel?)->()){
    self.getCustomerID { val in
      if val{
        guard let customerID = self.customerID else {return}
        let params = ["token":Client.flitsToken]
        let api    = "https://app.getflits.com/api/1/\(Client.flitsUserId)/\(customerID)/get_rule"
        Networking.shared.sendRequestUpdated(api: api, type: .POST, params: params, includePureURLString: true) { [weak self] (result) in
          switch result{
          case .success(let data):
            do{
              let json                     = try JSON(data: data)
              print(json)
              let decoder                  = JSONDecoder()
              decoder.keyDecodingStrategy  = .convertFromSnakeCase
              self?.flitsGetRuleInfoModel  = try decoder.decode(FlitsGetRuleInfoModel.self, from: data)
              print("FlitsGetRuleInfoModel=",self?.flitsGetRuleInfoModel)
              completion(self?.flitsGetRuleInfoModel)
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
  }
  
  func flitsPasswordUpdate(params:[String:String]){
    self.getCustomerID { val in
      if val{
        guard let customerID = self.customerID else { return }
        Networking.shared.sendRequestUpdated(api: "https://app.getflits.com/api/1/\(Client.flitsUserId)/\(customerID)/update_password?token=\(Client.flitsToken)", type: .POST, params: params, includePureURLString: true)  { [weak self] (result) in
          switch result{
          case .success(let data):
            do{
              let json                     = try JSON(data: data)
              print("FlitsPasswordUpdate==",json)
            }catch let error {
              print(error)
            }
          case .failure(let error):
            print(error)
          }
        }
      }
    }
  }
  
  fileprivate func getCustomerID(completion:@escaping(Bool)->()){
    Client.shared.fetchCustomerDetails(completeion: {
      response,error   in
      if let response = response {
        self.customerID    = response.customerId?.components(separatedBy: "/").last ?? ""
        self.customerEmail = response.email ?? ""
        completion(true)
      }
    })
  }
  
  
  
  func flitsViewWishlist(completion:@escaping(Array<ProductViewModel>?)->()){
    
    self.getCustomerID { val in
      if val {
        Networking.shared.sendRequestUpdated(api: "https://app.getflits.com/api/1/\(Client.flitsUserId)/wishlist?token=\(Client.flitsToken)&customer_email=\(self.customerEmail)", type: .GET, includePureURLString: true) { (result) in
          switch result{
          case .success(let data):
            do{
              let json = try JSON(data: data)
              print("flitsViewWishlist ==",json)
              let decoder                  = JSONDecoder()
              decoder.keyDecodingStrategy  = .convertFromSnakeCase
              self.flitsWishistModel       = try decoder.decode(FlitsWishlistModel.self, from: data)
              
              let wishlistProductIDs = self.flitsWishistModel?.data?.map({ [weak self] wishlistProduct in
                return wishlistProduct.productId
              })
              
              guard let wishlistProductIDs = wishlistProductIDs else {return}
              
              var ids = [GraphQL.ID]()
              for index in wishlistProductIDs{
                guard let index = index else {return}
                let str     = "gid://shopify/Product/\(String(describing: index))"
                let graphId = GraphQL.ID(rawValue: str)
                ids.append(graphId)
              }
              
              Client.shared.fetchMultiProducts(ids: ids, completion: { [weak self] (response, error) in
                if response != nil {
                  completion(response)
//                  self?.crosssellProducts = response
//                  self?.tableView.reloadData()
                }
              })
            }catch let error {
              completion(nil)
              print(error)
            }
          case .failure(let error):
            completion(nil)
            print(error)
          }
        }
      }
    }
  }
}
