//
//  SavingCornerView.swift
//  MageNative Shopify App
//
//  Created by Yash Pratap Singh sisodia on 23/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import UIKit

class SavingCornerView: UITableViewCell {

    @IBOutlet weak var parentView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
      
        self.parentView.backgroundColor = UIColor(light: UIColor(hexString: "#F2F2F2"),dark: UIColor.provideColor(type: .cartVc).black)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
