//
//  LivePreviewTableCell.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 10/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
class LivePreviewTableCell: UITableViewCell{
    
    private lazy var liveLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.setFont(fontWeight: "regular", fontStyle: "normal", fontSize: 16)
        label.textColor = UIColor(hexString: "#050505")
        return label;
    }()
    
    private lazy var scanLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.setFont(fontWeight: "light", fontStyle: "normal", fontSize: 12)
        label.textColor = UIColor(hexString: "#383838")
        return label;
    }()
    
    private lazy var scanImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false;
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "scan")
        return image;
    }()
    
    private lazy var outerView: UIView = {
        let outer = UIView()
        outer.translatesAutoresizingMaskIntoConstraints = false
        outer.backgroundColor = UIColor(light: UIColor(hexString: "#EAF2FB"),dark: UIColor.provideColor(type: .SideMenuController).lightGray)
        return outer
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
        addSubview(navigationBottomLine)
        addSubview(outerView)
        outerView.addSubview(liveLabel)
        outerView.addSubview(scanLabel)
        outerView.addSubview(scanImageView)
        NSLayoutConstraint.activate([
            outerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            outerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -75),
            outerView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            outerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            liveLabel.topAnchor.constraint(equalTo: outerView.topAnchor, constant: 25),
            
            
            scanLabel.topAnchor.constraint(equalTo: liveLabel.bottomAnchor, constant: 5),
            scanLabel.leadingAnchor.constraint(equalTo: liveLabel.leadingAnchor),
            scanLabel.bottomAnchor.constraint(equalTo: outerView.bottomAnchor, constant: -25),
            scanImageView.widthAnchor.constraint(equalToConstant: 56),
            scanImageView.heightAnchor.constraint(equalToConstant: 56),
            scanImageView.centerYAnchor.constraint(equalTo: outerView.centerYAnchor),
            scanImageView.leadingAnchor.constraint(equalTo: liveLabel.trailingAnchor, constant: 40),
            navigationBottomLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            navigationBottomLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
            navigationBottomLine.topAnchor.constraint(equalTo: topAnchor, constant: 1),
            navigationBottomLine.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        if(Client.locale=="ar"){
            liveLabel.centerXAnchor.constraint(equalTo: outerView.centerXAnchor, constant: 50).isActive = true;
        }
        else{
            liveLabel.centerXAnchor.constraint(equalTo: outerView.centerXAnchor, constant: -50).isActive = true;
        }
        if(Client.merchantID == "18"){
            liveLabel.text = "Live Preview Of Your Store".localized
            scanLabel.text = "Scan to see your store in phone".localized
        }
        else{
            liveLabel.text = "Move to demo store".localized
            scanLabel.text = "Click Here".localized
        }
    }
    
}
