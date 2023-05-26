//
//  orderListShimmerTC.swift
//  MageNative Magento Platinum
//
//  Created by Cedcoss on 18/02/22.
//  Copyright © 2022 CEDCOSS Technologies Private Limited. All rights reserved.
//

import UIKit

class orderListShimmerTC: UITableViewCell {
    
    static let reuseID = "orderListShimmerTC"
    
    lazy var container:UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 2
        if #available(iOS 13.0, *) {
            view.layer.borderColor = UIColor.systemGray6.cgColor
        } else {
            view.layer.borderColor = UIColor.lightGray.cgColor
        }
        view.backgroundColor = DynamicColor.systemBackground
        return view
    }()
    
    lazy var firstLbl:UIView = {
        let view = UIView()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemGray6
        } else {
            view.backgroundColor = .lightGray
        }
        view.clipsToBounds = true
        view.layer.cornerRadius = 7.0
        return view
    }()
    lazy var firstParallelLbl:UIView = {
        let view = UIView()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemGray6
        } else {
            view.backgroundColor = .lightGray
        }
        view.clipsToBounds = true
        view.layer.cornerRadius = 7.0
        return view
    }()
    
    lazy var twoLbl:UIView = {
        let view = UIView()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemGray6
        } else {
            view.backgroundColor = .lightGray
        }
        view.clipsToBounds = true
        view.layer.cornerRadius = 7.0
        return view
    }()
    
    lazy var threeLbl:UIView = {
        let view = UIView()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemGray6
        } else {
            view.backgroundColor = .lightGray
        }
        view.clipsToBounds = true
        view.layer.cornerRadius = 7.0
        return view
    }()
    
    lazy var fourLbl:UIView = {
        let view = UIView()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemGray6
        } else {
            view.backgroundColor = .lightGray
        }
        view.clipsToBounds = true
        view.layer.cornerRadius = 7.0
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
        addSubview(container)
        container.anchor(top: topAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 15, paddingLeft: 0, paddingRight: 0, height: 150)
        
        container.addSubview(firstLbl)
        firstLbl.anchor(top: container.topAnchor, left: container.leadingAnchor, paddingTop: 15, paddingLeft: 5, width: 125, height: 30)
        
        container.addSubview(firstParallelLbl)
        firstParallelLbl.anchor(top: container.topAnchor, right: container.trailingAnchor, paddingTop: 5, paddingRight: 5, width: 125, height: 30)
        
        container.addSubview(twoLbl)
        twoLbl.anchor(top: firstLbl.bottomAnchor, left: container.leadingAnchor, right: container.trailingAnchor, paddingTop: 5, paddingLeft: 5, paddingRight: 5, height: 25)
        
        container.addSubview(threeLbl)
        threeLbl.anchor(top: twoLbl.bottomAnchor, left: container.leadingAnchor, right: container.trailingAnchor, paddingTop: 5, paddingLeft: 5, paddingRight: 5, height: 25)
        
        container.addSubview(fourLbl)
        fourLbl.anchor(top: threeLbl.bottomAnchor, left: container.leadingAnchor, right: container.trailingAnchor, paddingTop: 5, paddingLeft: 5, paddingRight: 5, height: 25)
    }
    
    func populate(){
        firstLbl.startShimmeringEffect(width: 125, height: 30)
        firstParallelLbl.startShimmeringEffect(width: 125, height: 30)
        
        twoLbl.startShimmeringEffect(height: 25)
        threeLbl.startShimmeringEffect(height: 25)
        fourLbl.startShimmeringEffect(height: 25)
    }
    
}
