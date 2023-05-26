//
//  NewLoginVC.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 09/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//
import UIKit
import SDWebImage
import FBSDKLoginKit
import MobileBuySDK
import GoogleSignIn
import AuthenticationServices

class NewLoginVC: UIViewController {
    
    
    let kangarooViewModel = KangarooRewardsViewModel()
    @IBOutlet weak var logo_imgView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var socialLogin_heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var btn_facebook: UIButton!
    @IBOutlet weak var btn_apple: UIButton!
    @IBOutlet weak var btn_google: UIButton!
    @IBOutlet weak var socialLoginView: UIView!
    @IBOutlet weak var btn_signIn: UIButton!
    @IBOutlet weak var btn_showHidePassword: UIButton!
    var isShow = false
    @IBOutlet weak var textF_email: UITextField!
    @IBOutlet weak var textF_password: UITextField!
    
    var forgotView : ForgotPasswordView?
    private let growaveToken = GrowaveTokenHandler()
    var defaults    = UserDefaults.standard
    var shopifyPlan : String? {
        return self.defaults.value(forKey: "shopifyPlan") as? String
    }
    
    //SocialLogin
    var emailUsed       = ""
    var socialFirstName = ""
    var socialLastName  = ""
    
    let signInConfig = GIDConfiguration.init(clientID: "897895045326-55hg99pdai6ia91a4iqo6tvsst2b54lq.apps.googleusercontent.com")
    //Flits
    var flitsProfileManager       : FlitsProfileManager?
    var webViewVC: UIViewController?
    
