//
//  SubscriptionProductViewCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 20/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
class SubscriptionProductViewCell : UICollectionViewCell  {
    
    lazy var outerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imgView : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "shape")?.withRenderingMode(.alwaysTemplate)
        image.tintColor = UIColor.AppTheme()
        image.isHidden = true
        return image
    }()
    
    lazy var textLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(light:UIColor.black,dark: UIColor.provideColor(type: .productVC).textColor)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = mageFont.mediumFont(size: 13.0)
        label.textAlignment = .center
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
        addSubview(imgView)
        addSubview(textLabel)
        outerView.anchor(top: safeAreaLayoutGuide.topAnchor, left: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: trailingAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4)
        imgView.anchor(top: outerView.topAnchor, paddingTop: 8, width: 30, height: 30)
        imgView.centerX(inView: outerView)
//        textLabel.anchor(top: imgView.bottomAnchor, left: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: trailingAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 4, paddingRight: 4)
        textLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        textLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        textLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        outerView.layer.cornerRadius = 5.0
        outerView.layer.borderColor = UIColor.black.cgColor
        outerView.layer.borderWidth = 1.0
    }
}
