//
//  GrowaveRewardsViewController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 27/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
class GrowaveRewardsViewController : UIViewController {
    
    
    var topView = GrowaveRewardsTopView()
    var bottomView = GrowaveRewardsBottomTabView()
    var growaveVM : GrowaveRewardVM!
    var isGetReward = true
    var isEarnPoints = false
    var isTier = false
    var disposeBag = DisposeBag()
    var userPoints : Double = 0.0
    var redeemView : GrowaveRedeemView!
    var accountView : GrowaveAccountView!
    var birthdayView : GrowaveBirthdayView!
     
        
    
    
    
    
    fileprivate lazy var scrollView : UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    
    public lazy var mainStack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 2
        stack.axis = .vertical
        stack.distribution = .fill
        stack.backgroundColor = .lightGray
        return stack
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.viewBackgroundColor()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadPage()
    }
    
    func reloadPage() {
        self.growaveVM = GrowaveRewardVM()
        self.growaveVM.getTotalPointsData{ points in
            self.userPoints = points ?? 0.0
            self.setUpView()
            self.setupTopView()
            self.setupBottomView()
            self.loadSpendData()
        }
        
        
    }
    
    
    
    
    func setUpView() {
        view.backgroundColor = .white
        view.addSubview(topView)
        view.addSubview(bottomView)
        view.addSubview(scrollView)
        scrollView.addSubview(mainStack)
        
        topView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leadingAnchor, right: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8, height: 45)
        
        bottomView.anchor(left: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.trailingAnchor, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, height: 45)
        
        scrollView.anchor(top: topView.bottomAnchor, left: view.safeAreaLayoutGuide.leadingAnchor, bottom: bottomView.topAnchor, right: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 8, paddingLeft: 8,paddingBottom: 8, paddingRight: 8)
        
        mainStack.anchor(top: scrollView.topAnchor, left: view.safeAreaLayoutGuide.leadingAnchor, bottom: scrollView.bottomAnchor, right: view.safeAreaLayoutGuide.trailingAnchor)
        
    }
    
    func setupBottomView() {
        bottomView.historyBtn.setTitle("", for: .normal)
        bottomView.faqBtn.setTitle("", for: .normal)
        bottomView.historyBtn.addTarget(self, action: #selector(showPointsHistory(_:)), for: .touchUpInside)
        bottomView.historyBtn.tintColor = .black
        bottomView.faqBtn.addTarget(self, action: #selector(showFAQ(_:)), for: .touchUpInside)
        bottomView.faqBtn.tintColor = .black
        bottomView.pointsLabel.text = "\(self.userPoints)"
    }
    
    @objc func showPointsHistory(_ sender : UIButton) {
        let vc = GrowaveActivityVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showFAQ(_ sender : UIButton) {
        let vc = GrowaveFAQViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupTopView() {
        topView.earnPointsButton.setTitle("Earn Points".localized, for: .normal)
        topView.getRewardsButton.setTitle("Get Rewards".localized, for: .normal)
        topView.tiersButton.setTitle("VIP Tiers".localized, for: .normal)
        
        topView.earnPointsButton.setTitleColor(.AppTheme(), for: .normal)
        topView.getRewardsButton.setTitleColor(.AppTheme(), for: .normal)
        topView.tiersButton.setTitleColor(.AppTheme(), for: .normal)
        
        
        topView.earnPointsButton.setupFont(fontType: .Medium)
        topView.getRewardsButton.setupFont(fontType: .Medium)
        topView.tiersButton.setupFont(fontType: .Medium)
        
        topView.getRewardsButton.addTarget(self, action: #selector(getRewardsData(_:)), for: .touchUpInside)
        topView.earnPointsButton.addTarget(self, action: #selector(earnPointsData(_:)), for: .touchUpInside)
        topView.tiersButton.addTarget(self, action: #selector(getTierData(_:)), for: .touchUpInside)
        
        self.initialSelection()
        
        
    }
    
    func initialSelection() {
        if isGetReward {
            topView.getRewardImage.backgroundColor = .black
            topView.tierImage.backgroundColor = .lightGray
            topView.earnPtImage.backgroundColor = .lightGray
        }
        else if isEarnPoints {
            topView.getRewardImage.backgroundColor = .lightGray
            topView.tierImage.backgroundColor = .lightGray
            topView.earnPtImage.backgroundColor = .black
        }
        else {
            topView.getRewardImage.backgroundColor = .lightGray
            topView.tierImage.backgroundColor = .black
            topView.earnPtImage.backgroundColor = .lightGray
        }
        
    }
    
    @objc func getRewardsData(_ sender : UIButton) {
        self.loadSpendData()
        self.isGetReward = true
        self.isEarnPoints = false
        self.isTier = false
        self.initialSelection()
    }
    
    @objc func earnPointsData(_ sender : UIButton) {
        self.loadEarnData()
        self.isGetReward = false
        self.isEarnPoints = true
        self.isTier = false
        self.initialSelection()
    }
    
    @objc func getTierData(_ sender : UIButton) {
        self.loadTierData()
        self.isGetReward = false
        self.isEarnPoints = false
        self.isTier = true
        self.initialSelection()
    }
    
    func loadTierData() {
        self.view.addFullLoader()
        mainStack.subviews.forEach{$0.removeFromSuperview()}
        self.growaveVM.getTiers { items in
            self.view.removeFullLoader()
            if items?.count ?? 0 > 0 {
                for itm in items! {
                    let view = GrowaveTierView()
                    view.heading.text = itm.tier_title
                    view.subHeading.text = itm.description
                    
                    /*view.onEarnTap = { //[weak self] in
                        print("bhshd")
                    }*/
                    
                    
                    
                    self.mainStack.addArrangedSubview(view)
                    view.anchor(height: 100)
                }
            }
        }

    }
    
    
    func loadSpendData() {
        self.view.addFullLoader()
        mainStack.subviews.forEach{$0.removeFromSuperview()}
        self.growaveVM.getSpendingRules { items in
           
            self.growaveVM.getActiveDiscounts { discounts  in
                self.view.removeFullLoader()
                if items?.count ?? 0 > 0 {
                    //  for itm in items! {
                    for i in 0..<(items?.count ?? 0){
                        
                        let view = GrowaveGetRewardsView()
                        view.mainHeading.text = self.growaveVM.spendingModel[i].title
                        
                        if self.growaveVM.spendingModel[i].price <= self.userPoints {
                            view.earnButton.setTitle("Redeem".localized, for: .normal)
                            view.subHeading.text = "Redeem for ".localized + "\(self.growaveVM.spendingModel[i].price)" + " points.".localized
                            view.earnButton.tag = i
                        }
                        else {
                            view.earnButton.setTitle("Earn".localized, for: .normal)
                            view.subHeading.text = "Earn ".localized+"\(self.growaveVM.spendingModel[i].price)"+" more points to get discount.".localized
                            view.earnButton.tag = i
                        }
                        
                        view.earnButton.isHidden = false
                        view.earnButton.addTarget(self, action: #selector(self.earnButtonClicked(_:)), for: .touchUpInside)
                        self.mainStack.addArrangedSubview(view)
                        view.anchor(height: 100)
                    }
                }
                if discounts?.count ?? 0 > 0 {
                    for i in 0..<(discounts?.count ?? 0) {
                        let view = GrowaveGetRewardsView()
                        view.mainHeading.text = self.growaveVM.discountModel[i].title
                        view.subHeading.text = self.growaveVM.discountModel[i].discount_code
                        view.earnButton.setTitle("Copy".localized, for: .normal)
                        view.earnButton.tag = i
                        view.earnButton.isHidden = false
                        view.earnButton.addTarget(self, action: #selector(self.copyButtonClicked(_:)), for: .touchUpInside)
                        self.mainStack.addArrangedSubview(view)
                        view.anchor(height: 100)
                    }
                }
            }
        }
    }
    
    
    func loadEarnData() {
        self.view.addFullLoader()
        mainStack.subviews.forEach{$0.removeFromSuperview()}
        self.growaveVM.getEarningRules { items in
            self.view.removeFullLoader()
            if items?.count ?? 0 > 0 {
                for i in 0..<(items?.count ?? 0){
                    let view = GrowaveGetRewardsView()
                    view.mainHeading.text = self.growaveVM.earningModel[i].title
                    view.subHeading.text = "\(self.growaveVM.earningModel[i].points)"+" points.".localized
                    
                   
                    
                    if let url = self.growaveVM.earningModel[i].imageUrl?.getURL() {
                        view.imgView.sd_setImage(with: url,placeholderImage: UIImage(named: "placeholder"))
                    }
                    let ruleType = self.growaveVM.earningModel[i].rule_type
                    switch ruleType {
                    case "place_order" :
                        view.earnButton.isHidden = false
                        view.earnButton.setTitle("Shop Now".localized, for: .normal)
                        view.earnButton.addTarget(self, action: #selector(self.shopNowClicked(_:)), for: .touchUpInside)
                    default :
                        view.earnButton.isHidden = true
                    }
                    
                   let tapGesture = UITapGestureRecognizer()
                    
                    tapGesture.addTarget(self, action: #selector(self.viewEarnData(_:)))
                    view.addGestureRecognizer(tapGesture)
                    view.tag = i
                    
                    self.mainStack.addArrangedSubview(view)
                    view.anchor(height: 100)
                }
            }
        }

    }
    
    
    @objc func viewEarnData(_ sender : UITapGestureRecognizer) {
        if let tag = sender.view?.tag {
            let ruleType = self.growaveVM.earningModel[tag].rule_type
            switch ruleType {
            case "create_account" :
                let tempView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                tempView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                accountView = GrowaveAccountView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 50, height: 200))
                accountView.center.x = self.view.center.x
                accountView.center.y = self.view.center.y - 100
                accountView.view.layer.borderWidth = 1.5
                accountView.view.layer.borderColor = UIColor.black.cgColor
                accountView.resultLabel.isHidden = true
                accountView.verifyBtn.addTarget(self, action: #selector(verifyUserEmail(_:)), for: .touchUpInside)
                let tapGesture = UITapGestureRecognizer()
                 
                 tapGesture.addTarget(self, action: #selector(self.dismissView(_:)))
                 tempView.addGestureRecognizer(tapGesture)
                tempView.tag = 123321
                self.view.addSubview(tempView)
                tempView.addSubview(accountView)
            case "place_order" :
                if customAppSettings.sharedInstance.showTabbar{
                  self.tabBarController?.selectedIndex = 0
                }else{
                  self.navigationController?.popToRootViewController(animated: true)
                }
            case "birthday_gift" :
                let tempView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                tempView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                birthdayView = GrowaveBirthdayView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 50, height: 200))
                birthdayView.center.x = self.view.center.x
                birthdayView.center.y = self.view.center.y - 100
                birthdayView.view.layer.borderWidth = 1.5
                birthdayView.view.layer.borderColor = UIColor.black.cgColor
                birthdayView.headingLabel.text = "Enter your birthday".localized
                birthdayView.saveButton.addTarget(self, action: #selector(self.saveBirthday(_:)), for: .touchUpInside)
                let tapGesture = UITapGestureRecognizer()
                 
                 tapGesture.addTarget(self, action: #selector(self.dismissView(_:)))
                 tempView.addGestureRecognizer(tapGesture)
                tempView.tag = 123321
                self.view.addSubview(tempView)
                tempView.addSubview(birthdayView)
            case "instagram_follow" :
                if let data = (self.growaveVM.earningModel[tag].instaUrl) {
                    if let instagramURL = URL(string: Client.BASE_INSTAGRAM_URL + "\(data)/") {
                        if UIApplication.shared.canOpenURL(instagramURL) {
                            UIApplication.shared.open(instagramURL)
                        }
                    }
                }
                
                
            default:
                print("default")
            }
        }
    }
    
    @objc func shopNowClicked(_ sender : UIButton) {
        if customAppSettings.sharedInstance.showTabbar{
          self.tabBarController?.selectedIndex = 0
        }else{
          self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc func saveBirthday(_ sender : UIButton) {
        if let date = birthdayView.dateField.text {
            if date == "" {
                self.view.showmsg(msg: "Please add your birthdate".localized)
                return;
            }
            let formatter = DateFormatter()

            formatter.dateFormat = "dd/MM/yyyy"
            let dateIsValid = formatter.date(from: date) != nil && (formatter.date(from: date) ?? Date() < Date())
            if !dateIsValid {
                self.view.showmsg(msg: "Please enter a valid date".localized)
                return;
            }
            self.growaveVM.updateUserBirthday(bday: date) { json in
                if let json = json {
                    if json["status"].stringValue == "201" {
                        self.view.showmsg(msg: "Birthdate updated successfully!!".localized)
                    }
                }
                if let view = self.view.viewWithTag(123321) {
                    view.removeFromSuperview()
                }
                
            }
            

        }
        
    }
    
    @objc func verifyUserEmail(_ sender : UIButton) {
        self.growaveVM.verifyUser { json in
            if let json = json {
                if json["status"].stringValue == "200" {
                    self.accountView.resultLabel.isHidden = false
                }
                else {
                    self.accountView.resultLabel.isHidden = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                if let view = self.view.viewWithTag(123321) {
                    view.removeFromSuperview()
                }
            }
            
        }
    }
    
    @objc func earnButtonClicked(_ sender : UIButton) {
        let points = self.growaveVM.spendingModel[sender.tag].price
        if points <= self.userPoints {
            let tempView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            tempView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            redeemView = GrowaveRedeemView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 50, height: 200))
            redeemView.center.x = self.view.center.x
            redeemView.center.y = self.view.center.y - 100
            redeemView.view.layer.borderWidth = 1.5
            redeemView.view.layer.borderColor = UIColor.black.cgColor
            redeemView.headingLabel.text = "Get ".localized+"\(self.growaveVM.spendingModel[sender.tag].title)"+" your next purchase for ".localized+" \(self.growaveVM.spendingModel[sender.tag].price)"+" points".localized
            redeemView.accept.tag = sender.tag
            redeemView.accept.addTarget(self, action: #selector(applyRedeemPoint(_:)), for: .touchUpInside)
            redeemView.reject.addTarget(self, action: #selector(removePoint(_:)), for: .touchUpInside)
            let tapGesture = UITapGestureRecognizer()
             
             tapGesture.addTarget(self, action: #selector(self.dismissView(_:)))
             tempView.addGestureRecognizer(tapGesture)
            tempView.tag = 123321
            self.view.addSubview(tempView)
            tempView.addSubview(redeemView)
        }
        else {
            self.loadEarnData()
            self.isGetReward = false
            self.isEarnPoints = true
            self.isTier = false
            self.initialSelection()
        }
    }
    
    @objc func dismissView(_ sender : UITapGestureRecognizer) {
        if let view = self.view.viewWithTag(123321) {
            view.removeFromSuperview()
        }
    }
    
    @objc func applyRedeemPoint(_ sender : UIButton) {
        let ruleId = self.growaveVM.spendingModel[sender.tag].rule_id
        self.growaveVM.redeemPointsForUser(ruleId: ruleId) { json in
            if let json = json {
                if json["status"].stringValue == "200" {
                    self.reloadPage()
                }
            }
            if let view = self.view.viewWithTag(123321) {
                view.removeFromSuperview()
            }
            
        }
    }
    
    @objc func removePoint(_ sender : UIButton) {
        if let view = self.view.viewWithTag(123321) {
            view.removeFromSuperview()
        }
    }
    
    @objc func copyButtonClicked(_ sender : UIButton) {
        print("copyButtonClicked")
        let discount = self.growaveVM.discountModel[sender.tag].discount_code
        UIPasteboard.general.string = discount
        self.view.showmsg(msg: "Copied".localized)
    }
  
    
}
