//
//  BoostCommerceModels.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 15/07/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation

// MARK: - BCSearchProductsModel
// Start
struct BCSearchProductsModel: Decodable {
    var allEmpty: Bool?
    var totalProduct: Int?
    var products: [Product]?
    var suggestions: [String]?
    var collections: [Collection]?
//    var pages, didYouMean: [Any?]?
    var query: String?
//    var eventType: NSNull?
}

// MARK: - Collection
struct Collection: Decodable {
    var image: Image?
    var templateSuffix, handle: String?
    var id: Int?
    var title, sortValue: String?
}

// MARK: - Image
struct Image: Decodable {
    var src: String?
//    var alt: NSNull?
    var width: Int?
    var createdAt: Date?
    var height: Int?
}

// MARK: - Product
struct Product: Decodable {
  
    var bodyHTML: String?
    var title: String?
    var priceMin: Double?
    var id: Int?
    var images: [String: String]?
//    var priceMax: String?
    var compareAtPriceMin: Double?
  
  
//    var skus: [String]?
//    var available: Bool?
//    var createdAt: Date?
//    var reviewCount: Int?
//    var imagesInfo: [ImagesInfo]?
//    var reviewRatings: Int?
//    var updatedAt: Date?
//    var displayBn, displayFr: Display?
//    var collections: [Collection]?
//    var vendor: String?
//    var percentSaleMin, bestSellingRank: Int?
//    var publishedAt: Date?
//    var optionsWithValues: [OptionsWithValue]?
//    var displayHi, displayNl: Display?
//    var handle: String?
//    var barcodes, tags: [String]?
//    var publishedScope: String?
//    var productType: String?
//    var displayAr: Display?
//    var displayKo: Display?
    
//  init(from decoder: Decoder) throws {
//      let container = try decoder.container(keyedBy: CodingKeys.self)
//      bodyHTML        = try container.decode(String.self, forKey: CodingKeys.bodyHTML)
//      title          = try container.decode(String.self, forKey: CodingKeys.title)
//      priceMin        = try container.decode(String.self, forKey: CodingKeys.priceMin)
//
//
//       let minutes     = try container.decode(String.self, forKey: CodingKeys.valMinutes)
//
//      if let index = minutes.range(of: ".")?.lowerBound {
//          let substring = minutes[..<index]
//          let string = String(substring)
//          valMinutes = string
//      }else{
//          valMinutes = minutes
//      }
//  }
}

// MARK: - Display
struct Display: Decodable {
    var bodyHTML, title: String?
}

// MARK: - ImagesInfo
struct ImagesInfo: Decodable {
    var src: String?
    var width: Int?
//    var alt: NSNull?
    var id, position, height: Int?
}

// MARK: - OptionsWithValue
struct OptionsWithValue: Decodable {
    var values: [Value]?
    var name, label: String?
}

// MARK: - Value
struct Value: Decodable {
    var image: String?
    var title: String?
}

// MARK: - Variant
//struct Variant {
//    var mergedOptions: [String]?
//    var inventoryQuantity: Int?
//    var image, compareAtPrice: NSNull?
//    var inventoryManagement, fulfillmentService: String?
//    var available: Bool?
//    var title, inventoryPolicy, price: String?
//    var id: Int?
//    var sku, barcode: String?
//}

//END
