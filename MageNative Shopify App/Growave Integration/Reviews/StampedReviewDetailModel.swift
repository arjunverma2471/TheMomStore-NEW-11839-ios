//
//  stampedReviewDetailModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 16/09/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
// MARK: - Welcome
struct StampedReviewDetailModel:Decodable {
    let c: Bool?
    let page: Int?
    let data: [Datum]?
    let lang, shop, template: String?
    let elementId, total, totalAll, totalAllWithNPS: Int?
    let rating, ratingAll: Int?
    let isPro: Bool?
}

// MARK: - Datum
struct Datum:Decodable{
    let id: Int?
    let author, reviewTitle, reviewMessage: String?
    let reviewRating: Int?
    let reviewDate: String?
    let reviewUserPhotos: String?
    let reviewVerifiedType: Int?
    let reviewReply: String?
    let productID: Int?
    let productName: String?
    let productSKU: String?
    let shopProductId: Int?
    let productURL: String?
    let productImageURL: String?
    let productImageLargeURL: String?
    let productImageThumbnailURL: String?
    let avatar: String?
    
    let reviewVotesUp, reviewVotesDown: Int?
    let dateCreated: String?
    let isRecommend: Bool?
    let reviewType: Int?
    let widgetType: String?
//    let reviewOptionsList: [Any?]?
    let featured: Bool?
    let reviewUserPhotosWatermark: String?
}






