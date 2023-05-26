//
//  ReviewsIOModels.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 30/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
struct ReviewIOModel {
    
    var type : String?
    var type_label : String?
    var rating : String?
    var title : String?
    var author : String?
    var comments : String?
    var date_created : String?
    var source : String?
    
    init(json:JSON) {
        type = json["type"].stringValue
        type_label = json["type_label"].stringValue
        rating = json["rating"].stringValue
        title = json["title"].stringValue
        author = json["author"]["name"].stringValue
        comments = json["comments"].stringValue
        date_created = json["date_created"].stringValue
        source = json["source"].stringValue
        
    }
    
}
