//
//  HomeBannerSliderViewModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 03/09/19.
//  Copyright © 2019 MageNative. All rights reserved.
//

import Foundation

class HomeBannerSliderViewModel {
  
    let active_dot_color : UIColor?
    let choiceList :  String?
    let inactive_dot_color : UIColor?
    let item_dots :  String?
    let item_total :  String?
    let items :[[String:String]]?
    let timestamp :  String?
    let type :  String?
    let uniqueId :  String?
    let item_image_size: String?
    let banner_shape: String?
    let cornerRadius: String?
    let containerPadding: String?
    
    init(from model:[String:Any]) {
         self.active_dot_color = calculateColor(strA:model["active_dot_color"] as? String)
         self.choiceList = model["choiceList"] as? String
         self.inactive_dot_color = calculateColor(strA:model["inactive_dot_color"] as? String)
         self.item_dots = model["item_dots"] as? String
        
        self.item_total = model["item_total"] as? String
        self.timestamp = model["timestamp"] as? String
        self.type = model["type"] as? String
        self.uniqueId = model["uniqueId"] as? String
        self.items = model["items"] as? [[String:String]]
        self.item_image_size = model["item_image_size"] as? String
        self.banner_shape = model["banner_shape"] as? String
        self.cornerRadius = model["corner_radius"] as? String
        self.containerPadding = model["container_padding"] as? String
    }
}
