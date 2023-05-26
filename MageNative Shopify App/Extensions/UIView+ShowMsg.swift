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

extension UIView {
    
    func showmsg(msg:String){
        let snackBar = TTGSnackbar(message: msg, duration: .middle)
        snackBar.animationType = .slideFromLeftToRight
        snackBar.messageTextAlign = .center
        snackBar.show()
        
    }
}

extension UIView {
    
    func startShimmering(){
        let light = UIColor.darkGray.cgColor
        let alpha = UIColor.darkGray.withAlphaComponent(0.7).cgColor
        
        let gradient = CAGradientLayer()
        gradient.colors = [alpha, light, alpha, alpha, light, alpha]
        gradient.frame = CGRect(x: -self.bounds.size.width, y: 0, width: 3 * self.bounds.size.width, height: self.bounds.size.height)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.525)
        gradient.locations = [0.4, 0.5, 0.6]
        self.layer.mask = gradient
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = 1.5
        animation.repeatCount = HUGE
        gradient.add(animation, forKey: "shimmer")
    }
    
    func stopShimmering(){
        self.layer.mask = nil
    }
}

extension UIView{
    public func cardView(){
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.cornerRadius = 2
    }
    
    public func removeCardView(){
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.shadowOpacity = 0
        
    }

    public func cardViewWithDarkModeSupport() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(light: .black, dark: .white).cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 4
//        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        
//        if #available(iOS 13.0, *) {
//            self.layer.shadowColor = UIColor { (traitCollection) -> UIColor in
//                if traitCollection.userInterfaceStyle == .dark {
//                    return UIColor.white
//                } else {
//                    return UIColor.black
//                }
//            }.cgColor
//        }
       
    }
   
    public func makeBorder(width:CGFloat,color:UIColor?,radius:CGFloat){
        self.layer.borderColor = color?.cgColor
        self.layer.borderWidth = width
        self.layer.cornerRadius = radius
     //   self.clipsToBounds = true
      
    }
}
extension UIView{
    func createArc(){
        self.clipsToBounds = true
        self.layer.cornerRadius = 30
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
}
