//
//  NativeAddressListCVCelll.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 13/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class NativeAddressListCVCelll: UICollectionViewCell {

  @IBOutlet weak var address: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    self.layer.borderWidth = 1
    self.layer.borderColor = DynamicColor.label.cgColor
    }
  
  func configureFrom(_ model:AddressesViewModel){
     
      var address = model.address1 ?? ""
      if let address2 = model.address2 {
          address +=  " " + address2 + "\n"
      }
      if let city =  model.city {
          address +=  city + " "
      }
      if let province = model.province {
          address += province + "\n"
      }
      if let country = model.country {
          address += country + "-"
      }
      if let zip = model.zip {
          address += zip + "\n"
      }
      if let phone = model.phone {
          address += phone
      }
    self.address.text = address
    self.address.font = mageFont.regularFont(size: 14.0)
      
  }

}
