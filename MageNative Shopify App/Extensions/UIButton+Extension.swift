//
//  UIButton+Extension.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 04/02/20.
//  Copyright © 2020 MageNative. All rights reserved.
//

import UIKit

class BadgeButton: UIButton {
    
    var badgeLabel = UILabel()
    
    var badge: String? {
        didSet {
            addBadgeToButon(badge: badge)
        }
    }

    public var badgeBackgroundColor =  UIColor(light:  Client.navigationThemeData?.count_color ?? UIColor.red,dark: .white) {
        didSet {
            badgeLabel.backgroundColor = badgeBackgroundColor
        }
    }
    
    public var badgeTextColor = UIColor(light: Client.navigationThemeData?.count_textcolor ?? UIColor.white,dark: .black) {
        didSet {
            badgeLabel.textColor = badgeTextColor
        }
    }
    
    public var badgeFont = mageFont.regularFont(size: 10.0) {
        didSet {
            badgeLabel.font = badgeFont
        }
    }
    
    public var badgeEdgeInsets: UIEdgeInsets? {
        didSet {
            addBadgeToButon(badge: badge)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBadgeToButon(badge: nil)
    }
    
    func addBadgeToButon(badge: String?) {
        badgeLabel.text = badge
        badgeLabel.textColor = badgeTextColor
        badgeLabel.backgroundColor = badgeBackgroundColor
        badgeLabel.font = badgeFont
        badgeLabel.sizeToFit()
        badgeLabel.textAlignment = .center
        let badgeSize = badgeLabel.frame.size
        let height = max(18, Double(badgeSize.height) + 3.0)
        let width = max(height, Double(badgeSize.width) + 7.0)
        
        var vertical: Double?, horizontal: Double?
        if let badgeInset = self.badgeEdgeInsets {
            vertical = Double(badgeInset.top) - Double(badgeInset.bottom)
            horizontal = Double(badgeInset.left) - Double(badgeInset.right)
            
            let x = (Double(bounds.size.width) - 5 + horizontal!)
            let y = -(Double(badgeSize.height) / 2) - 10 + vertical!
            badgeLabel.frame = CGRect(x: x+1, y: y, width: width, height: height)//y-5
        } else {
            let x = self.frame.width - CGFloat((width / 2.0))
            let y = CGFloat(-(height / 2.0))
            badgeLabel.frame = CGRect(x: x+1, y: y, width: CGFloat(width), height: CGFloat(height))//y-5
        }
  
        badgeLabel.layer.cornerRadius = badgeLabel.frame.height/2
        badgeLabel.layer.masksToBounds = true
        addSubview(badgeLabel)
        badgeLabel.isHidden = badge != nil ? false : true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addBadgeToButon(badge: nil)
        //fatalError("init(coder:) has not been implemented")
    }
}


extension UIButton{
     func setButtonWithTitleAndImage(textColor: UIColor, tintColor : UIColor, bgColor:UIColor = .clear, buttonImage: UIImage?, imagePosition:buttonImageDirection = .left, imageSizeHW: CGFloat = 30){
            if imageView != nil {
                let image = buttonImage?.withRenderingMode(.alwaysTemplate)
                self.setImage(image, for: .normal)
                self.titleLabel?.font = mageFont.mediumFont(size: 14.0)
                self.setTitleColor(textColor, for: .normal)
                self.tintColor = tintColor
                self.backgroundColor = bgColor
                
                switch imagePosition{
                case .left:
                    imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: (bounds.width - (imageSizeHW + 5)))
                    titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
                case .right:
                    imageEdgeInsets = UIEdgeInsets(top: 5, left: (bounds.width - (imageSizeHW + 5)), bottom: 5, right: 5)
                    titleEdgeInsets = UIEdgeInsets(top: 0, left: (imageView?.frame.width)!, bottom: 0, right: 0)
                case .top:
                    imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: (bounds.width - (imageSizeHW + 5)), right: 5)
                    titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: (imageView?.frame.height)!, right: 0)
                case .bottom:
                    imageEdgeInsets = UIEdgeInsets(top: (bounds.width - (imageSizeHW + 5)), left: 5, bottom: 5, right: 5)
                    titleEdgeInsets = UIEdgeInsets(top: (imageView?.frame.height)!, left: 0, bottom: 0, right: 0)
                }
            }
            self.layoutIfNeeded()
        }
}

enum buttonImageDirection: Int {
    case left = 0
    case right
    case top
    case bottom
}
