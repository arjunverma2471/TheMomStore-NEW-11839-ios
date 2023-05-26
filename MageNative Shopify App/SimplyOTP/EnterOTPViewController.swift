//
//  EnterOTPViewController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 31/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import UIKit
class EnterOTPViewController: UIViewController {
    var phoneNumber: String = ""
    var OTP = ""
    let simplyOTPViewModel = SimplyOTPViewModel()
    let growaveToken = GrowaveTokenHandler()
    var flitsProfileManager : FlitsProfileManager?
    fileprivate lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "backArrow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.tintColor = .clear
        button.imageView?.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.tintColor = UIColor(light: UIColor(hexString: "#050505", alpha: 1),dark: UIColor.provideColor(type: .newLoginVC).textColor)
        return button
    }()
    
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "header")?.withRenderingMode(.alwaysOriginal)
        return imageView
    }()
    
    fileprivate let otpTextField: AEOTPTextField = {
        let textField = AEOTPTextField()
        textField.otpFont = mageFont.mediumFont(size: 16)
        textField.otpTextColor = UIColor.AppTheme()
        textField.otpCornerRaduis = 5
        textField.otpFilledBorderColor = UIColor.AppTheme()
        textField.otpFilledBorderWidth = 1
        textField.configure(with: 4)
        return textField
    }()
    
    fileprivate lazy var verifyOTPButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .AppTheme()
        button.layer.cornerRadius = 5
        button.setTitle("VERIFY OTP".localized, for: .normal)
        button.titleLabel?.font = mageFont.mediumFont(size: 16)
        button.tintColor = .white
        button.addTarget(self, action: #selector(verifyOTPTapped), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = mageFont.regularFont(size: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "The verification OTP is sent on Mobile Number ".localized+"\(phoneNumber)"
        return label
    }()
    
    fileprivate lazy var enterOTPLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = mageFont.regularFont(size: 18)
        label.textAlignment = .center
        label.text = "Enter OTP".localized
        return label
    }()
    
    fileprivate lazy var noOTPLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = mageFont.regularFont(size: 14)
        label.textAlignment = .center
        label.text = "Didn't recieve the OTP?".localized
        return label
    }()
    
    fileprivate lazy var resendButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle("Resend OTP".localized, for: .normal)
        button.tintColor = UIColor.gray
        button.titleLabel?.font = mageFont.regularFont(size: 14)
        button.addTarget(self, action: #selector(resendOTPTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .viewBackgroundColor()
        backButtonLayout()
        imageViewLayout()
        enterOTPLabelLayout()
        infoLabelLayout()
        otpTextFieldLayout()
        verifyButtonLayout()
        noOTPLabelLayout()
        resendButtonLayout()
        
    }
    
    private func imageViewLayout() {
        view.addSubview(imageView)
        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, paddingTop: 20, paddingLeft: ((view.frame.size.width / 2) - 70), width: 140, height: 140)
    }
    
    private func enterOTPLabelLayout() {
        view.addSubview(enterOTPLabel)
        enterOTPLabel.anchor(top: imageView.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20)
    }
    
    private func infoLabelLayout() {
        view.addSubview(infoLabel)
        infoLabel.anchor(top: enterOTPLabel.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingTop: 8, paddingLeft: 40, paddingRight: 40, height: 50)
    }
    
    private func otpTextFieldLayout() {
        otpTextField.otpDelegate = self
        view.addSubview(otpTextField)
        otpTextField.anchor(top: infoLabel.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: 20,  height: 44)
    }
    
    private func verifyButtonLayout() {
        view.addSubview(verifyOTPButton)
        verifyOTPButton.anchor(top: otpTextField.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: 20, height: 50)
    }
    
    private func noOTPLabelLayout() {
        view.addSubview(noOTPLabel)
        noOTPLabel.anchor(top: verifyOTPButton.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20)
    }
    
    
    private func resendButtonLayout() {
        view.addSubview(resendButton)
        resendButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        resendButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        resendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resendButton.topAnchor.constraint(equalTo: noOTPLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    
    private func backButtonLayout() {
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, paddingTop: 10, paddingLeft: 20, width: 30, height: 30)
    }
    
    
    @objc func verifyOTPTapped() {
        otpTextField.resignFirstResponder()
        verifyOTPRequest()
    }
    
    @objc func resendOTPTapped() {
        otpTextField.resignFirstResponder()
        resendOTPRequest()
    }
    
    @objc func backButtonTapped() {
        otpTextField.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension EnterOTPViewController: AEOTPTextFieldDelegate{
    func didUserFinishEnter(the code: String) {
        self.OTP = code
    }
}

extension EnterOTPViewController {
    private func verifyOTPRequest() {
        guard let otpID = UserDefaults.standard.value(forKeyPath: "simplyOTPID") as? String else {return}
        simplyOTPViewModel.verifyOTPRequest(phoneNumber: phoneNumber, shop_name: Client.shopUrl, otp: OTP, otp_id: otpID) {[weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {[weak self] in
                    if let url = self?.simplyOTPViewModel.verifyOTP?.redirectURL {
                        if url == "" {
                            self?.navigateToAccountUpdate(phoneNumber: self?.phoneNumber ?? "")
                        }
                        else {
                            if let email = self?.simplyOTPViewModel.verifyOTP?.email, let firstName = self?.simplyOTPViewModel.verifyOTP?.firstName, let lastName = self?.simplyOTPViewModel.verifyOTP?.lastName {
                                self?.socialLoginPressed(emailUsed: email, firstName: firstName, lastName: lastName)
                            }
                        }
                    }
                    else {
                        self?.navigateToAccountUpdate(phoneNumber: self?.phoneNumber ?? "")
                    }
                }
                
            case .failed(let err):
                self?.showMessage(message: err)
            }
        }
    }
    
    
    private func resendOTPRequest() {
        simplyOTPViewModel.sendOTPRequest(phoneNumber: phoneNumber, shop_name: Client.shopUrl, action: "resendOTP") {[weak self] result in
            switch result {
            case .success:
                self?.showMessage(message: "OTP successfully sent.".localized)
            case .failed(let err):
                self?.showMessage(message: err)
            }
        }
    }
    
    private func navigateToAccountUpdate(phoneNumber: String) {
        DispatchQueue.main.async {[weak self] in
            let vc = SimpleOTPAccountViewController()
            vc.phoneNumber = phoneNumber
            self?.navigationController?.pushViewController(vc, animated: true)
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
}
