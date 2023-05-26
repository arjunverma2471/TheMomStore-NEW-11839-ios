//
//  GrowaveWishlistRequests.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 23/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
struct GrowaveBoardList: Codable {
    let status: Int?
    let message: String?
    let data: [GrowaveBoardListData]?
}

// MARK: - Datum
struct GrowaveBoardListData: Codable {
    let boardID, title: String?

    enum CodingKeys: String, CodingKey {
        case boardID = "board_id"
        case title
    }
}

final class GrowaveBoardListRequest: Requestables {
    typealias Response = GrowaveBoardList
    
    var path: String {
        return "wishlist/boards"
    }
    
    var httpMethod: HTTPsMethods {
        return .get
    }
    
    var queryParameters: [String : Any] {
        var params: [String: Any] = [:]
        params.appendingQueryParameter(key: "user_id", value: user_id)
        return params as! [String: String]
    }
    
    var headerField: [String : String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "Accept", value: "application/json")
        header.appendingQueryParameter(key: "Authorization", value: "Bearer \(token)")
        return header as! [String : String]
    }
    
    private let user_id: String
    
    private let token: String
    
    init(user_id: String, token: String) {
        self.user_id = user_id
        self.token = token
    }
    
    
}


struct GrowaveCreateBoard: Codable {
    let status: Int?
    let message: String?
    let data: CreateBoardData?
}

struct CreateBoardData: Codable {
    let userID: String?
    let title, boardID: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case title
        case boardID = "board_id"
    }
}

final class GrowaveCreateBoardRequest: Requestables {
    typealias Response = GrowaveCreateBoard
    
    var path: String {
        return "wishlist/boards"
    }
    
    var httpMethod: HTTPsMethods {
        return .post
    }
    
    var headerField: [String : String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "Accept", value: "application/json")
        header.appendingQueryParameter(key: "Content-Type", value: "application/json")
        header.appendingQueryParameter(key: "Authorization", value: "Bearer \(token)")
        return header as! [String : String]
    }
    
    var httpBody: Data? {
        var body: [String: Any] = [:]
        body.appendingQueryParameter(key: "user_id", value: user_id)
        body.appendingQueryParameter(key: "title", value: title)
        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted])
        print("The json body is \(body)")
        return jsonData
    }
    
    private let user_id: String
    
    private let token: String
    
    private let title: String
    
    init(user_id: String, token: String, title: String) {
        self.user_id = user_id
        self.token = token
        self.title = title
    }
    
    
}

final class GrowaveDeleteBoardRequest: Requestables{
    typealias Response = FeraCreateCustomer
    
    var path: String {
        return "wishlist/boards"
    }
    
    var httpMethod: HTTPsMethods {
        return .delete
    }
    
    var queryParameters: [String : Any] {
        var params: [String: Any] = [:]
        params.appendingQueryParameter(key: "user_id", value: user_id)
        params.appendingQueryParameter(key: "board_id", value: board_id)
        return params as! [String: String]
    }
    
    var headerField: [String : String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "Accept", value: "application/json")
        header.appendingQueryParameter(key: "Authorization", value: "Bearer \(token)")
        return header as! [String : String]
    }
    
    private let user_id: String
    
    private let token: String
    
    private let board_id: String
    
    init(user_id: String, board_id: String, token: String) {
        self.user_id = user_id
        self.board_id = board_id
        self.token = token
    }
    
    
}


final class GrowaveModifyBoardRequest: Requestables {
    typealias Response = GrowaveCreateBoard
    
    var path: String {
        return "wishlist/boards/#\(board_id)"
    }
    
    var httpMethod: HTTPsMethods {
        return .put
    }
    
    var headerField: [String : String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "Accept", value: "application/json")
        header.appendingQueryParameter(key: "Content-Type", value: "application/json")
        header.appendingQueryParameter(key: "Authorization", value: "Bearer \(token)")
        return header as! [String : String]
    }
    
    var httpBody: Data? {
        var body: [String: Any] = [:]
        body.appendingQueryParameter(key: "user_id", value: user_id)
        body.appendingQueryParameter(key: "title", value: title)
        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted])
        print("The json body is \(body)")
        return jsonData
    }
    
    private let user_id: String
    
    private let token: String
    
    private let title: String
    
    private let board_id: String
    
    init(user_id: String, token: String, title: String, board_id: String) {
        self.user_id = user_id
        self.token = token
        self.title = title
        self.board_id = board_id
    }
}


struct GrowaveAddWishlist: Codable {
    let status: Int?
    let message: String?
    let data: GrowaveAddWishlistData?
}


struct GrowaveAddWishlistData: Codable {
    let userID: Int?
    let productID: String?
    let variantID: Int?
    let boardID: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case productID = "product_id"
        case variantID = "variant_id"
        case boardID = "board_id"
    }
}

