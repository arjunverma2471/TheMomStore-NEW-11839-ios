//
//  ProductChatGPTView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 28/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
class ProductChatGPTView : UIView {
    
    
    private lazy var initialLetter : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(hexString: "#79929C")
        label.text = "P"
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        return label
    }()
    
    private lazy var headingLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Short description of product information".localized
        label.textColor = UIColor(light: UIColor(hexString: "#6B6B6B"), dark: UIColor(hexString: "#F5F6F6"))
        label.font = mageFont.regularFont(size: 12.0)
        return label
    }()
    
    
    private lazy var separatorLine : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(light: UIColor(hexString: "#F2F2F2"), dark: UIColor(hexString: "#333333"))
        return view
    }()
    
    private lazy var chatIcon : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "ChatGPT_logo")
        return image
        
    }()
    
     lazy var stackView : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 5
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initView() {
        self.backgroundColor = UIColor(light: .white, dark: UIColor(hexString: "#212121"))
        self.addSubview(initialLetter)
        initialLetter.anchor(top: topAnchor, left: leadingAnchor, paddingTop: 12, paddingLeft: 12,width: 30, height: 30)
        self.addSubview(headingLabel)
        headingLabel.anchor(top: topAnchor, left: initialLetter.trailingAnchor, right: trailingAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12, height: 30)
        self.addSubview(separatorLine)
        separatorLine.anchor(top: headingLabel.bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 8, height: 1)
        self.addSubview(chatIcon)
        chatIcon.anchor(top: separatorLine.bottomAnchor, left: leadingAnchor, paddingTop: 12, paddingLeft: 12, width: 30, height: 30)
        self.addSubview(stackView)
        stackView.anchor(top: separatorLine.bottomAnchor, left: chatIcon.trailingAnchor,bottom: bottomAnchor, right: trailingAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 12, paddingRight: 12)
    }
    
    
    
    
    
}


extension UILabel {
    func animation(typing value: String, duration: Double){
        for char in value {
            self.text!.append(char)
            RunLoop.current.run(until: Date() + duration)
        }
    }
}


extension UILabel {
    func typeOn(data:[String]) {
        var index = 0
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { (timer) in
            self.text!.append(data[index] + " ")
            index += 1
            if index == data.count {
                timer.invalidate()
            }
        }
    }
}
