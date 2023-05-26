//
//  PickUpAddressListCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 17/11/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import Foundation
class PickUpAddressListCell : UITableViewCell {

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var headingText: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
