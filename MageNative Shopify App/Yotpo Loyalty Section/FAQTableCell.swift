//
//  FAQTableCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 11/06/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import UIKit

class FAQTableCell: UITableViewCell {

    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var headingLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
