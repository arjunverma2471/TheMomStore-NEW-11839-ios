//
//  RewardTableCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 09/06/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import UIKit

class RewardTableCell: UITableViewCell {

    @IBOutlet weak var headingLbl: UILabel!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var wrapperView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
