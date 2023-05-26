//
//  FlitsGetRuleInfoModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 26/07/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation


// MARK: - Welcome
struct FlitsGetRuleInfoModel:Decodable {
    var rules: Rules?
}

// MARK: - Rules
struct Rules:Decodable {
    var allRulesData: [AllRulesDatum]?
}

// MARK: - AllRulesDatum
struct AllRulesDatum:Decodable {
    var ruleID, isFixed, credits: Int?
    var columnValue, moduleOn, title, description: String?
    var image: String?
    var isDefaultRule: Bool?
    var tabToAppend: String?
//    var avails: [Any?]?
    var relation: String?
    var isEarned: Bool?
}
