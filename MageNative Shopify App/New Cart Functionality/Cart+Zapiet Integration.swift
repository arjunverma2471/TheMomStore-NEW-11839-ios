//
//  Cart+Zapiet Integration.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 20/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import SwiftyJSON
extension CartViewController {
    
    func checkForAvailableZapietMethod(checkoutMethod:String) {
        var products = ""
        var i = 0
        DBManager.shared.cartProducts?.forEach{
            products += "cart[\(i)][product_id]="+$0.id.components(separatedBy: "/").last! + ","
            products += "cart[\(i)][variant_id]="+$0.variant.id.components(separatedBy: "/").last! + ","
            products += "cart[\(i)][quantity]="+"\($0.qty)"+"&"
            i += 1
        }
        let params = ["shop":"\(Client.shopUrl)"
                     // "shoppingCart":products
        ]
        Networking.shared.sendRequestUpdated(api: "https://api-us.zapiet.com/v1.0/\(checkoutMethod)/validate", type: .POST, params: params) { (result) in
            switch result {
            case .success(let data):
                do {
                    let json = try JSON(data: data)
                    print(json,"\(checkoutMethod)")
                    if json["productsEligible"].boolValue {
                        if checkoutMethod == "pickup" {
                            self.checkForAvailableZapietMethod(checkoutMethod: "delivery")
                            self.getStoreLocation()
                           // self.getPickupDates()
                            self.pickupEligible = true

                        }
                        else if checkoutMethod == "delivery" {
                            self.checkForAvailableZapietMethod(checkoutMethod: "shipping")
                            self.deliveryEligible = true
                        
                        }
                        else {
                            self.getShippingDates()
                            self.shippingEligible = true
                        }
                    }
                    self.tableView.reloadData()
                    
                }
                catch let error {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    func getStoreLocation() {
        Networking.shared.sendRequestUpdated(api: "https://api-us.zapiet.com/v1.0/pickup/locations", type: .POST, params: ["shop":"\(Client.shopUrl)"], includePureURLString: true) { [weak self] (result) in
          switch result{
          case .success(let data):
            do{
              let json                     = try JSON(data: data)
              print(json)
                if json["locations"].arrayValue.count > 0 {
                    self?.locationsArray = json["locations"].arrayValue
                    for item in json["locations"].arrayValue {
                        var str = ""
                        str += item["company_name"].stringValue + "\n"
                        str += item["address_line_1"].stringValue + "\n"
                        str += item["city"].stringValue + "\n"
                        str += item["postal_code"].stringValue
                        self?.locationArray.append(str)
                    }
                    self?.isDataLoaded = true
                    self?.getPickupDates()
                }
                else{
                    self?.isDataLoaded = false
                    self?.showDeliveryDate = false
                    self?.showErrorAlert(error: "Sorry, pickup is not available for your selected items.")
                }
                self?.tableView.reloadData()
            }catch let error {
              print(error)
            }
          case .failure(let error):
            print(error)
          }
        }
        
    }
    
    func getPickupDates() {
        let locationId = self.locationsArray[initialSelected]["id"].stringValue
        var products = ""
        var i = 0
        DBManager.shared.cartProducts?.forEach{
            products += "cart[\(i)][product_id]="+$0.id.components(separatedBy: "/").last! + ","
            products += "cart[\(i)][variant_id]="+$0.variant.id.components(separatedBy: "/").last! + ","
            products += "cart[\(i)][quantity]="+"\($0.qty)"+"&"
            i += 1
        }
        let params = ["shop":"\(Client.shopUrl)",
                      "shoppingCart":products
        ]
        Networking.shared.sendRequestUpdated(api: "https://api-us.zapiet.com/v1.0/pickup/locations/\(locationId)/calendar", type: .POST, params: params) { (result) in
            switch result {
            case .success(let data):
                do {
                    let json                     = try JSON(data: data)
                    print(json)
                    self.maxDate = json["maxDate"].stringValue
                    self.minDate = json["minDate"].stringValue
                    self.invalidDays = json["disabled"].arrayValue
                    self.pickupJSON = json
                   // self.tableView.reloadSections(IndexSet(integer: 3), with: .fade)
                }
                catch let error {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func getDeliveryLocation(pincode:String="", completion : @escaping(JSON?) -> (Void)) {
        var params = [String:String]()
        var products = ""
        var i = 0
        DBManager.shared.cartProducts?.forEach{
            products += "cart[\(i)][product_id]="+$0.id.components(separatedBy: "/").last! + ","
            products += "cart[\(i)][variant_id]="+$0.variant.id.components(separatedBy: "/").last! + ","
            products += "cart[\(i)][quantity]="+"\($0.qty)"+"&"
            i += 1
        }
        if pincode != "" {
            params = ["shop":"\(Client.shopUrl)",
                     // "shoppingCart":products,
                      "geoSearchQuery":pincode
            ]
        }
        else {
             params = ["shop":"\(Client.shopUrl)"
                       // "shoppingCart":products
            ]
        }
        Networking.shared.sendRequestUpdated(api: "https://api-us.zapiet.com/v1.0/delivery/locations", type: .POST, params: params, includePureURLString: true) { (result) in
          switch result{
          case .success(let data):
            do{
                let json                     = try JSON(data: data)                
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
    
    
    func getDeliveryDates(locationId:String="", completion : @escaping(JSON?) -> (Void)) {
        
        var products = ""
        var i = 0
        DBManager.shared.cartProducts?.forEach{
            products += "cart[\(i)][product_id]="+$0.id.components(separatedBy: "/").last! + ","
            products += "cart[\(i)][variant_id]="+$0.variant.id.components(separatedBy: "/").last! + ","
            products += "cart[\(i)][quantity]="+"\($0.qty)"+"&"
            i += 1
        }
        let params = ["shop":"\(Client.shopUrl)",
                      "shoppingCart":products
        ]
        
        Networking.shared.sendRequestUpdated(api: "https://api-us.zapiet.com/v1.0/delivery/locations/\(locationId)/calendar", type: .POST, params: params) { (result) in
            switch result {
            case .success(let data):
                do {
                    let json                     = try JSON(data: data)
                    completion(json)
                }
                catch let error {
                    print(error)
                    completion(nil)
                }
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    func getDeliveryTime(locationId:String="", deliveryDate:String="") {
        Networking.shared.sendRequestUpdated(api: "https://api-us.zapiet.com/v1.0/delivery/locations/\(locationId)/calendar/\(deliveryDate)", type: .POST, params: ["shop":"\(Client.shopUrl)"]) { (result) in
            switch result {
            case .success(let data):
                do {
                    let json                     = try JSON(data: data)
                    print(json)
                    self.deliveryDateJSON = json
                }
                catch let error {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func getShippingDates(){
        var products = ""
        var i = 0
        DBManager.shared.cartProducts?.forEach{
            products += "cart[\(i)][product_id]="+$0.id.components(separatedBy: "/").last! + ","
            products += "cart[\(i)][variant_id]="+$0.variant.id.components(separatedBy: "/").last! + ","
            products += "cart[\(i)][quantity]="+"\($0.qty)"+"&"
            i += 1
        }
        let params = ["shop":"\(Client.shopUrl)",
                      "shoppingCart":products
        ]
        Networking.shared.sendRequestUpdated(api: "https://api-us.zapiet.com/v1.0/shipping/calendar", type: .POST, params: params) { (result) in
            switch result {
            case .success(let data):
                do {
                    let json = try JSON(data: data)
                    print(json)
                }
                catch let error {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
    
}


extension NewCartViewController {
    
    func checkForAvailableZapietMethod(checkoutMethod:String) {
        var products = ""
        var i = 0
        DBManager.shared.cartProducts?.forEach{
            products += "cart[\(i)][product_id]="+$0.id.components(separatedBy: "/").last! + ","
            products += "cart[\(i)][variant_id]="+$0.variant.id.components(separatedBy: "/").last! + ","
            products += "cart[\(i)][quantity]="+"\($0.qty)"+"&"
            i += 1
        }
        let params = ["shop":"\(Client.shopUrl)"
                     // "shoppingCart":products
        ]
        Networking.shared.sendRequestUpdated(api: "https://api-us.zapiet.com/v1.0/\(checkoutMethod)/validate", type: .POST, params: params) { (result) in
            switch result {
            case .success(let data):
                do {
                    let json = try JSON(data: data)
                    print(json,"\(checkoutMethod)")
                    if json["productsEligible"].boolValue {
                        if checkoutMethod == "pickup" {
                            self.checkForAvailableZapietMethod(checkoutMethod: "delivery")
                            self.getStoreLocation()
                           // self.getPickupDates()
                            self.pickupEligible = true

                        }
                        else if checkoutMethod == "delivery" {
                            self.checkForAvailableZapietMethod(checkoutMethod: "shipping")
                            self.deliveryEligible = true
                        
                        }
                        else {
                            self.getShippingDates()
                            self.shippingEligible = true
                        }
                    }
                    self.tableView.reloadData()
                    
                }
                catch let error {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    func getStoreLocation() {
        Networking.shared.sendRequestUpdated(api: "https://api-us.zapiet.com/v1.0/pickup/locations", type: .POST, params: ["shop":"\(Client.shopUrl)"], includePureURLString: true) { [weak self] (result) in
          switch result{
          case .success(let data):
            do{
              let json                     = try JSON(data: data)
              print(json)
                if json["locations"].arrayValue.count > 0 {
                    self?.locationsArray = json["locations"].arrayValue
                    for item in json["locations"].arrayValue {
                        var str = ""
                        str += item["company_name"].stringValue + "\n"
                        str += item["address_line_1"].stringValue + "\n"
                        str += item["city"].stringValue + "\n"
                        str += item["postal_code"].stringValue
                        self?.locationArray.append(str)
                    }
                    self?.isDataLoaded = true
                    self?.getPickupDates()
                }
                else{
                    self?.isDataLoaded = false
                    self?.showDeliveryDate = false
                    self?.showErrorAlert(error: "Sorry, pickup is not available for your selected items.")
                }
                self?.tableView.reloadData()
            }catch let error {
              print(error)
            }
          case .failure(let error):
            print(error)
          }
        }
        
    }
    
    func getPickupDates() {
        let locationId = self.locationsArray[initialSelected]["id"].stringValue
        var products = ""
        var i = 0
        DBManager.shared.cartProducts?.forEach{
            products += "cart[\(i)][product_id]="+$0.id.components(separatedBy: "/").last! + ","
            products += "cart[\(i)][variant_id]="+$0.variant.id.components(separatedBy: "/").last! + ","
            products += "cart[\(i)][quantity]="+"\($0.qty)"+"&"
            i += 1
        }
        let params = ["shop":"\(Client.shopUrl)",
                      "shoppingCart":products
        ]
        Networking.shared.sendRequestUpdated(api: "https://api-us.zapiet.com/v1.0/pickup/locations/\(locationId)/calendar", type: .POST, params: params) { (result) in
            switch result {
            case .success(let data):
                do {
                    let json                     = try JSON(data: data)
                    print(json)
                    self.maxDate = json["maxDate"].stringValue
                    self.minDate = json["minDate"].stringValue
                    self.invalidDays = json["disabled"].arrayValue
                    self.pickupJSON = json
                   // self.tableView.reloadSections(IndexSet(integer: 3), with: .fade)
                }
                catch let error {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func getDeliveryLocation(pincode:String="", completion : @escaping(JSON?) -> (Void)) {
        var params = [String:String]()
        var products = ""
        var i = 0
        DBManager.shared.cartProducts?.forEach{
            products += "cart[\(i)][product_id]="+$0.id.components(separatedBy: "/").last! + ","
            products += "cart[\(i)][variant_id]="+$0.variant.id.components(separatedBy: "/").last! + ","
            products += "cart[\(i)][quantity]="+"\($0.qty)"+"&"
            i += 1
        }
        if pincode != "" {
            params = ["shop":"\(Client.shopUrl)",
                     // "shoppingCart":products,
                      "geoSearchQuery":pincode
            ]
        }
        else {
             params = ["shop":"\(Client.shopUrl)"
                       // "shoppingCart":products
            ]
        }
        Networking.shared.sendRequestUpdated(api: "https://api-us.zapiet.com/v1.0/delivery/locations", type: .POST, params: params, includePureURLString: true) { (result) in
          switch result{
          case .success(let data):
            do{
                let json                     = try JSON(data: data)
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
    
    
    func getDeliveryDates(locationId:String="", completion : @escaping(JSON?) -> (Void)) {
        
        var products = ""
        var i = 0
        DBManager.shared.cartProducts?.forEach{
            products += "cart[\(i)][product_id]="+$0.id.components(separatedBy: "/").last! + ","
            products += "cart[\(i)][variant_id]="+$0.variant.id.components(separatedBy: "/").last! + ","
            products += "cart[\(i)][quantity]="+"\($0.qty)"+"&"
            i += 1
        }
        let params = ["shop":"\(Client.shopUrl)",
                      "shoppingCart":products
        ]
        
        Networking.shared.sendRequestUpdated(api: "https://api-us.zapiet.com/v1.0/delivery/locations/\(locationId)/calendar", type: .POST, params: params) { (result) in
            switch result {
            case .success(let data):
                do {
                    let json                     = try JSON(data: data)
                    completion(json)
                }
                catch let error {
                    print(error)
                    completion(nil)
                }
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    func getDeliveryTime(locationId:String="", deliveryDate:String="") {
        Networking.shared.sendRequestUpdated(api: "https://api-us.zapiet.com/v1.0/delivery/locations/\(locationId)/calendar/\(deliveryDate)", type: .POST, params: ["shop":"\(Client.shopUrl)"]) { (result) in
            switch result {
            case .success(let data):
                do {
                    let json                     = try JSON(data: data)
                    print(json)
                    self.deliveryDateJSON = json
                }
                catch let error {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func getShippingDates(){
        var products = ""
        var i = 0
        DBManager.shared.cartProducts?.forEach{
            products += "cart[\(i)][product_id]="+$0.id.components(separatedBy: "/").last! + ","
            products += "cart[\(i)][variant_id]="+$0.variant.id.components(separatedBy: "/").last! + ","
            products += "cart[\(i)][quantity]="+"\($0.qty)"+"&"
            i += 1
        }
        let params = ["shop":"\(Client.shopUrl)",
                      "shoppingCart":products
        ]
        Networking.shared.sendRequestUpdated(api: "https://api-us.zapiet.com/v1.0/shipping/calendar", type: .POST, params: params) { (result) in
            switch result {
            case .success(let data):
                do {
                    let json = try JSON(data: data)
                    print(json)
                }
                catch let error {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
    
}
