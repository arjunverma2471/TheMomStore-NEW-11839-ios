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
extension CheckoutViewModel {
    
    var payCheckout: PayCheckout {
        
        let payItems = self.lineItems.map { item in
            PayLineItem(price: item.individualPrice, quantity: item.quantity)
        }
        
        return PayCheckout(
            id:              self.id,
            lineItems:       payItems,
            giftCards:       nil,
            discount:        nil,
            shippingDiscount: nil,
            shippingAddress: self.shippingAddress?.payAddress,
            shippingRate:    self.shippingRate?.payShippingRate,
            currencyCode: self.currencyCode,
            totalDuties: 0.0,
            subtotalPrice:   self.subtotalPrice,
            needsShipping:   self.requiresShipping,
            totalTax:        self.totalTax,
            paymentDue:      self.paymentDue
            
        )
    }
}
