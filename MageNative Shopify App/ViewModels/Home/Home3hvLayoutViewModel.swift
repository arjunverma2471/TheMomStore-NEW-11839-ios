//
//  Home3hvLayoutViewModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 04/09/19.
//  Copyright © 2019 MageNative. All rights reserved.
//

import Foundation
class  Home3hvLayoutViewModel {
    let  header : String?
    let  header_action : String?
    let  header_action_background_color :UIColor?
    let  header_action_color :UIColor?
    let  header_action_font_style :String?
    let  header_action_font_weight : String?
    let  header_action_text :String?
    let  header_background_color : UIColor?
    let  header_deal :String?
    let  header_deal_color : UIColor?
    let  header_subtitle : String?
    let  header_subtitle_color : UIColor?
    let  header_subtitle_font_style : String?
    let  header_subtitle_font_weight : String?
    let  header_subtitle_text : String?
    let  header_title_color : UIColor?
    let  header_title_font_style : String?
    let  header_title_font_weight : String?
    let  header_title_text : String?
    let  item_border : String?
    let  item_border_color : UIColor?
    let  item_deal_end_date : String?
    let  item_deal_format : String?
    let  item_deal_message : String?
    let  item_deal_start_date : String?
    let  item_shape :String?
    let  item_text_alignment :String?
    let  item_title_font_style :String?
    let  item_title_font_weight : String?
    let  items : [[String:Any]]?
    let  link_type : String?
    let  panel_background_color : UIColor?
    let  timestamp : String?
    let  type :String?
    let  uniqueId : String?
    let  validated : String?
    
    init(from model:[String:Any]) {
        self.header_title_font_style = model["header_title_font_style"] as? String
        self.header_title_color = calculateColor(strA: model["header_title_color"] as? String)
        self.header = model["header"] as? String
        self.header_action = model["header_action"] as? String
        self.header_action_background_color = calculateColor(strA:model["header_action_background_color"] as? String)
        self.header_action_color = calculateColor(strA:model["header_action_color"] as? String)
        self.header_action_font_style = model["header_action_font_style"] as? String
        self.header_action_font_weight = model["header_action_font_weight"] as? String
        self.header_action_text = model["header_action_text"] as? String
        self.header_background_color = calculateColor(strA:model["header_background_color"] as? String)
        self.header_deal = model["header_deal"] as? String
        self.header_deal_color = calculateColor(strA:model["header_deal_color"] as? String)
        self.header_subtitle_font_style = model["header_subtitle_font_style"] as? String
        self.header_subtitle = model["header_subtitle"] as? String
        self.header_subtitle_color = calculateColor(strA:model["header_subtitle_color"] as? String)
        self.header_subtitle_text = model["header_subtitle_text"] as? String
        self.header_subtitle_font_weight = model["header_subtitle_font_weight"] as? String
        self.header_title_font_weight = model["header_title_font_weight"] as? String
        self.header_title_text = model["header_title_text"] as? String
        self.item_border = model["item_border"] as? String
        self.item_border_color = calculateColor(strA:model["item_border_color"] as? String)
        
        self.item_deal_end_date = model["item_deal_end_date"] as? String
        self.item_shape = model["item_shape"] as? String
        self.item_text_alignment = model["item_text_alignment"] as? String
        self.item_title_font_style = model["item_title_font_style"] as? String
        
        self.item_title_font_weight = model["item_title_font_weight"] as? String
        self.items = model["items"] as? [[String:Any]]
        self.link_type = model["link_type"] as? String
        self.panel_background_color = calculateColor(strA:model["panel_background_color"] as? String)
        
        self.timestamp = model["timestamp"] as? String
        self.type = model["type"] as? String
        self.uniqueId = model["uniqueId"] as? String
        self.validated = model["validated"] as? String
        self.item_deal_format = model["item_deal_format"] as? String
        self.item_deal_message = model["item_deal_message"] as? String
        self.item_deal_start_date = model["item_deal_start_date"] as? String
    }
}
