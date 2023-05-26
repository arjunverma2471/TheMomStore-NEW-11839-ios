//
//  HomeViewController+Personalised.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 06/04/20.
//  Copyright © 2020 MageNative. All rights reserved.
//

import Foundation
extension HomeViewController
{
  func loadRecommendedProducts()
  {
    Client.shared.fetchRecommendedProducts(query: [ "queries": [["id": "query1","max_recommendations": 8,"recommendation_type": "bestsellers"],["id": "query2","max_recommendations": 8,"recommendation_type": "trending"]]]) { (json, error) in
      if let json = json{
        if let status = json["status"] as? String{
          if(status.lowercased() == "ok"){
            if let query1 = json["query1"] as? [String:Any]{
              if let products = query1["products"] as? [[String:Any]]{
                var ids = [GraphQL.ID]()
                for index in products{
                  let str="gid://shopify/Product/\(index["product_id"]!)"
                  //let str1 = (str).data(using: String.Encoding.utf8)
                  //let base64 = str1!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                  let graphId = GraphQL.ID(rawValue: str)
                  
                  ids.append(graphId)
                }
                Client.shared.fetchMultiProducts(ids: ids, completion: { [weak self] (response, error) in
                  if let response = response {
                    self?.bestSellingProducts = response
                    self?.tableView.reloadData()
                  }else {
                    
                  }
                })
              }
            }
            if let query1 = json["query2"] as? [String:Any]{
              if let products = query1["products"] as? [[String:Any]]{
                var ids = [GraphQL.ID]()
                for index in products{
                  let str="gid://shopify/Product/\(index["product_id"]!)"
//                  let str1 = (str).data(using: String.Encoding.utf8)
//                  let base64 = str1!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                  let graphId = GraphQL.ID(rawValue: str)
                  
                  ids.append(graphId)
                }
                Client.shared.fetchMultiProducts(ids: ids, completion: { [weak self] (response, error) in
                  if let response = response {
                    self?.trendingProducts = response
                    self?.tableView.reloadData()
                  }else {
                    
                  }
                })
              }
            }
          }
        }
      }
    }
  }
}
