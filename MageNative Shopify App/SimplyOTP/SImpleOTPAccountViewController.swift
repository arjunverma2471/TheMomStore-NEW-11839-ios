//
//  SImpleOTPAccountViewController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 24/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import UIKit

class SimpleOTPAccountViewController: UIViewController {
    var phoneNumber: String = ""
    var flitsProfileManager : FlitsProfileManager?
    private let growaveToken = GrowaveTokenHandler()
    let viewModel = SimplyOTPViewModel()
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "header")?.withRenderingMode(.alwaysOriginal)
        return imageView
    }()
    
    fileprivate lazy var accountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = mageFont.mediumFont(size: 20)
        label.textAlignment = .center
        label.text = "Account Details".localized
        return label
    }()
    
    fileprivate let firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.textColor = .textColor()
        textField.layer.borderWidth = 1
        textField.textAlignment = .left
        textField.clipsToBounds = true
        textField.placeholder = "First Name".localized
        textField.font = mageFont.regularFont(size: 16)
        textField.setLeftPaddingPoints(15)
        textField.setRightPaddingPoints(15)
        return textField
    }()
    
    
    fileprivate let lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.textColor = .textColor()
        textField.layer.borderWidth = 1
        textField.textAlignment = .left
        textField.clipsToBounds = true
        textField.placeholder = "Last Name".localized
        textField.font = mageFont.regularFont(size: 16)
        textField.setLeftPaddingPoints(15)
        textField.setRightPaddingPoints(15)
        return textField
    }()
    
    fileprivate let emailTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.textColor = .textColor()
        textField.layer.borderWidth = 1
        textField.textAlignment = .left
        textField.clipsToBounds = true
        textField.placeholder = "Email".localized
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.font = mageFont.regularFont(size: 16)
        textField.setLeftPaddingPoints(15)
        textField.setRightPaddingPoints(15)
        return textField
    }()
    
    fileprivate lazy var phoneTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.textColor = .lightGray
        textField.layer.borderWidth = 1
        textField.textAlignment = .left
        textField.clipsToBounds = true
        textField.text = "\(phoneNumber)"
        textField.font = mageFont.regularFont(size: 16)
        textField.setLeftPaddingPoints(15)
        textField.setRightPaddingPoints(15)
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    fileprivate lazy var updateButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .AppTheme()
        button.cardView()
        button.setTitle("UPDATE".localized, for: .normal)
        button.titleLabel?.font = mageFont.mediumFont(size: 14)
        button.tintColor = .white
        button.addTarget(self, action: #selector(updateDetails), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .viewBackgroundColor()
        imageViewLayout()
        accountLabelLayout()
        textfieldsLayout(currentView: firstNameTextField, previousView: accountLabel)
        textfieldsLayout(currentView: lastNameTextField, previousView: firstNameTextField)
        textfieldsLayout(currentView: emailTextField, previousView: lastNameTextField)
        textfieldsLayout(currentView: phoneTextField, previousView: emailTextField)
        textfieldsLayout(currentView: updateButton, previousView: phoneTextField)
    }
    
    private func imageViewLayout() {
        view.addSubview(imageView)
        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, paddingTop: 30, paddingLeft: ((view.frame.size.width / 2) - 70), width: 140, height: 140)
    }
    
    private func accountLabelLayout() {
        view.addSubview(accountLabel)
        accountLabel.anchor(top: imageView.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingTop: 8, paddingLeft: 20, paddingRight: 20, height: 30)
    }
    
    private func textfieldsLayout(currentView: UIView, previousView: UIView) {
        view.addSubview(currentView)
        currentView.anchor(top: previousView.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingTop: 30, paddingLeft: 20, paddingBottom: 10, paddingRight: 20, height: 50)
    }
    
    @objc func updateDetails() {
        updateAccount()
    }
    
    private func updateAccount() {
        guard let firstName = firstNameTextField.text else {return}
        guard let lastName = lastNameTextField.text else {return}
        guard let email = emailTextField.text else {return}
        guard let otpID = UserDefaults.standard.value(forKeyPath: "simplyOTPID") as? String else {return}
        viewModel.updateAccountDetails(firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber, otp_id: otpID) {[weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.socialLoginPressed(emailUsed: email, firstName: firstName, lastName: lastName)
                }
            case .failed(let err):
                print(err)
                self?.showMessgae(message: err)
            }
        }
    }
    
    func socialLoginPressed(emailUsed: String, firstName: String, lastName: String) {
        let url = URL(string: "http://shopifymobileapp.cedcommerce.com/shopifymobile/shopifyapi/sociologincustomer?mid=\(Client.merchantID)&email="+emailUsed)
        
        var urlreq = URLRequest(url: url!)
        urlreq.httpMethod = "GET"
        urlreq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        self.view.addLoader()
        
        let task=URLSession.shared.dataTask(with: urlreq, completionHandler: {data,response,error in
            if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode/100 != 2
            {
                DispatchQueue.main.sync
                {
                    self.view.stopLoader()
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                return;
            }
            guard error == nil && data != nil else
            {
                DispatchQueue.main.sync
                {
                    self.view.stopLoader()
                    print("error=\(error)")
                    if error?.localizedDescription=="The Internet connection appears to be offline."{
                    }
                }
                return;
            }
            
            DispatchQueue.main.sync
            {
                self.view.stopLoader()
                guard let data = data else {return;}
                guard let json = try? JSON(data: data) else {return;}
                print(json)
                if json["is_present"] == true && json["success"] == true && json["is_changed"] == true
                {
                    print("success")
                    self.dynamicLogin(email: emailUsed)
                    //self.loginpressed(emailid: self.emailUsed, pswrd: "pass@kwd")
                }
                if json["is_present"] == true && json["success"] == true && json["state"].stringValue == "disabled"
                {
                    print("disabled")
                    //                        self.view.makeToast("Your id has been blocked.", duration: 2.0, position: .top, title: nil, image: nil, style: nil, completion: nil);
                }
                if json["is_present"] == false && json["success"] == true
                {
                    print("not register")
                    self.doSignUp(emailUsed, firstName, lastName)
                }
            }
        })
        task.resume()
    }
    
    func dynamicLogin(email: String, signUpUserData:SignUpUserData? = nil){
        self.view.addLoader()
        Client.shared.customerAccessToken(email: email, password: "pass@kwd", completion: {
            token,usererror,error in
            self.view.stopLoader()
            UserDefaults.standard.set("pass@kwd", forKey: "password")
            
            UserDefaults.standard.set(true, forKey: "isSocialLogin")
            UserDefaults.standard.synchronize()
            guard let token = token else {
                if let usererror = usererror {
                    if usererror.first?.errorMessage.lowercased() == "Unidentified Customer".lowercased() {
                        self.showErrorAlert(error: "Username or Password is Incorrect.".localized)
                    }else {
                        //self.showErrorAlert(errors: usererror)
                    }
                    return
                }else {
                    //self.showErrorAlert(error: error?.localizedDescription)
                }
                return
            }
            Client.shared.saveCustomerToken(token: token.accessToken, expiry: token.expireAt, email: email, password: "pass@kwd")
            //Flits
            if customAppSettings.sharedInstance.flitsIntegration{
                if let signUpUserData = signUpUserData {
                    self.flitsProfileManager = FlitsProfileManager()
                    let params = ["first_name":signUpUserData.firstName ?? "","last_name":signUpUserData.lastName ?? "","email":email,"phone":"","birthdate":"","gender":""]
                    self.flitsProfileManager?.flitsProfileUpdate(params: params)
                }
            }
            //End
            self.fetchCustomerDetails()
            NotificationCenter.default.post(name: NSNotification.Name("loadDrawerAgain"), object: nil)
            self.dismissSelf()
        })
    }
    
    func fetchCustomerDetails() {
        if Client.shared.isAppLogin() {
            Client.shared.fetchCustomerDetails(completeion: {
                response,error   in
                if let response = response {
                    UserDefaults.standard.setValue(response.customerTags, forKey: "wholeSaleCustomerTags")
                    let custID = response.customerId?.replacingOccurrences(of: "gid://shopify/Customer/", with: "") ?? ""
                    if customAppSettings.sharedInstance.isFeraReviewsEnabled {
                        if let email = response.email, let firstName = response.firstName, let lastName = response.lastName {
                            self.createFeraCustomer(customerId: custID, email: email, name: "\(firstName) \(lastName)")
                        }
                    }
                    if customAppSettings.sharedInstance.growaveRewardsIntegration {
                        self.growaveToken.generateTokenGrowave { token in
                            self.growaveToken.searchForGrowaveUser(customerId: custID, token: token ?? "") { userId in
                                print("GROWAVE USER ID",userId)
                                UserDefaults.standard.setValue(userId, forKey: "growaveUserId")
                            }
                        }
                    }
                }
            })
        }
    }
    
    func doSignUp(_ email:String,_ firstName:String,_ lastName:String){
        Client.shared.createCustomer(with: firstName, lname: lastName, email: email, password: "pass@kwd", newsletter: false){
            response,usererror,error in
            self.view.stopLoader()
            if let _ = response {
                //        self.showErrorAlert(title: "Success".localized, error: "Account is successfully created.".localized)
                let signUpUserData: SignUpUserData? = SignUpUserData(firstName: firstName, lastName: lastName, isFromSignUp: true)
                self.dynamicLogin(email: email,signUpUserData: signUpUserData)
                AppEvents.shared.logEvent(AppEvents.Name(rawValue: "Registration Complete"), parameters: [AppEvents.ParameterName(rawValue: "fb_registration_method"):"mobile"])
                print("Logging in")
                UserDefaults.standard.set(true, forKey: "isSocialLogin")
                UserDefaults.standard.synchronize()
            }
            else if let usererror = usererror {
                print(usererror)
                //     self.showErrorAlert(errors: usererror)
            }
            else {
                print(error?.localizedDescription)
                error.getMessage()
                self.showErrorAlert(error: error?.localizedDescription)
            }
        }
    }
    
    func dismissSelf() {
        self.view.makeToast("Logged in successfully".localized)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.dismiss(animated: true, completion: {
                self.presentingViewController?.tabBarController?.selectedIndex = 0
                UserDefaults.standard.set(true, forKey: "socialLogin")
            })
        }
    }
    
    func createFeraCustomer(customerId: String, email: String, name: String) {
        let feraViewModel = FeraViewModel()
        feraViewModel.createFeraCustomer(customerId: customerId, email: email, name: name) { result in
            switch result {
            case .success:
                print("DEBUG: Successfully fetched customer")
            case .failed(let err):
                print("DEBUG: Failed to get customer \(err)")
            }
        }
    }
    
    private func showMessage(message: String) {
        DispatchQueue.main.async {[weak self] in
            self?.view.showmsg(msg: message)
        }
    }
    
    private func showMessgae(message: String) {
        DispatchQueue.main.async {[weak self] in
            self?.view.hideLoader()
            self?.view.showmsg(msg: message)
        }
    }
    
}

