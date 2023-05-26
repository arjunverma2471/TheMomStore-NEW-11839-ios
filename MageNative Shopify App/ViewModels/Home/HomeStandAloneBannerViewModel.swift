//
//  HomeStandAloneBannerViewModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 03/09/19.
//  Copyright © 2019 MageNative. All rights reserved.
//

import Foundation

class HomeStandAloneBannerViewModel {
    
    let type: String?
    let timestamp: String?
    let uniqueId: String?
    let item_button_count: String?
    let item_button_position: String?
    let item_text_alignment: String?
    let first_button_text: String?
    let second_button_text: String?
    var button_background_color: UIColor?
    var button_border_color: UIColor?
    var button_text_color: UIColor?
    let item_font_weight: String?
    let item_font_style: String?
    let banner_url: URL?
    let first_button_link_type: String?
    let first_button_link_value: String?
    let second_button_link_type: String?
    let second_button_link_value: String?
    let banner_link: String?
    let banner_link_value: String?
    let item_image_size: String?
    
    init(from model:[String:Any]) {
        self.type = model["type"] as? String
        self.timestamp = model["timestamp"] as? String
        self.uniqueId = model["uniqueId"] as? String
        self.item_button_count = model["item_button_count"] as? String
        self.item_button_position = model["item_button_position"] as? String
        self.item_text_alignment = model["item_text_alignment"] as? String
        self.first_button_text = model["first_button_text"] as? String
        self.second_button_text = model["second_button_text"] as? String
        self.item_font_weight = model["item_font_weight"] as? String
        self.item_font_style = model["item_font_style"] as? String
        self.banner_url = URL(string:(model["banner_url"] as? String) ?? "")
        self.first_button_link_type = model["first_button_link_type"] as? String
        self.first_button_link_value = model["first_button_link_value"] as? String
        self.second_button_link_type = model["second_button_link_type"] as? String
        self.second_button_link_value = model["second_button_link_value"] as? String
        self.banner_link = model["banner_link_type"] as? String
        self.banner_link_value = model["banner_link_value"] as? String
        
        self.button_border_color = calculateColor(strA: model["button_border_color"] as? String)
        self.button_background_color = calculateColor(strA:model["button_background_color"] as? String )
        self.button_text_color = calculateColor(strA: model["button_text_color"] as? String)
        self.item_image_size = model["item_image_size"] as? String
    }
    
}
