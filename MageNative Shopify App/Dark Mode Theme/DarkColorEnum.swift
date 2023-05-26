//
//  DarkColorEnum.swift
//  MageNative Shopify App
//
//  Created by Yash Pratap Singh sisodia on 18/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation


public enum DarkClass {
    case newHomeCategorySliderCell
    case navBar
    case productListVC
    case productGridCollectionCell
    case categoryListVC
    case categoryListCollectionCell
    case newLoginVC
    case newSearchVC
    case newSignupVC
    case recentSearchView
    case tabBar
    case wishListCollectionCell
    case SideMenuController
    case accountVc
    case productVC
    case quickAddToCart
    case filterViewController
    case cartVc
    case addressVC
}


extension UIColor {

   static func provideColor(type: DarkClass) -> DarkColor {
        switch type {
        case .newHomeCategorySliderCell:
            return DarkColor(panelBackgroundColor: .black,itemTitleColor: .white)
        case .navBar:
            return DarkColor(navBarBackgroundColor: .black)
        case .productListVC:
            return DarkColor(itemTitleColor: .white, backGroundColor: .black,collectionViewBackgroundColor: .black)
        case .productGridCollectionCell:
            return DarkColor(backGroundColor: .black,productHeadingColor: .white,productSubHeadingColor: .white,priceColor: .white)
        case .categoryListVC:
            return DarkColor(textColor: .white,backGroundColor: .black,collectionViewBackgroundColor: .black)
        case .categoryListCollectionCell:
            return DarkColor(textColor: .white,backGroundColor: .black,innerCurvedView: .gray)
        case .newLoginVC:
            return DarkColor(textColor: .white,backGroundColor: .black)
        case .newSearchVC:
            return DarkColor(textColor: .white, backGroundColor: .black,tintColor: .white)
        case .recentSearchView:
            return DarkColor(textColor: .white, backGroundColor: .black)
        case .tabBar:
            return DarkColor( textColor: .white,backGroundColor: .black)
        case .newSignupVC:
            return DarkColor( textColor: .white,backGroundColor: .black,tintColor: .white)
        case .wishListCollectionCell:
            return DarkColor( textColor: .white,backGroundColor: .black,tintColor: .white)
        case .SideMenuController:
            return DarkColor(textColor: .white,backGroundColor: UIColor(hexString: "#0F0F0F"),tintColor: .white)
        case .accountVc:
            return DarkColor(textColor: .white,backGroundColor: .black,tintColor: .white)
        case .productVC:
            return DarkColor(textColor: .white,backGroundColor: UIColor(hexString: "#0F0F0F"),collectionViewBackgroundColor: UIColor(hexString: "#0F0F0F"),tintColor: .white)
        case .quickAddToCart:
            return DarkColor(textColor: .white,backGroundColor: .black,collectionViewBackgroundColor: .black,tintColor: .white)
        case .filterViewController:
            return DarkColor(textColor: .white,backGroundColor: .black,collectionViewBackgroundColor: .black,tintColor: .white)
        case .cartVc:
            return DarkColor(textColor: .white,backGroundColor: .black,collectionViewBackgroundColor: .black,tintColor: .white)
        case .addressVC:
            return DarkColor(textColor: .white,backGroundColor: .black,collectionViewBackgroundColor: .black,tintColor: .white)
        }
    }
}



struct DarkColor {
    
    
    
    var textColor = UIColor.black
    var black = UIColor.black
    var darkGrey = UIColor.darkGray
    var grey = UIColor.gray
    var white = UIColor.white
    var lightGray = UIColor.lightGray
    var panelBackgroundColor = UIColor.black
    var itemTitleColor = UIColor.white
    var navBarBackgroundColor = UIColor.red
    var backGroundColor = UIColor.red
    var collectionViewBackgroundColor = UIColor.blue
    var productHeadingColor = UIColor.white
    var productSubHeadingColor = UIColor.white
    var priceColor = UIColor.blue
    var innerCurvedView = UIColor.gray
    var tintColor = UIColor.white
    
    
    static var darkBorderColor = UIColor(hexString: "#0F0F0F")
}


