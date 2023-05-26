//
//  LogoutTableCell.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 10/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
class LogoutTableCell: UITableViewCell{
    
    var delegate: LogoutProtocol?
    var disposeBag = DisposeBag()
    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false;
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        
        return stack;
    }()
    
    private lazy var contactUsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Contact Us >", for: .normal)
        button.tintColor = UIColor(hexString: "#2472C1")
        button.setTitleColor(UIColor(hexString: "#2472C1"), for: .normal)
        button.titleLabel?.font = mageFont.setFont(fontWeight: "light", fontStyle: "normal", fontSize: 12)
        return button
    }()
    
    private lazy var aboutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.titleLabel?.font = mageFont.setFont(fontWeight: "light", fontStyle: "normal", fontSize: 12)
        button.setTitle("About Us >", for: .normal)
        button.tintColor = UIColor(hexString: "#2472C1")
        button.setTitleColor(UIColor(hexString: "#2472C1"), for: .normal)
        return button
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.rx.tap.bind{
            self.delegate?.logoutClicked()
        }.disposed(by: disposeBag)
        return button
    }()
    
    private lazy var logoutLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.text = "Logout".localized
        label.textColor = UIColor(hexString: "#2472C1")
        label.font = mageFont.setFont(fontWeight: "light", fontStyle: "normal", fontSize: 14)
        return label;
    }()
    
    private lazy var logoutImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false;
        image.image = UIImage(named: "logout")
        image.contentMode = .scaleAspectFit
        return image;
    }()
    
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
        addSubview(buttonsStack)
        buttonsStack.addArrangedSubview(aboutButton)
        buttonsStack.addArrangedSubview(contactUsButton)
        buttonsStack.addArrangedSubview(logoutButton)
        logoutButton.addSubview(logoutImageView)
        logoutButton.addSubview(logoutLabel)
        addSubview(navigationBottomLine)
        NSLayoutConstraint.activate([
            buttonsStack.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            buttonsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            buttonsStack.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -25),
            aboutButton.widthAnchor.constraint(equalToConstant: 100),
            contactUsButton.widthAnchor.constraint(equalToConstant: 100),
            logoutButton.widthAnchor.constraint(equalToConstant: 100),
            navigationBottomLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            navigationBottomLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
            navigationBottomLine.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            navigationBottomLine.heightAnchor.constraint(equalToConstant: 0.5),
            logoutImageView.leadingAnchor.constraint(equalTo: logoutButton.leadingAnchor, constant: 5),
            logoutImageView.centerYAnchor.constraint(equalTo: logoutButton.centerYAnchor),
            logoutImageView.heightAnchor.constraint(equalToConstant: 22),
            logoutImageView.widthAnchor.constraint(equalToConstant: 22),
            logoutLabel.leadingAnchor.constraint(equalTo: logoutImageView.trailingAnchor, constant: 5),
            logoutLabel.centerYAnchor.constraint(equalTo: logoutImageView.centerYAnchor)
        ])
        logoutButton.centerX(inView: self)
        aboutButton.isHidden = true
        contactUsButton.isHidden = true;
//        if(!Client.shared.isAppLogin()){
//            logoutButton.isHidden = true;
//        }
        
    }
}
