//
//  ProductVariationViewCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 18/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
class ProductVariationViewCell : UICollectionViewCell {
    
    lazy var textLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.mediumFont(size: 14.0)
        label.numberOfLines = 2
        label.layer.cornerRadius = 5.0
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.textColor = UIColor(light:UIColor.black,dark: UIColor.provideColor(type: .productVC).textColor)
        
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
        
        addSubview(textLabel)
        textLabel.anchor(top: safeAreaLayoutGuide.topAnchor, left: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    
}
