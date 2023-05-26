//
//  FastSimonModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 12/07/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation

// MARK: - FastSimonAutoCompleteProduct
// START

struct FastSimonAutoCompleteProductModel: Decodable {
    let uuid: String?
    let items: [Item]?
    let totalResults: Int?
    let term: String?
    let ispQuickViewMode: Int?
    let autoFacets: Bool?
}

// MARK: - Item
struct Item: Decodable {
    let l: String?
    let c: String?
    let u, p, pMin, pMax: String?
    let pC, pMinC, pMaxC, d: String?
    let t: String?
    let t2: String?
    let f: Int?
    let s, sku: String?
    let pSpl: Int?
    let id: String?
    let skus: [String]?
    let v: String?
    let b: [String]?
}
// END
/*
// MARK: - FastSimonUpCrossProductsModel
struct FastSimonUpCrossSellProductModel: Decodable {
    let categories: String?
    let fromProduct: Int?
    let sources, title, widgetId: String?
    let products: [FSProduct]?
}

// MARK: - Product
struct FSProduct: Decodable {
    let l, u, id: String?
    let t: String?
    let sku, c, p, pC: String?
    let pMin, pMax, pMinC, pMaxC: String?
    let iso: Bool?
    let skus: [String]?
    let vC: String?
}
//END
*/

// MARK: - Welcome
struct FastSimonUpCrossSellProductModel: Decodable {
    let uuid: String
    let widget_responses: [WidgetResponse]


}

// MARK: - WidgetResponse
struct WidgetResponse: Decodable {
    let products: [FSProduct]
    let categories: String?
    let from_product: Int
    let sources, title, widget_id: String
}

// MARK: - Product
struct FSProduct: Decodable {
    let t2: String
    let p_min_c, u, p_max: String
    let skus: [String]
    let d, id: String
    let b: [String]?
    let p_c: String
    let t: String
    let sku, c: String
    let rec_src, f, p_spl: Int
    let p_max_c, v: String
    let iso: Bool
    let s, l: String
    let v_c: Int
    let p, p_min: String
    

}
