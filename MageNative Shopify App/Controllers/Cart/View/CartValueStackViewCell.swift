//
//  CartValueStackViewCell.swift
//  MageNative Shopify App
//
//  Created by Yash Pratap Singh sisodia on 31/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import UIKit

class CartValueStackViewCell: UITableViewCell {
    
    
    
 
    @IBOutlet weak var discountVaslue: UILabel!
    @IBOutlet weak var discountlb: UILabel!
    @IBOutlet weak var shoppingValue: UILabel!
    @IBOutlet weak var shoppingBagLbl: UILabel!
    @IBOutlet weak var shoppingStack: UIStackView!
    @IBOutlet weak var discountStack: UIStackView!
  
    @IBOutlet weak var cartPriceStack: UIStackView!
    @IBOutlet weak var parentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.parentView.backgroundColor = UIColor(light: UIColor(hexString: "#F2F2F2"),dark: UIColor.provideColor(type: .cartVc).backGroundColor)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
