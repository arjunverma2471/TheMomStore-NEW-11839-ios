//
//  HomeSpacerViewModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 08/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation

class HomeSpacerViewModel {
  
    let spacerColor : UIColor?
    let spacerHeight : Int?
    let uniqueID: String?
 
    
    init(from model:[String:Any]) {
         self.spacerColor = calculateColor(strA:model["background_color"] as? String)
         var heightStr = model["height"] as? String ?? "0"
         let heightInt = Int(heightStr) ?? 0
        self.spacerHeight = heightInt
        self.uniqueID = model["uniqueId"] as? String
    }
}
