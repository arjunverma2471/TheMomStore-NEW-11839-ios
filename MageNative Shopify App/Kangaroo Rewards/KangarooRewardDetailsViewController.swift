//
//  KangarooRewardDetailsViewController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 14/04/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import UIKit
class KangarooRewardDetailsViewController: UIViewController {
    var rewardsData: KangarooCustomerRewardsData?
    var kangarooViewModel = KangarooRewardsViewModel()
    var cellName: String?
    static let textColor = UIColor(light: UIColor(hexString: "#050505", alpha: 1),dark: UIColor.provideColor(type: .newLoginVC).textColor)
    lazy var dismissButton : UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.setImage(UIImage(named: "cancelled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .black
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(light: UIColor(hexString: "#050505", alpha: 1),dark: UIColor.provideColor(type: .newLoginVC).textColor)
        label.font = mageFont.mediumFont(size: 14)
        return label
    }()
    
    lazy var imageView : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 5
        imgView.layer.borderColor = UIColor.lightGray.cgColor
        imgView.layer.borderWidth = 1
        imgView.image = UIImage(named: "splash")
        return imgView
    }()
    
    
    fileprivate lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading"
        label.textAlignment = .center
        label.textColor = UIColor(light: UIColor(hexString: "#050505", alpha: 1),dark: UIColor.provideColor(type: .newLoginVC).textColor)
        label.font = mageFont.mediumFont(size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate let seperator: UIView = {
        let seperatorLine = UIView()
        seperatorLine.cardView()
        seperatorLine.backgroundColor = UIColor.lightGray
        return seperatorLine
    }()
    
    lazy var redeemButton : UIButton = {
        let button = UIButton()
        button.setTitle("Redeem".localized, for: .normal)
        button.addTarget(self, action: #selector(redeemClicked), for: .touchUpInside)
        button.cardView()
        button.backgroundColor = UIColor.AppTheme()
        button.setTitleColor(UIColor.textColor(), for: .normal)
        button.titleLabel?.font = mageFont.mediumFont(size: 14)
        return button
    }()
    
    lazy var copyButton : UIButton = {
        let button = UIButton()
        button.setTitle("Copy Coupon Code".localized, for: .normal)
        button.addTarget(self, action: #selector(copyClicked), for: .touchUpInside)
        button.cardView()
        button.backgroundColor = UIColor.AppTheme()
        button.setTitleColor(UIColor.textColor(), for: .normal)
        button.titleLabel?.font = mageFont.mediumFont(size: 14)
        button.isHidden = true
        return button
    }()
    
    let codeLable: UILabel = {
        let label = UILabel()
        label.text = "Loading"
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = textColor
        label.makeBorder(width: 1, color: UIColor.AppTheme(), radius: 5)
        label.font = mageFont.boldFont(size: 18)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewBackgroundColor()
        setupUI()
    }
    
    private func setupUI() {
        dismissButtonLayout()
        nameLabelLayout()
        seperatorLayout()
        imageViewLayout()
        redeembuttonLayout()
        copybuttonLayout()
        descriptionLabelLayout()
        
        
    }
    
    private func dismissButtonLayout() {
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.trailingAnchor, paddingTop: 10, paddingBottom: 10, paddingRight: 20, width: 30, height: 30)
    }
    
    private func seperatorLayout() {
        view.addSubview(seperator)
        seperator.anchor(top: dismissButton.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingTop: 10, height: 2)
    }
    
    private func redeembuttonLayout() {
        view.addSubview(redeemButton)
        redeemButton.anchor(left: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.trailingAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, height: 44)
    }
    
    private func copybuttonLayout() {
        view.addSubview(copyButton)
        copyButton.anchor(left: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.trailingAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, height: 44)
    }
    
    private func nameLabelLayout() {
        view.addSubview(nameLabel)
        nameLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, right: dismissButton.leadingAnchor, paddingTop: 10, paddingLeft: 50, paddingBottom: 10, paddingRight: 10, width: 30, height: 30)
    }
    
    private func imageViewLayout() {
        view.addSubview(imageView)
        imageView.anchor(top: seperator.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingTop: 20, paddingLeft: 30, paddingRight: 30, height: 150)
    }
    
    private func descriptionLabelLayout(){
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: imageView.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20, height: 60)
    }
    
    private func codeLabelLayout() {
        view.addSubview(codeLable)
        
        codeLable.anchor(left: view.leadingAnchor, bottom: imageView.bottomAnchor, right: view.trailingAnchor, paddingTop: 20, paddingLeft: 30, paddingRight: 30, height: 80)
    }
    
    func setupRewardsData(rewardsData: KangarooCustomerRewardsData, cellName: String) {
        self.rewardsData = rewardsData
        self.cellName = cellName
        DispatchQueue.main.async {[weak self] in
            if let name = rewardsData.title {
                self?.nameLabel.text = name
            }
            if let des = rewardsData.description {
                self?.descriptionLabel.text = des
            }
            if let image = rewardsData.images?.first?.large?.getURL() {
                self?.imageView.setImageFrom(image)
            }
        }
        
    }
    
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func redeemClicked() {
        view.addLoader()
        if cellName == "Reward Yourself" {
            redeeemCoupon()
        }
        else {
            redeeemReward()
        }
        
    }
    
    @objc func copyClicked() {
        let pasteboard = UIPasteboard.general
        if codeLable.text != "" && codeLable.text != "Loading" {
            pasteboard.string = codeLable.text
            view.showmsg(msg: "Code Copied!")
        }
        
    }
    
    
    private func redeeemCoupon() {
        guard let offerId = rewardsData?.id, let couponId = rewardsData?.coupon?.id else {return}
        
        kangarooViewModel.kangarooRewardCouponRedeem(offer_id: "\(offerId)", coupon_id: "\(couponId)") {[weak self] result in
            switch result {
            case .success:
                let code = self?.kangarooViewModel.coupon?.ecomCoupon?.code ?? "Loading"
                self?.animate(code: code )
                print("Kangaroo Success")
            case .failed(let err):
                self?.view.stopLoader()
                print("The err \(err)")
            }
        }
    }
    
    
    private func redeeemReward() {
        guard let catalog_id = rewardsData?.id else {return}
        kangarooViewModel.kangarooOfferCouponRedeem(catalog_item_id: "\(catalog_id)") {[weak self] result in
            switch result {
            case .success:
                let code = self?.kangarooViewModel.coupon?.ecomCoupon?.code ?? "Loading"
                self?.animate(code: code )
                print("Kangaroo Success")
            case .failed(let err):
                self?.view.stopLoader()
                print("The err \(err)")
            }
        }
    }
    
    private func multiplyPoints() {
        guard let rewardsId = rewardsData?.id else {return}
        let points = kangarooViewModel.userPoint
        kangarooViewModel.multiplyCustomerPoints(points: points, reward_id: "\(rewardsId)") {[weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.dismiss(animated: true, completion: nil)
                }
                print("Kangaroo Success")
            case .failed(let err):
                self?.view.stopLoader()
                print("The err \(err)")
            }
        }
    }
    
    
    private func animate(code: String) {
        DispatchQueue.main.async {[weak self] in
            UIView.animate(withDuration: 0.5, delay: 0) {[weak self] in
                self?.codeLable.text = code
                self?.codeLabelLayout()
                self?.redeemButton.isHidden = true
                self?.copyButton.isHidden = false
                self?.imageView.isHidden = true
                self?.view.stopLoader()
            }
        }
    }
}
