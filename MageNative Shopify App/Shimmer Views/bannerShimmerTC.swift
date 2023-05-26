//
//  bannerShimmerTC.swift
//  MageNative Magento Platinum
//
//  Created by Cedcoss on 14/02/22.
//  Copyright © 2022 CEDCOSS Technologies Private Limited. All rights reserved.
//

import UIKit

class bannerShimmerTC: UITableViewCell {

    static let reuseID = "bannerShimmerTC"
    
    lazy var topBannerView:UIImageView = {
        let view = UIImageView()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemGray6
        } else {
            view.backgroundColor = .lightGray
        }
        view.clipsToBounds = true
        view.layer.cornerRadius = 15.0
        return view
    }()

    lazy var labelView:UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8.0
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemGray6
        } else {
            view.backgroundColor = .lightGray
        }
//        view.startShimmeringEffect()
        return view
    }()
    
    lazy var secondaryLabelView:UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8.0
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemGray6
        } else {
            view.backgroundColor = .lightGray
        }
//        view.startShimmeringEffect()
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(){
        addSubview(topBannerView)
        topBannerView.anchor(top: topAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: 200)
        
        addSubview(labelView)
        labelView.anchor(top: topBannerView.bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 8, paddingLeft: 0, paddingRight: 0, height: 30)
        
        addSubview(secondaryLabelView)
        secondaryLabelView.anchor(top: labelView.bottomAnchor, left: leadingAnchor,paddingTop: 8, paddingLeft: 0, width: 150, height: 30)
        
        
    }
    
    func populate(){
//        LoadingShimmer.startCovering(topBannerView, with: [bannerShimmerTC.reuseID])
        topBannerView.startShimmeringEffect(height: 200)
        labelView.startShimmeringEffect(height: 30)
        secondaryLabelView.startShimmeringEffect(width: 150, height: 30)
    }
    
    
}


extension UIView {
    func startShimmeringEffect(width:CGFloat = UIScreen.main.bounds.width - 20,height:CGFloat) {
        let light = UIColor.white.cgColor
        let alpha = UIColor(red: 206/255, green: 10/255, blue: 10/255, alpha: 0.4).cgColor
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: width, height: height)
        gradient.colors = [light, alpha, light]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0,y: 0.525)
        gradient.locations = [0.35, 0.50, 0.65]
        self.layer.mask = gradient
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9,1.0]
        animation.duration = 1.5
        animation.repeatCount = HUGE
        gradient.add(animation, forKey: "shimmer")
    }
    func stopShimmeringEffect() {
        self.layer.mask = nil
    }
}
