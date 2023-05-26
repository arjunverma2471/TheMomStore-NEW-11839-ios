//
//  GetRewardsViewController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 10/06/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import Foundation
import FSCalendar
import UIKit

protocol setDateValueDelegate {
  func setDate(value: String)
}

class GetRewardsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
  
    struct RewardContent {
        var image : String?
        var title : String?
        var desc : String?
        var icon : String?
    }
    var rewardContent = [RewardContent]()
    var isfromGetrewards = true
    var customerEmail = String()
    var customerId = String()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topLabel: UILabel!
    var rewardData = [[String:String]]()
    var redeemView : RedeemRewardView?
    var couponCode = String()
    var earnPtsView : EarnPointsView?
    var referralCode = String()
    let tempView = UIView()
    let datePickerView = UIDatePicker()//FSCalendar()
    let screenSize: CGRect = UIScreen.main.bounds;
    var receivedDate:String = ""
    var selectedDate : Date?
    var delegate: setDateValueDelegate?
    var deliveryDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topLabel.backgroundColor = UIColor.black
        if isfromGetrewards {
            topLabel.text = "REDEEM MY POINTS".localized
        }
        else {
            topLabel.text = "EARN POINTS".localized
        }
        topLabel.backgroundColor = UIColor.AppTheme()
        topLabel.textColor = UIColor.textColor()
        topLabel.font = mageFont.mediumFont(size: 15.0)
        getData()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
      

    }
    
    func getData() {
        if isfromGetrewards {
            let url = "https://loyalty.yotpo.com/api/v2/redemption_options"
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
                    for items in json {
                        var data = [String:String]()
                        for (k,v) in items.1.dictionaryValue
                        {
                            data[k] = v.stringValue
                        }
                        self.rewardData.append(data)
                        
                    }
                    self.tableView.reloadData()
                }
              }
            })
            task.resume()

            
        }
        else {
            
            let url = "https://loyalty.yotpo.com/api/v2/campaigns?with_status=true&customer_email=\(self.customerEmail)"
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
                    for items in json {
                        var data = [String:String]()
                        for (k,v) in items.1.dictionaryValue
                        {
                            data[k] = v.stringValue
                        }
                        self.rewardData.append(data)
                        
                    }
                    self.tableView.reloadData()
                }
              }
            })
            task.resume()
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rewardData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isfromGetrewards {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GetRewardsTableCell", for: indexPath) as! GetRewardsTableCell
            cell.selectionStyle = .none
            cell.headingLbl.text = rewardData[indexPath.row]["name"]
            cell.descLbl.text = rewardData[indexPath.row]["cost_text"]
            cell.headingLbl.textColor = UIColor.AppTheme()//UIColor.textColor()
            cell.descLbl.backgroundColor = UIColor.AppTheme()
            cell.wrapperView.layer.borderWidth = 2.0
            cell.wrapperView.layer.borderColor = UIColor.AppTheme().cgColor//UIColor.textColor().cgColor
            cell.headingLbl.font = mageFont.mediumFont(size: 16.0)
            cell.descLbl.font = mageFont.regularFont(size: 15.0)
            let imageType = rewardData[indexPath.row]["icon"]?.trimmingCharacters(in: .whitespaces)
            switch imageType {
            case "fa-inr" :
                cell.imgView.image = UIImage(named: "rupppeee")
            case "fa-heart":
                cell.imgView.image = UIImage(named: "yotpoheart")
            case "fa-user":
                cell.imgView.image = UIImage(named: "yotpouser")
            case "fa-birthday-cake":
                cell.imgView.image = UIImage(named: "yotpocake")
            case "fa-dollar":
                cell.imgView.image = UIImage(named: "yotpodollar")
            default:
                print("test")
            }
           
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GetRewardsTableCell", for: indexPath) as! GetRewardsTableCell
            cell.selectionStyle = .none
            cell.headingLbl.text = rewardData[indexPath.row]["title"]
            cell.descLbl.text = rewardData[indexPath.row]["reward_text"]
            let type = rewardData[indexPath.row]["type"]
            if type == "CreateAccountCampaign" {
                cell.descLbl.text = type
            }
            cell.descLbl.backgroundColor = UIColor.AppTheme()
            cell.wrapperView.layer.borderWidth = 2.0
            cell.headingLbl.textColor = UIColor.AppTheme()//UIColor.textColor()
            cell.wrapperView.layer.borderColor = UIColor.AppTheme().cgColor//UIColor.textColor().cgColor
            cell.headingLbl.font = mageFont.mediumFont(size: 16.0)
            cell.descLbl.font = mageFont.regularFont(size: 15.0)
            let imageType = rewardData[indexPath.row]["icon"]?.trimmingCharacters(in: .whitespaces)
            switch imageType {
            case "fa-inr" :
                cell.imgView.image = UIImage(named: "rupppeee")
            case "fa-heart":
                cell.imgView.image = UIImage(named: "yotpoheart")
            case "fa-user":
                cell.imgView.image = UIImage(named: "yotpouser")
            case "fa-birthday-cake":
                cell.imgView.image = UIImage(named: "yotpocake")
            case "fa-dollar":
                cell.imgView.image = UIImage(named: "yotpodollar")
            default:
                print("test")
            }
           
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isfromGetrewards {
            let tempView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            tempView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            redeemView = RedeemRewardView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 50, height: 250))
            redeemView?.center.x = self.view.center.x
            redeemView?.center.y = self.view.center.y - 100
            redeemView?.tag = 123344;
            redeemView?.closeBtn.addTarget(self, action: #selector(dismissView(_:)), for: .touchUpInside)
            redeemView?.view.layer.borderWidth = 1.5
            redeemView?.view.layer.borderColor = UIColor.textColor().cgColor
            redeemView?.headingTxt.text = rewardData[indexPath.row]["name"]
            redeemView?.descriptionTxt.text = rewardData[indexPath.row]["description"]
            redeemView?.headingTxt.textColor = UIColor.AppTheme()//UIColor.textColor()
            redeemView?.descriptionTxt.textColor = UIColor.textColor()
            redeemView?.closeBtn.tintColor = UIColor.AppTheme()//UIColor.textColor()
            redeemView?.redeemBtn.setTitleColor(UIColor.textColor(), for:.normal)
            redeemView?.redeemBtn.backgroundColor = UIColor.AppTheme()
            redeemView?.redeemBtn.addTarget(self, action: #selector(redeemRewardButton(_:)), for: .touchUpInside)
            redeemView?.redeemBtn.tag = indexPath.row
            redeemView?.redeemBtn.layer.cornerRadius = 5.0
            tempView.tag = 123321
            self.view.addSubview(tempView)
            tempView.addSubview(redeemView!)
            
        }
        
        else {
            let tempView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            tempView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            earnPtsView = EarnPointsView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 50, height: 275))
            earnPtsView?.center.x = self.view.center.x
            earnPtsView?.center.y = self.view.center.y - 100
            earnPtsView?.tag = 14526;
            earnPtsView?.topHaedingLbl.textColor = UIColor.AppTheme()//UIColor.textColor()
            earnPtsView?.closeBtn.tintColor = UIColor.AppTheme()//UIColor.textColor()
            earnPtsView?.closeBtn.addTarget(self, action: #selector(dismissPointView(_:)), for: .touchUpInside)
            earnPtsView?.view.layer.borderWidth = 1.5
            earnPtsView?.view.layer.borderColor = UIColor.iconColor.cgColor
            earnPtsView?.topHaedingLbl.numberOfLines = 0
            earnPtsView?.descriptionLabel.numberOfLines = 0
            let type = rewardData[indexPath.row]["icon"]?.trimmingCharacters(in: .whitespaces)
            switch type{
            case "fa-inr" :
                earnPtsView?.topHaedingLbl.text = rewardData[indexPath.row]["title"]
                earnPtsView?.descriptionLabel.text = rewardData[indexPath.row]["details"]
    
            case "fa-heart":
                earnPtsView?.topHaedingLbl.text = rewardData[indexPath.row]["title"]
                earnPtsView?.descriptionLabel.text = rewardData[indexPath.row]["details"]
                earnPtsView?.redirectBtn.isHidden = false
                earnPtsView?.redirectBtn.setTitleColor(UIColor.iconColor, for: .normal)
                earnPtsView?.redirectBtn.layer.cornerRadius = 5.0
                earnPtsView?.redirectBtn.addTarget(self, action: #selector(redirectToReferral(_:)), for: .touchUpInside)
            case "fa-user":
                earnPtsView?.topHaedingLbl.text = rewardData[indexPath.row]["title"]
                earnPtsView?.descriptionLabel.text = rewardData[indexPath.row]["details"]
            case "fa-birthday-cake":
                earnPtsView?.topHaedingLbl.text = rewardData[indexPath.row]["title"]
                    earnPtsView?.descriptionLabel.text = rewardData[indexPath.row]["details"]
                    earnPtsView?.bottomLabel.text = rewardData[indexPath.row]["extra_copy1"]
                    earnPtsView?.redirectBtn.setTitle(rewardData[indexPath.row]["cta_text"], for:.normal)
                    earnPtsView?.redirectBtn.isHidden = false
                    earnPtsView?.dateBtn.isHidden = false
                    earnPtsView?.bottomLabel.isHidden = false
                    earnPtsView?.dateBtn.layer.borderWidth = 0.5
                    earnPtsView?.dateBtn.layer.borderColor = UIColor.white.cgColor
                    earnPtsView?.dateBtn.backgroundColor = UIColor.iconColor
                    earnPtsView?.redirectBtn.setTitleColor(UIColor.iconColor, for: .normal)
                    earnPtsView?.dateBtn.addTarget(self, action: #selector(datebtnClicked(_:)), for: .touchUpInside)
                    earnPtsView?.redirectBtn.addTarget(self, action: #selector(birthdayButtonClicked(_:)), for: .touchUpInside)
                
            case "fa-dollar":
                earnPtsView?.topHaedingLbl.text = rewardData[indexPath.row]["title"]
                earnPtsView?.descriptionLabel.text = rewardData[indexPath.row]["details"]
            default:
                print("test")
            }
            tempView.tag = 123321
            self.view.addSubview(tempView)
            tempView.addSubview(earnPtsView!)
            
        }
    }
    
    @objc func dismissPointView(_ sender : UIButton) {
        self.view.viewWithTag(123321)?.removeFromSuperview()
    }
    @objc func redirectToReferral(_ sender : UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ReferFriendsViewController") as! ReferFriendsViewController
        vc.referralCode = self.referralCode
        vc.customerEmail = self.customerEmail
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func dismissView(_ sender : UIButton) {
        self.view.viewWithTag(123321)?.removeFromSuperview()
    }
    
    @objc func redeemRewardButton(_ sender : UIButton) {
        let redemptionId = rewardData[sender.tag]["id"] ?? ""
        let url = "https://loyalty.yotpo.com/api/v2/redemptions?customer_external_id=\(self.customerId)&customer_email=\(self.customerEmail)&redemption_option_id=\(redemptionId)"
        guard let urlRequest = url.getURL() else {return}
        var request = URLRequest(url: urlRequest)
        request.httpMethod="POST"
        request.setValue("\(Client.yotpoRewardGUID)", forHTTPHeaderField: "x-guid")
        request.setValue("\(Client.yotpoRewardApiKey)", forHTTPHeaderField: "x-api-key")
        let task=URLSession.shared.dataTask(with: request, completionHandler: {data,response,error in
          DispatchQueue.main.sync
          {
            do {
              guard let data = data else {return;}
              guard let json = try? JSON(data:data) else {return;}
                
                print(json)
                if (json["amount"].exists()) {
                    self.redeemView?.resultTxt.text = json["amount"].arrayValue.first?.stringValue
                    self.redeemView?.resultTxt.textColor = UIColor.systemRed
                }
                if (json["reward_text"].exists()) {
                    self.couponCode = json["reward_text"].stringValue
                    self.redeemView?.resultTxt.text = "Thanks for redeeming! Here's your coupon code ".localized + json["reward_text"].stringValue
                    self.redeemView?.resultTxt.textColor = UIColor.white
                    self.redeemView?.copyBtn.isHidden = false
                    self.redeemView?.copyBtn.setTitleColor(UIColor.iconColor, for: .normal)
                    self.redeemView?.copyBtn.tintColor = UIColor.iconColor
                    self.redeemView?.copyBtn.addTarget(self, action: #selector(self.copyCode(_:)), for: .touchUpInside)
                    
                    
                }
            }
          }
        })
        task.resume()
            
    }
    
    
    @objc func copyCode(_ sender : UIButton) {
        UIPasteboard.general.string = self.couponCode
        self.view.makeToast("Copied".localized)
    }
    
    @objc func datebtnClicked(_ sender:UIButton){
        print("clicked")
        if #available(iOS 14.0, *) {
            datePickerView.preferredDatePickerStyle = .inline
        } else {
            // Fallback on earlier versions
        }
        
    tempView.frame = UIScreen.main.bounds;
    
    tempView.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight , UIView.AutoresizingMask.flexibleWidth];
    tempView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:0.5);
        let dismissBtn = UIButton()
        dismissBtn.frame = UIScreen.main.bounds
        dismissBtn.addTarget(self, action: #selector(backgroundClicked(_:)), for: .touchUpInside)
    self.view.addSubview(tempView)
        tempView.addSubview(dismissBtn)
    
    let tempInrView = UIView();
    tempInrView.frame = CGRect(x: 0, y: CGFloat(0), width: screenSize.width-50,height: CGFloat(240));
    tempInrView.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight , UIView.AutoresizingMask.flexibleWidth];
    tempInrView.backgroundColor = UIColor.white;
    tempInrView.center = CGPoint(x: tempView.frame.size.width / 2,
                                 y: tempView.frame.size.height/2);
    tempInrView.layer.borderColor = UIColor.blue.cgColor
    tempInrView.layer.borderWidth = 1.5
    tempView.addSubview(tempInrView)
    
    datePickerView.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin,UIView.AutoresizingMask.flexibleRightMargin];
    datePickerView.frame = CGRect(x: 0, y: CGFloat(0), width: tempInrView.frame.width,height: CGFloat(240));
    tempInrView.addSubview(datePickerView)
        datePickerView.datePickerMode = UIDatePicker.Mode.date;
        datePickerView.setValue(UIColor.black, forKeyPath: "textColor");
        datePickerView.backgroundColor = UIColor.white;
        datePickerView.maximumDate = Date()
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)

    datePickerView.locale = Locale(identifier: "en")

    }
    @objc func backgroundClicked(_ sender:UIButton){
        tempView.removeFromSuperview()
    }
    @objc func datePickerValueChanged(_ sender : UIDatePicker) {
        let date = datePickerView.date ?? Date()
         let formatter = DateFormatter()
         formatter.dateFormat = "dd-MM-yyyy"
         let result = formatter.string(from: date)
         print(result)
        self.selectedDate = date
        self.deliveryDate = formatter.string(from: date)
         print(self.deliveryDate)
         earnPtsView?.dateBtn.setTitle("\(deliveryDate)", for: .normal)
         tempView.removeFromSuperview()
    }
    
    
    
    @objc func birthdayButtonClicked(_ sender : UIButton) {
        if selectedDate == nil {
            self.view.showmsg(msg: "Please select a date".localized)
            return;
        }
        print(self.deliveryDate)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: selectedDate!)
        let year = components.year
        let month = components.month
        let day = components.day
        let url = "https://loyalty.yotpo.com/api/v2/customer_birthdays"
        let postString = "&customer_email=\(customerEmail)&day=\(day ?? 0)&month=\(month ?? 0)&year=\(year ?? 0)"
        print(postString)
        guard let urlRequest = url.getURL() else {return}
        var request = URLRequest(url: urlRequest)
        request.httpMethod="POST"
        request.setValue("\(Client.yotpoRewardGUID)", forHTTPHeaderField: "x-guid")
        request.setValue("\(Client.yotpoRewardApiKey)", forHTTPHeaderField: "x-api-key")
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task=URLSession.shared.dataTask(with: request, completionHandler: {data,response,error in
          DispatchQueue.main.sync
          {
            do {
              guard let data = data else {return;}
              guard let json = try? JSON(data:data) else {return;}
                self.view.viewWithTag(123321)?.removeFromSuperview()
            }
          }
        })
        task.resume()

    }
    
    
}
