//
//  CartCalendarCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 05/10/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import UIKit

class CartCalendarCell: UITableViewCell {

    @IBOutlet weak var calendarImg: UIImageView!
    @IBOutlet weak var calendarBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if Client.locale == "ar"{
            calendarBtn.contentHorizontalAlignment = .right
        }else{
            calendarBtn.contentHorizontalAlignment = .left
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
