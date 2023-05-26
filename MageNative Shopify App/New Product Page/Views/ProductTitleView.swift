//
//  ProductTitleView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 12/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit

class ProductTitleView : UIView {
    
    var productHeadingColor = UIColor(light: UIColor(hexString: "#050505"),dark: UIColor.provideColor(type: .productVC).textColor)
    var productSubHeadingColor = UIColor(light: UIColor(hexString: "#6B6B6B"),dark: UIColor.provideColor(type: .productVC).textColor)
    var product : ProductViewModel!
    
    lazy var productHeading : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.mediumFont(size: 14.0)//15.0
        label.numberOfLines = 0
        return label
    }()
    
    lazy var productSubHeading : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.regularFont(size: 14.0)//13.0
        label.numberOfLines = 2
        label.textColor = productHeadingColor
        return label
    }()
    
    lazy var similarProductsButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Similar".localized, for: .normal)
        button.titleLabel?.font = mageFont.mediumFont(size: 12)
        button.setImage(UIImage(named: "similar"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hexString: "#F88282")
        return button
    }()
    
    lazy var productPrice : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.mediumFont(size: 13.0)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var availableQty : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(light: .black,dark: UIColor.provideColor(type: .productVC).textColor)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.regularFont(size: 13.0)
        label.numberOfLines = 2
        return label
    }()
    
    // MARK:- Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .productVC).backGroundColor)
        addSubview(productSubHeading)
        addSubview(productHeading)
//        addSubview(similarProductsButton)
        addSubview(productPrice)
//        addSubview(availableQty)
        productSubHeading.anchor(top: safeAreaLayoutGuide.topAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 12, paddingLeft: 10, paddingRight: 8, height: 25)
//        similarProductsButton.anchor(top: productSubHeading.topAnchor, right: trailingAnchor, paddingTop: 0, paddingRight: 8, width: 120, height: 35)
//        productHeading.anchor(top: productSubHeading.bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 4, paddingRight: 8)
        productPrice.anchor(top: productSubHeading.bottomAnchor, left: leadingAnchor,bottom: safeAreaLayoutGuide.bottomAnchor,  paddingTop: 4, paddingLeft: 10, paddingBottom: 8)
//        availableQty.anchor(top: productPrice.bottomAnchor, left: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: trailingAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 4, paddingRight: 8)
    }
    
    func setupView() {
//        productHeading.text = product.vendor
        productSubHeading.text = product.title
        productPrice.attributedText = self.calculatePrice(model: product)
    }
    
   
    func calculatePrice(model:ProductViewModel) -> NSMutableAttributedString {
        let finalString = NSMutableAttributedString()
        let compareAtPrice = model.variants.items.first?.compareAtPrice == nil ? "false" : ( (model.variants.items.first?.price)! < (model.variants.items.first?.compareAtPrice!)! ? Currency.stringFrom((model.variants.items.first?.compareAtPrice!)!) : "false" )
        let priceAttr = [NSAttributedString.Key.foregroundColor:UIColor(light: .AppTheme(),dark: UIColor.provideColor(type: .productVC).textColor),NSAttributedString.Key.font:mageFont.mediumFont(size: 14.0)]
        if  compareAtPrice != "false"
        {
            let attribute1 = NSAttributedString(string:  model.price, attributes: priceAttr  as [NSAttributedString.Key : Any])
            finalString.append(attribute1)
            let attr = [NSAttributedString.Key.strikethroughStyle:1,NSAttributedString.Key.font: mageFont.mediumFont(size: 14.0 ),NSAttributedString.Key.foregroundColor:UIColor.darkGray] as [NSAttributedString.Key : Any]
            finalString.append(NSAttributedString(string: " "))
            let attribute = NSAttributedString(string:  model.compareAtPrice, attributes: attr)
            finalString.append(attribute)
            let minusPrice = ((model.variants.items.first?.compareAtPrice ?? 0.0)-(model.variants.items.first?.price ?? 0.0))
            let percentage = ((minusPrice/(model.variants.items.first?.compareAtPrice ?? 0.0))*100)
            let val = String(format: "%.0f", Double(truncating : percentage as? NSNumber ?? 0))
            let offerString: NSMutableAttributedString =  NSMutableAttributedString(string: "(\(val)% "+"OFF".localized+")")
            offerString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor(hexString: "#28A138"), NSAttributedString.Key.font : mageFont.mediumFont(size: 12.0)], range: NSMakeRange(0, offerString.length))
            finalString.append(NSMutableAttributedString(string : " "))
            finalString.append(offerString)
        }
        else {
            let attr = [NSAttributedString.Key.foregroundColor:UIColor(light: .black,dark: UIColor.provideColor(type: .productVC).textColor),NSAttributedString.Key.font:mageFont.mediumFont(size: 14.0)]
          let attribute = NSAttributedString(string:  model.price, attributes: attr  as [NSAttributedString.Key : Any])
          finalString.append(attribute)
          return finalString
        }
        return finalString
       
    }
}