final class GrowaveAddWishlistRequest: Requestables{
    typealias Response = GrowaveAddWishlist
    
    var path: String {
        return "wishlist"
    }
    
    var httpMethod: HTTPsMethods {
        return .post
    }
    
    var headerField: [String : String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "Accept", value: "application/json")
        header.appendingQueryParameter(key: "Content-Type", value: "application/json")
        header.appendingQueryParameter(key: "Authorization", value: "Bearer \(token)")
        return header as! [String : String]
    }
    
    var httpBody: Data? {
        var body: [String: Any] = [:]
        body.appendingQueryParameter(key: "user_id", value: user_id)
        body.appendingQueryParameter(key: "board_id", value: board_id)
        body.appendingQueryParameter(key: "product_id", value: product_id)
        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted])
        print("The json body is \(body)")
        return jsonData
    }
    
    private let user_id: String
    
    private let token: String
    
    private let board_id: String
    
    private let product_id: String
    
    init(user_id: String, token: String, product_id: String, board_id: String) {
        self.user_id = user_id
        self.token = token
        self.board_id = board_id
        self.product_id = product_id
    }
    
    
}

struct GrowaveWishlist: Codable {
    let status: Int?
    let message: String?
    let data: [GrowaveWishlistData]?
}

// MARK: - Datum
struct GrowaveWishlistData: Codable {
    let userID, productID, variantID, boardID: String?
    let date, handle: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case productID = "product_id"
        case variantID = "variant_id"
        case boardID = "board_id"
        case date, handle
    }
}

final class GrowaveWishlistRequest: Requestables {
    typealias Response = GrowaveWishlist
    
    var path: String {
        return "wishlist"
    }
    
    var httpMethod: HTTPsMethods {
        return .get
    }
    
    var headerField: [String : String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "Accept", value: "application/json")
        header.appendingQueryParameter(key: "Content-Type", value: "application/json")
        header.appendingQueryParameter(key: "Authorization", value: "Bearer \(token)")
        return header as! [String : String]
    }
    
    
    var queryParameters: [String : Any] {
        var params: [String: Any] = [:]
        params.appendingQueryParameter(key: "user_id", value: user_id)
        params.appendingQueryParameter(key: "board_id", value: board_id)
        return params as! [String: String]
    }
    
    private let user_id: String
    
    private let token: String
    
    private let board_id: String
    
    init(user_id: String, token: String, board_id: String) {
        self.user_id = user_id
        self.token = token
        self.board_id = board_id
    }
}


struct DeleteGrowaveWishlist: Codable {
    let status: Int?
    let message: String?
}

final class DeleteGrowaveWishlistRequest: Requestables {
    typealias Response = DeleteGrowaveWishlist
    
    var path: String {
        return "wishlist"
    }
    
    var httpMethod: HTTPsMethods {
        return .delete
    }
    
    var headerField: [String : String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "Accept", value: "application/json")
        header.appendingQueryParameter(key: "Content-Type", value: "application/json")
        header.appendingQueryParameter(key: "Authorization", value: "Bearer \(token)")
        return header as! [String : String]
    }
    
    
    var queryParameters: [String : Any] {
        var params: [String: Any] = [:]
        params.appendingQueryParameter(key: "user_id", value: user_id)
        params.appendingQueryParameter(key: "product_id", value: product_id)
        return params as! [String: String]
    }
    
    private let user_id: String
    
    private let token: String
    
    private let product_id: String
    
    init(user_id: String, token: String, product_id: String) {
        self.user_id = user_id
        self.token = token
        self.product_id = product_id
    }
}


final class GrowaveMoveItem: Requestables {
    typealias Response = DeleteGrowaveWishlist
    
    var path: String {
        return "wishlist/moveProduct/"
    }
    
    var httpMethod: HTTPsMethods {
        return .put
    }
    
    var headerField: [String : String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "Accept", value: "application/json")
        header.appendingQueryParameter(key: "Content-Type", value: "application/json")
        header.appendingQueryParameter(key: "Authorization", value: "Bearer \(token)")
        return header as! [String : String]
    }
    
    
    var httpBody: Data? {
        var body: [String: Any] = [:]
        body.appendingQueryParameter(key: "user_id", value: user_id)
        body.appendingQueryParameter(key: "product_id", value: product_id)
        body.appendingQueryParameter(key: "current_board_id", value: current_board_id)
        body.appendingQueryParameter(key: "destination_board_id", value: destination_board_id)
        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted])
        return jsonData
    }
    
    private let user_id: String
    
    private let product_id: String
    
    private let current_board_id: String
    
    private let destination_board_id: String
    
    private let token: String
    
    init(user_id: String, product_id: String, current_board_id: String, destination_board_id: String, token: String){
        self.user_id = user_id
        self.product_id = product_id
        self.token = token
        self.current_board_id = current_board_id
        self.destination_board_id = destination_board_id
    }
}