    @IBOutlet weak var headingLbl : UILabel!
    @IBOutlet weak var subHeadingLbl : UILabel!
    @IBOutlet weak var orSignInWithLbl : UILabel!
    @IBOutlet weak var btn_forgotPassword : UIButton!
    @IBOutlet weak var btn_signUP : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.closeButton.tintColor = UIColor(light: .black,dark: UIColor.provideColor(type: .newLoginVC).tintColor)
        self.view.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .newLoginVC).backGroundColor)
        self.btn_showHidePassword.tintColor = UIColor(light: .black,dark: UIColor.provideColor(type: .newSignupVC).tintColor)
        // Do any additional setup after loading the view.
        
        self.textF_email.delegate = self
        self.textF_password.delegate = self
        //MARK: - Fetch ShopifyPlan
        //
        //print("SL===>",customAppSettings.sharedInstance.socialLoginEnabled)
        if customAppSettings.sharedInstance.socialLoginEnabled{
          //print("Shopify Plan==ViewDidLoad",shopifyPlan)
          if shopifyPlan == nil {
            getShopifyPlanName()
          }
         // setupSocialLogin()
            socialLoginView.isHidden = false
            socialLogin_heightConstraint.constant = 100
        }
        else{
            socialLoginView.isHidden = true
            socialLogin_heightConstraint.constant = 0
        }
        //
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
    }
    
    func setupUI(){
        btn_facebook.layer.borderWidth = 0.5
        btn_google.layer.borderWidth = 0.5
        btn_apple.layer.borderWidth = 0.5
        btn_facebook.backgroundColor =  UIColor(light: .white,dark: UIColor.provideColor(type: .newLoginVC).backGroundColor)
        btn_google.backgroundColor =  UIColor(light: .white,dark: UIColor.provideColor(type: .newLoginVC).backGroundColor)
        btn_apple.backgroundColor =  UIColor(light: .white,dark: UIColor.provideColor(type: .newLoginVC).backGroundColor)
        btn_apple.tintColor = UIColor(light: .black,dark: .white)
        textF_email.font = mageFont.lightFont(size: 15)
        textF_password.font = mageFont.lightFont(size: 15)
        btn_facebook.layer.borderColor  =  UIColor(light: UIColor.lightGray.withAlphaComponent(0.5),dark: .white).cgColor
        btn_google.layer.borderColor  =  UIColor(light: UIColor.lightGray.withAlphaComponent(0.5),dark: .white).cgColor
        btn_apple.layer.borderColor  =  UIColor(light: UIColor.lightGray.withAlphaComponent(0.5),dark: .white).cgColor
        emailView.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .newLoginVC).backGroundColor)
        passwordView.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .newLoginVC).backGroundColor)
        emailView.layer.borderColor = UIColor(light: UIColor.lightGray.withAlphaComponent(0.5), dark: .white).cgColor
        passwordView.layer.borderColor = UIColor(light: UIColor.lightGray.withAlphaComponent(0.5), dark: .white).cgColor
        emailView.layer.borderWidth = 1
        passwordView.layer.borderWidth = 1
        
        btn_google.addTarget(self, action: #selector(performGoogleSignIn(_:)), for: .touchUpInside)
        btn_apple.addTarget(self, action: #selector(didTapAppleButton), for: .touchUpInside)
        
        headingLbl.text = "Sign In".localized
        headingLbl.textColor = UIColor(light: .black,dark: UIColor.provideColor(type: .newLoginVC).textColor)
        subHeadingLbl.text = "Please enter your email address below to start using app".localized
        subHeadingLbl.textColor = UIColor(light: .black,dark: UIColor.provideColor(type: .newLoginVC).textColor)
      //  textF_email.placeholder = "Email *".localized
        textF_email.attributedPlaceholder = NSAttributedString(
            string: "Email".localized,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(light: .darkGray, dark: .white)]
        )
       // textF_password.placeholder = "Password *".localized
        textF_password.attributedPlaceholder = NSAttributedString(
            string: "Password".localized,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(light: .darkGray, dark: .white)]
        )
        btn_signIn.setTitle("Sign In".localized, for: .normal)
        btn_signIn.setTitleColor(UIColor.textColor(), for: .normal)
        
        btn_forgotPassword.setTitle("Forgot Password ?".localized, for: .normal)
        btn_forgotPassword.setTitleColor(UIColor(light: UIColor(hexString: "#383838"),dark: UIColor.provideColor(type: .newLoginVC).textColor), for: .normal)
        btn_signUP.setTitle("Don't have any account? Sign Up".localized, for: .normal)
        btn_signUP.setTitleColor(UIColor(light: UIColor(hexString: "#383838"),dark: UIColor.provideColor(type: .newLoginVC).textColor), for: .normal)
        orSignInWithLbl.text = "Or Sign In with".localized
        orSignInWithLbl.textColor = UIColor(light: UIColor(hexString: "#383838"), dark: UIColor.provideColor(type: .newLoginVC).textColor)
        orSignInWithLbl.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .newLoginVC).backGroundColor)
        
        
        if(Client.locale == "ar"){
          textF_email.textAlignment = .right
          textF_password.textAlignment = .right
            headingLbl.textAlignment = .right
            subHeadingLbl.textAlignment = .right
            btn_forgotPassword.contentHorizontalAlignment = .left
        }
        else{
          textF_email.textAlignment = .left
          textF_password.textAlignment = .left
            headingLbl.textAlignment = .left
            subHeadingLbl.textAlignment = .left
            btn_forgotPassword.contentHorizontalAlignment = .right
        }
        btn_signIn.backgroundColor = UIColor.AppTheme()
        
    }
    
    @IBAction func closeView_Clicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func showHidePassword_Clicked(_ sender: Any) {
        isShow = !isShow
        print("show===>",isShow)
        
        if isShow{
            btn_showHidePassword.setImage(UIImage(named: "eyeshow"), for: .normal)
            textF_password.isSecureTextEntry = false
        }
        else{
            btn_showHidePassword.setImage(UIImage(named: "eyehide"), for: .normal)
            textF_password.isSecureTextEntry = true
        }
    }
    @IBAction func signIn_Clicked(_ sender: Any) {
        self.setupUI()
        guard let usernameText = textF_email.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) else {return}
        guard let password = textF_password.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) else {return}
        if usernameText == "" || password ==  ""  {
            self.showErrorAlert(error: "Username or password is empty.".localized)
            return
        }
        
        
        self.view.addLoader()
        Client.shared.customerAccessToken(email: usernameText, password: password, completion: {
            token,usererror,error in
            self.view.stopLoader()
            UserDefaults.standard.set(password, forKey: "password")
            UserDefaults.standard.set(false, forKey: "isSocialLogin")
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
            AnalyticsFirebaseData.shared.firebaseUserAppLogin(email: usernameText)
            Client.shared.saveCustomerToken(token: token.accessToken, expiry: token.expireAt, email: usernameText, password: password)
           
            self.fetchCustomerDetails()
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: NSNotification.Name("loadDrawerAgain"), object: nil)
                self.presentingViewController?.tabBarController?.selectedIndex = 0
            })
        })
    }
    
    @IBAction func forgotPassword_Clicked(_ sender: Any) {
        /*  let vc = storyboard?.instantiateViewController(withIdentifier: "NewForgotPasswordVC") as! NewForgotPasswordVC
         self.navigationController?.pushViewController(vc, animated: false)
        */
        // FORGOT ACCOUNT POP UP
        
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        tempView.backgroundColor = UIColor(light: .black.withAlphaComponent(0.5),dark: .black.withAlphaComponent(0.5))
        forgotView = ForgotPasswordView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 50, height: 350))
        forgotView?.center.x = self.view.center.x
        forgotView?.center.y = self.view.center.y - 50
        forgotView?.cardView()
        forgotView?.closeButton.addTarget(self, action: #selector(dismissForgotView), for: .touchUpInside)
        forgotView?.submitButton.addTarget(self, action: #selector(sendRecoveryEmail(_:)), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(self.dismissForgotView))
        tempView.addGestureRecognizer(tapGesture)
        tempView.tag = 123321
        self.view.addSubview(tempView)
        tempView.addSubview(forgotView!)
        
    }
    
    @objc func dismissForgotView() {
        guard let view = self.view.viewWithTag(123321) else {return}
        view.removeFromSuperview()
    }
    
    @objc func sendRecoveryEmail(_ sender : UIButton) {
        guard let email = forgotView?.email.text else {return}
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
                    guard let view = self.view.viewWithTag(123321) else {return}
                    view.removeFromSuperview()
                }
            }else if let _ = netError{
                //self.showErrorAlert(error: netError.localizedDescription)
            }
        })
    }
   
    @IBAction func facebookLogin_Clicked(_ sender: Any) {
        let fbLoginManager : LoginManager = LoginManager()
        
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self, handler:{ (result, error) -> Void in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
              // if user cancel the login
              if (result?.isCancelled)!{
                      return
              }
              if(fbloginresult.grantedPermissions.contains("email"))
              {
                  print("TOKEN===>",fbloginresult.token?.tokenString)
                  self.getFBUserData(token: fbloginresult.token?.tokenString ?? "")
              }
            }
          })
    
    }
    func getFBUserData(token:String){
        if((token) != nil){


            let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"], tokenString: token, version: nil, httpMethod: .get)
            request.start { (connection, result, error) in
              if (error == nil){

                let firstname = (result as AnyObject).value(forKey: "first_name") as! String
                let lastname = (result as AnyObject).value(forKey: "last_name") as! String
                var email = ""
                if let temp = (result as AnyObject).value(forKey: "email")
                {
                  email = temp as! String
                }
                let fbuser = ["firstname":firstname,"lastname":lastname,"email":email]
                print(fbuser)

                self.socialFirstName    = firstname
                self.socialLastName     = lastname
                self.emailUsed          = email
                // Logging out of facebook after fetching info
                let loginManager = LoginManager()
                loginManager.logOut()
                self.socialLoginPressed()

              }
       }
     }
    }
    
    @IBAction func signUp_Clicked(_ sender: Any) {
        print("Signup")
        let vc = storyboard?.instantiateViewController(withIdentifier: "NewSignUpVC") as! NewSignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func getShopifyPlanName(){
      //    guard let url = "https://herbspro-us.myshopify.com/admin/api/2022-01/shop.json".getURL() else {return}
      guard let url = "https://magenative.myshopify.com/admin/api/2022-01/shop.json".getURL() else {return}
      print(url)
      var request = URLRequest(url: url)
      request.httpMethod="GET"
      //    request.setValue("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", forHTTPHeaderField: "X-Shopify-Access-Token")
      request.setValue("31fc1f41196628610bef9a4c73e2949c", forHTTPHeaderField: "X-Shopify-Access-Token")
      self.view.addLoader()
      AF.request(request).responseData(completionHandler: {
        response in
        self.view.stopLoader()
        switch response.result {
        case .success:
          do {
            guard let json   = try? JSON(data: response.data!) else{return;}
            print(json)
            print(json["shop"]["plan_name"].stringValue)
            self.defaults.setValue(json["shop"]["plan_name"].stringValue, forKey: "shopifyPlan")
            //print(self.shopifyPlan)
          }
        case .failure:
          print("failed")
        }
      })
    }
}

