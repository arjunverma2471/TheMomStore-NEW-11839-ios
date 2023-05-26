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

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var sendPwdBtn: Button!
    @IBOutlet weak var txtLbl: UILabel!
    @IBOutlet weak var emailField: SkyFloatingLabelTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtLbl.text = "Enter your registered mail to get reset link and follow the steps in mail to reset the password".localized
        txtLbl.font = mageFont.regularFont(size: 14.0)
        emailField.font = mageFont.regularFont(size: 15.0)
        emailField.placeholder = "Enter your registered mail".localized
        sendPwdBtn.titleLabel?.font = mageFont.mediumFont(size: 15.0)
        sendPwdBtn.setTitle("Send Password Reset Link".localized, for: .normal)
        if(Client.locale == "ar"){
            emailField.textAlignment = .right
        }
        else{
            emailField.textAlignment = .left
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        FloatingButton.shared.controller = self
//        FloatingButton.shared.renderFloatingButton()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
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
}
