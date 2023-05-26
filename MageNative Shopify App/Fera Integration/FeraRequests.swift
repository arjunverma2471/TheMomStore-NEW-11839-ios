//
//  FeraRequests.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 14/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
struct FeraKeys {
    let secretKey = "sk_57066495418246e722f166d5d34f4fd473787301b796b1e960299751198bb2f0"
}
struct FeraRating: Codable {
    let subject, externalProductID: String?
    let productID: String?
    let average, count: CGFloat?
    let verifiedCount, verifiedAverage: Int?
    
    enum CodingKeys: String, CodingKey {
        case subject
        case externalProductID = "external_product_id"
        case productID = "product_id"
        case average, count
        case verifiedCount = "verified_count"
        case verifiedAverage = "verified_average"
    }
}


final class FeraRatingRequest: Requestables {
    typealias Response = FeraRating
    
    var path: String {
        return "products/\(productId)/rating"
    }
    
    var httpMethod: HTTPsMethods {
        return .get
    }
    
    var headerField: [String: String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "SECRET-KEY", value: FeraKeys().secretKey)
        header.appendingQueryParameter(key: "accept", value: "application/json")
        return header as! [String : String]
    }
    
    
    private let productId: String
    
    init(productId: String) {
        self.productId = productId
    }
    
    
}


struct FeraCreateCustomer: Codable {
    let message: String?
    //    let avatarURL: String?
    //    let externalID, name, email: String?
    
    enum CodingKeys: String, CodingKey {
        //        case id
        case message
        //        case displayName = "display_name"
        //        case avatarURL = "avatar_url"
        //        case externalID = "external_id"
        //        case name, email
    }
}


final class FeraCreateCustomerRequest: Requestables {
    typealias Response = FeraCreateCustomer
    
    var path: String {
        return "customers"
    }
    
    var httpMethod: HTTPsMethods {
        return .post
    }
    
    var httpBody: Data? {
        var body: [String: Any] = [:]
        body.appendingQueryParameter(key: "data", value: ["external_id": external_id,
                                                          "email": email,
                                                          "name": name])
        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted])
        print("The fera create customer body is \(body)")
        return jsonData
    }
    
    var headerField: [String: String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "SECRET-KEY", value: FeraKeys().secretKey)
        header.appendingQueryParameter(key: "accept", value: "application/json")
        header.appendingQueryParameter(key: "content-type", value: "application/json")
        return header as! [String : String]
    }
    
    
    private let external_id: String
    
    private let email: String
    
    private let name: String
    
    init(external_id: String, email: String, name: String) {
        self.external_id = external_id
        self.email = email
        self.name = name
    }
    
    
}


struct FeraProductReviews: Codable {
    let data: [FeraProductReviewsData]?
}

struct FeraProductReviewsData: Codable {
    let id, state, subject: String?
    let externalProductID, productID: String?
    let externalCustomerID, customerID: String?
    let createdAt, updatedAt: String?
    let rating: Int?
    let heading, body: String?
    let customer: FeraCustomerData?
    enum CodingKeys: String, CodingKey {
        case id, state, subject
        case externalProductID = "external_product_id"
        case productID = "product_id"
        case externalCustomerID = "external_customer_id"
        case customerID = "customer_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case rating, heading, body
        case customer
    }
}

struct FeraCustomerData: Codable {
    let id: String?
    let displayName: String?
    let avatarURL: String?
    let externalID, name, email: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case avatarURL = "avatar_url"
        case externalID = "external_id"
        case name, email
        case updatedAt = "updated_at"
    }
}


final class FeraProductReviewsRequest: Requestables {
    typealias Response = FeraProductReviews
    
    var path: String {
        return "reviews"
    }
    
    var httpMethod: HTTPsMethods {
        return .get
    }
    
    var queryParameters: [String : Any] {
        var params: [String: Any] = [:]
        params.appendingQueryParameter(key: "product.id", value: productId)
        params.appendingQueryParameter(key: "state", value: "approved")
        params.appendingQueryParameter(key: "sort_by", value: "created_at")
        return params as! [String: String]
    }
    
    
    var headerField: [String: String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "SECRET-KEY", value: FeraKeys().secretKey)
        header.appendingQueryParameter(key: "accept", value: "application/json")
        header.appendingQueryParameter(key: "content-type", value: "application/json")
        return header as! [String : String]
    }
    
    
    private let productId: String
    
    init(productId: String) {
        self.productId = productId
    }
    
    
}

struct FeraPostReview: Codable {
    let id, state, subject, externalProductID: String?
    let productID, externalCustomerID, customerID, createdAt: String?
    let updatedAt: String?
    let rating: Int?
    let heading, body: String?

    enum CodingKeys: String, CodingKey {
        case id, state, subject
        case externalProductID = "external_product_id"
        case productID = "product_id"
        case externalCustomerID = "external_customer_id"
        case customerID = "customer_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case rating
        case heading, body
    }
}

class FeraPostReviewRequest: Requestables {
    typealias Response = FeraPostReview
    
    var path: String {
        return "reviews"
    }
    
    var httpMethod: HTTPsMethods {
        return .post
    }
    
    var httpBody: Data? {
        var body: [String: Any] = [:]
        body.appendingQueryParameter(key: "data", value: ["customer": ["name": name,
                                                                       "email": email],
                                                          "rating": rating,
                                                          "heading": heading,
                                                          "body": reviewBody,
                                                          "state": "approved",
                                                          "is_verified": true,
                                                          "external_product_id": external_product_id]
//                                                          "external_customer_id": external_customer_id]
        )
        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted])
        print("The json body is \(body)")
        return jsonData
    }
    
    var headerField: [String: String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "SECRET-KEY", value: FeraKeys().secretKey)
        header.appendingQueryParameter(key: "accept", value: "application/json")
        header.appendingQueryParameter(key: "content-type", value: "application/json")
        return header as! [String : String]
    }
    
    
    private let name: String
    
    private let email: String
    
    private let rating: String
    
    private let heading: String
    
    private let reviewBody: String
    
    private let external_product_id: String
    
//    private let external_customer_id: String
    
    init(name: String, email: String, rating: String, heading: String, reviewBody: String, external_product_id: String) {
        self.name = name
        self.email = email
        self.rating = rating
        self.heading = heading
        self.reviewBody = reviewBody
        self.external_product_id = external_product_id
//        self.external_customer_id = external_customer_id
    }
    
    
}
