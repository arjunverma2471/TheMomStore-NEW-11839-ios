//
//  SocialMenuView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 15/12/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import RxSwift
class SocialMenuView:UIView{
    
    var delegate: ChatsProtocol?
    var disposeBag = DisposeBag()
   
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor =  UIColor(hexString: "#D1D1D1")
        return view
    }()
     lazy var whatsAppButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "whatsapp"), for: .normal)
         button.setTitle("Connect with".localized, for: .normal)
        button.titleLabel?.font = mageFont.regularFont(size: 12)
        button.imageView?.contentMode = .scaleAspectFit
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.imagePadding = 12
            button.configuration = config
        }
        
        button.backgroundColor = UIColor(light: UIColor(hexString: "#F2F2F2"),dark: UIColor(hexString: "#383838"))
        button.rx.tap.bind{
            self.delegate?.socialClicked(url: Client.whatsappNumber, name: "whatsapp")
        }.disposed(by: disposeBag)
         button.tintColor = UIColor.gray
         button.semanticContentAttribute = Client.locale == "ar" ? .forceLeftToRight : .forceRightToLeft
        button.anchor(height: 40)
        return button
    }()
    
     lazy var fbButton: UIButton = {
        let button = UIButton()
         button.setTitle("Connect with".localized, for: .normal)
         button.titleLabel?.font = mageFont.regularFont(size: 12)
        button.setImage(UIImage(named: "messenger-fb"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.imagePadding = 12
            button.configuration = config
        }
        button.backgroundColor =  UIColor(light: UIColor(hexString: "#F2F2F2"),dark: UIColor(hexString: "#383838"))
        button.rx.tap.bind{
            self.delegate?.socialClicked(url: Client.fbURL, name: "fb")
        }.disposed(by: disposeBag)
         button.tintColor = UIColor.gray
         button.semanticContentAttribute = Client.locale == "ar" ? .forceLeftToRight : .forceRightToLeft
         button.anchor(height: 44)
        return button
    }()
     lazy var buttonsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [whatsAppButton,fbButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack;
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    private func setView(){
        addSubview(lineView)
        lineView.anchor(top: topAnchor,left: leadingAnchor,right: trailingAnchor,height: 0.5)
        addSubview(buttonsStack)
        buttonsStack.anchor(top: lineView.bottomAnchor,left: leadingAnchor,bottom: bottomAnchor,right: trailingAnchor,paddingTop: 16)
    }
}
