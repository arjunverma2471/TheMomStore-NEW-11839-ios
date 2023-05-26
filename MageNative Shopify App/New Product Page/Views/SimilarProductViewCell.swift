//
//  SimilarProductViewCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 14/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
class SimilarProductViewCell : UICollectionViewCell {
    
    lazy var outerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.cardView()
        view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    lazy var productImage : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var productName : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.mediumFont(size: 14.0)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var productPrice : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.mediumFont(size: 14.0)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        addSubview(outerView)
        addSubview(productImage)
        addSubview(productName)
        addSubview(productPrice)
        outerView.anchor(top: safeAreaLayoutGuide.topAnchor, left: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: trailingAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4)
        productImage.anchor(top: safeAreaLayoutGuide.topAnchor, left: leadingAnchor,right: trailingAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8)
        productName.anchor(top: productImage.bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 4, paddingLeft: 8, paddingRight: 8, height: 35)
        productPrice.anchor(top: productName.bottomAnchor, left: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: trailingAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, height: 35)
    }
    
    
    func setupView(model : ProductViewModel) {
        productImage.setImageFrom(model.images.items.first?.url)
        productName.text = model.title
        productPrice.attributedText = self.calculatePrice(model: model)
    }
    
    
    func calculatePrice(model:ProductViewModel) -> NSMutableAttributedString {
        let finalString = NSMutableAttributedString()
        let compareAtPrice = model.variants.items.first?.compareAtPrice == nil ? "false" : ( (model.variants.items.first?.price)! < (model.variants.items.first?.compareAtPrice!)! ? Currency.stringFrom((model.variants.items.first?.compareAtPrice!)!) : "false" )
        let priceAttr = [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:mageFont.mediumFont(size: 14.0)]
        if  compareAtPrice != "false"
        {
            let attribute1 = NSAttributedString(string:  model.price, attributes: priceAttr  as [NSAttributedString.Key : Any])
            finalString.append(attribute1)
            let attr = [NSAttributedString.Key.strikethroughStyle:1,NSAttributedString.Key.font: mageFont.mediumFont(size: 12.0 ),NSAttributedString.Key.foregroundColor:UIColor.darkGray] as [NSAttributedString.Key : Any]
            finalString.append(NSAttributedString(string: " "))
            let attribute = NSAttributedString(string:  model.compareAtPrice, attributes: attr)
            finalString.append(attribute)
            let minusPrice = ((model.variants.items.first?.compareAtPrice ?? 0.0)-(model.variants.items.first?.price ?? 0.0))
            let percentage = ((minusPrice/(model.variants.items.first?.compareAtPrice ?? 0.0))*100)
            let val = String(format: "%.0f", Double(truncating : percentage as? NSNumber ?? 0))
            let offerString: NSMutableAttributedString =  NSMutableAttributedString(string: "(\(val)% "+"OFF".localized+")")
            offerString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor(hexString: "#28A138"), NSAttributedString.Key.font : mageFont.mediumFont(size: 14.0)], range: NSMakeRange(0, offerString.length))
            finalString.append(NSMutableAttributedString(string : " "))
            finalString.append(offerString)
        }
        else {
          let attr = [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:mageFont.mediumFont(size: 14.0)]
          let attribute = NSAttributedString(string:  model.price, attributes: attr  as [NSAttributedString.Key : Any])
          finalString.append(attribute)
          return finalString
        }
        return finalString
       
    }
    
    
    
}
