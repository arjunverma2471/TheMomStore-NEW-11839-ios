//
//  HomeCollectionGridLayoutViewModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 04/09/19.
//  Copyright © 2019 MageNative. All rights reserved.
//

import Foundation
class HomeCollectionGridLayoutViewModel{
    let  cell_background_color : UIColor?
    let  item_border : String?
    let  item_border_color : UIColor?
    let  item_font_style :  String?
    let  item_font_weight :  String?
    let  item_in_a_row :  String?
    let  item_rows :  String?
    let  item_shape :  String?
    let  item_text_alignment :  String?
    let  item_title :  String?
    let  item_title_color : UIColor?
    let  items : [[String:String]]?
    let  panel_background_color : UIColor?
    let  selection_type :  String?
    let  timestamp :  String?
    let  type :  String?
    let  uniqueId :  String?
    let  validated :  String?
    let header : String?
    let  header_title_color : UIColor?
    let  header_title_text :String?
    
    init(from model:[String:Any]) {
        cell_background_color = calculateColor(strA:  model["cell_background_color"])
        item_border = model["item_border"] as? String
        item_border_color = calculateColor(strA: model["item_border_color"] as? String)
        item_font_style = model["item_font_style"] as? String
        item_font_weight = model["item_font_weight"] as? String
        item_in_a_row = "3"
//      item_in_a_row = model["item_in_a_row"] as? String
        item_rows = model["item_rows"] as? String
        item_shape = model["item_shape"] as? String
        item_text_alignment = model["item_text_alignment"] as? String
        item_title = model["item_title"] as? String
        item_title_color = calculateColor(strA: model["item_title_color"] as? String)
        items = model["items"] as? [[String:String]]
        panel_background_color = calculateColor(strA: model["panel_background_color"] as? String)
        selection_type = model["selection_type"] as? String
        timestamp = model["timestamp"] as? String
        type = model["type"] as? String
        uniqueId = model["uniqueId"] as? String
        validated = model["validated"] as? String
        header_title_text = model["header_title_text"] as? String
        header_title_color = calculateColor(strA: model["header_title_color"] as? String)
        header = model["header"] as? String
    }
}
