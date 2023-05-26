//
//  SideMenuData.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 25/07/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
public class SideMenuData {
    
    static let shared = SideMenuData()
    var menus : [MenuObject]!{
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name("loadDrawerAgain"), object: nil)
        }
    }
    
    public init() {
        menus = [MenuObject]()
    }
    
    public func getMenuDataFromShopify() {
        self.menus.removeAll()
      //  Client.shared.fetchShopBlog { blogsModel in
          Client.shared.fetchNavigationMenu { navigationMenu in
            navigationMenu?.forEach({ menuItem in
              if let count  = menuItem.menuItems?.count {
                let subMenu = menuItem.menuItems
                if count > 0 {
                    self.shopifyFechSubMenu(menu: subMenu) { db in
                        let translatedStr = menuItem.menuTitle ?? ""
                        
                            let temp = MenuObject(name: translatedStr, children: db, id: menuItem.menuID ?? "", image: "",type: "",url: "")
                            self.menus.append(temp)
                      
                    }
                    
                }
                else{
                  // Case when no submenu is present
                  if menuItem.menuType != "BLOG"{
                      let translatedStr = menuItem.menuTitle ?? ""
                      
                          let temp = MenuObject(name: translatedStr, id: menuItem.menuID ?? "", image: "",type: menuItem.menuType ?? "",url: menuItem.menuUrl?.description ?? "")
                          self.menus.append(temp)
                     
                  }
                }
              }
            })
         /*   if let blogs = blogsModel{  // Removing as per Android
                var db : [MenuObject] = []
              for index in blogs.items{
                  let translatedStr = index.title
                      db.append(MenuObject(name: index.title, id: "", image: "", type: "BLOG", url: index.onlineStoreUrl?.absoluteString ?? "" ))

              }
                if db.count > 0 {
                    self.menus.append(MenuObject(name: "Quick Links".localized, children: db, id: "", image: "", type: "quickLinks", url: ""))
                }
            }  */
          }
      //  }
    }
        
        func shopifyFetchSubMenu(menu: [NavigationMenuItemViewModel]?) -> [MenuObject]{
        var dataObjects = [MenuObject]()
        for items in menu! {
       
          if items.menuItems!.count > 0 {
              let db =  shopifyFetchSubMenu(menu: items.menuItems)
              let translatedStr = items.menuTitle ?? ""
                  let temp = MenuObject(name: translatedStr,children: db, id: items.menuID ?? "", image: "",type: "",url: "")
                  dataObjects.append(temp)
             
              
          }else{
              let translatedStr = items.menuTitle ?? ""
             
                  let db=MenuObject(name: translatedStr, id:items.menuID ?? "", image: "",type:items.menuType?.description ?? "",url: items.menuUrl?.description ?? "")
                         dataObjects.append(db)
            
          }
        }
        return dataObjects
      }
      
    func shopifyFechSubMenu(menu: [NavigationMenuItemViewModel]?, completion : @escaping(([MenuObject]) -> Void)) {
    var menuData = menu
    var dataObjects = [MenuObject]()
    for items in menu! {
   
      if items.menuItems!.count > 0 {
          self.shopifyFechSubMenu(menu: items.menuItems) { db in
              menuData=items.menuItems
              let translatedStr = items.menuTitle ?? ""
                  let temp = MenuObject(name: translatedStr,children: db, id: items.menuID ?? "", image: "",type: "",url: "")
                  dataObjects.append(temp)
          }
      }else{
          let translatedStr = items.menuTitle ?? ""
              let db=MenuObject(name: translatedStr, id:items.menuID ?? "", image: "",type:items.menuType?.description ?? "",url: items.menuUrl?.description ?? "")
                     dataObjects.append(db)
         
      }
    }
       completion(dataObjects)
    
  }
}
