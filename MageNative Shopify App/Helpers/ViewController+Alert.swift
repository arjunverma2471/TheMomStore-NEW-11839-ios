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

import Foundation
import UIKit
import RxSwift
import RxCocoa


extension UIViewController {
    func showErrorAlert(errors:[UserErrorViewModel]?){
        guard let errors = errors else {return}
        var errorMsg = ""
        errors.forEach{
            errorMsg += $0.errorMessage + "\n"
        }
        let alertViewController = UIAlertController(title: "Error".localized, message: errorMsg, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: nil))
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func showCustomerErrorAlert(errors:[CustomerErrorViewModel]?){
        guard let errors = errors else {return}
        var errorMsg = ""
        errors.forEach{
            errorMsg += $0.errorMessage + "\n"
        }
        let alertViewController = UIAlertController(title: "Error".localized, message: errorMsg, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: nil))
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func showErrorAlert(title:String? = nil,error:String?){
        guard let error = error else {return}
        
        let alertViewController = UIAlertController(title: title, message: error, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "YES".localized, style: .default, handler: nil))
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func showAlert(title:String? = nil,error:String?){
        guard let error = error else {return}
        
        let alertViewController = UIAlertController(title: title, message: error, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: nil))
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func setupTabbarCount(){
//        if customAppSettings.sharedInstance.inAppWishlist {
//            self.tabBarController?.tabBar.items?[2].badgeValue = CartManager.shared.cartCount.description
//           // self.tabBarController?.tabBar.items?[3].badgeValue = WishlistManager.shared.wishCount.description
//        }
//        else {
//            self.tabBarController?.tabBar.items?[2].badgeValue = CartManager.shared.cartCount.description
//        }
        
        if let tabbarControl =  self.tabBarController as? TabbarController {
          
          
          tabbarControl.tabBar.items![0].title = "Home".localized
          tabbarControl.tabBar.items![1].title = "Search".localized
            tabbarControl.tabBar.items![2].title = "Categories".localized
            tabbarControl.tabBar.items![3].title = "Account".localized
          
        }
    }
}

extension UIButton {
  
  func showHideButton() -> UIButton {
      self.clipsToBounds = true
      self.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(30), height: CGFloat(30))
      self.setImage(UIImage(named: "eyehide"), for: .normal)
      self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      return self
    }
}
