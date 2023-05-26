//
//  KangarooReferCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 07/04/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import UIKit
class KangarooReferCell: UICollectionViewCell {
    static let textColor = UIColor(light: UIColor(hexString: "#050505", alpha: 1),dark: UIColor.provideColor(type: .newLoginVC).textColor)
    static let reuseID = "KangarooReferCell"
    fileprivate let referLabel: UILabel =  {
        let label = UILabel()
        label.textColor = textColor
        label.font = mageFont.boldFont(size: 14)
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.text = "Refer a Friend"
        return label
    }()
    
    fileprivate let infoLabel: UILabel =  {
        let label = UILabel()
        label.textColor = textColor
        label.font = mageFont.regularFont(size: 12)
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.text = "Refer friends and family to earn an offer. You'll get 50 Points, and your friend and family get 150 Points"
        label.numberOfLines = 0
        return label
    }()
    
    let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ShareCode")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    let codeLable: UILabel = {
        let label = UILabel()
        label.text = "http://krn.biz/dc4a2"
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = textColor
        label.makeBorder(width: 1, color: UIColor.lightGray, radius: 5)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        contentView.clipsToBounds = true
        contentView.layer.borderWidth = 1
        contentView.addSubview(shareButton)
        shareButton.anchor(bottom: contentView.bottomAnchor, right: contentView.trailingAnchor, paddingBottom: 16, paddingRight: 16, width: 30, height: 30)
        
        contentView.addSubview(codeLable)
        codeLable.anchor(left: contentView.leadingAnchor, bottom: contentView.bottomAnchor, right: shareButton.leadingAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 8, paddingRight: 10, height: 44)
        
        contentView.addSubview(referLabel)
        referLabel.anchor(top: contentView.topAnchor, left: contentView.leadingAnchor, right: contentView.trailingAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16, height: 30)
        
        contentView.addSubview(infoLabel)
        infoLabel.anchor(top: referLabel.bottomAnchor, left: contentView.leadingAnchor, bottom: codeLable.topAnchor, right: contentView.trailingAnchor, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
