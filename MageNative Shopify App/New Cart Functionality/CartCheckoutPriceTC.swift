//
//  CartCheckoutPriceTC.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 18/11/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class CartCheckoutPriceTC: UITableViewCell {

    @IBOutlet weak var checkoutMainStack: UIStackView!
    @IBOutlet weak var totalAmtStack: UIStackView!
    @IBOutlet weak var totalAmtLbl: UILabel!
    @IBOutlet weak var totalAmtValue: UILabel!
    
    @IBOutlet weak var grandTotalStack: UIStackView!
    
    @IBOutlet weak var grandTtlLabel: UILabel!
    
    @IBOutlet weak var grandTtlValue: UILabel!
    
    @IBOutlet weak var discountStack: UIStackView!
    
    @IBOutlet weak var discountLbl: UILabel!
    
    @IBOutlet weak var discountValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
