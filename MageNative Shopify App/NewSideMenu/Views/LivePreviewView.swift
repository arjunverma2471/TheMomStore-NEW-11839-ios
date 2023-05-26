//
//  LivePreviewView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 16/12/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
class LivePreviewView: UIView{
    
    lazy var liveLabel: UILabel = {
        let label = UILabel()
        label.font = mageFont.setFont(fontWeight: "regular", fontStyle: "normal", fontSize: 16)
        label.textColor = UIColor(light: UIColor(hexString: "#050505", alpha: 1),dark: UIColor.provideColor(type: .SideMenuController).textColor)
        return label;
    }()
    
    lazy var scanLabel: UILabel = {
        let label = UILabel()
        label.font = mageFont.setFont(fontWeight: "light", fontStyle: "normal", fontSize: 12)
        label.textColor = UIColor(light: UIColor(hexString: "#383838"),dark: UIColor.provideColor(type: .SideMenuController).textColor)
        return label;
    }()
    
    lazy var scanImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "scan")
        return image;
    }()
    
    lazy var outerView: UIButton = {
        let outer = UIButton()
        outer.clipsToBounds = true
       
        if #available(iOS 13.0, *) {
           // stack.layer.borderColor =  UIColor(light: UIColor.secondarySystemBackground,dark: .lightGray).cgColor
            outer.layer.borderColor = UIColor(light: .lightGray, dark: .lightGray).cgColor
        }
        outer.layer.cornerRadius = 8
        outer.layer.borderWidth = 0.5
        return outer
    }()
    
    lazy var navigationBottomLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(hexString: "#D1D1D1")
        return line;
    }()
    lazy var titleView: UIView = {
        let view = UIView()
        view.addSubview(liveLabel)
        liveLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, right: view.trailingAnchor)
        view.addSubview(scanLabel)
        scanLabel.anchor(top: liveLabel.bottomAnchor, left: view.leadingAnchor, bottom:view.safeAreaLayoutGuide.bottomAnchor,right: view.trailingAnchor, paddingTop: 4)
        return view
    }()
    
    lazy var topBtnView: UIButton = {
        let outer = UIButton()
        outer.backgroundColor = .clear
        return outer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
       
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setView()
    }
    private func setView(){
        addSubview(outerView)
        addSubview(topBtnView)
//        outerView.addSubview(liveLabel)
        outerView.addSubview(titleView)
        outerView.addSubview(scanImageView)
        outerView.anchor(top: topAnchor,left: leadingAnchor,bottom: bottomAnchor,right: trailingAnchor)//,paddingTop: 4,paddingLeft: 0,paddingBottom: 8,paddingRight: 0)
        scanImageView.anchor(right:outerView.trailingAnchor,paddingRight: 25,width:56,height: 56)
        scanImageView.centerY(inView: outerView)
        titleView.centerY(inView: outerView)
        titleView.anchor(left: outerView.leadingAnchor,right: scanImageView.leadingAnchor,paddingLeft: 16,paddingRight: 10)
        topBtnView.anchor(top: topAnchor,left: leadingAnchor,bottom: bottomAnchor,right: trailingAnchor)
        if(Client.merchantID == "18"){
            liveLabel.text = "Live Preview Of Your Store".localized
            scanLabel.text = "Scan to see your store in phone".localized
            scanImageView.isHidden = false
        }
        else{
            liveLabel.text = "Move to demo store".localized
            scanLabel.text = "Click Here".localized
            scanImageView.isHidden = true
        }
    }
}
