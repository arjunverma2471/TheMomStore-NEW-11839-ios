//
//  CurrencyCode.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 08/02/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
public class CurrencyCode {
    
    public static let shared = CurrencyCode()
    
    public var currencyCode : String
    
    private init() {
        currencyCode = ""
    }
    
    public func saveCurrencyCode(code : String) {
        currencyCode = code
    }
    
    public func getCurrencyCode() -> String {
        return currencyCode
    }
    
}
