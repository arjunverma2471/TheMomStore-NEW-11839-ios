//
//  CurrencyViewModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 01/02/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
class CurrencyViewModel: ViewModel {
    typealias ModelType =  MobileBuySDK.Storefront.Localization
    let model: ModelType?
    let currencyIsoCode:[String]?
    let currencyName:[String]?
    let currencySymbol:[String]?
    let countryIsoCode:[String]?
    let countryName:[String]?
    let countryUnitSystem:[String]?
    var nameIsoCode: [countryCurrency]?
    var availableLanguagesData: [AvailableLanguage]?
    
    
    required init(from model: ModelType) {
        self.model = model
      
        self.currencyIsoCode = model.availableCountries.map{$0.currency.isoCode.rawValue}
        self.currencyName = model.availableCountries.map{$0.currency.name.description}
        self.currencySymbol = model.availableCountries.map{$0.currency.symbol.description}
        self.countryIsoCode = model.availableCountries.map{$0.isoCode.rawValue}
        self.countryName = model.availableCountries.map{$0.name.description}
        self.countryUnitSystem = model.availableCountries.map{$0.unitSystem.rawValue}
        let val = model.availableCountries.map{
           countryCurrency(code: $0.isoCode.rawValue, name: $0.name.description, currencyCode: $0.currency.isoCode.rawValue)
        }
        self.nameIsoCode = val
      
      let data = model.availableLanguages.map({ lang in
        AvailableLanguage(code: lang.isoCode.rawValue, name: lang.name.description, endonymName: lang.endonymName)
      })
      self.availableLanguagesData = data
    }
}

extension MobileBuySDK.Storefront.Localization:ViewModeling{
    typealias ViewModelType = CurrencyViewModel
}
class countryCurrency{
    let code : String
    let name : String
    let currencyCode : String
    init(code : String , name :String ,currencyCode:String) {
        self.code = code
        self.name = name
        self.currencyCode = currencyCode
    }
}


class AvailableLanguage{
   init(code: String, name: String, endonymName: String) {
    self.code = code
    self.name = name
    self.endonymName = endonymName
  }
  
  let code: String
  let name: String
  let endonymName: String
}