//MARK: - Google SignIn
//
extension NewLoginVC{
  
  @objc func performGoogleSignIn(_ sender: GIDSignInButton){

      GIDSignIn.sharedInstance.configuration = signInConfig
            GIDSignIn.sharedInstance.signIn(withPresenting: self) { user, error in
      guard error     == nil else { return }
                guard let users  = user else { return }
                                  let user = users.user
      guard let email = user.profile?.email else { return }

      let _                 = user.profile?.name
      guard let givenName   = user.profile?.givenName else { return }
      guard let familyName  = user.profile?.familyName else { return }
      let _                 = user.profile?.imageURL(withDimension: 320)
      print("----GoogleSignin----")
      self.socialFirstName = givenName
      self.socialLastName  = familyName
      self.emailUsed       = email
      print(email)
      GIDSignIn.sharedInstance.signOut()
      self.socialLoginPressed()

      //Check for shopify plus clients
      //      if self.shopifyPlan == "shopify_plus"{
      //        self.multipassLogin()
      //      }else{
      //        self.socialLoginPressed()
      //      }
    }
  }
}
//MARK: - Facebook Login
//
extension NewLoginVC: LoginButtonDelegate{
   
  
  func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
    let token   = result?.token?.tokenString
    let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"], tokenString: token, version: nil, httpMethod: .get)
    request.start { (connection, result, error) in
      if (error == nil){
        
        let firstname = (result as AnyObject).value(forKey: "first_name") as! String
        let lastname = (result as AnyObject).value(forKey: "last_name") as! String
        var email = ""
        if let temp = (result as AnyObject).value(forKey: "email")
        {
          email = temp as! String
        }
        let fbuser = ["firstname":firstname,"lastname":lastname,"email":email]
        print(fbuser)
        
        self.socialFirstName    = firstname
        self.socialLastName     = lastname
        self.emailUsed          = email
        // Logging out of facebook after fetching info
        let loginManager = LoginManager()
        loginManager.logOut()
        self.socialLoginPressed()
        
        //Check for shopify plus clients
        //
        //        print("Shopify Plan==",self.shopifyPlan)
        //        if self.shopifyPlan == "shopify_plus"{
        //          self.multipassLogin()
        //        }else{
        //          self.socialLoginPressed()
        //        }
      }
    }
  }
  
  //2nd
  func socialLoginPressed()
  {
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
          self.dynamicLogin(email: self.emailUsed)
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
          self.doSignUp(self.emailUsed, self.socialFirstName, self.socialLastName)
        }
      }
    })
    task.resume()
  }
  
  //3rd
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
  
  //4th
  func dynamicLogin(email: String,signUpUserData:SignUpUserData? = nil){
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
                
                if customAppSettings.sharedInstance.isKangarooRewardsEnabled {
                    self.kangarooViewModel.generateTokenKangaroo { token in
                        if let email = response.email, let firstName = response.firstName, let lastName = response.lastName {
                            self.getKangarooUserId(email: email, firstName: firstName, lastName: lastName)
                        }
                    }
                }
            }
          })
        }
      }
    
  func dismissSelf() {
      self.view.makeToast("Logged in successfully".localized)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      self.dismiss(animated: true, completion: {
        self.presentingViewController?.tabBarController?.selectedIndex = 0
     UserDefaults.standard.set(true, forKey: "socialLogin")
          if let webVc = self.webViewVC as? WebViewController{
              webVc.loadPage()
          }
      })
    }
  }
    
  func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    print("Facebook Logged Out button pressed")
  }
}

