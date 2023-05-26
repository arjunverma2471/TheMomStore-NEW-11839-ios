//
//  GrowaveRewardModels.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 27/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
struct GrowaveSpendModel {
    let rule_id : String
    let reward_amount :  String
    let title : String
    let type : String
    let price : Double
    
    
    init(json:JSON) {
        rule_id = json["rule_id"].stringValue
        reward_amount = json["reward_amount"].stringValue
        title = json["title"].stringValue
        type = json["type"].stringValue
        price = json["price"].doubleValue
        
    }
}



struct GrowaveEarnModel {
    let rule_id : String
    let rule_type :  String
    let title : String
    let discount_id : String
    let points : Double
    let imageUrl : String?
    let instaUrl:String?
    
    
    init(json:JSON) {
        rule_id = json["rule_id"].stringValue
        rule_type = json["rule_type"].stringValue
        title = json["title"].stringValue
        discount_id = json["discount_id"].stringValue
        points = json["points"].doubleValue
        imageUrl = json["image_url"].stringValue
        instaUrl = json["additional_info"]["instagram_account"].stringValue
        
    }
}

struct GrowaveTierModel {
    let tier_id : String
    let tier_title : String
    let description : String
    let multiply_points : String
    let state : String
    
    init(json:JSON) {
        
        tier_id = json["tier_id"].stringValue
        tier_title = json["tier_title"].stringValue
        description = json["description"].stringValue
        multiply_points = json["multiply_points"].stringValue
        state = json["state"].stringValue
        
        
    }
    
}

struct GrowavePointActivityModel {
    let title : String
    let type : String
    let id : String
    let earnedPoints : String
    let spendPoints : String
    let rewarding_type : String
    let creation_time : Double
    let manualTitle : String?
    let spendingTitle : String?
    
    init(json:JSON){
        title = json["earning_rule"]["title"].stringValue
        type = json["type"].stringValue
        id = json["earning_rule"]["id"].stringValue
        earnedPoints = json["earned"].stringValue
        spendPoints = json["spend"].stringValue
        rewarding_type = json["rewarding_type"].stringValue
        creation_time = json["creation_time"].doubleValue
        manualTitle = json["rewarding_params"]["comment"].stringValue
        spendingTitle = json["spending_rule"]["title"].stringValue
        
    }
}

struct GrowaveDiscountModel {
    let discount_code : String
    let title : String
    let type : String
    
    init(json:JSON) {
        discount_code = json["discount_code"].stringValue
        title = json["title"].stringValue
        type = json["type"].stringValue
    }
}
