//
//  RewardifyActiveDiscountViewModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 27/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//


protocol ReceivedActiveDiscounts {
  func receivedActiveDiscounts()
}

import Foundation

class RewardifyActiveDiscountVM{
  
  private let rewardifyTH               = RewardifyTokenHandler()
  var customerID                        = String()
  let decoder                           = JSONDecoder()
  var discountListingModel              :[DiscountListingModel]?
  var delegate                          : ReceivedActiveDiscounts?
  init(){
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    rewardifyTH.getcustomerID { [weak self] cid in
      if let cid = cid {
        self?.customerID = cid
        self?.loadActiveDiscount()
      }
    }
  }
  
  func loadActiveDiscount(){
    let api = "\(RewardifyAPI.customerAccount.rawValue)\(self.customerID)/discounts"
    
    rewardifyTH.rewardifyGenerateToken { token in
      if let token = token {
        SharedNetworking.shared.sendRequestUpdated(api: api,type: .GET, token: token) { [weak self] (result) in
          switch result{
          case .success(let data):
            do{
              let json = try JSON(data: data)
              print("loadActiveDiscount==",json)
              self?.discountListingModel   = try self?.decoder.decode([DiscountListingModel].self, from: data)
              print(self?.discountListingModel?.first?.code)
              self?.delegate?.receivedActiveDiscounts()
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
  
  
  func revertDiscount(discountID:String?, completion: @escaping (Bool)->()){
    guard let discountID = discountID else {
      return
    }

    let api = "\(RewardifyAPI.customerAccount.rawValue)discount/\(discountID)/recover"
    rewardifyTH.rewardifyGenerateToken { token in
      if let token = token {
        SharedNetworking.shared.sendRequestUpdated(api: api,type: .PATCH, token: token) { [weak self] (result) in
          switch result{
          case .success(let data):
            do{
              let json = try JSON(data: data)
              print("revertDiscount==",json)
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
