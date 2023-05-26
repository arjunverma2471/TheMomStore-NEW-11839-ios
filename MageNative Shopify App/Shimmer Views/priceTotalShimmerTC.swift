//
//  priceTotalShimmerTC.swift
//  MageNative Magento Platinum
//
//  Created by Cedcoss on 19/02/22.
//  Copyright © 2022 CEDCOSS Technologies Private Limited. All rights reserved.
//

import UIKit

class priceTotalShimmerTC: UITableViewCell {

    static let reuseId = "priceTotalShimmerTC"
    
    lazy var lblOne:UIView = {
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
    
    lazy var lblTwo:UIView = {
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
    
    lazy var lblThree:UIView = {
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
    
    lazy var lblFour:UIView = {
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
        addSubview(lblOne)
        lblOne.anchor(top: topAnchor, right: trailingAnchor, paddingTop: 5, paddingRight: 5, width: 260, height: 30)
        
        addSubview(lblTwo)
        lblTwo.anchor(top: lblOne.bottomAnchor, right: trailingAnchor, paddingTop: 5, paddingRight: 5, width: 240, height: 30)
        
        addSubview(lblThree)
        lblThree.anchor(top: lblTwo.bottomAnchor,right: trailingAnchor, paddingTop: 5, paddingRight: 5, width: 220, height: 30)
        
        addSubview(lblFour)
        lblFour.anchor(top: lblThree.bottomAnchor, right: trailingAnchor, paddingTop: 5, paddingRight: 5, width: 200, height: 30)
    }
    
    func populate(){
        lblOne.startShimmeringEffect(width: 260, height: 30)
        lblTwo.startShimmeringEffect(width: 240, height: 30)
        lblThree.startShimmeringEffect(width: 220, height: 30)
        lblFour.startShimmeringEffect(width: 200, height: 30)
    }
    
}
