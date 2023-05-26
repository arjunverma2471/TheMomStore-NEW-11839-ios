//
//  PreviewThemeCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 20/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
class PreviewThemeCell : UICollectionViewCell {
    
    @IBOutlet weak var verifyTick: UIImageView!
    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var verifyTickWidth: NSLayoutConstraint!
    @IBOutlet weak var bannerImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupData(data:String) {
        switch data {
        case "Default".localized :
            bannerImage.image = UIImage(named: "Default")
        case "Grocery".localized :
            bannerImage.image = UIImage(named: "Grocery")
        case "Electronics".localized :
            bannerImage.image = UIImage(named: "Electronics")
        case "Fashion".localized :
            bannerImage.image = UIImage(named: "Fashion")
        case "Home Decor".localized :
            bannerImage.image = UIImage(named: "Home Decor")
        default:
            bannerImage.backgroundColor = .randomAlpha
        
        }
        bannerImage.layer.cornerRadius = 10.0
        bannerImage.clipsToBounds = true
        bannerImage.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        previewLabel.text = "Preview Theme".localized
        themeLabel.text = data
        if data == "Default".localized {
            verifyTick.isHidden = false
            verifyTickWidth.constant = 25
        }
        else {
            verifyTick.isHidden = true
            verifyTickWidth.constant = 0
        }
        bottomView.backgroundColor = UIColor.AppTheme()
        bottomView.layer.cornerRadius = 10
        bottomView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        previewLabel.font = mageFont.mediumFont(size: 14.0)
        themeLabel.font = mageFont.regularFont(size: 14.0)
        previewLabel.textColor = UIColor.textColor()
        themeLabel.textColor = UIColor.textColor()
    }
    
    
    
    
}

