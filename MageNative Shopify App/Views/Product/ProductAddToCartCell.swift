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
import PassKit

protocol ProductAddToCartDelegate: AnyObject {
    //func productAddToCart(_ cell: ProductAddToCartCell, didAddToCart sender: Any)
    func buyWithApplePay(_ cell: ProductAddToCartCell, didAddToCart sender: Any)
}

class ProductAddToCartCell: UITableViewHeaderFooterView {
    weak var delegate: ProductAddToCartDelegate?
    @IBOutlet weak var buyButtonsStack: UIStackView!
    
    
    var view:UIView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        xibSetup()
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    func xibSetup()
    {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
       setupAddtocart()
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "productaddtocartcell", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
 
    func setupAddtocart() {
        let addToCartButton = Button()
        addToCartButton.setTitle("Add To Bag".localized, for: .normal)
        addToCartButton.addTarget(self, action: #selector(self.productAddToCart(sender:)), for: .touchUpInside)
        self.buyButtonsStack.addArrangedSubview(addToCartButton)
        if AppSetUp.applePayEnable {
            //Adding Apple Pay Button if supported
            if PKPaymentAuthorizationController.canMakePayments() {
                let applePay = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black)
                applePay.addTarget(self, action: #selector(self.productApplePay(sender:)), for: .touchUpInside)
                self.buyButtonsStack.addArrangedSubview(applePay)
            }
        }
    }
    
    @objc func productAddToCart(sender:UIButton){
       // self.delegate?.productAddToCart(self, didAddToCart: sender)
    }
    
    @objc func productApplePay(sender:UIButton){
        self.delegate?.buyWithApplePay(self, didAddToCart: sender)
    }
}
