//
//  cartproductShimmerTC.swift
//  MageNative Magento Platinum
//
//  Created by Cedcoss on 19/02/22.
//  Copyright © 2022 CEDCOSS Technologies Private Limited. All rights reserved.
//

import UIKit

class cartproductShimmerTC: UITableViewCell {

    static let reuseID = "cartproductShimmerTC"

    lazy var prdImage:UIView = {
        let view = UIView()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemGray6
        } else {
            view.backgroundColor = .lightGray
        }
        view.clipsToBounds = true
        view.layer.cornerRadius = 50
        return view
    }()
    
    lazy var labelView:UIView = {
        let view = UIView()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemGray6
        } else {
            view.backgroundColor = .lightGray
        }
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var secondayLblView:UIView = {
        let view = UIView()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemGray6
        } else {
            view.backgroundColor = .lightGray
        }
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var bottomLblView:UIView = {
        let view = UIView()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemGray6
        } else {
            view.backgroundColor = .lightGray
        }
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI(){
        addSubview(prdImage)
        prdImage.anchor(top: topAnchor, left: leadingAnchor, paddingTop: 5, paddingLeft: 0, width: 100, height: 100)
        
        addSubview(labelView)
        labelView.anchor(top: topAnchor, left: prdImage.trailingAnchor, right: trailingAnchor, paddingTop: 15, paddingLeft: 8, paddingRight: 8, height: 35)
        
        addSubview(secondayLblView)
        secondayLblView.anchor(top: labelView.bottomAnchor, left: prdImage.trailingAnchor, paddingTop: 8, paddingLeft: 8, width: 100, height: 30)
        
        addSubview(bottomLblView)
        bottomLblView.anchor(top: prdImage.bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 5, paddingLeft: 0, paddingRight: 0, height: 30)
    }
    
    func populate(){
        prdImage.startShimmeringEffect(width: 100, height: 100)
        labelView.startShimmeringEffect(width: (UIScreen.main.bounds.width - 135), height: 35)
        secondayLblView.startShimmeringEffect(width: 100, height: 30)
        bottomLblView.startShimmeringEffect(height: 30)
    }
    
}
