//
//  Model3D.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 06/04/20.
//  Copyright © 2020 MageNative. All rights reserved.
//

import UIKit
struct Model3D{
    var mediaContentType: String?
    var __typename: String?
    var sources: [Sources]?
}

struct Sources{
    var format: String?
    var mimeType: String?
    var url: String?
}
