/**
 * CedCommerce
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the End User License Agreement (EULA)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://cedcommerce.com/license-agreement.txt
 *
 * @category  Ced
 * @package   MageNative
 * @author    CedCommerce Core Team <connect@cedcommerce.com >
 * @copyright Copyright CEDCOMMERCE (http://cedcommerce.com/)
 * @license      http://cedcommerce.com/license-agreement.txt
 */

import UIKit
import SDWebImage
import FBSDKLoginKit
import MobileBuySDK
import CryptoKit
import CommonCrypto
import CryptoSwift
import GoogleSignIn
import AuthenticationServices

class LoginViewController: UIViewController {
  
  @IBOutlet weak var socialLoginStack: UIStackView!
  @IBOutlet weak var username: UITextField!
  @IBOutlet weak var login: Button!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var dismissView: UIBarButtonItem!
  @IBOutlet weak var loginbg: UIImageView!
  
  @IBOutlet weak var signUp: UIButton!
  @IBOutlet weak var forgotPAssBtn: UIButton!
  
  //Multipass Variables
  var defaults    = UserDefaults.standard
  var shopifyPlan : String? {
    return self.defaults.value(forKey: "shopifyPlan") as? String
  }
  
  var encryptionKey = String()
  var signatureKey  = String()
  
  //SocialLogin
  var emailUsed       = ""
  var socialFirstName = ""
  var socialLastName  = ""
  
  let signInConfig = GIDConfiguration.init(clientID: "897895045326-55hg99pdai6ia91a4iqo6tvsst2b54lq.apps.googleusercontent.com")
  
  //Flits
  var flitsProfileManager       : FlitsProfileManager?
  
  lazy var facebookLogin: FBLoginButton = {
    let facebookLogin               = FBLoginButton()
    facebookLogin.delegate          = self
//    let buttonText = NSAttributedString(string: " ")
//    facebookLogin.setAttributedTitle(buttonText, for: .normal)
    facebookLogin.permissions       = ["public_profile", "email"]
    return facebookLogin
  }()
  
