//
//  HomeTopBarViewModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 14/09/19.
//  Copyright © 2019 MageNative. All rights reserved.
//

import Foundation
import UIKit
class HomeTopBarViewModel{
  let active_dot_color : UIColor?
  let count_color : UIColor?
  let count_textcolor : UIColor?
  let icon_color : UIColor?
  let  inactive_dot_color :UIColor?
  let  item_banner : String?
  let  item_dots : String?
  let  item_total :String?
  let  logo_image_url :URL?
  let  panel_background_color : UIColor?
  let  search_background_color :UIColor?
  let  search_border_color :UIColor?
  let  search_placeholder : String?
  let search_position : String?
  let search_text_color :UIColor?
  let shape : String?
  let timestamp : String?
  let type : String?
  let  uniqueId : String?
  let wishlist : Bool?
  let items:[[String:String]]?
  
  init(from model:[String:Any]) {
    self.active_dot_color = calculateColor(strA: model["active_dot_color"] as? String)
    self.count_color = calculateColor(strA: model["count_color"] as? String)
    self.count_textcolor = calculateColor(strA: model["count_textcolor"] as? String)
    self.icon_color = calculateColor(strA: model["icon_color"] as? String)
    self.inactive_dot_color = calculateColor(strA: model["inactive_dot_color"] as? String)
    self.item_banner =  model["item_banner"] as? String
    self.item_dots =  model["item_dots"] as? String
    
    self.item_total =  model["item_total"] as? String
    self.logo_image_url =  (model["logo_image_url"] as? String)?.getURL()
    
    self.panel_background_color = calculateColor(strA: model["panel_background_color"] as? String)
    self.search_background_color = calculateColor(strA: model["search_background_color"] as? String)
    self.search_border_color = calculateColor(strA: model["search_border_color"] as? String)
    self.search_placeholder = model["search_placeholder"] as? String
    self.search_position =  model["search_position"] as? String
    self.search_text_color = calculateColor(strA: model["search_text_color"] as? String)
    self.shape =  model["shape"] as? String
    self.timestamp =  model["timestamp"] as? String
    self.type =  model["type"] as? String
    self.uniqueId =  model["uniqueId"] as? String
    self.wishlist =  ((model["wishlist"] as? String) == "0" ? false : true)
    self.items = model["items"] as? [[String:String]]
    UIColor.iconColor = calculateColor(strA: model["icon_color"] as? String) ?? UIColor.red
  }
    
    
  
}
