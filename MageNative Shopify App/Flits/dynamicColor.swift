//
//  dynamicColor.swift
//  MageNative Magento Platinum
//
//  Created by cedcoss on 20/04/20.
//  Copyright © 2020 CEDCOSS Technologies Private Limited. All rights reserved.
//

import Foundation

public struct DynamicColor {
    
    //MARK: Background Colors
    public static var systemBackground: UIColor = {
       if #available(iOS 13.0, *) { return .systemBackground}
       else { return .white}
     }()
    
    public static var secondarySystemBackground: UIColor = {
       if #available(iOS 13.0, *) { return .secondarySystemBackground}
       else { return .darkGray}
     }()

    public static var tertiarySystemBackground: UIColor = {
       if #available(iOS 13.0, *) { return .tertiarySystemBackground}
       else { return .lightGray}
     }()
    
    //MARK: - Label Colors
    
    public static var label: UIColor = {
       if #available(iOS 13.0, *) { return .label }
       else { return .black }
     }()
    
    public static var secondaryLabel: UIColor = {
       if #available(iOS 13.0, *) { return UIColor.secondaryLabel }
       else { return .darkGray }
     }()
    
    public static var tertiaryLabel: UIColor = {
       if #available(iOS 13.0, *) { return UIColor.tertiaryLabel }
       else { return .lightGray }
     }()
    
//MARK: - Tint Colors

    public static var imageTint: UIColor = {
         if #available(iOS 13.0, *) {
             return UIColor { (trait) -> UIColor in
                if trait.userInterfaceStyle == .dark { return .white}
                else { return .black}
             }
         } else { return .black}
     }()
    
    
    public static func getColorOnTheme() -> UIColor {
    /*    if let color = UserDefaults.standard.value(forKey: "themeSelected") as? String {
            switch color {
            case "Grocery".localized :
                return UIColor(hexString: "#03AD53")
            case "Home Decor".localized :
                return UIColor(hexString: "#0696B4")
            case "Fashion".localized :
                return UIColor(hexString: "#5B311F")
            default:
                return UIColor(hexString: "")
            }
        }*/
        if !(Client.homeStaticThemeColor.isEmpty) {
            let color = Client.homeStaticThemeColor
            return UIColor(hexString: color)
        }
        else if var colorCode = UserDefaults.standard.value(forKey: "color") as? String{
            colorCode = colorCode.components(separatedBy: "#").last!
            let scanner = Scanner(string:colorCode)
            var color:UInt32 = 0;
            scanner.scanHexInt32(&color)
            let mask = 0x000000FF
            let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
            let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
            let b = CGFloat(Float(Int(color) & mask)/255.0)
            return UIColor(red: r, green: g, blue: b, alpha: CGFloat(1))
        }
        else {
            return UIColor.black
        }
    }
}
