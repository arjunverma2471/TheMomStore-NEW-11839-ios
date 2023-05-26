//
//  FlitsCreditViewModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 09/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation

protocol StoreCreditReceived {
  func storeCreditReceived()
}
    
class FlitsCreditViewModel{
   init() {
     if Client.shared.isAppLogin(){
       getcustomerID()
     }
  }
  
  var customerID        : String?
  var delegate          : StoreCreditReceived?
  var flitsCreditModel  : FlitsCreditModel?{
    didSet{
    
      if let earnedCredits = flitsCreditModel?.customer?.totalEarnedCredits, let spendCredits = flitsCreditModel?.customer?.totalSpentCredits, let currentCredits = flitsCreditModel?.customer?.credits {
        creditDetail["Earned Credits".localized]  = (earnedCredits / 100).addCurrency()
        creditDetail["Spend Credits".localized]   = (spendCredits / 100).addCurrency()
        creditDetail["Current Credits".localized] = (currentCredits / 100).addCurrency()
      }
    }
  }
  var creditDetail      : [String:String] = [String:String]()
  var flitsCreditTypes  = ["Earned Credits".localized,"Spend Credits".localized,"Current Credits".localized]
  var creditLogCount    : Int {
    flitsCreditModel?.customer?.creditLog?.count ?? 0
  }
  
  func getcustomerID(){
    Client.shared.fetchCustomerDetails(completeion: {
      response,error   in
      if let response = response {
        self.customerID = response.customerId?.components(separatedBy: "/").last ?? ""
        self.getStoreCreditDetails()
      }
    })
  }
  
  func getStoreCreditDetails(){
    guard let customerID = self.customerID else {return}
    let api = "https://app.getflits.com/api/1/\(Client.flitsUserId)/\(customerID)/credit/get_credit?token=\(Client.flitsToken)"
    Networking.shared.sendRequestUpdated(api: api, type: .GET, includePureURLString: true) { [weak self] (result) in
      switch result{
      case .success(let data):
        do{
          let json                     = try JSON(data: data)
          print(json)
          let decoder                  = JSONDecoder()
          decoder.keyDecodingStrategy  = .convertFromSnakeCase
          self?.flitsCreditModel       = try decoder.decode(FlitsCreditModel.self, from: data)
          self?.delegate?.storeCreditReceived()
        }catch let error {
          print(error)
        }
      case .failure(let error):
        print(error)
      }
    }
  }
  
 
}

extension Double{
  func addCurrency()->String{
    let symbol = Currencies.currency(for:Client.shared.getCurrencyCode()!)!.shortestSymbol
    var str = self.description
    if self < 0 {
      str.insert(contentsOf:symbol,  at: str.index(str.startIndex, offsetBy: 1))
    }else{
      str.insert(contentsOf:symbol,  at: str.startIndex)
    }
    return str
  }
}
