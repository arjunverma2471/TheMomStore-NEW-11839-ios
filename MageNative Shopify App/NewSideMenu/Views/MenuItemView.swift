//
//  MenuItemView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 16/12/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import RxSwift
class MenuItemView: UIView{
    var disposeBag = DisposeBag()
    var isExpanded = false
    lazy var titleButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor(light: UIColor(hexString: "#383838", alpha: 1), dark: .white), for: .normal)
        btn.titleLabel?.font = mageFont.regularFont(size: 14)
        btn.contentHorizontalAlignment = .leading
        return btn
    }()
    lazy var rightButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "rightArrow"), for: .normal)
        return btn
    }()
    lazy var subItemStackView: UIStackView = {
        let stack = UIStackView()
        //stack.spacing = 4.0
        stack.axis = .vertical
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 8, bottom: 0, right: 8)
        return stack
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setView()
    }
    func setView(){
        addSubview(subItemStackView)
        subItemStackView.anchor(left: leadingAnchor,bottom: safeAreaLayoutGuide.bottomAnchor,right: trailingAnchor,paddingLeft: 12,paddingBottom: 4,paddingRight: 12)
        addSubview(titleButton)
        titleButton.anchor(top: safeAreaLayoutGuide.topAnchor,left: leadingAnchor,bottom: subItemStackView.topAnchor,right: trailingAnchor,paddingLeft: 16,height: 45)
        addSubview(rightButton)
        rightButton.anchor(right: titleButton.trailingAnchor,paddingRight: 12,width: 30,height: 30)
        rightButton.centerY(inView: titleButton)
    }
    func setup(from menu :MenuObject,level:Int) {
        titleButton.setTitle(menu.name, for: .normal)
        
        rightButton.isHidden = menu.children.count > 0 ? false : true
        rightButton.setImage(level>0 ? UIImage(named: "menuPlus") : UIImage(named: "rightArrow"), for: .normal)
        self.backgroundColor=UIColor.clear
        if Client.locale == "ar" {
            titleButton.contentHorizontalAlignment = .right
            rightButton.imageView?.image = rightButton.imageView?.image?.imageFlippedForRightToLeftLayoutDirection()
        }
        else{
            titleButton.contentHorizontalAlignment = .left
        }
        
    }
    
}
