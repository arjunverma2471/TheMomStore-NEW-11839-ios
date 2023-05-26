//
//  RewardViewController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 09/06/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import Foundation
import UIKit

class RewardViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    struct RewardContent {
        var image : String?
        var title : String?
        var desc : String?
    }
    
    @IBOutlet weak var loginTxt: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topLabel: UILabel!
    var rewardContent = [RewardContent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginTxt.text = "Log in or sign up to earn rewards today".localized
        topLabel.text = "Reward Points".localized
        self.topLabel.backgroundColor = UIColor.AppTheme()
        self.registerBtn.backgroundColor = UIColor.AppTheme()
        self.loginBtn.backgroundColor = UIColor.AppTheme()
        self.topLabel.textColor = UIColor.textColor()
        self.registerBtn.setTitleColor(UIColor.textColor(), for: .normal)
        self.loginBtn.setTitleColor(UIColor.textColor(), for: .normal)
        self.getData()
        loginTxt.font = mageFont.regularFont(size: 15.0)
        topLabel.font = mageFont.mediumFont(size: 16.0)
        loginBtn.setTitle("Log In".localized, for: .normal)
        registerBtn.setTitle("Create Account".localized, for: .normal)
        loginBtn.titleLabel?.font = mageFont.mediumFont(size: 15.0)
        registerBtn.titleLabel?.font = mageFont.mediumFont(size: 15.0)
        loginBtn.addTarget(self, action: #selector(redirectToLogin(_:)), for: .touchUpInside)
        registerBtn.addTarget(self, action: #selector(redirectToRegister(_:)), for: .touchUpInside)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    func getData() {
        rewardContent.append(RewardContent(image: "ruppee", title: "Spend Rs 1000".localized, desc: "150 Points".localized))
        rewardContent.append(RewardContent(image: "black-heart", title: "Refer a friend".localized, desc: "500 Points".localized))
        rewardContent.append(RewardContent(image: "new-user", title: "Create an Account".localized, desc: "300 Points".localized))
        rewardContent.append(RewardContent(image: "ruppee", title: "₹500 Off".localized, desc: "500 Points".localized))
        rewardContent.append(RewardContent(image: "ruppee", title: "₹1000 Off".localized, desc: "1000 Points".localized))
        rewardContent.append(RewardContent(image: "ruppee", title: "₹2500 Off".localized, desc: "2500 Points".localized))
        rewardContent.append(RewardContent(image: "ruppee", title: "₹5000 off".localized, desc: "5000 Points".localized))
        rewardContent.append(RewardContent(image: "ruppee", title: "Rs. 1500 off".localized, desc: "1500 Points".localized))
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RewardTableCell", for: indexPath) as! RewardTableCell
            cell.imgView.image = UIImage(named: rewardContent[indexPath.row].image ?? "")
            cell.headingLbl.text = rewardContent[indexPath.row].title
            cell.descriptionLbl.text = rewardContent[indexPath.row].desc
            cell.imgView.tintColor = UIColor.iconColor
            cell.headingLbl.font = mageFont.mediumFont(size: 16.0)
            cell.descriptionLbl.font = mageFont.regularFont(size: 15.0)
            return cell
        }
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RewardTableCell", for: indexPath) as! RewardTableCell
            cell.imgView.image = UIImage(named: rewardContent[indexPath.row+3].image ?? "")
            cell.headingLbl.text = rewardContent[indexPath.row+3].title
            cell.descriptionLbl.text = rewardContent[indexPath.row+3].desc
            cell.headingLbl.font = mageFont.mediumFont(size: 16.0)
            cell.descriptionLbl.font = mageFont.regularFont(size: 15.0)
            cell.imgView.tintColor = UIColor.iconColor
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "EARN POINTS FOR ACTIONS".localized
        }
        if section == 1{
            return "REDEEM POINTS FOR DISCOUNTS".localized
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    @objc func redirectToLogin(_ sender : UIButton) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController" ) as! LoginViewController
//        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationController?.popViewController(animated: false) {
            if let loginNavigation = self.storyboard?.instantiateViewController(withIdentifier:"NewLoginNavigation") {
                loginNavigation.modalPresentationStyle = .fullScreen
                self.present(loginNavigation, animated: true, completion: nil)
            }
        }
    }
    
    @objc func redirectToRegister(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: false) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomerSignUpViewController" ) as! CustomerSignUpViewController
        self.navigationController?.pushViewController(vc, animated: false)
           
        }
    }
}
