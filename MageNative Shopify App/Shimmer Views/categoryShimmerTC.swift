//
//  categoryShimmerTC.swift
//  MageNative Magento Platinum
//
//  Created by Cedcoss on 15/02/22.
//  Copyright © 2022 CEDCOSS Technologies Private Limited. All rights reserved.
//

import UIKit

class categoryShimmerTC: UITableViewCell {

    static let reuseId = "categoryShimmerTC"
    
    lazy var hStack:UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.spacing = 5
        return stack
    }()
    
//    lazy var circleView:UIView = {
//
//    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(){
        addSubview(hStack)
        hStack.anchor(top: topAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 5, paddingLeft: 0, paddingRight: 0,height: 70)
        
        
    }
    
    func populateWithCategory(){
        hStack.subviews.forEach{$0.removeFromSuperview()}
        for _ in 0..<5{
            createCircle()
        }
//        hStack.subviews.forEach{view in
//
//        }
    }
    
    func createCircle(){
        let view = UIView()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemGray6
        } else {
            view.backgroundColor = .lightGray
        }
        view.clipsToBounds = true
        view.layer.cornerRadius = 35
        hStack.addArrangedSubview(view)
        view.startShimmeringEffect(width: (UIScreen.main.bounds.width - 36)/5, height: 70)
    }
    
    func createSquare(){
        let outerView = UIView()
        outerView.backgroundColor = .clear
        
        let topImg = UIView()
        if #available(iOS 13.0, *) {
            topImg.backgroundColor = .systemGray6
        } else {
            topImg.backgroundColor = .lightGray
        }
        topImg.clipsToBounds = true
        
        
    }
    
}
