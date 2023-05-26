//
//  productRatingAndReview.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 16/03/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import Foundation

struct productRatingData : Decodable {
  let success : Bool
  let data : DataClass
}

struct DataClass : Decodable {
    var reviews: [productRatingAndReviews]
}

struct productRatingAndReviews : Decodable {  
  let rating : String
  let review_title : String
  let review_date : String
  let reviewer_name : String
  let outof : String
  let content : String
  let id : String
}
