//
//  ProductPageTabView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 18/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
import AlgoliaSearchClient
class ProductPageTabView : UIView {
    
  @IBOutlet weak var buyNowButton: UIButton!
  @IBOutlet weak var wishlistButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var wishlistButton: UIButton!
    var view: UIView!
    
    override init(frame: CGRect)
    {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
        if Client.locale == "ar" {
            cartButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            cartButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        }
        else {
            cartButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            cartButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        // 1. setup any properties here
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    func xibSetup()
    {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        // Make the view stretch with containing view
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        buyNowButton.setTitle("Buy Now".localized, for: .normal)
        buyNowButton.clipsToBounds = true
        buyNowButton.setTitleColor(UIColor(light: .darkGray, dark: .lightGray), for: .normal)
        cartButton.setTitleColor(UIColor.textColor(), for: .normal)
//        cartButton.setTitleColor(UIColor(light: .AppTheme(),dark: .AppTheme()), for: .normal)
        cartButton.backgroundColor = UIColor(light: .AppTheme(),dark: .AppTheme())
        buyNowButton.backgroundColor = UIColor.white
        wishlistButton.tintColor = UIColor(light: .black.withAlphaComponent(0.5), dark: .white)
        wishlistButton.layer.borderWidth = 0.5
        wishlistButton.layer.borderColor = UIColor(light: UIColor.black.withAlphaComponent(0.5),dark: .white).cgColor
        cartButton.layer.borderWidth = 0.5
        cartButton.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        buyNowButton.layer.cornerRadius = 5
        cartButton.layer.cornerRadius = 5
        wishlistButton.layer.cornerRadius = 5
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ProductPageTabView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
}
