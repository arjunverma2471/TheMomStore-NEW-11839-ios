//
//  MenuFooterCell.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 10/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
class MenuFooterCell: UITableViewCell{
    
    private lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "#6B6B6B")
        label.font = mageFont.setFont(fontWeight: "light", fontStyle: "normal", fontSize: 12)
        return label;
    }()
    
    private lazy var copyrightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "#6B6B6B")
        label.font = mageFont.setFont(fontWeight: "light", fontStyle: "normal", fontSize: 12)
        return label;
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
        addSubview(versionLabel)
        addSubview(copyrightLabel)
        NSLayoutConstraint.activate([
            versionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            versionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            versionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            copyrightLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            copyrightLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            copyrightLabel.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 5),
            copyrightLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    func setup(menu: MenuObject){
        versionLabel.text = menu.name
        copyrightLabel.text = "Copyright@".localized+"\(Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "")"
        if Client.shared.isAppLogin(){
            
        }
    }
    
}
