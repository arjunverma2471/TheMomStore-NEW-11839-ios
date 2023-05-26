//
//  HomeAnnouncementBarViewModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 09/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
import UIKit
class HomeAnnouncementBarViewModel {
  
    
    let type : String?
    let timestamp : String?
    let uniqueId : String?
    let bar_type : String?
    let bar_text : String?
    let bar_text_alignment : NSTextAlignment?
    let bar_text_marquee : String?
    let marquee_text_direction : String?
    let marquee_text_speed : TimeInterval?
    let link_type : String?
    let link_value : String?
    let active_dot_color : (String?,Float?,String?)
    let inactive_dot_color : (String?,Float?,String?)
    let background_color : (String?,Float?,String?)
    let text_color : (String?,Float?,String?)
    let item_dots : String?
    let item_total : String?
    let items :[[String:String]]?
    let image_link_type: String?
    let image_link_value: String?
    let image_link: URL?
    let text_link_type : String?
    let text_link_value : String?
    
    init(from model:[String:Any]) {
        self.type = model["type"] as? String
        self.timestamp = model["timestamp"] as? String
        self.uniqueId = model["uniqueId"] as? String
        self.bar_type = model["bar_type"] as? String
        self.bar_text = model["bar_text"] as? String
        self.bar_text_marquee = model["bar_text_marquee"] as? String
        self.marquee_text_direction = model["marquee_text_direction"] as? String
        self.marquee_text_speed = (model["marquee_text_speed"] as? String)?.convertToTimeInterval()
        self.active_dot_color = calculateHexCode(strA: model["active_dot_color"] as? String)
        self.inactive_dot_color = calculateHexCode(strA: model["inactive_dot_color"] as? String)
        self.background_color = calculateHexCode(strA: model["background_color"] as? String)
        self.text_color = calculateHexCode(strA: model["text_color"] as? String)
        self.item_dots = model["item_dots"] as? String
        self.item_total = model["item_total"] as? String
        self.items = model["items"] as? [[String:String]]
        self.link_type = model["link_type"] as? String
        self.link_value = model["link_value"] as? String
        self.image_link = URL(string:(model["image_link"] as? String) ?? "")
        self.image_link_type = model["image_link_type"] as? String
        self.image_link_value = model["image_link_value"] as? String
        self.text_link_type = model["text_link_type"] as? String
        self.text_link_value = model["text_link_value"] as? String
        switch model["bar_text_alignment"] as? String {
        case "center":
              self.bar_text_alignment = .center
        case "right":
              self.bar_text_alignment = .right
        default:
              self.bar_text_alignment = .left
        }
    }
    
}


func calculateHexCode(strA:String?)->(hex:String, opacity:Float?, rgba :String?) {
    if let js = strA {
        
    let json = try? JSON(data:(js).data(using: .utf8)!).dictionary
        if let str = json?["color"]?.stringValue , let opacity = json?["opacity"]?.floatValue, let rgba = json?["rgbastring"]?.stringValue{
            return (str,opacity,rgba)
        }
    }
    return ("",0.0,"")
}