//  MARK: - Apple Signin
extension NewLoginVC: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding{
  
  
    @objc func didTapAppleButton(){
        if #available(iOS 13.0, *) {
            let provider = ASAuthorizationAppleIDProvider()
            let request  = provider.createRequest()
            request.requestedScopes = [.fullName, .email]

            let controller  = ASAuthorizationController(authorizationRequests: [request])
            controller.presentationContextProvider  = self
            controller.delegate                     = self
            controller.performRequests()

        } else {
            // Fallback on earlier versions
        }
    }
  
  @available(iOS 13.0, *)
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return view.window!
  }
  
  @available(iOS 13.0, *)
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    print("Something bad happended",error)
  }
  
  @available(iOS 13.0, *)
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    switch authorization.credential{
    case let credentials as ASAuthorizationAppleIDCredential:
        print(credentials.user)
        print(credentials.email)
        print(credentials.fullName?.givenName)
        print(credentials.identityToken)
        let userIdentifier = credentials.user
        let fullName       = credentials.fullName?.givenName
        let lastName       = credentials.fullName?.familyName
        let email          = credentials.email
        if let email = credentials.email,let name = credentials.fullName?.givenName{
          self.saveAppleSignDetails(firstName: fullName, lastName: lastName, code: userIdentifier, email: email)
        }else{
          self.getSignInDetails(code: userIdentifier)
        }
        break
    default: break
    }
  }
  
  @objc func saveAppleSignDetails(firstName:String?,lastName:String?,code:String,email:String?) {
    print("Save")
    var requestString = "http://shopifymobileapp.cedcommerce.com/shopifymobile/shopifyapi/putappledetails?mid=\(Client.merchantID)"
  
    if let name = firstName {
      requestString += "&first_name="+name
    }
    
    if let lname = lastName {
      requestString += "&last_name="+lname
    }
    requestString += "&code="+code
    if let em = email {
      requestString += "&email="+em
    }
    
    guard let url = requestString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?.getURL() else {return}
      print("putappledetailsUrl✅✅✅",requestString)
      self.view.addLoader()
      var request=URLRequest(url: url)
      request.httpMethod="GET"
      AF.request(request).responseData(completionHandler: {
         response in
        self.view.stopLoader()
         switch response.result{
         case .success:
             if let data = response.data {
                 do{
                  let json = try JSON(data: data)
                  print("✅✅✅Check putappledetails data✅✅✅",json)
                   if json["success"].stringValue == "true" {
                     self.getSignInDetails(code: code)
                   }
                 }catch{
                     print("failed")
                 }
             }
         case .failure:
             print("failed42")
         }
     })
  }
  
  @objc func getSignInDetails(code:String) {
    var requestString = "http://shopifymobileapp.cedcommerce.com/shopifymobile/shopifyapi/getappledetails?mid=\(Client.merchantID)"
    
    requestString += "&code="+code
    
    guard let url = requestString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?.getURL() else {return;}
    print(url)
    var urlreq=URLRequest(url: url)
    urlreq.httpMethod="GET"
    urlreq.setValue("application/json", forHTTPHeaderField: "Content-Type")
    self.view.addLoader()
    let task=URLSession.shared.dataTask(with: urlreq, completionHandler: {data,response,error in
      if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode/100 != 2
      {
        DispatchQueue.main.sync
        {
          self.view.stopLoader()
          print("statusCode should be 200, but is \(httpStatus.statusCode)")
          print("response = \(String(describing: response))")
        }
        return;
      }
      guard error == nil && data != nil else
      {
        DispatchQueue.main.sync
        {
          self.view.stopLoader()
          print("error=\(String(describing: error))")
          if error?.localizedDescription=="The Internet connection appears to be offline."{
          }
        }
        return ;
      }
      DispatchQueue.main.sync
      {
        self.view.stopLoader()
        guard let data = data else {return;}
        guard let json = try? JSON(data: data) else {return;}
        print(json)
        if json["success"].stringValue == "true" {
          self.socialFirstName=json["data"]["first_name"].stringValue
          self.socialLastName=json["data"]["last_name"].stringValue
          self.emailUsed=json["data"]["email_id"].stringValue
          self.socialLoginPressed()
        }
      }
    })
    task.resume()
  }
    
    /*func fetchCustomerDetails() {
        if Client.shared.isAppLogin() {
          Client.shared.fetchCustomerDetails(completeion: {
            response,error   in
            if let response = response {
                UserDefaults.standard.setValue(response.customerTags, forKey: "wholeSaleCustomerTags")
            }
          })
        }
      }*/
}

