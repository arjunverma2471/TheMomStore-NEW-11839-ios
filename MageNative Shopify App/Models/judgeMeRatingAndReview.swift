//
//  judgeMeRatingAndReview.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 26/04/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import Foundation


struct judgeMeRatingAndReview: Decodable {
  let reviews: [Review]
}

// MARK: - Review
struct Review : Decodable {
  let title, body: String?
  let rating:Int?
  let reviewer: Reviewer
  let created_at, updated_at: String?
    let product_title, product_handle, curated: String?
    let pictures: [Pictures]
    let hidden: Bool
}
struct Pictures : Decodable {
    let urls: Urls?
    let hidden: Bool
}

struct Urls : Decodable {
    let compact, original, small, huge: String?
}

// MARK: - Reviewer
struct Reviewer : Decodable {
  let id: Int
  let email, name: String
  let phone: String?
}

struct Alireviews:Decodable{
    let status: Bool
    let data: AliData?
}

struct AliData: Decodable{
    let data: [AliReviewData]?
}

struct AliReviewData: Decodable{
    let author, content, star, created_at, updated_at: String
}
