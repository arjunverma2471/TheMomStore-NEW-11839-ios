//
//  UIColor+Extension.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 30/01/20.
//  Copyright © 2020 MageNative. All rights reserved.
//

import Foundation

struct mageColor{
    static var labelTextColor: UIColor = {
        if #available(iOS 13.0, *) {
          return UIColor { (UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark { return UIColor.red }
            else { return UIColor.black }
          }
        } else {
            return UIColor.black
        }
    }()
}
