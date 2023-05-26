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

class CustomerSignUpViewController: UIViewController {
  
  var passEyeButton             = UIButton(type: .custom)
  var confirmPassEyeButton      = UIButton(type: .custom)
  var flitsProfileManager       : FlitsProfileManager?
  
  @IBOutlet weak var newsletter: UIButton!
  @IBOutlet weak var confirmPassword: UITextField!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var lastName: UITextField!
  @IBOutlet weak var firstName: UITextField!
  
  @IBOutlet weak var loginbg: UIImageView!
  @IBOutlet weak var signUp: UIButton!
  var newsletterSubscribed = false
  
 
  override func viewDidLoad() {
    super.viewDidLoad()
    if(Client.locale == "ar"){
      email.textAlignment = .right
      password.textAlignment = .right
      firstName.textAlignment = .right
      lastName.textAlignment = .right
      confirmPassword.textAlignment = .right
      newsletter.contentHorizontalAlignment = .right
    }
    else{
      email.textAlignment = .left
      password.textAlignment = .left
      firstName.textAlignment = .left
      lastName.textAlignment = .left
      confirmPassword.textAlignment = .left
      newsletter.contentHorizontalAlignment = .left
    }
      firstName.placeholder = "First Name".localized
      lastName.placeholder = "Last Name".localized
      email.placeholder = "Email".localized
      password.placeholder = "Password".localized
      confirmPassword.placeholder = "Confirm Password".localized
      newsletter.setTitle("Newsletter".localized, for: .normal)
      signUp.setTitle("SIGNUP".localized, for: .normal)
      firstName.font = mageFont.regularFont(size: 14.0)
      lastName.font = mageFont.regularFont(size: 14.0)
      email.font = mageFont.regularFont(size: 14.0)
      password.font = mageFont.regularFont(size: 14.0)
      confirmPassword.font = mageFont.regularFont(size: 14.0)
      newsletter.titleLabel?.font = mageFont.regularFont(size: 14.0)
      signUp.titleLabel?.font = mageFont.mediumFont(size: 15.0)
      newsletter.imageView?.contentMode = .scaleAspectFit
    let img = UserDefaults.standard.value(forKey: "loginbg") as! String
    self.loginbg.sd_setImage(with: URL(string: img))
    signUp.addTarget(self, action: #selector(self.signUP(sender:)), for: .touchUpInside)
    newsletter.addTarget(self, action: #selector(self.subscribeNewsLetter(_:)), for: .touchUpInside)
    setupEyeButton()
  }

  func setupEyeButton(){
    password.rightViewMode     = .always
    password.rightView         = passEyeButton.showHideButton()
    passEyeButton.addTarget(self, action: #selector(controlVisibility(_:)), for: .touchUpInside)

    confirmPassword.rightViewMode     = .always
    confirmPassword.rightView         = confirmPassEyeButton.showHideButton()
    confirmPassEyeButton.addTarget(self, action: #selector(controlVisibility(_:)), for: .touchUpInside)
  }
  
  @objc func controlVisibility(_ sender: UIButton){
  
    if sender == passEyeButton {
      password.isSecureTextEntry = !password.isSecureTextEntry
      password.isSecureTextEntry ? sender.setImage(UIImage(named: "eyehide"), for: .normal) : sender.setImage(UIImage(named: "eyeshow"), for: .normal)
    }else{
      confirmPassword.isSecureTextEntry = !confirmPassword.isSecureTextEntry
      confirmPassword.isSecureTextEntry ? sender.setImage(UIImage(named: "eyehide"), for: .normal) : sender.setImage(UIImage(named: "eyeshow"), for: .normal)
    }
  }
  
  @objc func subscribeNewsLetter(_ sender:UIButton){
    if newsletterSubscribed {
      sender.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
      newsletterSubscribed = false
    }else {
      sender.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
      newsletterSubscribed = true
    }
  }
  
  @objc func signUP(sender:UIButton)
  {
    guard let fname = firstName.text else {return}
    guard let lname = lastName.text else {return}
    guard let email = email.text else {return}
    guard let pass = password.text else {return}
    guard let confirmPass = confirmPassword.text else {return}
    
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
    Client.shared.createCustomer(with: fname, lname: lname, email: email, password: pass,newsletter: newsletterSubscribed){
      response,usererror,error in
      self.view.stopLoader()
      if let _ = response {
        let alert = UIAlertController(title: "Success".localized, message: "Account is successfully created".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { (action) in
          self.fetchCustomerToken(usernameText: email, password: pass)
        }))
        self.present(alert, animated: true, completion: nil);
        //self.showErrorAlert(title: "Success".localized, error: "Account is successfully created.".localized)
        
       
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
  
  func fetchCustomerToken(usernameText: String, password: String){
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
      
      //Flits
      if customAppSettings.sharedInstance.flitsIntegration{
        guard let fname = self.firstName.text else {return}
        guard let lname = self.lastName.text else {return}
        guard let email = self.email.text else {return}
        
        self.flitsProfileManager = FlitsProfileManager()
        let params = ["first_name":fname,"last_name":lname,"email":email,"phone":"","birthdate":"","gender":""]
        self.flitsProfileManager?.flitsProfileUpdate(params: params)
      }
      //End
        
      
                let params : [AppEvents.ParameterName:Any] = [AppEvents.ParameterName.content : usernameText]
                AppEvents.shared.logEvent(.completedRegistration, parameters: params)
              self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: NSNotification.Name("loadDrawerAgain"), object: nil)
                self.presentingViewController?.tabBarController?.selectedIndex = 0
              })
    })
  }
}
