
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
import MobileBuySDK

class EditUserViewController: BaseViewController {
  
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var passwordHeight: NSLayoutConstraint!
  @IBOutlet weak var checkBoxButton: UIButton!
  var userDetails=[String:String]()
  @IBOutlet weak var cnfPasswordHeight: NSLayoutConstraint!
  
    @IBOutlet weak var scrollWidth: NSLayoutConstraint!
    @IBOutlet weak var pwdLbl: UILabel!
  @IBOutlet weak var cnfpassword: UITextField!
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var lastNam: UITextField!
  @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var viewInfo: UILabel!
    
//  @IBOutlet weak var viewHieght: NSLayoutConstraint!
  var flag=false
  var parentVC: AccountViewController?
    var passEyeButton             = UIButton(type: .custom)
    var confirmPassEyeButton      = UIButton(type: .custom)
  //Flits
  var flitsProfileManager:FlitsProfileManager?
  
  override func viewDidLoad() {
    super.viewDidLoad()
      headerTitleSetup()
      setupEyeButton()
      saveButton.setTitle("Update".localized, for: .normal)
      saveButton.backgroundColor = UIColor.AppTheme()
      saveButton.setTitleColor(UIColor.textColor(), for: .normal)
      scrollWidth.constant = UIScreen.main.bounds.width
     
    if Client.locale == "ar" {
      email.textAlignment = .right
      password.textAlignment = .right
      firstName.textAlignment = .right
      lastNam.textAlignment = .right
      pwdLbl.textAlignment = .right
      cnfpassword.textAlignment = .right
      
    }
    else {
      email.textAlignment = .left
      password.textAlignment = .left
      firstName.textAlignment = .left
      lastNam.textAlignment = .left
      pwdLbl.textAlignment = .left
      cnfpassword.textAlignment = .left
    }
    self.view.addLoader()
    Client.shared.fetchCustomerDetails {
      response,error   in
      self.view.stopLoader()
      if let response = response {
        self.firstName.text=response.firstName
        self.lastNam.text=response.lastName
        self.email.text=response.email
      }else {
        //self.showErrorAlert(error: error?.localizedDescription)
      }
    }
    
    setupPage()
      print("isSocialLogin===>",UserDefaults.standard.bool(forKey: "isSocialLogin"))
      if UserDefaults.standard.bool(forKey: "isSocialLogin"){
          checkBoxButton.isHidden = true
          pwdLbl.isHidden = true
      }
      else{
          checkBoxButton.isHidden = false
          pwdLbl.isHidden = false
      }
    checkBoxButton.addTarget(self, action: #selector(checkBoxClicked), for: .touchUpInside)
  }
  
  
    func headerTitleSetup(){
        let titleWidth = ("View Your Info" as NSString).size(withAttributes: [NSAttributedString.Key.font: mageFont.mediumFont(size: 15)]).width
        let title           = UILabel(frame: CGRect(x: 0, y: 0, width: titleWidth, height: 30))
        title.font          = mageFont.mediumFont(size: 15)
        title.text          = "View Your Info".localized
        title.textColor     = Client.navigationThemeData?.icon_color ?? .white
       
            self.navigationItem.leftBarButtonItems?.append(UIBarButtonItem(customView: title))
        
    }
  
  
  func setupPage(){
    firstName.placeholder = "First Name".localized
    lastNam.placeholder = "Last Name".localized
    email.placeholder = "Email".localized
    pwdLbl.text = "Change Password".localized
    password.placeholder = "New Password".localized
    cnfpassword.placeholder = "Confirm Password".localized
    saveButton.titleLabel?.font = mageFont.mediumFont(size: 16.0)
      viewInfo.text = "View Your Info".localized
      viewInfo.font = mageFont.boldFont(size: 15.0)
      viewInfo.textColor = UIColor.AppTheme()
//      saveButton.titleLabel?.text = "SAVE".localized

    firstName.font = mageFont.regularFont(size: 15.0)
    lastNam.font = mageFont.regularFont(size: 15.0)
    email.font = mageFont.regularFont(size: 15.0)
    pwdLbl.font = mageFont.regularFont(size: 15.0)
    password.font = mageFont.regularFont(size: 15.0)
    cnfpassword.font = mageFont.regularFont(size: 15.0)
    
    checkBoxButton.tag=0
    checkBoxButton.setImage(UIImage(named: "unchecked"), for: .normal)
    password.isHidden=true
    cnfpassword.isHidden=true
    passwordHeight.constant=0
    
    cnfPasswordHeight.constant=0
   // viewHieght.constant-=80//120
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @objc func checkBoxClicked(){
    if checkBoxButton.tag==0
    {
      checkBoxButton.tag=10
      checkBoxButton.setImage(UIImage(named: "checked"), for: .normal)
      flag=true
      password.isHidden=false
      cnfpassword.isHidden=false
      passwordHeight.constant=40
      cnfPasswordHeight.constant=40
      //viewHieght.constant+=80//120
    }
    else
    {
      checkBoxButton.tag=0
      password.isHidden=true
      cnfpassword.isHidden=true
      checkBoxButton.setImage(UIImage(named: "unchecked"), for: .normal)
      flag=false
      passwordHeight.constant=0
      cnfPasswordHeight.constant=0
     // viewHieght.constant-=80//120
    }
  }
  @IBAction func saveButtonTapped(_ sender: Any) {
    
    if firstName.text=="" || lastNam.text=="" || email.text==""{
      self.showErrorAlert(error: "All fields are required.".localized)
      return
    }
    if !(firstName.text?.isValidName())!
    {
      
      self.showErrorAlert(error: "Invalid First Name.".localized)
      return
    }
    if !(lastNam.text?.isValidName())!
    {
      
      self.showErrorAlert(error: "Invalid Last Name.".localized)
      return
    }
    if !(email.text?.isValidEmail())!
    {
      
      self.showErrorAlert(error: "Invalid Email ID.".localized)
      return
    }
    
    if flag==true
    {
      
      if password.text == "" || cnfpassword.text == ""
      {
        
        self.showErrorAlert(error: "All Fields are Required.".localized)
        return
      }
      if password.text != cnfpassword.text
      {
        
        self.showErrorAlert(error: "Please enter same password for confirm password.".localized)
        return
      }
    }
    self.view.addLoader()
    //Flits
    if self.checkBoxButton.tag == 10 {
    if customAppSettings.sharedInstance.flitsIntegration{
      self.flitsProfileManager = FlitsProfileManager()
      let params  = ["password":self.password.text!,"password_confirmation":self.password.text!]
      self.flitsProfileManager?.flitsPasswordUpdate(params: params)
    }
    }
    //
    Client.shared.updateCustomer(with: firstName.text!, lname: lastNam.text!, email: email.text!, password:password.text! ){
      response,error,netError  in
      self.view.stopLoader()
      if let _ = response{
        // Log out customer in case of password update
        if self.checkBoxButton.tag == 10 {
          
          self.showPasswordUpdatedAlert(title: "Success".localized, error: "Customer Data Updated.".localized + "Please sign in".localized)
        }else{
          self.showErrorAlert(title: "Success".localized, error: "Customer Data Updated.".localized)
        }
      }else if let error = error {
        self.showCustomerErrorAlert(errors: error)
      }else {
        self.showErrorAlert(error: netError?.localizedDescription)
      }
    }
  }
  
  func doLogOut(){
    self.navigationController?.popViewController(completion: {
      self.parentVC?.fromPasswordUpdate = true
      self.parentVC?.doLogOut()
    })
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    //        FloatingButton.shared.controller = self
    //        FloatingButton.shared.renderFloatingButton()
  }
  
   func showPasswordUpdatedAlert(title:String? = nil,error:String?){
      guard let error = error else {return}
      let alertViewController = UIAlertController(title: title, message: error, preferredStyle: .alert)
    alertViewController.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { _ in
      self.doLogOut()
    }))
      self.present(alertViewController, animated: true, completion: nil)
  }
    
    func setupEyeButton(){
      password.rightViewMode     = .always
      password.rightView         = passEyeButton.showHideButton()
      passEyeButton.addTarget(self, action: #selector(controlVisibility(_:)), for: .touchUpInside)

      cnfpassword.rightViewMode     = .always
      cnfpassword.rightView         = confirmPassEyeButton.showHideButton()
      confirmPassEyeButton.addTarget(self, action: #selector(controlVisibility(_:)), for: .touchUpInside)
    }
    @objc func controlVisibility(_ sender: UIButton){
    
      if sender == passEyeButton {
        password.isSecureTextEntry = !password.isSecureTextEntry
        password.isSecureTextEntry ? sender.setImage(UIImage(named: "eyehide"), for: .normal) : sender.setImage(UIImage(named: "eyeshow"), for: .normal)
      }else{
        cnfpassword.isSecureTextEntry = !cnfpassword.isSecureTextEntry
        cnfpassword.isSecureTextEntry ? sender.setImage(UIImage(named: "eyehide"), for: .normal) : sender.setImage(UIImage(named: "eyeshow"), for: .normal)
      }
    }
}
