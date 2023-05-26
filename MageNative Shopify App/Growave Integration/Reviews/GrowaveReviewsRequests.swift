//
//  GrowaveReviewsRequests.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 07/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
struct GrowaveToken {
    let grantType     = "client_credentials"
}

struct GrowaveAllReviews: Codable {
    let status: Int?
    let message: String?
    let data: [GrowaveAllReviewsData]?
}

// MARK: - Datum
struct GrowaveAllReviewsData: Codable {
    let reviewID, productID, userID, author: String?
    let vb: Int?
    let title, body, creationDate, status: String?
    let rate, userIDProductID: String?

    enum CodingKeys: String, CodingKey {
        case reviewID = "review_id"
        case productID = "product_id"
        case userID = "user_id"
        case author, vb, title, body
        case creationDate = "creation_date"
        case status, rate
        case userIDProductID = "user_id_product_id"
    }
}

// MARK: - Image
struct ImageArray: Codable {
    let imageDefault, thumb: String?
    
    enum CodingKeys: String, CodingKey {
        case imageDefault = "default"
        case thumb
    }
}

final class AllReviewsRequest: Requestables{
    typealias Response =  GrowaveAllReviews
    
    var path: String {
        return "reviews"
    }
    
    var queryParameters: [String : Any] {
        var params: [String: Any] = [:]
        params.appendingQueryParameter(key: "product_id", value: product_id)
        params.appendingQueryParameter(key: "since_id", value: "0")
        params.appendingQueryParameter(key: "order_by", value: "review_id")
        params.appendingQueryParameter(key: "direction", value: "ASC")
        return params
    }
    
    var headerField: [String: String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "Accept", value: "application/json")
        header.appendingQueryParameter(key: "Authorization", value: "Bearer \(token)")
        return header as! [String : String]
    }
    
    var httpMethod: HTTPsMethods {
        return .get
    }
    
    private let product_id: String
    
    private let token: String
    
    init(product_id: String, token: String) {
        self.product_id = product_id
        self.token = token
    }
}



struct GrowaveProductScore: Codable {
    let status: Int?
    let message: String?
    let data: [GrowaveProductScoreData]?
}

// MARK: - Datum
struct GrowaveProductScoreData: Codable {
    let productID, reviewsCount, averageRate: String?

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case reviewsCount = "reviews_count"
        case averageRate = "average_rate"
    }
}


final class GrowaveProductScoreRequest: Requestables {
    typealias Response =  GrowaveProductScore
    
    var path: String {
     return "reviews/products"
    }
    
    var queryParameters: [String : Any] {
        var params: [String: Any] = [:]
        params.appendingQueryParameter(key: "product_ids", value: product_id)
        return params
    }
    
    var headerField: [String: String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "Accept", value: "application/json")
        header.appendingQueryParameter(key: "Authorization", value: "Bearer \(token)")
        return header as! [String : String]
    }
    
    var httpMethod: HTTPsMethods {
        return .get
    }
    
    private let product_id: String
    
    private let token: String
    
    init(product_id: String,
         token: String){
        self.product_id = product_id
        self.token = token
    }
}



struct GrowavePostProductReview: Codable {
    let status: Int?
    let message: String?
    let data: GrowavePostProductReviewData?
}

// MARK: - DataClass
struct GrowavePostProductReviewData: Codable {
    let reviewID, userID: String?
    let rate: Int?
    let title, body, creationDate: String?

    enum CodingKeys: String, CodingKey {
        case reviewID = "review_id"
        case userID = "user_id"
        case rate, title, body
        case creationDate = "creation_date"
    }
}


final class GrowaveProductReviewRequest: Requestables {
    typealias Response =  GrowavePostProductReview
    
    var path: String {
     return "reviews"
    }
    
    var httpBody: Data? {
        var body: [String: Any] = [:]
        body.appendingQueryParameter(key: "email", value: email)
        body.appendingQueryParameter(key: "name", value: name)
        body.appendingQueryParameter(key: "product_id", value: product_id)
        body.appendingQueryParameter(key: "body", value: review_body)
        body.appendingQueryParameter(key: "title", value: title)
        body.appendingQueryParameter(key: "rate", value: rate)
        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted])
        return jsonData
    }
    
    
    var headerField: [String: String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "Accept", value: "application/json")
        header.appendingQueryParameter(key: "Content-Type", value: "application/json")
        header.appendingQueryParameter(key: "Authorization", value: "Bearer \(token)")
        return header as! [String : String]
    }
    
    var httpMethod: HTTPsMethods {
        return .post
    }
    
    private let email: String
    
    private let name: String
    
    private let product_id: String
    
    private let review_body: String
    
    private let title: String
    
    private let rate: Int
    
    private let token: String
    
    init(email: String, name: String, product_id: String, review_body: String, title: String, rate: Int, token: String) {
        self.email = email
        self.name = name
        self.product_id = product_id
        self.review_body = review_body
        self.title = title
        self.rate = rate
        self.token = token
    }
}

