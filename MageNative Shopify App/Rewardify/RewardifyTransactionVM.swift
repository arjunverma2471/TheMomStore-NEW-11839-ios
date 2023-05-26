//
//  RewardifyTransactionVM.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 21/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import MobileBuySDK

protocol ReceivedRewardifyTransactions {
  func receivedTransactions()
}

class RewardifyTransactionVM{
  
  let rewardifyTH               = RewardifyTokenHandler()
  var customerID                = String()
  var rewardifyTransactionModel : [RewardifyTransactionModel]?
  var rewardifyDiscount         : RewardifyDiscount?
  var rewardifyAccountModel     : RewardifyAccountModel?
  var delegate                  : ReceivedRewardifyTransactions?
  let decoder                   = JSONDecoder()
  
  init(){
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    rewardifyTH.getcustomerID { cid in
      if let cid = cid {
        self.customerID = cid
        self.getCustomerAccountDetails()
      }
    }
  }

  func getCustomerAccountDetails(){
    
    rewardifyTH.rewardifyGenerateToken { token in
      if let token = token {
        SharedNetworking.shared.sendRequestUpdated(api: RewardifyAPI.customerAccount.rawValue + self.customerID + "/account", type: .GET, token: token) { [weak self] (result) in
          switch result{
          case .success(let data):
            do{
              let json                     = try JSON(data: data)
              print("getCustomerAccountDetails==",json)
              self?.rewardifyAccountModel       = try self?.decoder.decode(RewardifyAccountModel.self, from: data)
              self?.loadTransactions()
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
  
  func getWithCurrency(_ currency: String,_ amount: inout String)->String{

      let symbol = Currencies.currency(for: currency)?.shortestSymbol ?? ""
    amount.insert(contentsOf: symbol, at: amount.startIndex)
    return amount
  }
  
  
  func loadTransactions(){
    let api = "\(RewardifyAPI.customerAccount.rawValue)\(self.customerID)/account/transactions?page=1&itemsPerPage=10"
//    let api = "https://api.rewardify.ca/customer/3517652893732/account/transactions?page=1&itemsPerPage=10"
    rewardifyTH.rewardifyGenerateToken { token in
      if let token = token {
        SharedNetworking.shared.sendRequestUpdated(api: api,type: .GET, token: token) { [weak self] (result) in
          switch result{
          case .success(let data):
            do{
              let json = try JSON(data: data)
              print("loadTransactions==",json)
              self?.rewardifyTransactionModel   = try self?.decoder.decode([RewardifyTransactionModel].self, from: data)
              print(self?.rewardifyTransactionModel?.count)
              self?.delegate?.receivedTransactions()
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
  
  func generateDiscountCode(amount: String,memo: String,completion: @escaping (Bool)->()){
    
    var curr = "USD"
//    if Client.shared.getCurrencyCode() != "" && Client.shared.getCurrencyCode() != nil{
//      curr = Client.shared.getCurrencyCode()!
//    }else if UserDefaults.standard.value(forKey: "defaultCurrency") as! String != nil{
//      curr = UserDefaults.standard.value(forKey: "defaultCurrency") as! String
//    }else{
//      curr = "USD"
//    }
  
    let params = ["currency":curr.uppercased(),
                  "amount"  :amount,
                  "memo"    :memo]
    
    rewardifyTH.rewardifyGenerateToken { token in
      if let token = token {
        SharedNetworking.shared.sendRequestUpdated(api: RewardifyAPI.customerAccount.rawValue + self.customerID + "/account/redeem", type: .POST,params:params, token: token) { [weak self] (result) in
          switch result{
          case .success(let data):
            do{
              let json                     = try JSON(data: data)
                let discountJSon           = try json["discount"].rawData()
              self?.rewardifyDiscount      = try self?.decoder.decode(RewardifyDiscount.self, from: discountJSon)
              print("generatediscountCode==",discountJSon)
              completion(true)
            }catch let error {
              print(error)
              completion(false)
            }
          case .failure(let error):
              print(error)
              completion(false)
          }
        }
      }
    }
  }
}
