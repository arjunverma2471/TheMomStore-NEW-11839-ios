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


//protocol proceedToCheckoutDelegate: class {
//    func proceedToCheckout(_ cell: CartCheckoutCell, didAddToCart sender: Any,ofType:checkoutType)
//}

class CartCheckoutCell: UITableViewHeaderFooterView {
    @IBOutlet weak var subTotal: UILabel!
  //  var delegate:proceedToCheckoutDelegate?
    @IBOutlet weak var checkoutOptions: UIStackView!
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
        setupCheckoutOptions()
        setupTotal()
        addSubview(view)
    }
    
    func setupTotal(amount: Decimal = 0.0, giftCard: Bool = false){
        if(!giftCard){
            subTotal.text = "SubTotal: ".localized + Currency.stringFrom(CartManager.shared.cartSubtotal)
        }
        else{
            subTotal.text = "SubTotal: ".localized + "\(Currency.formatter.string(from: amount as NSDecimalNumber)!)"
        }
        
    }
    
  func loadViewFromNib() -> UIView
  {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: "cartcheckoutview", bundle: bundle)
    let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    return view
  }
  
  func setupCheckoutOptions(){
    let webCheckout = Button()
    webCheckout.setTitle("Checkout".localized, for: .normal)
    webCheckout.addTarget(self, action: #selector(self.proceedToWebCheckout(sender:)), for: .touchUpInside)
    self.checkoutOptions.addArrangedSubview(webCheckout)
    if AppSetUp.applePayEnable {
      //Adding Apple Pay Button if supported
      if PKPaymentAuthorizationController.canMakePayments() {
        let applePay = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black)
        applePay.addTarget(self, action: #selector(self.proceedToApplePay(sender:)), for: .touchUpInside)
        self.checkoutOptions.addArrangedSubview(applePay)
      }
    }
  }
  
  @objc func proceedToWebCheckout(sender:UIButton){
  //  self.delegate?.proceedToCheckout(self, didAddToCart: sender, ofType: .webcheckout)
    }
    
    @objc func proceedToApplePay(sender:UIButton){
   //     self.delegate?.proceedToCheckout(self, didAddToCart: sender, ofType: .applePay)
    }
    
   
    
}
