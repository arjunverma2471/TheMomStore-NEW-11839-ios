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
import UserNotifications

class CartManager {
  
  static let shared = CartManager()
  private let backQueue    = DispatchQueue(label: "com.magenative.Queue")
  
  var cartProducts : [CartProduct] = []
  private var saveCart = false
  
  var cartSubtotal: Decimal {
    return DBManager.shared.cartProducts?.reduce(0) {
      $0 + 0 * Decimal($1.qty)
    } ?? 0.0
  }
  
  var cartCount: Int {
//    return DBManager.shared.cartProducts?.reduce(0) {
//      $0 + $1.qty
//    } ?? 0
    return DBManager.shared.cartProducts?.count ?? 0
  }
  
  private var cartURL: URL = {
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    let documentsURL  = URL(fileURLWithPath: documentsPath)
    let cartURL       = documentsURL.appendingPathComponent("\(Client.shopUrl)new1.json")
    print("Cart URL: \(cartURL)")
    return cartURL
  }()
  
  // ----------------------------------
  //  MARK: - Init -
  //
  private init() {
    if(DBManager.shared.cartProducts?.count ?? 0 > 0){
      self.getAccessLocalNotification()
    }
    else{
      UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["magenative_cart_notification_center"])
    }
  }
  
  // ----------------------------------
  //  MARK: - Update cart quantity -
  //
  func updateCartQuantity(_ products: LineItemViewModel ,with qty:Int){
    DBManager.shared.updateToCart(product: products,qty: qty)
  }
   
    func updateCartQuantityProduct(_ products: CartLineItemViewModel ,with qty:Int){
      DBManager.shared.updateToCartProduct(product: products,qty: qty)
    }
  
  // ----------------------------------
  //  MARK: - Add to cart -
  //
    func addToCart(_ product:CartProduct, id: String = ""){
        DBManager.shared.addToCart(product: product, id: id)
        if DBManager.shared.cartProducts?.count ?? 0 > 0 {
            let center = UNUserNotificationCenter.current()
            center.getPendingNotificationRequests(completionHandler: { requests in
                if requests.count == 0 {
                    self.getAccessLocalNotification()
                }
            })
        }
  }
  
  // ----------------------------------
  //  MARK: - Get product id using line item-
  //
  func getProductId(product: LineItemViewModel)->String{
    return DBManager.shared.getCartProduct(product: product)
  }
    
    func getCartProductID(product:CartLineItemViewModel)->String{
        return DBManager.shared.getCartProductID(product: product)
    }
  
  // ----------------------------------
  //  MARK: - Delete product from cart -
  //
  func deleteQty(_ product: LineItemViewModel){
    DBManager.shared.removeFromCart(product: product)
  }
    
    func deleteCartQty(_ product: CartLineItemViewModel){
      DBManager.shared.removeFromCartProduct(product: product)
    }
    
  
  // ----------------------------------
  //  MARK: - Clear cart -
  //
  func deleteAll()
  {
    DBManager.shared.clearCartData()
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["magenative_cart_notification_center"])
  }
  
  // ----------------------------------
  //  MARK: - Show error in case cart items are out of stock -
  //
  func showCartQuantityError(on view:UIViewController,error:[UserErrorViewModel]?){
    guard let error = error else {return}
    var msg = ""
    error.forEach{
      guard let errors =  $0.errorFields else {return}
      guard let index = Int(errors[2]) else {return}
      let title = DBManager.shared.cartProducts?[index].variant.title
      msg += title ?? "" + "\n" + $0.errorMessage + "\n"
    }
    msg += "So we are updating quantity in cart.".localized
    let alertViewController = UIAlertController(title: "Quantity Error".localized, message: msg, preferredStyle: .alert)
    alertViewController.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: nil))
    view.present(alertViewController, animated: true, completion: nil)
  }
}
