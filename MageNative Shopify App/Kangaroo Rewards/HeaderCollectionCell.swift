//
//  HeaderCollectionCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 20/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
class KangarooHeaderCollectionCell: UICollectionViewCell {
    static let reuseID = "KangarooHeaderCollectionCell"
    let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = mageFont.regularFont(size: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        labelLayout()
    }
    
    private func labelLayout() {
        contentView.addSubview(label)
        label.anchor(top: topAnchor, left: leadingAnchor, bottom: bottomAnchor, right: trailingAnchor, paddingTop: 0, paddingBottom: 0)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            label.textColor = isHighlighted ? UIColor.black : UIColor.lightGray
            label.font = isHighlighted ? mageFont.mediumFont(size: 14) : mageFont.regularFont(size: 14)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            label.textColor = isSelected ? UIColor.black : UIColor.lightGray
            label.font = isSelected ? mageFont.mediumFont(size: 14) : mageFont.regularFont(size: 14)
        }
    }
}
