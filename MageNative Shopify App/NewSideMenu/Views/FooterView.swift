//
//  FooterView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 15/12/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
class FooterView:UIView{
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor =  UIColor(hexString: "#D1D1D1")
        return view
    }()
    private lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "#6B6B6B")
        label.font = mageFont.setFont(fontWeight: "light", fontStyle: "normal", fontSize: 12)
        return label;
    }()
    
    private lazy var copyrightLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "#6B6B6B")
        label.font = mageFont.setFont(fontWeight: "light", fontStyle: "normal", fontSize: 12)
        return label;
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
        lineView.anchor(top: topAnchor,left: leadingAnchor,right: trailingAnchor,paddingTop: 2,height: 0.5)
        addSubview(versionLabel)
        addSubview(copyrightLabel)
        versionLabel.anchor(top: lineView.bottomAnchor,right: trailingAnchor, paddingTop: 16,paddingRight: 70)
        versionLabel.centerX(inView: self)
        copyrightLabel.anchor(top:versionLabel.bottomAnchor,right: trailingAnchor,paddingTop: 4,paddingRight: 70)
        copyrightLabel.centerX(inView: self)
    }
    func setup(menu: MenuObject){
        versionLabel.text = menu.name
        copyrightLabel.text = "Copyright@".localized+"\(Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "")"
        if Client.shared.isAppLogin(){
            
        }
    }
    
}
