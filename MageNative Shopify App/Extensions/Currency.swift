//
//  Currency.swift
//  Storefront
//
//  Created by Shopify.
//  Copyright (c) 2017 Shopify Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

// Use below function in case of currency switching
struct Currency {
  
  static let formatter: NumberFormatter = {
    let formatter         = NumberFormatter()
    formatter.numberStyle = .currency
      formatter.currencyCode = CurrencyCode.shared.getCurrencyCode()//Client.shared.getCurrencyCode()
      formatter.locale = Locale(identifier: "en")
    return formatter
  }()
  
  
  static func stringFrom(_ decimal: Decimal) -> String {
    let currency = CurrencyCode.shared.getCurrencyCode()//Client.shared.getCurrencyCode()
    var currentrating = Decimal()
    var bydefaultrating = Decimal()
 
    formatter.currencyCode = currency
    if let rating = UserDefaults.standard.value(forKey: "rates") as? [String:Any]{
      for (key,value) in rating
      {
        if key == currency
        {
          bydefaultrating = Decimal(string: String(describing: value))!
          
        }
        if key == CurrencyCode.shared.getCurrencyCode()//Client.shared.getCurrencyCode()
        {
          currentrating = Decimal(string: String(describing: value))!
        }
      }
    }
    let price = ((decimal*bydefaultrating)/currentrating)
    return self.formatter.string(from: price as NSDecimalNumber)!
  }
}

