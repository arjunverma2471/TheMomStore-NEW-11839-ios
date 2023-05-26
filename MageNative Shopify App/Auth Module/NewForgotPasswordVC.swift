//
//  NewForgotPasswordVC.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 09/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class NewForgotPasswordVC: UIViewController {

    @IBOutlet weak var emailView: UIView!
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var btn_submit: UIButton!
    
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var txtLbl: UILabel!
    @IBOutlet weak var emailField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.closeBtn.tintColor = .AppTheme()
        // Do any additional setup after loading the view.
        emailView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        emailView.layer.borderWidth = 0.5
        headingLbl.text = "Forgot Password".localized
        txtLbl.text = "Enter your registered mail to get reset link and follow the steps in mail to reset the password".localized
        //txtLbl.font = mageFont.regularFont(size: 14.0)
        //emailField.font = mageFont.regularFont(size: 15.0)
        emailField.placeholder = "Email".localized
        //btn_submit.titleLabel?.font = mageFont.mediumFont(size: 15.0)
        btn_submit.setTitle("Submit".localized, for: .normal)
        if(Client.locale == "ar"){
            emailField.textAlignment = .right
            headingLbl.textAlignment = .right
            txtLbl.textAlignment = .right
        }
        else{
            emailField.textAlignment = .left
            headingLbl.textAlignment = .left
            txtLbl.textAlignment = .left
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
   
    @IBAction func submitEmail_Clicked(_ sender: Any) {
        guard let email = emailField.text else {return}
        if email == ""{
            self.showErrorAlert(error: "Email is empty.".localized)
            return
        }
        self.view.addLoader()
        Client.shared.forgetPassword(with: email, completion: {
            error,netError  in
            self.view.stopLoader()
            if let error = error {
                if error.count != 0 {
                    //self.showErrorAlert(errors: error)
                }else {
                     self.showErrorAlert(error: "A reset password link sent to your email id.".localized)
                }
            }else if let _ = netError{
                //self.showErrorAlert(error: netError.localizedDescription)
            }
        })
    }
    
    @IBAction func back_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
