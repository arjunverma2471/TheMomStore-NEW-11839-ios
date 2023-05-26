//
//  cartView+AppleCheckout.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 07/04/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import Foundation

extension CartViewController:PaySessionDelegate {
  
  func paySession(_ paySession: PaySession, didRequestShippingRatesFor address: PayPostalAddress, checkout: PayCheckout, provide: @escaping  (PayCheckout?, [PayShippingRate]) -> Void) {
    
    print("Updating checkout with address...")
    Client.shared.updateCheckout(checkout.id, updatingPartialShippingAddress: address) { checkout in
      
      guard let checkout = checkout else {
        print("Update for checkout failed.")
        provide(nil, [])
        return
      }
      
      print("Getting shipping rates...")
      Client.shared.fetchShippingRatesForCheckout(checkout.id) { result in
        if let result = result {
          print("Fetched shipping rates.")
          provide(result.checkout.payCheckout, result.rates.payShippingRates)
        } else {
          provide(nil, [])
        }
      }
    }
  }
  
  func paySession(_ paySession: PaySession, didUpdateShippingAddress address: PayPostalAddress, checkout: PayCheckout, provide: @escaping (PayCheckout?) -> Void) {
    
    print("Updating checkout with shipping address for tax estimate...")
    Client.shared.updateCheckout(checkout.id, updatingPartialShippingAddress: address) { checkout in
      
      if let checkout = checkout {
        provide(checkout.payCheckout)
      } else {
        print("Update for checkout failed.")
        provide(nil)
      }
    }
  }
  
  func paySession(_ paySession: PaySession, didSelectShippingRate shippingRate: PayShippingRate, checkout: PayCheckout, provide: @escaping  (PayCheckout?) -> Void) {
    
    print("Selecting shipping rate...")
    Client.shared.updateCheckout(checkout.id, updatingShippingRate: shippingRate) { updatedCheckout in
      print("Selected shipping rate.")
      provide(updatedCheckout?.payCheckout)
    }
  }
  
  func paySession(_ paySession: PaySession, didAuthorizePayment authorization: PayAuthorization, checkout: PayCheckout, completeTransaction: @escaping (PaySession.TransactionStatus) -> Void) {
    
    guard let email = authorization.shippingAddress.email else {
      print("Unable to update checkout email. Aborting transaction.")
      completeTransaction(.failure)
      return
    }
    
    print("Updating checkout shipping address...")
    Client.shared.updateCheckout(checkout.id, updatingCompleteShippingAddress: authorization.shippingAddress) { updatedCheckout in
      guard let _ = updatedCheckout else {
        completeTransaction(.failure)
        return
      }
      
      print("Updating checkout email...")
      Client.shared.updateCheckout(checkout.id, updatingEmail: email) { updatedCheckout in
        guard let _ = updatedCheckout else {
          completeTransaction(.failure)
          return
        }
        
        print("Checkout email updated: \(email)")
        print("Completing checkout...")
        Client.shared.completeCheckout(checkout, billingAddress: authorization.billingAddress, applePayToken: authorization.token, idempotencyToken: paySession.identifier) { payment,error  in
          if let payment = payment, checkout.paymentDue == payment.amount {
            print("Checkout completed successfully.")
            completeTransaction(.success)
            self.appleCheckoutCompleted=true
          } else {
            print("Checkout failed to complete.")
            completeTransaction(.failure)
            self.appleCheckoutCompleted=false
          }
        }
      }
    }
  }
  
  func paySessionDidFinish(_ paySession: PaySession) {
    print("finish")
    if self.appleCheckoutCompleted==true {
      let viewControl:orderPlacedViewController = self.storyboard!.instantiateViewController()
      viewControl.modalPresentationStyle = .fullScreen
      self.present(viewControl, animated: true, completion: nil)
    }
  }
}
