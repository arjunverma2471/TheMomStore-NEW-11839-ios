//
//  GrowaveFAQTableCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 30/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
class GrowaveFAQTableCell : UITableViewCell {
    
    @IBOutlet weak var subHeading: UILabel!
    @IBOutlet weak var heading: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
