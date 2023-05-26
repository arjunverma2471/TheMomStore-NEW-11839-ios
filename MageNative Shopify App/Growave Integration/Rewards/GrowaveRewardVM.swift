//
//  GrowaveRewardVM.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 27/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
class GrowaveRewardVM {
    
    let growaveToken = GrowaveTokenHandler()
    var spendingModel = [GrowaveSpendModel]()
    var earningModel = [GrowaveEarnModel]()
    var tierModel = [GrowaveTierModel]()
    var discountModel = [GrowaveDiscountModel]()
    
    func getSpendingRules(completion: @escaping ([GrowaveSpendModel]?) -> Void) {
        if let userID = UserDefaults.standard.value(forKey: "growaveUserId") as? String {
            growaveToken.generateTokenGrowave { token in
                NetworkHandler.shared.sendRequestUpdated(api: "https://api.growave.io/api/reward/spendingRules&user_id=\(userID)",type: .GET, token: token ?? "") { (result) in
                    switch result{
                    case .success(let data):
                        do{
                            let json                     = try JSON(data: data)
                            print("growaveSpendingRules==",json)
                            self.spendingModel = json["data"].arrayValue.map({GrowaveSpendModel(json: $0)})
                            print(self.spendingModel.count)
                            completion(self.spendingModel)
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
    
    
    func getEarningRules(completion: @escaping ([GrowaveEarnModel]?) -> Void) {
        if let userID = UserDefaults.standard.value(forKey: "growaveUserId") as? String {
           // let params = ["user_id":userID]
            growaveToken.generateTokenGrowave { token in
                NetworkHandler.shared.sendRequestUpdated(api: "https://api.growave.io/api/reward/earningRules&user_id=\(userID)",type: .GET, token: token ?? "") { (result) in
                    switch result{
                    case .success(let data):
                      do{
                        let json                     = try JSON(data: data)
                        print("growaveEarningRules==",json)
                          self.earningModel = json["data"].arrayValue.map({GrowaveEarnModel(json: $0)})
                          print(self.earningModel.count)
                          completion(self.earningModel)
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
    
    
    func getTiers(completion: @escaping ([GrowaveTierModel]?) -> Void) {
        if let userID = UserDefaults.standard.value(forKey: "growaveUserId") as? String {
            growaveToken.generateTokenGrowave { token in
                NetworkHandler.shared.sendRequestUpdated(api: "https://api.growave.io/api/reward/tiers&user_id=\(userID)",type: .GET, token: token ?? "") { (result) in
                    switch result{
                    case .success(let data):
                        do{
                            let json                     = try JSON(data: data)
                            print("growaveTierRules==",json)
                            self.tierModel = json["data"].arrayValue.map({GrowaveTierModel(json: $0)})
                            print(self.tierModel.count)
                            completion(self.tierModel)
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
    
    
    func getTotalPointsData(completion: @escaping (Double?) -> Void) {
        if let userID = UserDefaults.standard.value(forKey: "growaveUserId") as? String {
            growaveToken.generateTokenGrowave { token in
                NetworkHandler.shared.sendRequestUpdated(api: "https://api.growave.io/api/users/\(userID)",type: .GET, token: token ?? "") { (result) in
                    switch result{
                    case .success(let data):
                        do{
                            let json                     = try JSON(data: data)
                            print("completeUserData==",json)
                            let points = json["data"]["points"].doubleValue
                            completion(points)
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
    
    
    func redeemPointsForUser(ruleId:String,completion: @escaping (JSON?) -> Void) {
        if let userID = UserDefaults.standard.value(forKey: "growaveUserId") as? String {
            let params = ["user_id":userID,"rule_id":ruleId]
            growaveToken.generateTokenGrowave { token in
                NetworkHandler.shared.sendRequestUpdated(api: "https://api.growave.io/api/reward/redeem",type: .POST,params: params, token: token ?? "") { (result) in
                    switch result{
                    case .success(let data):
                        do{
                            let json                     = try JSON(data: data)
                            print("completeUserData==",json)
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
        }
    }
    
    
    func getActiveDiscounts(completion: @escaping ([GrowaveDiscountModel]?) -> Void) {
        if let userID = UserDefaults.standard.value(forKey: "growaveUserId") as? String {
            growaveToken.generateTokenGrowave { token in
                NetworkHandler.shared.sendRequestUpdated(api: "https://api.growave.io/api/reward/discounts&user_id=\(userID)",type: .GET, token: token ?? "") { (result) in
                    switch result{
                    case .success(let data):
                        do{
                            let json                     = try JSON(data: data)
                            print("activeDiscounts==",json)
                            self.discountModel = json["data"].arrayValue.map({GrowaveDiscountModel(json: $0)})
                            completion(self.discountModel)
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
    
    
    func verifyUser(completion: @escaping (JSON?) -> Void) {
        if let userID = UserDefaults.standard.value(forKey: "growaveUserId") as? String {
            growaveToken.generateTokenGrowave { token in
                NetworkHandler.shared.sendRequestUpdated(api: "https://api.growave.io/api/users/verify&user_id=\(userID)",type: .GET, token: token ?? "") { (result) in
                    switch result{
                    case .success(let data):
                        do{
                            let json                     = try JSON(data: data)
                            print("verifyUser==",json)
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
        }
    }
    
    
    func updateUserBirthday(bday:String,completion: @escaping (JSON?) -> Void) {
        if let userID = UserDefaults.standard.value(forKey: "growaveUserId") as? String {
            growaveToken.generateTokenGrowave { token in
                let params = ["birthdate":bday]
                NetworkHandler.shared.sendRequestUpdated(api: "https://api.growave.io/api/users/\(userID)",type: .PUT,params: params, token: token ?? "") { (result) in
                    switch result{
                    case .success(let data):
                        do{
                            let json                     = try JSON(data: data)
                            print("updateUser==",json)
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
        }
    }
    
}
