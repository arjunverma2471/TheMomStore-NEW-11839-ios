//
//  ProductQuantityTextFieldCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 26/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
class ProductQuantityTextFieldCell : UICollectionViewCell {
    
    lazy var textField : UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .center
        text.layer.borderWidth = 1.0
        text.layer.borderColor = UIColor.black.cgColor
        text.font = mageFont.mediumFont(size: 12.0)
        text.keyboardType = .numberPad
        return text
    }()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        addSubview(textField)
        textField.anchor(top: safeAreaLayoutGuide.topAnchor, left: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
}
