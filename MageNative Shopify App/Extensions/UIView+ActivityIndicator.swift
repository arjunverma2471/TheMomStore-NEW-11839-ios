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

extension UIView {
    func addLoader(){
        let activity = UIActivityIndicatorView(style: .whiteLarge)
        activity.frame.size = CGSize(width: 100, height: 100)
        activity.color = UIColor.black
        activity.center = self.center
        activity.tag = 12334
        activity.hidesWhenStopped = true
        activity.startAnimating()
        self.addSubview(activity)
    }
    
    func stopLoader(){
       if let activity = self.viewWithTag(12334) as? UIActivityIndicatorView {
        activity.stopAnimating()
        activity.removeFromSuperview()
        }
    }
    
    func addFullLoader() {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        let activity = UIActivityIndicatorView(style: .whiteLarge)
        activity.frame.size = CGSize(width: 100, height: 100)
        activity.color = UIColor.black
        activity.center = self.center
        activity.tag = 12334
        view.tag = 14556
        activity.hidesWhenStopped = true
        activity.startAnimating()
        self.addSubview(view)
        self.addSubview(activity)
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    
    func removeFullLoader() {
        if let view = self.viewWithTag(14556) {
            view.removeFromSuperview()
        }
        if let activity = self.viewWithTag(12334) as? UIActivityIndicatorView {
         activity.stopAnimating()
         activity.removeFromSuperview()
         }
    }
}
