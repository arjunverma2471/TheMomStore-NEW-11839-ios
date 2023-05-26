//
//  KangarooHistoryCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 18/04/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import UIKit
class KangarooCustomerHistoryCell: UICollectionViewCell {
    static let reuseID = "KangarooCustomerHistoryCell"
    var copyButtonTapped: (() -> ())?
    var menuButtonTapped: (()->())?
    
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "gift")?.withRenderingMode(.alwaysOriginal)
        return imageView
    }()
    
    
    lazy var menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.clipsToBounds = true
        button.setImage(UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(menuButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(light: UIColor(hexString: "#050505", alpha: 1),dark: UIColor.provideColor(type: .newLoginVC).textColor)
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.text = "Loading"
        return label
    }()
    
    fileprivate let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(light: UIColor(hexString: "#050505", alpha: 1),dark: UIColor.provideColor(type: .newLoginVC).textColor)
        label.font = UIFont(name: "Poppins-Regular", size: 12)
        label.textAlignment = .left
        label.text = "Loading"
        return label
    }()
    
    fileprivate let codePlaceholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(light: UIColor(hexString: "#050505", alpha: 1),dark: UIColor.provideColor(type: .newLoginVC).textColor)
        label.font = UIFont(name: "Poppins-Regular", size: 12)
        label.textAlignment = .left
        label.text = "Code: "
        return label
    }()
    
     lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .AppTheme()
        label.font = UIFont(name: "Poppins-Regular", size: 13)
        label.textAlignment = .left
        label.text = "Loading"
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleCopy))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(light: UIColor(hexString: "#050505", alpha: 1),dark: UIColor.provideColor(type: .newLoginVC).textColor)
        label.font = UIFont(name: "Poppins-Regular", size: 13)
        label.textAlignment = .right
        label.text = "Date"
        label.adjustsFontSizeToFitWidth = true
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
        menuButtonLayout()
        imageViewLayout()
        headerLabelLayout()
        dateLabelLayout()
        descriptionLabelLayout()
        codePlaceholderLabelLayout()
        codeLabelLayout()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        menuButton.isHidden = true
        headerLabel.text = nil
        descriptionLabel.text = nil
        dateLabel.text = nil
        codeLabel.text = nil
        dateLabel.isHidden = false
    }
    
    private func imageViewLayout() {
        contentView.addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leadingAnchor, bottom: bottomAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, width: 60)
    }
    private func menuButtonLayout() {
        contentView.addSubview(menuButton)
        menuButton.anchor(top: contentView.topAnchor, right: contentView.trailingAnchor, paddingTop: 8, paddingRight: 8, width: 25, height: 25)
    }
    
    private func headerLabelLayout() {
        contentView.addSubview(headerLabel)
        headerLabel.anchor(top: topAnchor, left: imageView.trailingAnchor, right: trailingAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8, height: 35)
    }
    
    private func descriptionLabelLayout() {
        contentView.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: headerLabel.bottomAnchor, left: imageView.trailingAnchor, right: dateLabel.leadingAnchor, paddingTop: 02, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, height: 25)
    }
    
    private func codePlaceholderLabelLayout() {
        contentView.addSubview(codePlaceholderLabel)
        codePlaceholderLabel.anchor(top: descriptionLabel.bottomAnchor, left: imageView.trailingAnchor, bottom: contentView.bottomAnchor, paddingTop: 5, paddingLeft: 8, paddingBottom: 8, paddingRight: 5, width: 45)
    }
    
    private func codeLabelLayout() {
        contentView.addSubview(codeLabel)
        codeLabel.anchor(top: descriptionLabel.bottomAnchor, left: codePlaceholderLabel.trailingAnchor, bottom: contentView.bottomAnchor,  right: dateLabel.leadingAnchor, paddingTop: 5, paddingLeft: 2, paddingBottom: 8, paddingRight: 8)
    }
    
    private func dateLabelLayout() {
        contentView.addSubview(dateLabel)
        dateLabel.anchor(bottom: contentView.bottomAnchor, right: contentView.trailingAnchor, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 140)
    }
    
    @objc func handleCopy(sender: UITapGestureRecognizer) {
        let pasteboard = UIPasteboard.general
        if codeLabel.text != "" && codeLabel.text != "Loading" {
            pasteboard.string = codeLabel.text
            self.copyButtonTapped?()
        }
    }
    
    @objc func menuButtonPressed() {
        menuButtonTapped?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(history: KangarooCustomerHistoryData) {
        if let title = history.name {
            self.headerLabel.text = title
        }
        if let des = history.points {
            self.descriptionLabel.text = "\(des) Points"
        }
        if let code = history.ecomCoupon {
            if code.statusDescription == "active" {
                self.codeLabel.text = code.code
                menuButton.isHidden = false
                codeLabel.isHidden = false
                codePlaceholderLabel.isHidden = false
            }
            else {
                menuButton.isHidden = true
                codeLabel.isHidden = true
                codePlaceholderLabel.isHidden = true
            }
            
        }
        else {
            menuButton.isHidden = true
            codeLabel.isHidden = true
            codePlaceholderLabel.isHidden = true
        }
        if let date = history.ecomCoupon?.expiresAt {
            self.dateLabel.isHidden = false
            self.dateLabel.text = "Expiry Date: \(date.toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ssZ")?.toString(withFormat: "dd-MM-yyyy") ?? "N/A")"
        }
        else {
            self.dateLabel.isHidden = true
        }
    }
}