extension NewLoginVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textF_email {
            
            emailView.layer.borderColor = UIColor(light: .black,dark: UIColor(hexString: "#ff0099cc")).cgColor
            emailView.layer.borderWidth = 1.5
            
            
           
        } else if textField == textF_password {
            passwordView.layer.borderColor = UIColor(light: .black,dark: UIColor(hexString: "#ff0099cc")).cgColor
            passwordView.layer.borderWidth = 1.5
            

        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == textF_email {
            emailView.layer.borderColor = UIColor(light: UIColor.lightGray.withAlphaComponent(0.5), dark: .white).cgColor
            emailView.layer.borderWidth = 1
            
           
        } else if textField == textF_password {
            passwordView.layer.borderColor = UIColor(light: UIColor.lightGray.withAlphaComponent(0.5), dark: .white).cgColor
            passwordView.layer.borderWidth = 1

        }
    }
}

extension NewLoginVC {
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
    
    func getKangarooUserId(email: String, firstName: String, lastName: String) {
        self.kangarooViewModel.fetchKangarooCustomer(email: email) { result in
            switch result {
            case .success:
                print("DEBUG: Successfully fetched customer")
            case .failed(let err):
                if err == "User not found" {
//                    self.createKangarooCustomer(email: email, first_name: firstName, last_name: lastName)
                }
                
            }
        }
    }
}
