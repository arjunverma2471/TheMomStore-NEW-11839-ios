//
//  FlitsCreditModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 10/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct FlitsCreditModel:Decodable {
    let status: Bool?
    let customer: Customer?
}

// MARK: - Customer
struct Customer:Decodable  {
    let id, customerID: Int?
    let name, email: String?
    let isFromShopify, isFromMailchimp, acceptsMarketing, isSubscriber: Int?
    let state: String?
//    let phone, birthdate, gender: NSNull?
    let points, isRegisterGiven, isSubscriberGiven: Int?
    let isFirstOrderGiven: Int?
    let referralCode: String?
//    let referBy: NSNull?
    let verifiedEmail, ordersCount, totalSpent: Int?
//    let lastOrderID, lastOrderName, lastOrderCreatedAt: NSNull?
    let currency: String?
//    let note: NSNull?
    let createdAt, updatedAt: String?
    let refundCredits, promotionalCredits: Int?
    let acceptsMarketingUpdatedAt: String?
//    let marketingOptInLevel: NSNull?
    let lastSyncedAt, shopifyCreatedAt, shopifyUpdatedAt: String?
    let credits,totalSpentCredits,totalEarnedCredits: Double?
    let creditLog, earnedCredits, spentCredits: [CreditLog]?
}

// MARK: - CreditLog
struct CreditLog:Decodable  {
    let id, shopifyCustomerId, credits: Double?
    let comment: String?
    let ruleId: Int?
    let columnValue: String?
    let creditTypeId, usedCredits, currentCredits: Double?
//    let creditFrom, expiryDate, orderID: NSNull?
    let createdAt, updatedAt: String?
//    let deletedAt: NSNull?
//    let metafields: [Any?]?
}
