//
//  NavigationViewModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 21/04/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import MobileBuySDK

//class NavigationViewModel: ViewModel {
//
//  typealias ModelType =  MobileBuySDK.Storefront.Menu
//  let model           : ModelType?
//  let menuTitle       : String?
//  let menuID          : String?
//  let menuHandle      : String?
//  let menuItems       : [MobileBuySDK.Storefront.MenuItem]?
//
//  required init(from model: ModelType) {
//    self.model        = model
//    self.menuTitle    = model.title
//    self.menuID       = model.id.rawValue
//    self.menuHandle   = model.handle
//    self.menuItems    = model.items
//  }
//}
//
//extension MobileBuySDK.Storefront.Menu:ViewModeling{
//  typealias ViewModelType = NavigationViewModel
//}


class NavigationMenuItemViewModel: ViewModel {
  typealias ModelType =  MobileBuySDK.Storefront.MenuItem
  let model              : ModelType?
  let menuTitle       : String?
  let menuID          : String?
  let menuUrl         : URL?
  let menuType        : String?
  let menuItems       : [NavigationMenuItemViewModel]?
 
  
  required init(from model: ModelType) {
    self.model           = model
    self.menuTitle       = model.title
    self.menuID          = model.resourceId?.rawValue.sub()
    self.menuUrl         = model.url
    self.menuType        = model.type.rawValue
    self.menuItems       = model.items.map({ item in
        NavigationMenuItemViewModel(from: item)
    })
  }
}

extension MobileBuySDK.Storefront.MenuItem:ViewModeling{
  typealias ViewModelType = NavigationMenuItemViewModel
}


extension String{
  func sub()->String{
    if let index = self.range(of: "/", options: .backwards)?.upperBound {
        let afterEqualsTo = String(self.suffix(from: index))
      return afterEqualsTo
    }
    return self
  }
}
