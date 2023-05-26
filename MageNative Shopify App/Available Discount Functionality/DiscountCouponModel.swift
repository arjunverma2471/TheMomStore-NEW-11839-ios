//
//  DiscountCouponModel.swift
//  MageNative Shopify App
//
//  Created by Yash Pratap Singh sisodia on 24/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation




import Foundation
struct CouponResponse : Codable {
    let data : [CouponData]?
    let success : Bool?

    enum CodingKeys: String, CodingKey {

        case data = "data"
        case success = "success"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([CouponData].self, forKey: .data)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
    }

}

struct CouponData : Codable {
    let discount : DiscountCouponModel?

    enum CodingKeys: String, CodingKey {

        case discount = "discount"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        discount = try values.decodeIfPresent(DiscountCouponModel.self, forKey: .discount)
    }

}



struct DiscountCouponModel : Codable {
    let typename : String?
    let appliesOncePerCustomer : Bool?
    let asyncUsageCount : Int?
    let createdAt : String?
    let startsAt : String?
    let endsAt : String?
    let hasTimelineComment : Bool?
    let recurringCycleLimit : Int?
    let shortSummary : String?
    let summary : String?
    let status : String?
    let title : String?
//    let usageLimit : String?

    enum CodingKeys: String, CodingKey {

        case typename = "__typename"
        case appliesOncePerCustomer = "appliesOncePerCustomer"
        case asyncUsageCount = "asyncUsageCount"
        case createdAt = "createdAt"
        case startsAt = "startsAt"
        case endsAt = "endsAt"
        case hasTimelineComment = "hasTimelineComment"
        case recurringCycleLimit = "recurringCycleLimit"
        case shortSummary = "shortSummary"
        case summary = "summary"
        case status = "status"
        case title = "title"
//        case usageLimit = "usageLimit"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        typename = try values.decodeIfPresent(String.self, forKey: .typename)
        appliesOncePerCustomer = try values.decodeIfPresent(Bool.self, forKey: .appliesOncePerCustomer)
        asyncUsageCount = try values.decodeIfPresent(Int.self, forKey: .asyncUsageCount)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        startsAt = try values.decodeIfPresent(String.self, forKey: .startsAt)
        endsAt = try values.decodeIfPresent(String.self, forKey: .endsAt)
        hasTimelineComment = try values.decodeIfPresent(Bool.self, forKey: .hasTimelineComment)
        recurringCycleLimit = try values.decodeIfPresent(Int.self, forKey: .recurringCycleLimit)
        shortSummary = try values.decodeIfPresent(String.self, forKey: .shortSummary)
        summary = try values.decodeIfPresent(String.self, forKey: .summary)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        title = try values.decodeIfPresent(String.self, forKey: .title)
//        usageLimit = try values.decodeIfPresent(String.self, forKey: .usageLimit)
    }

}
