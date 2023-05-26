//
//  ContentCollectionCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 20/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import UIKit
protocol RedeemCoupon {
    func redeemCoupon(apiKey: String, sId: String, campaignId: Int, points: Int)
}

protocol CopyCoupon {
    func copyCoupon(couponCode: String)
}

protocol UpdateKangarooDetils {
    func updateKangarooDetails(firstName: String, lastName: String, email: String, dob: String)
    func updateKangarooConsent(allow_sms:Bool,allow_email:Bool)
}
class KangarooContentCollectionCell: UICollectionViewCell {
    var parent: UIViewController?
    var rewardsPageNumber = 1
    var offersPageNumber = 1
    static let reuseID = "KangarooContentCollectionCell"
    var cellName = ""
    var redeemDelegate: RedeemCoupon!
    var copyCouponDelegate: CopyCoupon!
    var customerData: KanagrooCustomerData?
    var customerConsent : KangarooGetCustomerConsentData?
    var updateKangarooDelegate: UpdateKangarooDetils!
    let kangarooViewModel = KangarooRewardsViewModel()
    var customerRewards = [KangarooCustomerRewardsData]()
    var customerOffers = [KangarooCustomerRewardsData]()
    var tiers = [KangarooTiersLevel]()
    var currentUserPoints : Int?
    
    fileprivate let rewardsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(KangarooRewardsCollectionCell.self, forCellWithReuseIdentifier: KangarooRewardsCollectionCell.reuseID)
        collectionView.register(KangarooReferCell.self, forCellWithReuseIdentifier: KangarooReferCell.reuseID)
        collectionView.register(KangarooProfileCell.self, forCellWithReuseIdentifier: KangarooProfileCell.reuseID)
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16)
        return collectionView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        rewardsCollectionLayout()
        setupDelegates()
    }
    
    private func rewardsCollectionLayout() {
        contentView.addSubview(rewardsCollectionView)
        rewardsCollectionView.anchor(top: topAnchor, left: leadingAnchor, bottom: bottomAnchor, right: trailingAnchor)
    }
    
    private func setupDelegates() {
        rewardsCollectionView.delegate = self
        rewardsCollectionView.dataSource = self
    }
    
    func reloadCollection() {
        DispatchQueue.main.async {[weak self] in
            self?.rewardsCollectionView.reloadData()
        }
    }
    
    @objc func referTapped() {
        guard let objectsToShare: URL = URL(string: "http://krn.biz/dc4a2") else {return}
        let sharedObjects: [AnyObject] = [objectsToShare as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.parent?.view
        
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.postToTwitter, UIActivity.ActivityType.mail]
        
        self.parent?.present(activityViewController, animated: true, completion: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension KangarooContentCollectionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if cellName == "Reward Yourself" {
            return customerRewards.count + 1
        }
        else if cellName == "Exclusive Offers" {
            return customerOffers.count
        }
        else if cellName == "Tiers" {
            return tiers.count
        }
        else if cellName == "Profile" {
            return 1
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(index)
        if  cellName == "Reward Yourself" {
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KangarooReferCell.reuseID, for: indexPath) as! KangarooReferCell
                cell.shareButton.addTarget(self, action: #selector(referTapped), for: .touchUpInside)
                return cell
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KangarooRewardsCollectionCell.reuseID, for: indexPath) as! KangarooRewardsCollectionCell
                cell.setupRewardsData(rewards: customerRewards[indexPath.item - 1])
                return cell
            }
            
        }
        else if cellName == "Profile" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KangarooProfileCell.reuseID, for: indexPath) as! KangarooProfileCell
            cell.setupData(customer: customerData,consentData: customerConsent)
            cell.parent = parent
            cell.updateTapped = {[weak self] in
                let firstName = cell.firstNameTextField.text ?? ""
                let lastName = cell.lastNameTextField.text ?? ""
                let email = cell.emailTextField.text ?? ""
                let dob = cell.dobTextField.text ?? ""
                let emailConsent = cell.emailCheck
                let smsConsent = cell.smsCheck
                self?.updateKangarooDelegate.updateKangarooDetails(firstName: firstName, lastName: lastName, email: email, dob: dob)
                self?.updateKangarooDelegate.updateKangarooConsent(allow_sms: smsConsent, allow_email: emailConsent)
            }
            
            return cell
        }
        else if cellName == "Tiers" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KangarooRewardsCollectionCell.reuseID, for: indexPath) as! KangarooRewardsCollectionCell
            cell.setupTiersData(tier: tiers[indexPath.item])
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KangarooRewardsCollectionCell.reuseID, for: indexPath) as! KangarooRewardsCollectionCell
            cell.setupRewardsData(rewards: customerOffers[indexPath.item])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if cellName == "Reward Yourself" && indexPath.item != 0 {
            self.showRedeemViewController(rewardsData: customerRewards[indexPath.item - 1], cellName: cellName)
            
        }
        if cellName == "Exclusive Offers" {
            let customerOffer = customerOffers[indexPath.item]
            if let points = customerOffer.points, let currentUserPoints = currentUserPoints {
                if points <= currentUserPoints {
                    self.showRedeemViewController(rewardsData: customerOffers[indexPath.item], cellName: cellName)

                }
                else {
                    self.parent?.view.showmsg(msg: "You don't have enough points to redeem")
                }
            }
        }
    }
    
    private func showRedeemViewController(rewardsData: KangarooCustomerRewardsData, cellName: String) {
        if rewardsData.type != "bonus_points" {
            DispatchQueue.main.async {[weak self] in
                let vc = KangarooRewardDetailsViewController()
                vc.setupRewardsData(rewardsData: rewardsData, cellName: cellName)
                if #available(iOS 15.0, *) {
                    if let sheet = vc.sheetPresentationController {
                        sheet.detents = [.medium()]
                        sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                        sheet.preferredCornerRadius = 0
                    }
                }
                self?.parent?.present(vc, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if cellName == "Reward Yourself" {
            if indexPath.item == 0 {
                return CGSize(width: collectionView.frame.size.width - 32, height: 150)
            }
            else {
                return CGSize(width: collectionView.frame.size.width - 32, height: 80)
            }
        }
        else if cellName == "Exclusive Offers" {
            return CGSize(width: collectionView.frame.size.width - 32, height: 80)
        }
        else if cellName == "Tiers" {
            return CGSize(width: collectionView.frame.size.width - 32, height: 80)
        }
        else if cellName == "Profile" {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
        else {
            return CGSize()
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cellName == "Reward Yourself" {
            if indexPath.item == customerRewards.count - 1 {
                print("Hit reward yourself request")
            }
        }
        if cellName == "Exclusive Offers" {
            if indexPath.item == customerOffers.count - 1 {
                print("Hit offers yourself request")
            }
        }
    }
    
}
