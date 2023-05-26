//
//  RewardPointsViewController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 09/06/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import Foundation
import UIKit
class RewardPointsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var rewardContent = [RewardContent]()
    struct RewardContent {
        var image : String?
        var name : String?
        
    }
    var totalPointsEarned = String()
    var customerId = String()
    var customerEmail = String()
    var myRewardData = [[String:String]]()
    var referralCode = String()
    var pointsBalance = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      self.title = "Earn Rewards".localized
        fetchData()
        getData()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func fetchData() {
        self.view.addLoader()
        Client.shared.fetchCustomerDetails(completeion: {
            response,error   in
            if let response = response {
                self.view.stopLoader()
                self.customerId = response.customerId?.components(separatedBy: "/").last ?? "" //base64decode() ?? ""
                self.customerEmail = response.email ?? ""
                let url = "https://loyalty.yotpo.com/api/v2/customers?customer_id=\(self.customerId)&customer_email=\(self.customerEmail)&with_referral_code=true&with_history=true"
                print(url)
                guard let urlRequest = url.getURL() else {return}
                var request = URLRequest(url: urlRequest)
                request.httpMethod="GET"
                request.setValue("\(Client.yotpoRewardGUID)", forHTTPHeaderField: "x-guid")
                request.setValue("\(Client.yotpoRewardApiKey)", forHTTPHeaderField: "x-api-key")
                let task=URLSession.shared.dataTask(with: request, completionHandler: {data,response,error in
                  DispatchQueue.main.sync
                  {
                    do {
                      guard let data = data else {return;}
                      guard let json = try? JSON(data:data) else {return;}
                        print(json)
                        self.totalPointsEarned = json["points_earned"].stringValue
                        self.referralCode = json["referral_code"]["code"].stringValue
                        self.pointsBalance = json["points_balance"].stringValue
                        for items in json["history_items"].arrayValue {
                            var data = [String:String]()
                            for (k,v) in items {
                                data[k] = v.stringValue
                            }
                            self.myRewardData.append(data)
                            }
                        self.tableView.reloadData()
                        }
                    }
                })
                task.resume()
            }
        })
        
        
    }
    func getData() {
        rewardContent.append(RewardContent(image: "giftbox", name: "REDEEM MY POINTS".localized))
        rewardContent.append(RewardContent(image: "icons8-star-50", name: "EARN POINTS".localized))
        rewardContent.append(RewardContent(image: "outline_favorite_black_24pt", name: "REFER FRIENDS".localized))
        rewardContent.append(RewardContent(image: "new-user", name: "MY POINTS HISTORY".localized))
        rewardContent.append(RewardContent(image: "help-web-button", name: "FAQS".localized))
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RewardPointsTopTableCell", for: indexPath) as! RewardPointsTopTableCell
            cell.topHeading.text = "TOTAL POINTS EARNED".localized
            cell.descLabel.text = self.totalPointsEarned + " POINTS".localized
            cell.pointsBalanceLbl.text = "POINTS BALANCE".localized
            cell.ptsLbl.text = self.pointsBalance + " POINTS".localized
            cell.topHeading.backgroundColor = UIColor.AppTheme()
            cell.descLabel.backgroundColor = UIColor.AppTheme()
            cell.pointsBalanceLbl.backgroundColor = UIColor.AppTheme()
            cell.ptsLbl.backgroundColor = UIColor.AppTheme()
            cell.topHeading.textColor = UIColor.textColor()
            cell.descLabel.textColor = UIColor.textColor()
            cell.pointsBalanceLbl.textColor = UIColor.textColor()
            cell.ptsLbl.textColor = UIColor.textColor()
            cell.topHeading.font = mageFont.mediumFont(size: 15.0)
            cell.descLabel.font = mageFont.mediumFont(size: 15.0)
            cell.pointsBalanceLbl.font = mageFont.mediumFont(size: 15.0)
            cell.ptsLbl.font = mageFont.mediumFont(size: 15.0)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RewardPointsBottomTableCell", for: indexPath) as! RewardPointsBottomTableCell
            cell.imgView.image = UIImage(named: rewardContent[indexPath.row].image ?? "")
            cell.imgView.tintColor = UIColor.iconColor
            cell.labelText.text = rewardContent[indexPath.row].name
            cell.labelText.font = mageFont.regularFont(size: 15.0)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 75
        }
        else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                let vc = storyboard?.instantiateViewController(withIdentifier: "GetRewardsViewController") as! GetRewardsViewController
                vc.isfromGetrewards = true
                vc.customerId = self.customerId
                vc.customerEmail = self.customerEmail
                self.navigationController?.pushViewController(vc, animated: true)
               
            case 1:
                let vc = storyboard?.instantiateViewController(withIdentifier: "GetRewardsViewController") as! GetRewardsViewController
                vc.isfromGetrewards = false
                vc.referralCode = self.referralCode
                vc.customerEmail = self.customerEmail
                self.navigationController?.pushViewController(vc, animated: true)
                
            case 2 :
                let vc = storyboard?.instantiateViewController(withIdentifier: "ReferFriendsViewController") as! ReferFriendsViewController
                vc.referralCode = self.referralCode
                vc.customerEmail = self.customerEmail
                self.navigationController?.pushViewController(vc, animated: true)
                
            case 3 :
                let vc = storyboard?.instantiateViewController(withIdentifier: "RewardListingViewController") as! RewardListingViewController
                vc.myRewardData=self.myRewardData
              self.navigationController?.pushViewController(vc, animated: true)
            
            case 4 :
                let vc = storyboard?.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
                self.navigationController?.pushViewController(vc, animated: true)
                
            default:
                print("default")
            }
        }
    }
    
}
