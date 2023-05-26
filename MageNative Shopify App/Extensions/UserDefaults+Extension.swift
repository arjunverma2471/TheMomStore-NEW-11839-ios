//
//  UserDefaults+Extension.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 28/05/20.
//  Copyright © 2020 MageNative. All rights reserved.
//

import Foundation
extension UserDefaults {

    func valueExists(forKey key: String) -> Bool {
        return object(forKey: key) != nil
    }

}
