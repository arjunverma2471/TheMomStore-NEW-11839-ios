//
//  ReferFriendsViewController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 10/06/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import Foundation
import UIKit
class ReferFriendsViewController : UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var emailBtn: UIButton!
    
    @IBOutlet weak var labelTxt: UILabel!
    @IBOutlet weak var copyBtn: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var topLabel: UILabel!
    var emailPopup : ReferralEmailView!
    var referralCode = String()
    var customerEmail = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.isEnabled = false
        topLabel.text = "REFER FRIENDS".localized
        labelTxt.text = "Earn upto 500 points for every time you refer a friend who spends over ₹500. 1 point = Re 1".localized
        topLabel.backgroundColor = UIColor.AppTheme()
        topLabel.textColor = UIColor.textColor()
        textField.text = "http://rwrd.io/\(self.referralCode)?c"
        copyBtn.addTarget(self, action: #selector(copyToClipBoard(_:)), for: .touchUpInside)
        copyBtn.backgroundColor = UIColor.AppTheme()
        emailBtn.backgroundColor = UIColor.AppTheme()
        copyBtn.setTitleColor(UIColor.textColor(), for: .normal)
        emailBtn.setTitleColor(UIColor.textColor(), for: .normal)
        emailBtn.layer.cornerRadius = 5.0
        emailBtn.addTarget(self, action: #selector(openEmailpopUp(_:)), for: .touchUpInside)
        imgView.tintColor = UIColor.iconColor
        emailBtn.setTitle("Email".localized, for: .normal)
    }
    @objc func copyToClipBoard(_ sender : UIButton) {
        UIPasteboard.general.string = textField.text
        self.view.makeToast("Copied".localized)
    }
    
    @objc func openEmailpopUp(_ sender : UIButton) {
        emailPopup = ReferralEmailView(frame: CGRect(x: 0 , y: 0, width: UIScreen.main.bounds.width - 50, height: 300))
        emailPopup.tag = 10001;
        emailPopup.center.x = self.view.center.x
        emailPopup.center.y = self.view.center.y - 100
        emailPopup.view.layer.borderWidth = 1.5
        emailPopup.view.layer.borderColor = UIColor.iconColor.cgColor
        emailPopup.closeBtn.tintColor = UIColor.iconColor
        emailPopup.sendEmail.backgroundColor = UIColor.AppTheme()
        emailPopup.sendEmail.setTitleColor(UIColor.textColor(), for: .normal)
        emailPopup.topHeading.textColor = UIColor.textColor()
        emailPopup.labelInfo.textColor = UIColor.textColor()
        emailPopup.closeBtn.addTarget(self, action: #selector(dismissView(_:)), for: .touchUpInside)
        emailPopup.sendEmail.layer.cornerRadius = 5.0
        emailPopup.sendEmail.addTarget(self, action: #selector(sendEmail(_:)), for: .touchUpInside)
        self.view.addSubview(emailPopup)
        
    }
    
    @objc func dismissView(_ sender : UIButton) {
        self.view.viewWithTag(10001)?.removeFromSuperview()
    }
    
    
    @objc func sendEmail(_ sender : UIButton) {
        if emailPopup.emailTextField.text == "" {
            self.view.makeToast("Please enter valid email".localized)
            return;
        }
        let url = "https://loyalty.yotpo.com/api/v2/referral/share"//"&email=\(self.customerEmail)&emails=\(emailPopup.emailTextField.text ?? "")"
    //    let params = ["email" : self.customerEmail , "emails" : emailPopup.emailTextField.text ?? ""]
        let postString = "email=\(self.customerEmail)&emails=\(emailPopup.emailTextField.text ?? "")"
        guard let urlRequest = url.getURL() else {return}
        var request = URLRequest(url: urlRequest)
        request.httpMethod="POST"
        request.httpBody = postString.data(using: String.Encoding.utf8)//data
        request.setValue("\(Client.yotpoRewardGUID)", forHTTPHeaderField: "x-guid")
        request.setValue("\(Client.yotpoRewardApiKey)", forHTTPHeaderField: "x-api-key")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let task=URLSession.shared.dataTask(with: request, completionHandler: {data,response,error in
          DispatchQueue.main.sync
          {
            do {
              guard let data = data else {return;}
              guard let json = try? JSON(data:data) else {return;}
                self.view.makeToast("Email has been sent successfully".localized, duration: 2.0, position: .center)
            }
          }
        })
        task.resume()
            
    }
}
