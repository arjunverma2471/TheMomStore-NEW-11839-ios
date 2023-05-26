//
//  NativeAddressViewModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 13/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation

protocol AddressUpdatesDelegate{
  func addressUpdate()
}

class NativeAddressViewModel{
  
  var addresses : PageableArray<AddressesViewModel>?
  var delegate: AddressUpdatesDelegate?
  
  func loadAddresses(){

    Client.shared.fetchCustomerAddresses(completion: {
      response,error  in
      if let response = response {
        self.addresses = response
        self.delegate?.addressUpdate()
      }else {
        //self.showErrorAlert(error: error?.localizedDescription)
      }
    })
  }
}
