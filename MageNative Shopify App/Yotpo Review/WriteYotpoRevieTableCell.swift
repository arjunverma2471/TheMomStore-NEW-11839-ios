//
//  WriteYotpoRevieTableCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 29/10/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import UIKit
import Cosmos

class WriteYotpoRevieTableCell: UITableViewCell {

    @IBOutlet weak var submitBtn: Button!
    @IBOutlet weak var reviewBody: UITextView!
    @IBOutlet weak var reviewTitle: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cosmosView: CosmosView!
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
