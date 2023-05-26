//
//  ReviewsAPIHandler.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 30/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
class ReviewsAPIHandler {
    
    func getProductAverageRating(model:ProductViewModel,completion: @escaping (Double?) -> Void) {
        
        var skuStr = ""
        for items in model.variants.items {
            skuStr+=(items.sku ?? "")+";"
        }
     //   let params = ["store":Client.shopUrl,"sku":skuStr]
        SharedNetworking.shared.sendRequestUpdated(api: "https://api.reviews.io/product/rating-batch?store=\(Client.shopUrl)&sku=\(skuStr)",type:.GET) { (result) in
            switch result{
            case .success(let data):
              do{
                let json                     = try JSON(data: data)
                print("reviewsAverageRatingREVIEWSIO==",json)
                  completion(json[0]["average_rating"].doubleValue)
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
    
    
    func getAllReviewsForProduct(model:ProductViewModel,completion: @escaping ([ReviewIOModel]?) -> Void) {
        var skuStr = ""
        for items in model.variants.items {
            skuStr+=(items.sku ?? "")+";"
        }
        
        SharedNetworking.shared.sendRequestUpdated(api: "https://api.reviews.io/reviews?store=\(Client.shopUrl)&sku=\(skuStr)&type=product_review&page=1&per_page=5",type:.GET) { (result) in
            switch result{
            case .success(let data):
              do{
                let json                     = try JSON(data: data)
                print("allReviewIO==",json)
                  let data = json["reviews"].arrayValue.map({ReviewIOModel(json: $0)})
                  completion(data)
               
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
