//
//  CartPincodeChecker.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 30/09/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import UIKit

class CartPincodeChecker: UITableViewCell {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var searchPincode: UIButton!
    @IBOutlet weak var pincodeTextfield: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
