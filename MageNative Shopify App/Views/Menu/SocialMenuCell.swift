//
//  SocialMenuCell.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 13/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import RxSwift
class SocialMenuCell: UITableViewCell{
    
    var delegate: ChatsProtocol?
    var disposeBag = DisposeBag()
    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false;
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        
        return stack;
    }()
    
    private lazy var whatsAppButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.backgroundColor = UIColor(light: UIColor(hexString: "#F2F2F2"), dark: UIColor.provideColor(type: .SideMenuController).grey)
        button.rx.tap.bind{
            self.delegate?.socialClicked(url: Client.whatsappNumber, name: "whatsapp")
        }.disposed(by: disposeBag)
        return button
    }()
    
    private lazy var fbButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.backgroundColor = UIColor(light: UIColor(hexString: "#F2F2F2"), dark: UIColor.provideColor(type: .SideMenuController).grey)
        button.rx.tap.bind{
            self.delegate?.socialClicked(url: Client.fbURL, name: "fb")
        }.disposed(by: disposeBag)
        return button
    }()
    
    private lazy var whatsappLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.text = "Connect with".localized
        label.textColor = UIColor(light: UIColor(hexString: "#383838"), dark: UIColor.provideColor(type: .SideMenuController).textColor)
        label.font = mageFont.setFont(fontWeight: "light", fontStyle: "normal", fontSize: 14)
        return label;
    }()
    
    private lazy var fbLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.text = "Connect with".localized
        label.textColor = UIColor(light: UIColor(hexString: "#383838"), dark: UIColor.provideColor(type: .SideMenuController).textColor)
        label.font = mageFont.setFont(fontWeight: "light", fontStyle: "normal", fontSize: 14)
        return label;
    }()
    
    private lazy var whatsappImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false;
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "whatsapp")
        return image;
    }()
    
    private lazy var fbImageView: UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false;
        image.image = UIImage(named: "messenger-fb")
        image.contentMode = .scaleAspectFit
        return image;
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
        addSubview(buttonsStack)
        buttonsStack.addArrangedSubview(whatsAppButton)
        buttonsStack.addArrangedSubview(fbButton)
        whatsAppButton.addSubview(whatsappLabel)
        whatsAppButton.addSubview(whatsappImageView)
        fbButton.addSubview(fbLabel)
        fbButton.addSubview(fbImageView)
        NSLayoutConstraint.activate([
            buttonsStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            buttonsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            whatsAppButton.heightAnchor.constraint(equalToConstant: 50),
            fbButton.heightAnchor.constraint(equalToConstant: 50),
            
            whatsappLabel.centerYAnchor.constraint(equalTo: whatsAppButton.centerYAnchor),
            whatsappImageView.leadingAnchor.constraint(equalTo: whatsappLabel.trailingAnchor, constant: 10),
            whatsappImageView.heightAnchor.constraint(equalToConstant: 36),
            whatsappImageView.widthAnchor.constraint(equalToConstant: 36),
            whatsappImageView.centerYAnchor.constraint(equalTo: whatsappLabel.centerYAnchor),
            
            fbLabel.centerYAnchor.constraint(equalTo: fbButton.centerYAnchor),
            fbImageView.leadingAnchor.constraint(equalTo: fbLabel.trailingAnchor, constant: 10),
            fbImageView.heightAnchor.constraint(equalToConstant: 36),
            fbImageView.widthAnchor.constraint(equalToConstant: 36),
            fbImageView.centerYAnchor.constraint(equalTo: fbLabel.centerYAnchor),
            
        ])
        if(Client.locale == "ar"){
            fbLabel.centerXAnchor.constraint(equalTo: fbButton.centerXAnchor, constant: 20).isActive = true
            whatsappLabel.centerXAnchor.constraint(equalTo: whatsAppButton.centerXAnchor, constant: 20).isActive = true;
        }
        else{
            fbLabel.centerXAnchor.constraint(equalTo: fbButton.centerXAnchor, constant: -20).isActive = true
            whatsappLabel.centerXAnchor.constraint(equalTo: whatsAppButton.centerXAnchor, constant: -20).isActive = true;
        }
        if(customAppSettings.sharedInstance.fbIntegration && customAppSettings.sharedInstance.whatsappInegration){
            NSLayoutConstraint.activate([
                buttonsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                buttonsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -75)
                
            ])
        }
        else{
            NSLayoutConstraint.activate([
                buttonsStack.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -20),
                whatsAppButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45),
                fbButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.40),
            ])
        }
        
        if(!customAppSettings.sharedInstance.fbIntegration){
            fbLabel.isHidden = true;
            fbButton.isHidden = true;
            fbImageView.isHidden = true;
        }
        if(!customAppSettings.sharedInstance.whatsappInegration){
            whatsappLabel.isHidden = true;
            whatsAppButton.isHidden = true;
            whatsappImageView.isHidden = true;
        }
    }
}
