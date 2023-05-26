//
//  InstaViewModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 22/07/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
class InstaViewModel{

    let data: [InstagramMedia]?
    
    init(from model:Feed) {
        print(model)
        data = model.data
    }
}
