//
//  Cart+Wholesale.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 28/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
import AlgoliaSearchClient
extension CartViewController {
    
    
    func getWholesaleData(){
        if Client.shared.isAppLogin() {
            var i = 0;
            var params = [String:Any]()
            var finalData = [[String:String]]()
            self.products.forEach{
                var data = [String:String]()
                data["product_id"]=$0.productId.components(separatedBy: "/").last!
                data["variant_id"]=$0.variantID!.components(separatedBy: "/").last!
                data["quantity"]="\($0.quantity)"
                data["price"]="\($0.individualPrice)"
                let comparePrice = $0.compareAtPrice ?? 0.0
                data["compare_at_price"]="\(comparePrice)"
                i += 1
                finalData.append(data)
            }
             let url = "https://api.wholesalehelper.io/api/v1/prices"
            if let data = UserDefaults.standard.value(forKey: "wholeSaleCustomerTags") as? [String] {
                params = ["items":finalData,
                          "customer" : [
                    "tags" : data
                ]]
            }
            let postString = self.convertAnyDicTostring(str: params)
            guard let urlRequest = url.getURL() else {return}
            var request = URLRequest(url: urlRequest)
            request.httpMethod="POST"
            request.httpBody = postString.data(using: String.Encoding.utf8)
            let token = "Bearer " + Client.wholesaleAuthorization
            request.setValue(token, forHTTPHeaderField: "Authorization")
            request.setValue(Client.wholesaleApiKey, forHTTPHeaderField: "X-WH-API-KEY")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task=URLSession.shared.dataTask(with: request, completionHandler: {data,response,error in
              DispatchQueue.main.sync
              {
                do {
                  guard let data = data else {return;}
                  guard let json = try? JSON(data:data) else {return;}
                  print(json)
                    if json["is_error"].stringValue == "false" {
                        self.wholesaleDiscountedPrice=0.0
                        for items in json["items"].arrayValue {
                            let product = self.products.filter{
                                let id = $0.variantID?.components(separatedBy: "/").last ?? ""
                                return id == items["variant_id"].stringValue
                            }
                            let wPrice = items["wpd_price"].stringValue
                            let quantity = items["quantity"].stringValue
                            if product.count > 0 {
                                
                                product.first?.compareAtPrice = Decimal(string:wPrice) ?? 0.0
                            }
                            let wPriceDecimal = (wPrice as NSString).doubleValue
                            let quantityInt = (quantity as NSString).doubleValue
                            self.wholesaleDiscountedPrice+=wPriceDecimal*quantityInt
                                    
                            
                            }
                        print(self.wholesaleDiscountedPrice)
                        self.wholesaleDataFetched = true
                        self.applyWholesaleDiscountOnCheckout()
                        self.setUpCheckoutView()
                        self.tableView.reloadData()
                    }
                }
              }
            })
            task.resume()
        }
    }
    
    func applyWholesaleDiscountOnCheckout() {
        let decimal = Decimal(self.wholesaleDiscountedPrice)
        let totalPrice = self.checkoutViewModelArray?.totalPrice ?? 0.0
        let minus = (totalPrice-decimal)
        let divide = minus / totalPrice
        let discountPercentage = divide*100
        let double = Double(truncating: discountPercentage as NSNumber)
        self.wholeSalePercentage=round(double)
    
        if discountPercentage != 0 {
            let text = self.generateRandom(size: 12)
            let url = "https://shopmobileapp.cedcommerce.com/shopifymobile/shopifycoupon/shopifycouponcode?mid=\(Client.merchantID)&coupon=\(text)&type=percentage&value=-\(discountPercentage)"
            Networking.shared.sendRequestUpdated(api: url) { (result) in
                switch result{
                case .success(let data):
                  do{
                    let json                     = try JSON(data: data)
                    print(json)
                      if json["success"].stringValue == "true" {
                          self.applyDiscountCode = text
                      }
                      else {
                          self.applyDiscountCode = ""
                      }
                      self.setUpCheckoutView()
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
