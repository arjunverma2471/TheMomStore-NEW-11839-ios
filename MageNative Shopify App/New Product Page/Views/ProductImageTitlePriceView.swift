//
//  ProductImageTitlePriceView.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 07/09/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class ProductImageTitlePriceView: UIView {

    
    var product : ProductViewModel!
    var productHeadingColor = UIColor(light: UIColor(hexString: "#050505"),dark: UIColor.provideColor(type: .quickAddToCart).textColor)
    var productSubHeadingColor = UIColor(light: UIColor(hexString: "#6B6B6B"),dark: UIColor.provideColor(type: .quickAddToCart).textColor)
    
    lazy var productImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false;
        image.contentMode = .scaleAspectFit
        return image;
    }()
    
    lazy var crossButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.setImage(UIImage(named: "crossmark"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        //button.setTitle("X", for: .normal)
        //button.setTitleColor(UIColor(hexString: "#14142B"), for: .normal)
        return button;
    }()
    
    lazy var productHeading : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.regularFont(size: 14.0)//15.0
        label.numberOfLines = 0
        label.textColor = productHeadingColor
        return label
    }()
    
    lazy var productPrice : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.mediumFont(size: 14.0)
        label.lineBreakMode = .byWordWrapping
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
        backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .quickAddToCart).backGroundColor)
        
        addSubview(productImage)
        addSubview(productHeading)
        
        addSubview(productPrice)
        addSubview(crossButton)
        productImage.anchor(top: safeAreaLayoutGuide.topAnchor, left: leadingAnchor, paddingTop: 12, paddingLeft: 8, paddingRight: 8, width: 80, height: 80)
        
        productHeading.anchor(top: safeAreaLayoutGuide.topAnchor, left: productImage.trailingAnchor, right: trailingAnchor, paddingTop: 15, paddingLeft: 8, paddingBottom: 4, paddingRight: 8)
        productPrice.anchor(top: productHeading.bottomAnchor, left: productImage.trailingAnchor, right: trailingAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 4, paddingRight: 8)
        crossButton.anchor(top: safeAreaLayoutGuide.topAnchor,right: trailingAnchor, paddingTop: 15, paddingRight: 15, width: 20, height: 20)
        
        
    }
    
    func setupView() {
        if let img = product.images.items.first{
            productImage.setImageFrom(img.url)
        }
        
        productHeading.text = product.title
        productPrice.attributedText = self.calculatePrice(model: product)
    }
    
   
    func calculatePrice(model:ProductViewModel) -> NSMutableAttributedString {
        let finalString = NSMutableAttributedString()
        let compareAtPrice = model.variants.items.first?.compareAtPrice == nil ? "false" : ( (model.variants.items.first?.price)! < (model.variants.items.first?.compareAtPrice!)! ? Currency.stringFrom((model.variants.items.first?.compareAtPrice!)!) : "false" )
        let priceAttr = [NSAttributedString.Key.foregroundColor:UIColor(light: .black,dark: UIColor.provideColor(type: .quickAddToCart).textColor),NSAttributedString.Key.font:mageFont.mediumFont(size: 14.0)]
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
            let attr = [NSAttributedString.Key.foregroundColor:UIColor(light: UIColor(hexString: "#6B6B6B"),dark: UIColor.provideColor(type: .quickAddToCart).textColor),NSAttributedString.Key.font:mageFont.mediumFont(size: 14.0)]
          let attribute = NSAttributedString(string:  model.price, attributes: attr  as [NSAttributedString.Key : Any])
          finalString.append(attribute)
          return finalString
        }
        return finalString
       
    }
    
}
