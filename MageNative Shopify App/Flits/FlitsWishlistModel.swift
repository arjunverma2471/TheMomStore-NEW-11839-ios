//
//  FlitsWishlistModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 28/07/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation


// MARK: - Welcome
struct FlitsWishlistModel: Decodable {
    var status: Bool?
    var data: [WishlistDatum]?
    var count: Int?
}

// MARK: - Datum
struct WishlistDatum: Decodable {
    var id: Int?
    var customerEmail: String?
    var productId: Int?
    var productHandle, productTitle: String?
    var customerID: Int?
    var updatedAt, createdAt: String?
    var customersCount: Int?
    var productImage: String?
}
