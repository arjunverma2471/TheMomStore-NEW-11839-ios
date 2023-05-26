//
//  CategoryListCC.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 12/09/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class CategoryListCC: UICollectionViewCell {
    lazy var productImage : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.layer.maskedCorners = Client.locale == "ar" ? [.layerMinXMinYCorner, .layerMinXMaxYCorner] : [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        return image
    }()
    
    lazy var innerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false;
        view.backgroundColor = UIColor(light: .AppTheme() .withAlphaComponent(0.1),dark: UIColor.provideColor(type: .categoryListCollectionCell).innerCurvedView)//UIColor(hexString: "#F2F7FD")
        view.alpha = 0.5
        view.layer.cornerRadius = 10.0
        //view.clipsToBounds = true
        view.layer.masksToBounds = true
        return view;
    }()
    
    lazy var productLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.font = mageFont.regularFont(size: 16)
        label.numberOfLines = 0
        label.textColor = UIColor(light: .black,dark: UIColor.provideColor(type: .categoryListCollectionCell).textColor)
        return label;
    }()
    
//    lazy var productImageView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false;
//        view.backgroundColor = .white//UIColor(hexString: "#F2F7FD")
//        view.alpha = 1
//        return view;
//    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
       
        addSubview(innerView)
        addSubview(productImage)
        addSubview(productLabel)
        innerView.anchor(top: topAnchor, left: leadingAnchor, bottom: bottomAnchor, right: trailingAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4)
        productImage.anchor(top: innerView.topAnchor, bottom: innerView.bottomAnchor, right: innerView.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingRight: 0,width: 200)
        //productImage.widthAnchor.constraint(equalToConstant: 205).isActive = true;
        productLabel.centerYAnchor.constraint(equalTo: innerView.centerYAnchor).isActive = true;
        productLabel.anchor(left: innerView.leadingAnchor, right: productImage.leadingAnchor, paddingLeft: 20, paddingRight: 35)
        let layer0 = CAGradientLayer()

        layer0.colors = [

          UIColor(red: 0.949, green: 0.969, blue: 0.992, alpha: 0).cgColor,

          UIColor(red: 0.949, green: 0.969, blue: 0.992, alpha: 1).cgColor

        ]

        layer0.locations = [0.46, 0.91]

        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)

        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)

        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0.01, b: 0.92, c: -0.92, d: 0, tx: 0.96, ty: 0))

        layer0.bounds = productImage.bounds.insetBy(dx: -0.5*productImage.bounds.size.width, dy: -0.5*productImage.bounds.size.height)

        layer0.position = productImage.center

        //productImage.layer.addSublayer(layer0)
        
        
        //setGradiantColor(view: productImage, topColor: UIColor(displayP3Red: 0.949, green: 0.969, blue: 0.992, alpha: 0), bottomColor: UIColor(displayP3Red: 0.949, green: 0.969, blue: 0.992, alpha: 1), cornerRadius: 0, gradiantDirection: .leftToRight)
        //self.productImage.applyGradient(colours: [.yellow, .blue, .red], locations: [0.0, 0.5, 1.0])
    }
    
    func configure(_ collection: CollectionViewModel){
        //productImage.sd_setImage(with: collection.imageURL, for: .normal)
        productImage.setImageFrom(collection.imageURL)
        productLabel.text = collection.title
    }
    

}

