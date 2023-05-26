//
//  RewardPointsTopTableCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 09/06/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import UIKit

class RewardPointsTopTableCell: UITableViewCell {

    @IBOutlet weak var pointsBalanceLbl: UILabel!
    
    @IBOutlet weak var ptsLbl: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var topHeading: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
