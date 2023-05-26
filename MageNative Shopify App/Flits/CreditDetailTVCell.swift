//
//  CreditDetailTVCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 10/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class CreditDetailTVCell: UITableViewCell {

  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var creditType: UILabel!
  @IBOutlet weak var creditValue: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    self.selectionStyle               = .none
    containerView.layer.borderColor   = DynamicColor.label.cgColor
    containerView.layer.borderWidth   = 0.5
    containerView.layer.cornerRadius  = 5
    
    }
}