  lazy var gButton: UIButton = {
    let gButton = UIButton()
    gButton.backgroundColor = .white
    gButton.layer.borderColor =  UIColor.lightGray.cgColor
    gButton.layer.borderWidth = 1
    gButton.layer.cornerRadius = 5
    gButton.contentHorizontalAlignment = .left
    gButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    gButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
    gButton.setTitleColor(UIColor.lightGray, for: .normal)
    gButton.setTitle("Sign in", for: .normal)
    gButton.titleLabel?.font = mageFont.mediumFont(size: 14)
    gButton.setImage(UIImage(named: "googleCustom"), for: .normal)
    gButton.addTarget(self, action: #selector(performGoogleSignIn(_:)), for: .touchUpInside)
    return gButton
  }()
  
  lazy var googleLogin: GIDSignInButton = {
    let googleLogin = GIDSignInButton()
//  googleLogin.style = .iconOnly
//  googleLogin.layer.masksToBounds = true
    googleLogin.clipsToBounds = true
//    googleLogin.addTarget(self, action: #selector(performGoogleSignIn(_:)), for: .touchUpInside)
    return googleLogin
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
    //MARK: - Fetch ShopifyPlan
    //
    if customAppSettings.sharedInstance.socialLoginEnabled{
      //print("Shopify Plan==ViewDidLoad",shopifyPlan)
      if shopifyPlan == nil {
        getShopifyPlanName()
      }
      setupSocialLogin()
    }
    //
    username.placeholder = "USERNAME".localized
    password.placeholder = "PASSWORD".localized
    login.setTitle("SIGN IN".localized, for: .normal)
    forgotPAssBtn.setTitle("Forgot Password".localized, for: .normal)
    signUp.setTitle("SIGN UP TODAY".localized, for: .normal)
    username.font = mageFont.regularFont(size: 14.0)
    password.font = mageFont.regularFont(size: 14.0)
    login.titleLabel?.font = mageFont.mediumFont(size: 15.0)
    forgotPAssBtn.titleLabel?.font = mageFont.mediumFont(size: 15.0)
    signUp.titleLabel?.font = mageFont.mediumFont(size: 15.0)
    let img = UserDefaults.standard.value(forKey: "loginbg") as! String
    self.loginbg.sd_setImage(with: URL(string: img))
    //self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    //self.navigationController?.navigationBar.shadowImage = UIImage()
    if #available(iOS 13.0, *) {
      self.navigationItem.backBarButtonItem?.tintColor = UIColor.label
    } else {
      self.navigationItem.backBarButtonItem?.tintColor = UIColor.black
    }
    
    self.navigationController?.navigationBar.isTranslucent = true
    if(Client.locale == "ar"){
      username.textAlignment = .right
      password.textAlignment = .right
    }
    else{
      username.textAlignment = .left
      password.textAlignment = .left
    }
    dismissView.target = self
    dismissView.action = #selector(self.dismissViewControl)
    login.addTarget(self, action: #selector(self.doLogin), for: .touchUpInside)
    setupEyeButton()
  }
  
  func setupSocialLogin(){
    socialLoginStack.addArrangedSubview(facebookLogin)
    socialLoginStack.addArrangedSubview(gButton)
        if #available(iOS 13.0, *) {
          let appleSignInButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
          appleSignInButton.clipsToBounds = true
          socialLoginStack.addArrangedSubview(appleSignInButton)
          appleSignInButton.addTarget(self, action: #selector(didTapAppleButton), for: .touchUpInside)
        }
  }
  
  func setupEyeButton(){
    let button             = UIButton(type: .custom)
    password.rightViewMode = .always
    password.rightView     = button.showHideButton()
    button.addTarget(self, action: #selector(controlVisibility(_:)), for: .touchUpInside)
  }
  
  @objc func controlVisibility(_ sender: UIButton){
    password.isSecureTextEntry = !password.isSecureTextEntry
    password.isSecureTextEntry ? sender.setImage(UIImage(named: "eyehide"), for: .normal) : sender.setImage(UIImage(named: "eyeshow"), for: .normal)
  }
  
  @objc func dismissViewControl(){
    self.dismiss(animated: true, completion: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @objc func doLogin(){
    guard let usernameText = username.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) else {return}
    guard let password = password.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) else {return}
    if usernameText == "" || password ==  ""  {
      self.showErrorAlert(error: "Username or password is empty.".localized)
      return
    }
    self.view.addLoader()
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
        }else {
          //self.showErrorAlert(error: error?.localizedDescription)
        }
        return
      }
      
      Client.shared.saveCustomerToken(token: token.accessToken, expiry: token.expireAt, email: usernameText, password: password)
      self.view.makeToast("Logged in successfully")
        self.fetchCustomerDetails()
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          self.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: NSNotification.Name("loadDrawerAgain"), object: nil)
            
            /*  if let navigation = self.tabBarController?.viewControllers![self.tabBarController!.selectedIndex] as? UINavigationController {
                    navigation.popToRootViewController(animated: true)
                  }  */
              
