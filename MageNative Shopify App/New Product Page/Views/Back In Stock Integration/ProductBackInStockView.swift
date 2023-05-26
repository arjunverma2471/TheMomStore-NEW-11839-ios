//
//  ProductBackInStockView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 21/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
class ProductBackInStockView : UIView {
    
    lazy var heading : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sign up for restock notifications".localized
        label.font = mageFont.mediumFont(size: 15.0)
        return label
    }()
    
    lazy var textField : TextFieldWithPadding = {
        let text = TextFieldWithPadding()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = mageFont.mediumFont(size: 14.0)
        text.layer.borderWidth = 0.5
        text.layer.borderColor = UIColor.gray.cgColor
        text.layer.cornerRadius = 5.0
        text.placeholder = "Enter your email address".localized
        text.keyboardType = .emailAddress
        text.autocapitalizationType = .none
        return text
    }()
    
    lazy var notifyButton : Button = {
        let button = Button()
        button.setTitle("Notify Me".localized, for: .normal)
        button.backgroundColor = UIColor.AppTheme()
        button.setTitleColor(UIColor.textColor(), for: .normal)
        return button
    }()
    
    lazy var resultLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = mageFont.mediumFont(size: 15.0)
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
        backgroundColor = .white
        addSubview(heading)
        addSubview(textField)
        addSubview(notifyButton)
        addSubview(resultLabel)
        heading.anchor(top: safeAreaLayoutGuide.topAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 40)
        textField.anchor(top: heading.bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 45)
        notifyButton.anchor(top: textField.bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 12, paddingLeft: 16, paddingRight: 16, height: 45)
        resultLabel.anchor(top: notifyButton.bottomAnchor, left: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: trailingAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 8, paddingRight: 16)
    }
}
class TextFieldWithPadding: UITextField {
    var textPadding = UIEdgeInsets(
        top: 0,
        left: 15,
        bottom: 0,
        right: 15
    )
    override func textRect(forBounds bounds: CGRect) -> CGRect {
            let rect = super.textRect(forBounds: bounds)
            return rect.inset(by: textPadding)
        }

        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            let rect = super.editingRect(forBounds: bounds)
            return rect.inset(by: textPadding)
        }
}
