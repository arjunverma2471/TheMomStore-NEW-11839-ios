//
//  MenuLoginCell.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 10/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
class MenuLoginCell: UITableViewCell{
    
    private lazy var avtarImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false;
        image.layer.cornerRadius = 25
        image.contentMode = .scaleAspectFit
        
        image.clipsToBounds = true;
        return image;
    }()
    
    private lazy var avtarInitails: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false;
        lbl.layer.cornerRadius = 25
        lbl.backgroundColor = .black
        lbl.font = mageFont.setFont(fontWeight: "bold", fontStyle: "normal", fontSize: 20)
        lbl.textColor  = .white
        lbl.clipsToBounds = true;
        lbl.textAlignment = .center
        return lbl;
    }()
    
    private lazy var profileName: UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false;
        name.font = mageFont.setFont(fontWeight: "regular", fontStyle: "normal", fontSize: 14)
        name.textColor = UIColor(light: UIColor(hexString: "#383838"), dark: UIColor.provideColor(type: .SideMenuController).textColor)
        return name;
    }()
    
    private lazy var msgLabel: UILabel = {
        let msg = UILabel()
        msg.translatesAutoresizingMaskIntoConstraints = false;
        msg.font = mageFont.setFont(fontWeight: "light", fontStyle: "normal", fontSize: 12)
        msg.textColor = UIColor(light: UIColor(hexString: "#383838"), dark: UIColor.provideColor(type: .SideMenuController).textColor)
        return msg
    }()
    
    private lazy var rightArrowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.setImage(UIImage(named: "rightArrow"), for: .normal);
        button.imageView?.contentMode = .scaleAspectFit;
        return button;
    } ()
    
    private lazy var navigationBottomLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false;
        line.backgroundColor = UIColor(hexString: "#D1D1D1")
        return line;
    }()
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isMultipleTouchEnabled = true
        contentView.isUserInteractionEnabled = true
        selectionStyle = .none
        initView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView(){
        addSubview(avtarImage)
        addSubview(avtarInitails)
        addSubview(profileName)
        addSubview(msgLabel)
        addSubview(rightArrowButton)
        addSubview(navigationBottomLine)
        NSLayoutConstraint.activate([
            avtarImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            avtarImage.heightAnchor.constraint(equalToConstant: 50),
            avtarImage.widthAnchor.constraint(equalToConstant: 50),
            avtarImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            avtarInitails.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            avtarInitails.heightAnchor.constraint(equalToConstant: 50),
            avtarInitails.widthAnchor.constraint(equalToConstant: 50),
            avtarInitails.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileName.leadingAnchor.constraint(equalTo: avtarInitails.trailingAnchor, constant: 5),
            profileName.topAnchor.constraint(equalTo: avtarInitails.topAnchor, constant: 10),
            msgLabel.leadingAnchor.constraint(equalTo: profileName.leadingAnchor),
            msgLabel.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 5),
            rightArrowButton.centerYAnchor.constraint(equalTo: avtarInitails.centerYAnchor),
            rightArrowButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            rightArrowButton.heightAnchor.constraint(equalToConstant: 25),
            rightArrowButton.widthAnchor.constraint(equalToConstant: 25),
            navigationBottomLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            navigationBottomLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
            navigationBottomLine.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            navigationBottomLine.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    func setup(menu: MenuObject){
       
//        msgLabel.text = "Sign in via email"
        //mageShopLogin
        print("v=========>",Client.shared.isAppLogin())
        if Client.shared.isAppLogin(){
            profileName.text = menu.name
            avtarImage.isHidden = true
            avtarInitails.isHidden = false
            let fullName = menu.name
            var name = ""
            if let firstName = fullName.components(separatedBy: " ").first?.first{
                name += firstName.description
            }
            if let lastName = fullName.components(separatedBy: " ").last?.first{
                name += lastName.description
            }
            
            avtarInitails.text = name.uppercased()
            msgLabel.text = "Save, Shop and View Orders".localized
        }
        else{
            avtarImage.image = UIImage(named: "profile")
            avtarImage.isHidden = false
            avtarInitails.isHidden = true
            profileName.text = "Hey Guest!".localized
            msgLabel.text = "Sign in via email".localized
            
        }
    }
}
