//
//  NewSignUpVC.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 10/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit
class NewSignUpVC: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var confirmPasswordView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var lastNameView: UIView!
    @IBOutlet weak var firstNameView: UIView!
    @IBOutlet weak var btn_newsletter: UIButton!
    @IBOutlet weak var textF_fname: UITextField!
    
    @IBOutlet weak var textF_confirmPassword: UITextField!
    @IBOutlet weak var textF_password: UITextField!
    @IBOutlet weak var textF_email: UITextField!
    @IBOutlet weak var textF_lname: UITextField!
    
    @IBOutlet weak var btnShowHide_password: UIButton!
    
    @IBOutlet weak var btnShowHide_confirmPassword: UIButton!
   
    @IBOutlet weak var kangarooSMS: UIButton!
    @IBOutlet weak var kangarooEmail: UIButton!
    
    @IBOutlet weak var kangarooEmailHeight: NSLayoutConstraint!
    @IBOutlet weak var kangarooSMSheight: NSLayoutConstraint!
    var isNewsChecked = false
    var isShowPassword = false
    var isShowConfirmPassword = false
    var isKangarooSMSChecked = false
    var isKangarooEmailChecked = false
    
    @IBOutlet weak var lbl_signUp: UILabel!
    
    @IBOutlet weak var btn_backToLogin: UIButton!
    @IBOutlet weak var btn_signUp: UIButton!
    @IBOutlet weak var headingLbl : UILabel!
    @IBOutlet weak var subHeadingLbl : UILabel!
    private let growaveToken = GrowaveTokenHandler()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.closeButton.tintColor = UIColor(light: .black,dark: .white)
        // Do any additional setup after loading the view.
        setUp_UI()
    }
    func setUp_UI() {
        showKangarooButtons()
        textF_fname.font = mageFont.lightFont(size: 15)
        textF_lname.font = mageFont.lightFont(size: 15)
        textF_email.font = mageFont.lightFont(size: 15)
        textF_password.font = mageFont.lightFont(size: 15)
        textF_confirmPassword.font = mageFont.lightFont(size: 15)
        textF_lname.font = mageFont.lightFont(size: 15)
        self.view.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .newSignupVC).backGroundColor)
        self.btnShowHide_password.tintColor = UIColor(light: .black,dark: UIColor.provideColor(type: .newSignupVC).tintColor)
        self.btnShowHide_confirmPassword.tintColor = UIColor(light: .black,dark: UIColor.provideColor(type: .newSignupVC).tintColor)
        firstNameView.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .newSignupVC).backGroundColor)
        firstNameView.layer.borderColor = UIColor(light: UIColor.lightGray.withAlphaComponent(0.5), dark: .white).cgColor
        firstNameView.layer.borderWidth = 1
        lastNameView.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .newSignupVC).backGroundColor)
        lastNameView.layer.borderColor = UIColor(light: UIColor.lightGray.withAlphaComponent(0.5), dark: .white).cgColor
        lastNameView.layer.borderWidth = 1
        emailView.layer.borderColor = UIColor(light: UIColor.lightGray.withAlphaComponent(0.5), dark: .white).cgColor
        emailView.layer.borderWidth = 1
        emailView.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .newSignupVC).backGroundColor)
        passwordView.layer.borderColor = UIColor(light: UIColor.lightGray.withAlphaComponent(0.5), dark: .white).cgColor
        passwordView.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .newSignupVC).backGroundColor)
        passwordView.layer.borderWidth = 1
        confirmPasswordView.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .newSignupVC).backGroundColor)
        confirmPasswordView.layer.borderColor = UIColor(light: UIColor.lightGray.withAlphaComponent(0.5), dark: .white).cgColor
        confirmPasswordView.layer.borderWidth = 1
        
        if(Client.locale == "ar"){
          textF_email.textAlignment = .right
          textF_password.textAlignment = .right
          textF_fname.textAlignment = .right
          textF_lname.textAlignment = .right
          textF_confirmPassword.textAlignment = .right
          btn_newsletter.contentHorizontalAlignment = .right
        }
        else{
          textF_email.textAlignment = .left
          textF_password.textAlignment = .left
          textF_fname.textAlignment = .left
          textF_lname.textAlignment = .left
          textF_confirmPassword.textAlignment = .left
          btn_newsletter.contentHorizontalAlignment = .left
        }
        
        textF_fname.placeholder = "First Name".localized
        textF_lname.placeholder = "Last Name".localized
        textF_email.placeholder = "Email".localized
        textF_password.placeholder = "Password".localized
        textF_confirmPassword.placeholder = "Confirm Password".localized
        btn_newsletter.setTitle("Newsletter".localized, for: .normal)
        btn_newsletter.setTitleColor(UIColor(light: .black,dark: .white), for: .normal)
        btn_newsletter.tintColor = UIColor(light: .black,dark: .white)
        btn_signUp.setTitle("Create an Account".localized, for: .normal)
        btn_backToLogin.setTitle("Already have an account ? Sign In".localized, for: .normal)
        btn_backToLogin.isHidden = true
        headingLbl.text = "Sign Up".localized
        headingLbl.textColor = UIColor(light: .black,dark: UIColor.provideColor(type: .newLoginVC).textColor)
        subHeadingLbl.text = "Please enter your email address below to start using app".localized
        subHeadingLbl.textColor = UIColor(light: .black,dark: UIColor.provideColor(type: .newLoginVC).textColor)
        btn_signUp.backgroundColor = UIColor.AppTheme()
        btn_signUp.setTitleColor(.textColor(), for: .normal)
     
       
        setPlaceholder(for: textF_fname, with: "First Name".localized)
        setPlaceholder(for: textF_lname, with: "Last Name".localized)
        setPlaceholder(for: textF_email, with: "Email".localized)
        setPlaceholder(for: textF_password, with: "Password".localized)
        setPlaceholder(for: textF_confirmPassword, with: "Confirm Password".localized)
        
        kangarooSMS.addTarget(self, action: #selector(kangarooSMSClicked(_:)), for: .touchUpInside)
        kangarooEmail.addTarget(self, action: #selector(kangarooEmailClicked(_:)), for: .touchUpInside)
        
    }
    
    

    func setPlaceholder(for textField: UITextField, with placeholder: String) {
        let placeholderAttributes: [NSAttributedString.Key: UIColor] = [.foregroundColor: UIColor(light: .darkGray, dark: .white)]
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder.localized,
            attributes: placeholderAttributes
        )
    }

    @IBAction func back_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func newsletter_clicked(_ sender: Any) {
        if isNewsChecked {
            isNewsChecked = false
            btn_newsletter.isSelected = false
        }
        else{
            isNewsChecked = true
            btn_newsletter.isSelected = true
        }
    }
    @IBAction func backToLogin_clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAction_showHidePassword(_ sender: Any) {
        isShowPassword = !isShowPassword
        print("show===>",isShowPassword)
        if isShowPassword{
            btnShowHide_password.setImage(UIImage(named: "eyeshow"), for: .normal)
            textF_password.isSecureTextEntry = false
        }
        else{
            btnShowHide_password.setImage(UIImage(named: "eyehide"), for: .normal)
            textF_password.isSecureTextEntry = true
        }
    }
    @IBAction func btnAction_showHideConfirmPassword(_ sender: Any) {
        isShowConfirmPassword = !isShowConfirmPassword
        print("show===>",isShowConfirmPassword)
        if isShowConfirmPassword{
            btnShowHide_confirmPassword.setImage(UIImage(named: "eyeshow"), for: .normal)
            textF_confirmPassword.isSecureTextEntry = false
        }
        else{
            btnShowHide_confirmPassword.setImage(UIImage(named: "eyehide"), for: .normal)
            textF_confirmPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction func btnAction_SignUp(_ sender: Any) {
        guard let fname = textF_fname.text else {return}
        guard let lname = textF_lname.text else {return}
        guard let email = textF_email.text else {return}
        guard let pass = textF_password.text else {return}
        guard let confirmPass = textF_confirmPassword.text else {return}
        
        
        
        
        
        if fname.isEmpty || lname.isEmpty || email.isEmpty || pass.isEmpty || confirmPass.isEmpty {
          self.showErrorAlert(error: "All fields are required.".localized)
          return
        }
        if !fname.isValidName() || !lname.isValidName() {
          self.showErrorAlert(error: "First Name or Last Name is not Valid.".localized)
          return
        }
        
        if !email.isValidEmail() {
          self.showErrorAlert(error: "Email is not Valid.".localized)
          return
        }
        
        if pass != confirmPass {
          self.showErrorAlert(error: "Password and Confirm password not matched.".localized)
          return
        }
        
        self.view.addLoader()
        Client.shared.createCustomer(with: fname, lname: lname, email: email, password: pass,newsletter: isNewsChecked){
          response,usererror,error in
          self.view.stopLoader()
          if let _ = response {
            let alert = UIAlertController(title: "Success".localized, message: "Account is successfully created".localized, preferredStyle: .alert)
              
            alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { (action) in
                self.fetchCustomerToken(usernameText: email, firstName: fname, lastName: lname, password: pass)
            }))
            self.present(alert, animated: true, completion: nil);
            //self.showErrorAlert(title: "Success".localized, error: "Account is successfully created.".localized)
              
              AnalyticsFirebaseData.shared.firebaseUserSignUp(email: email)
          }
          else if let usererror = usererror {
            self.showCustomerErrorAlert(errors: usererror)
          }
          else {
            error.getMessage()
            self.showErrorAlert(error: error?.localizedDescription)
          }
        }
    }
    
    func fetchCustomerToken(usernameText: String, firstName: String, lastName: String, password: String){
      Client.shared.customerAccessToken(email: usernameText, password: password, completion: {
        token,usererror,error in
        self.view.stopLoader()
        UserDefaults.standard.set(password, forKey: "password")
        guard let token = token else {
          if let usererror = usererror {
            if usererror.first?.errorMessage.lowercased() == "Unidentified Customer".lowercased() {
              self.showErrorAlert(error: "Username or Password is Incorrect.".localized)
            }else {
              //self.showErrorAlert(errors: usererror)
            }
            return
          }
          else {
            //self.showErrorAlert(error: error?.localizedDescription)
          }
          return
        }
          Client.shared.saveCustomerToken(token: token.accessToken, expiry: token.expireAt, email: usernameText, password: password)
          if customAppSettings.sharedInstance.wholesalePricingDiscount {
              self.fetchCustomerDetails(email: usernameText, first_name: firstName, last_name: lastName)
          }
          else {
              if Client.shared.isAppLogin() {
                Client.shared.fetchCustomerDetails(completeion: {
                  response,error   in
                  if let response = response {
                      let custID = response.customerId?.replacingOccurrences(of: "gid://shopify/Customer/", with: "") ?? ""
                      if customAppSettings.sharedInstance.isFeraReviewsEnabled {
                          if let email = response.email, let firstName = response.firstName, let lastName = response.lastName {
                              self.createFeraCustomer(customerId: custID, email: email, name: "\(firstName) \(lastName)")
                          }
                      }
                      if customAppSettings.sharedInstance.isKangarooRewardsEnabled {
                          self.createKanagrooCustomer(email: usernameText, first_name: firstName, last_name: lastName)
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
                  let params : [AppEvents.ParameterName:Any] = [AppEvents.ParameterName.content : usernameText]
                  AppEvents.shared.logEvent(.completedRegistration, parameters: params)
                self.dismiss(animated: true, completion: {
                  NotificationCenter.default.post(name: NSNotification.Name("loadDrawerAgain"), object: nil)
                  self.presentingViewController?.tabBarController?.selectedIndex = 0
                })
      })
    }
    
    func fetchCustomerDetails(email: String, first_name: String, last_name: String) {
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
                if customAppSettings.sharedInstance.isKangarooRewardsEnabled {
                    self.createKanagrooCustomer(email: email, first_name: first_name, last_name: last_name)
                }
            }
          })
        }
      }
}
extension NewSignUpVC {
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
}
extension NewSignUpVC {
    func createKanagrooCustomer(email: String, first_name: String, last_name: String) {
        let kangarooViewModel = KangarooRewardsViewModel()
        kangarooViewModel.createKangarooCustomer(email: email, first_name: first_name, last_name: last_name, allow_sms: isKangarooSMSChecked, allow_email: isKangarooEmailChecked) { result in
            switch result {
            case .success(let userId):
                print("Here is the user id \(userId)")
            case .failed(let err):
                print("Kangaroo: \(err)")
            }
        }
    }
    
    private func showKangarooButtons() {
        if !customAppSettings.sharedInstance.isKangarooRewardsEnabled {
            self.kangarooSMSheight.constant = 0
            self.kangarooEmailHeight.constant = 0
            self.kangarooSMS.isHidden = true
            self.kangarooEmail.isHidden = true
        }
        else {
            self.kangarooSMSheight.constant = 30
            self.kangarooEmailHeight.constant = 30
            self.kangarooSMS.isHidden = false
            self.kangarooEmail.isHidden = false
        }
    }
    
    @objc func kangarooSMSClicked(_ sender : UIButton) {
        if isKangarooSMSChecked {
            isKangarooSMSChecked = false
            kangarooSMS.isSelected = false
        }
        else{
            isKangarooSMSChecked = true
            kangarooSMS.isSelected = true
        }
    }
    @objc func kangarooEmailClicked(_ sender : UIButton) {
        if isKangarooEmailChecked {
            isKangarooEmailChecked = false
            kangarooEmail.isSelected = false
        }
        else{
            isKangarooEmailChecked = true
            kangarooEmail.isSelected = true
        }
    }
}
