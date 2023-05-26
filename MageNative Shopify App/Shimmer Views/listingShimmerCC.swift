//
//  listingShimmerCC.swift
//  MageNative Magento Platinum
//
//  Created by Cedcoss on 15/02/22.
//  Copyright © 2022 CEDCOSS Technologies Private Limited. All rights reserved.
//

import UIKit

class listingShimmerCC: UICollectionViewCell {
    
    static let reuseID = "listingShimmerCC"
    
    lazy var topImgView:UIView = {
        let view = UIView()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemGray6
        } else {
            view.backgroundColor = .lightGray
        }
        view.clipsToBounds = true
        view.layer.cornerRadius = 12.0
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
        view.layer.cornerRadius = 8.0
        return view
    }()
    
    lazy var secondaryView:UIView = {
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
    
    //MARK: - Inititializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(topImgView)
        topImgView.anchor(top: topAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingRight:0, height: 200)
        
        addSubview(labelView)
        labelView.anchor(top: topImgView.bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 5, paddingLeft: 0, paddingRight:0, height: 30)
        
        addSubview(secondaryView)
        secondaryView.anchor(top: labelView.bottomAnchor, left: leadingAnchor, paddingTop: 5, paddingLeft: 0,width: 80, height: 25)
    }
    
    func populate(){
        topImgView.startShimmeringEffect(height: 200)
        labelView.startShimmeringEffect(width: (UIScreen.main.bounds.width-26)/2, height: 30)
        secondaryView.startShimmeringEffect(width: 80, height: 25)
    }
    
}
