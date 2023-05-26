//
//  DeliveryTimeCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 14/03/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
class DeliveryTimeCell: UITableViewCell {
    
    @IBOutlet weak var deliveryTimeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if Client.locale == "ar"{
            deliveryTimeBtn.contentHorizontalAlignment = .right
        }else{
            deliveryTimeBtn.contentHorizontalAlignment = .left
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
