//
//  DarkMode+Extensions.swift
//  MageNative Shopify App
//
//  Created by Yash Pratap Singh sisodia on 18/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation





public extension UIColor {

    /// Creates a color object that generates its color data dynamically using the specified colors. For early SDKs creates light color.
    /// - Parameters:
    ///   - light: The color for light mode.
    ///   - dark: The color for dark mode.
    convenience init(light: UIColor, dark: UIColor = .white) {
        if #available(iOS 13.0, tvOS 13.0, *) {
            self.init { traitCollection in
                if traitCollection.userInterfaceStyle == .dark {
                    return dark
                }
                return light
            }    
        }
        else {
            self.init(cgColor: light.cgColor)
        }
    }
}


public extension UIImageAsset {

    /// Creates an image asset with registration of tht eimages with the light and dark trait collections.
    /// - Parameters:
    ///   - lightModeImage: The image you want to register with the image asset with light user interface style.
    ///   - darkModeImage: The image you want to register with the image asset with dark user interface style.
    convenience init(lightModeImage: UIImage?, darkModeImage: UIImage?) {
        self.init()
        register(lightModeImage: lightModeImage, darkModeImage: darkModeImage)
    }

    /// Register an images with the light and dark trait collections respectively.
    /// - Parameters:
    ///   - lightModeImage: The image you want to register with the image asset with light user interface style.
    ///   - darkModeImage: The image you want to register with the image asset with dark user interface style.
    func register(lightModeImage: UIImage?, darkModeImage: UIImage?) {
        register(lightModeImage, for: .init(userInterfaceStyle: .light))
        register(darkModeImage, for: .init(userInterfaceStyle: .dark))
    }

    /// Register an image with the specified trait collection.
    /// - Parameters:
    ///   - image: The image you want to register with the image asset.
    ///   - traitCollection: The traits to associate with image.
    func register(_ image: UIImage?, for traitCollection: UITraitCollection) {
        guard let image = image else {
            return
        }
        register(image, with: traitCollection)
    }

    /// Returns the variant of the image that best matches the current trait collection. For early SDKs returns the image for light user interface style.
    func image() -> UIImage {
        if #available(iOS 13.0, tvOS 13.0, *) {
            image(with: .current)
        }
        return image(with: .init(userInterfaceStyle: .light))
    }
}
