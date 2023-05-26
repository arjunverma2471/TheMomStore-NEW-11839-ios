//
//  ShippingMethodTableCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 29/04/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
class ShippingMethodTableCell : UITableViewCell {
    
    private lazy var wrapperView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
     lazy var radioImageView : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
         image.tintColor = .black
        return image
    }()
    
    private lazy var labelText : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.regularFont(size: 14.0)
        return label
        
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isMultipleTouchEnabled = true
        contentView.isUserInteractionEnabled = true
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
      super.awakeFromNib()
    }
    
    func initView() {
        self.addSubview(wrapperView)
        self.addSubview(radioImageView)
        self.addSubview(labelText)
        NSLayoutConstraint.activate([
            wrapperView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            wrapperView.topAnchor.constraint(equalTo: self.topAnchor),
            wrapperView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            wrapperView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            radioImageView.leadingAnchor.constraint(equalTo: self.wrapperView.leadingAnchor, constant: 4),
            radioImageView.centerYAnchor.constraint(equalTo: self.wrapperView.centerYAnchor),
            radioImageView.widthAnchor.constraint(equalToConstant: 30),
            radioImageView.heightAnchor.constraint(equalToConstant: 30),
            labelText.leadingAnchor.constraint(equalTo: radioImageView.trailingAnchor, constant: 4),
            labelText.topAnchor.constraint(equalTo: self.wrapperView.topAnchor,constant:  4),
            labelText.trailingAnchor.constraint(equalTo: self.wrapperView.trailingAnchor, constant: -4),
            labelText.bottomAnchor.constraint(equalTo: self.wrapperView.bottomAnchor, constant: -4)
        
            
        ])
        
        
       
    }
    
    func setupData(model : ShippingRateViewModel) {
        labelText.text = model.title
    }
    
    
}
