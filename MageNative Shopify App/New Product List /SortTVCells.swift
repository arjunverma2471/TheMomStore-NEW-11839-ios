//
//  SortTVCells.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 13/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import UIKit

class SortTVCells: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var sortStatusImage: UIImageView!
    @IBOutlet weak var sortHeader: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.backgroundColor = UIColor(light: .white,dark: .black)
        sortHeader.font      = UIFont(name: "Poppins-Regular", size: 15)
        sortHeader.textColor = UIColor(light: UIColor.init(hexString: "#6B6B6B"))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
