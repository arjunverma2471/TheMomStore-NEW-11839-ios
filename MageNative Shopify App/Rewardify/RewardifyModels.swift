//
//  RewardifyModels.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 21/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation

struct RewardifyTransactionModel: Decodable {
    let id: Int?
//    let shopifyID: String?
    let shopifyCustomerID, transactionType: String?
    let effectiveAt: String?
    let customerOpenBalance, amount, amountCurrency: String?
//    let memo: String?
    let expiresAt, expiredAt: String?
}


struct RewardifyAccountModel: Decodable {
    let currency: String?
    let customer: RewardifyCustomer?
    let amount: String?
}

// MARK: - Customer
struct RewardifyCustomer: Decodable {
    let email: String?
    let phone, deletedAt: String?
    let totalSpent, subtotalSpent: String?
    let acceptsMarketing: Bool?
    let firstName: String?
    let note: String?
    let shopifyId, shopifyState, lastName: String?
}

// MARK: - Discount
struct RewardifyDiscount: Decodable {
    let shopifyId, shopifyPriceRuleID: Int?
    let code, tag: String?
    let endsAt: String?
    let amount, amountType: String?
    let minOrderAmount: Int?
    let currency: String?
    let deletedAt: String?
}


// MARK: - DiscountListing
struct DiscountListingModel: Decodable {
    let shopifyId, shopifyPriceRuleID, code, tag: String?
    let endsAt: String?
    let amount, amountType, minOrderAmount, currency: String?
    let deletedAt: String?
}
