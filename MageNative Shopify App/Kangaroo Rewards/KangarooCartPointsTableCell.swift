//
//  KangarooCartPointsTableCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 02/05/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
class KangarooCartPointsTableCell : UITableViewCell {
    
    static let reuseId = "KangarooCartPointsTableCell"
    
    var payWithPointsApi : (()->())?
    var removePointsFromCoupon : (()->())?
    var useCopyButton : (()->())?
    
    var isInitialCheck = false
    
    lazy var checkButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "unchecked"), for: .normal)
        button.tintColor = UIColor.AppTheme()
        button.addTarget(self, action: #selector(checkButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    
    
    lazy var pointsLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pay with Points"
        return label
    }()
    
    
    lazy var couponText : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var couponCopyButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Copy", for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(copyButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    
    var couponTextHeightConstraint : NSLayoutConstraint?
    var copyButtonHeightConstraint : NSLayoutConstraint?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.isMultipleTouchEnabled = true
        contentView.isUserInteractionEnabled = true
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        self.couponTextHeightConstraint = NSLayoutConstraint(item: couponText, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        self.copyButtonHeightConstraint = NSLayoutConstraint(item: couponCopyButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        self.addSubview(checkButton)
        checkButton.anchor(top: safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leadingAnchor, paddingTop: 8, paddingLeft: 8, width: 40, height: 40)
        self.addSubview(pointsLabel)
        pointsLabel.anchor(top: safeAreaLayoutGuide.topAnchor, left: checkButton.trailingAnchor, right: safeAreaLayoutGuide.trailingAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8, height: 40)
        self.addSubview(couponText)
        couponText.anchor(top: checkButton.bottomAnchor, left: safeAreaLayoutGuide.leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8)
        self.addSubview(couponCopyButton)
        couponCopyButton.anchor(top: pointsLabel.bottomAnchor, left: couponText.trailingAnchor,bottom: safeAreaLayoutGuide.bottomAnchor, right: safeAreaLayoutGuide.trailingAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 100)
        self.couponTextHeightConstraint?.isActive = true
        self.copyButtonHeightConstraint?.isActive = true
        
    }
    
    @objc func checkButtonClick(_ sender : UIButton) {
        isInitialCheck.toggle()
        if isInitialCheck {
            checkButton.setImage(UIImage(named: "checked"), for: .normal)
            payWithPointsApi?()
        }
        else {
            checkButton.setImage(UIImage(named: "unchecked"), for: .normal)
            removePointsFromCoupon?()
        }
        
    }
    
    @objc func copyButtonClick(_ sender : UIButton) {
        useCopyButton?()
    }
    
    
}
