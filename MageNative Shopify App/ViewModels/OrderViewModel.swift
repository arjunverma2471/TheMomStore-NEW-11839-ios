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

class OrderViewModel:ViewModel
{
  typealias ModelType = MobileBuySDK.Storefront.OrderEdge
  
  
  let model: ModelType?
  let processedAt:String
  let customerUrl:URL?
  let totalPrice:String
  let orderNumber:String
  let statusUrl:URL?
  let fulfillmentStatus:String
  let financialStatus:String
  let shippingAddress:AddressViewModel?
  let lineItems:PageableArray<OrderLineItemViewModel>
  let name:String
  let latitude:Double?
  let longitude :Double?
  let phoneNumber:String
  let cancelAt:String
  let cancelReason:String
  var subTotal:String?
  var shippingPrice:String?
  var refundPrice:String?
  var taxPrice:String?
  var email:String?
  
  required init(from model: ModelType) {
    self.model = model
    self.customerUrl =  model.node.customerUrl
    self.processedAt =  model.node.processedAt.formatDate(with: "MMM dd yyyy")
    self.orderNumber = String(model.node.orderNumber)
    self.totalPrice  = CurrencyOrder.stringFrom(model.node.totalPrice.amount, curr: model.node.totalPrice.currencyCode.rawValue)
    self.shippingAddress =  model.node.shippingAddress?.viewModel
    self.statusUrl = model.node.statusUrl
    self.name = model.node.shippingAddress?.name ?? ""
      self.phoneNumber = model.node.phone ?? ""//model.node.shippingAddress?.phone ?? ""
    self.latitude = model.node.shippingAddress?.latitude
    self.longitude = model.node.shippingAddress?.longitude
    self.fulfillmentStatus = model.node.fulfillmentStatus.rawValue
    self.financialStatus = model.node.financialStatus?.rawValue ?? ""
    self.subTotal = CurrencyOrder.stringFrom(model.node.subtotalPrice?.amount ?? 0.0, curr: model.node.totalPrice.currencyCode.rawValue)
    self.shippingPrice = CurrencyOrder.stringFrom(model.node.totalShippingPrice.amount, curr: model.node.totalPrice.currencyCode.rawValue)
//    self.shippingPrice = Currency.stringFrom(model.node.totalRefundedV2.amount)
    self.taxPrice = CurrencyOrder.stringFrom(model.node.totalTax?.amount ?? 0.0, curr: model.node.totalPrice.currencyCode.rawValue)
    self.email = model.node.email
    self.cancelAt = model.node.canceledAt?.description ?? ""
    self.cancelReason = model.node.cancelReason?.rawValue ?? ""
    self.lineItems =  PageableArray (
      with: model.node.lineItems.edges,
      pageInfo: model.node.lineItems.pageInfo
    )
  }
}
extension MobileBuySDK.Storefront.OrderEdge:ViewModeling{
  typealias ViewModelType = OrderViewModel
}



struct  CurrencyOrder {
  
  static var curr: String = String()
  
  static let formatter: NumberFormatter = {
    let formatter          = NumberFormatter()
    formatter.numberStyle  = .currency
    formatter.currencyCode = curr
    return formatter
  }()
  
  static func stringFrom(_ decimal: Decimal, curr:String) -> String {
    let currency = curr
    var currentrating = Decimal()
    var bydefaultrating = Decimal()
    formatter.currencyCode = currency
    if let rating = UserDefaults.standard.value(forKey: "rates") as? [String:Any]{
      for (key,value) in rating
      {
        if key == currency
        {
          bydefaultrating = Decimal(string: String(describing: value))!
        }
        if key == curr
        {
          currentrating = Decimal(string: String(describing: value))!
        }
      }
    }
    let price = ((decimal*bydefaultrating)/currentrating)
    return self.formatter.string(from: price as NSDecimalNumber)!
  }
}
