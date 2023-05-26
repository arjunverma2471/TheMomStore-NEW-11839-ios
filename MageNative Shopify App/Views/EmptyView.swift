//
//  EmptyView.swift
//  MageNative Shopify App
//
//  Created by Manohar on 27/09/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class EmptyView: UIView {

    
    var delegate: UIViewController?
    lazy var titleHeading : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        //label.textColor = headingColor
        //label.text = "Customer Review".localized
        label.font = mageFont.mediumFont(size: 16.0)
        label.textColor = UIColor(light: UIColor.init(hexString: "#303030"), dark: .white)
        return label
    }()
    lazy var subtitleHeading : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor(light: UIColor.init(hexString: "#6B6B6B"), dark: .white)
      
        //label.textColor = headingColor
        //label.text = "Customer Review".localized
        label.font = mageFont.regularFont(size: 14.0)
        return label
    }()
    
    lazy var emptyImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false;
        image.contentMode = .scaleAspectFit
        return image;
    }()
    
    lazy var continueButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.setTitle("Continue Shopping".localized, for: .normal)
        button.addTarget(self, action: #selector(continueButtonClicked(_:)), for: .touchUpInside)
        button.backgroundColor = .AppTheme()
        button.titleLabel?.font = mageFont.regularFont(size: 16.0)
        button.setTitleColor(.textColor(), for: .normal)
        button.layer.cornerRadius = 2.0
        return button;
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        addSubview(titleHeading)
        addSubview(subtitleHeading)
        addSubview(emptyImageView)
        addSubview(continueButton)
        NSLayoutConstraint.activate([
            emptyImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            emptyImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            emptyImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            emptyImageView.heightAnchor.constraint(equalToConstant: 150),
            titleHeading.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 30),
            titleHeading.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            titleHeading.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            subtitleHeading.topAnchor.constraint(equalTo: titleHeading.bottomAnchor, constant: 10),
            subtitleHeading.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            subtitleHeading.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            continueButton.topAnchor.constraint(equalTo: subtitleHeading.bottomAnchor, constant: 20),
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            
        ])
    }
    
    func configure(imageName: String, title: String, subtitle: String){
        emptyImageView.image = UIImage(named: imageName)
        titleHeading.text = title;
        subtitleHeading.text = subtitle
    }
    
    @objc func continueButtonClicked(_ sender: UIButton){
        if customAppSettings.sharedInstance.showTabbar{
          delegate?.tabBarController?.selectedIndex = 0
            delegate?.navigationController?.popToRootViewController(animated: true)
        }else{
            delegate?.navigationController?.popToRootViewController(animated: true)
        }
    }

}