          self.presentingViewController?.tabBarController?.selectedIndex = 0
          })
       }
    })
  }
    
    func fetchCustomerDetails() {
        if Client.shared.isAppLogin() {
          Client.shared.fetchCustomerDetails(completeion: {
            response,error   in
            if let _ = response {
            }
          })
        }
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
extension LoginViewController{
  
  @objc func performGoogleSignIn(_ sender: GIDSignInButton){
/*
    GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
      guard error     == nil else { return }
      guard let user  = user else { return }
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
    }*/
  }
}

//MARK: - Facebook Login
//

extension LoginViewController: LoginButtonDelegate{
  
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
      guard let token = token else {
        if let usererror = usererror {
          if usererror.first?.errorMessage.lowercased() == "Unidentified Customer".lowercased() {
            self.showErrorAlert(error: "Unidentified Customer.".localized)
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
      NotificationCenter.default.post(name: NSNotification.Name("loadDrawerAgain"), object: nil)
      self.dismissSelf()
    })
  }
  
  func dismissSelf() {
    self.view.makeToast("Logged in successfully")
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      self.dismiss(animated: true, completion: {
        self.presentingViewController?.tabBarController?.selectedIndex = 0
        UserDefaults.standard.set(true, forKey: "socialLogin")
      })
    }
  }
  
  func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    print("Facebook Logged Out button pressed")
  }
  
  //  func multipassLogin(){
  //    construct()
  //  }
  //
  //  // 1st Step
  //  func construct(){
  //    var multiPassKey = "1f4237c87f31090e5763feaa34962b72"
  //    var keyMaterial  = multiPassKey.hash256()
  //
  //    encryptionKey    = keyMaterial[0..<16]
  //    signatureKey     = keyMaterial[16..<32]
  //
  //    print("keyMaterial==",keyMaterial)
  //    print("keyMaterial==",keyMaterial.count)
  //    print("Check==",encryptionKey,signatureKey)
  //    generateToken()
  //  }
  //
  //  //2nd Step
  //  func generateToken(){
  //    print("Hashing")
  //    let dic = ["email":"willjohntest@gmail.com","created_at":Date().string(format: "yyyy-MM-dd'T'HH:mm:ssZ")]
  //    guard let jsonData = try? JSONEncoder().encode(dic) else {return}
  //
  //    let keyData = encryptionKey.data(using:String.Encoding.utf8)!
  //
  //    var cryptData :Data?
  //    do {
  //      cryptData = try aesCBCEncrypt(data:jsonData, keyData:keyData)
  //      print("cryptData:   \(cryptData! as NSData)")
  //      print("String encrypted (base64):,\(cryptData?.base64EncodedString())")
  //    }
  //    catch (let status) {
  //      print("Error aesCBCEncrypt: \(status)")
  //    }
  //  }
  //
  //  // Using random iv
  //  // The iv is prefixed to the encrypted data
  //  func aesCBCEncrypt(data:Data, keyData:Data) throws -> Data {
  //    let keyLength = keyData.count
  //    let validKeyLengths = [kCCKeySizeAES128, kCCKeySizeAES192, kCCKeySizeAES256]
  //    if (validKeyLengths.contains(keyLength) == false) {
  //      throw AESError.KeyError(("Invalid key length", keyLength))
  //    }
  //
  //    let ivSize = kCCBlockSizeAES128;
  //    let cryptLength = size_t(ivSize + data.count + kCCBlockSizeAES128)
  //    var cryptData = Data(count:cryptLength)
  //
  //    let status = cryptData.withUnsafeMutableBytes {ivBytes in
  //      SecRandomCopyBytes(kSecRandomDefault, kCCBlockSizeAES128, ivBytes)
  //    }
  //    if (status != 0) {
  //      throw AESError.IVError(("IV generation failed", Int(status)))
  //    }
  //
  //    var numBytesEncrypted :size_t = 0
  //    let options   = CCOptions(kCCOptionPKCS7Padding)
  //
  //    let cryptStatus = cryptData.withUnsafeMutableBytes {cryptBytes in
  //      data.withUnsafeBytes {dataBytes in
  //        keyData.withUnsafeBytes {keyBytes in
  //          CCCrypt(CCOperation(kCCEncrypt),
  //                  CCAlgorithm(kCCAlgorithmAES),
  //                  options,
  //                  keyBytes, keyLength,
  //                  cryptBytes,
  //                  dataBytes, data.count,
  //                  cryptBytes+kCCBlockSizeAES128, cryptLength,
  //                  &numBytesEncrypted)
  //        }
  //      }
  //    }
  //
  //    if UInt32(cryptStatus) == UInt32(kCCSuccess) {
  //      cryptData.count = numBytesEncrypted + ivSize
  //    }
  //    else {
  //      throw AESError.CryptorError(("Encryption failed", Int(cryptStatus)))
  //    }
  //    return cryptData;
  //  }
}

//  MARK: - Apple Signin

extension LoginViewController: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding{
  
  
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
}


//enum AESError: Error {
//  case KeyError((String, Int))
//  case IVError((String, Int))
//  case CryptorError((String, Int))
//}

extension String {
  func hmac(key: String) -> String {
    var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
    CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), key, key.count, self, self.count, &digest)
    let data = Data(bytes: digest)
    return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
  }
}

struct SignUpUserData{
  let firstName: String?
  let lastName: String?
  let isFromSignUp: Bool?
}

