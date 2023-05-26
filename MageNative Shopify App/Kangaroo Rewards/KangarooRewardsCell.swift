//
//  RewardsCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 20/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import UIKit
class KangarooRewardsCollectionCell: UICollectionViewCell {
    static let reuseID = "KangarooRewardsCollectionCell"
    var copyButtonTapped: (() -> ())?
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "gift")?.withRenderingMode(.alwaysOriginal)
        return imageView
    }()
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(light: UIColor(hexString: "#050505", alpha: 1),dark: UIColor.provideColor(type: .newLoginVC).textColor)
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.text = "Get 10 Points  on minimum purchase of Rs. 1000"
        return label
    }()
    
    fileprivate let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(light: UIColor(hexString: "#050505", alpha: 1),dark: UIColor.provideColor(type: .newLoginVC).textColor)
        label.font = UIFont(name: "Poppins-Regular", size: 12)
        label.textAlignment = .left
        label.text = "Description: rewards description goes here"
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(light: UIColor(hexString: "#050505", alpha: 1),dark: UIColor.provideColor(type: .newLoginVC).textColor)
        label.font = UIFont(name: "Poppins-Regular", size: 12)
        label.textAlignment = .right
        label.text = "Date"
        label.adjustsFontSizeToFitWidth = true
        label.isHidden = true
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
        imageViewLayout()
        headerLabelLayout()
        dateLabelLayout()
        descriptionLabelLayout()
        
    }
    
    private func imageViewLayout() {
        contentView.addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leadingAnchor, bottom: bottomAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, width: 50)
    }
    
    private func headerLabelLayout() {
        contentView.addSubview(headerLabel)
        headerLabel.anchor(top: topAnchor, left: imageView.trailingAnchor, right: trailingAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8)
    }
    
    private func descriptionLabelLayout() {
        contentView.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: headerLabel.bottomAnchor, left: imageView.trailingAnchor, bottom: contentView.bottomAnchor, right: dateLabel.leadingAnchor, paddingTop: 15, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
    }
    
    private func dateLabelLayout() {
        contentView.addSubview(dateLabel)
        dateLabel.anchor(bottom: contentView.bottomAnchor, right: contentView.trailingAnchor, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 100)
    }
    
    @objc func handleCopy() {
        self.copyButtonTapped?()
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
        if let date = history.createdAt {
            self.dateLabel.text = date.toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ssZ")?.toString(withFormat: "dd-MM-yyyy")
        }
    }
    
    func setupRewardsData(rewards: KangarooCustomerRewardsData) {
        if let title = rewards.title {
            self.headerLabel.text = title
        }
        if let des = rewards.points {
            self.descriptionLabel.text = "\(des) Points"
        }
    }
    
    func setupTiersData(tier: KangarooTiersLevel) {
        if let title = tier.name {
            self.headerLabel.text = title
        }
        if let des = tier.reachPoints {
            self.descriptionLabel.text = "\(des) Reach Points"
        }
    }
}

