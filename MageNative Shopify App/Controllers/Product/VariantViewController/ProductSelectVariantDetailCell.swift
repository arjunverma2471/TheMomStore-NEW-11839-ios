//
//  ProductSelectVariantDetailCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 14/04/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class ProductSelectVariantDetailCell: UITableViewCell {
  
  @IBOutlet weak var heading: UILabel!
  @IBOutlet weak var variantDetail: UILabel!
  @IBOutlet weak var availaibleQty: UILabel!
  
  var selectedVariant : VariantViewModel!{
    didSet{
      var str = String()
      selectedVariant.selectedOptions.forEach { data in
        str += "\(data.name): \(data.value)\n"
      }
      variantDetail.text = str
      preselectAvlQty()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    heading.textColor = UIColor.AppTheme()
    self.selectionStyle = .none
  }
  
  func preselectAvlQty(){
      if !self.selectedVariant.currentlyNotInStock {
          if self.selectedVariant.availableQuantity != "" {
              if Int(self.selectedVariant.availableQuantity) ?? 0 > 0  {
                  self.availaibleQty.text = "• \(self.selectedVariant.availableQuantity)"+" Available Quantity".localized
                  self.availaibleQty.font = mageFont.regularFont(size: 15.0)
//                  self.availableLabelHeight.constant = 15.0
              }
              else {
              
                  self.availaibleQty.text = ""
              }
          }
          else {
              self.availaibleQty.text = ""
          }
      }
  }
}
