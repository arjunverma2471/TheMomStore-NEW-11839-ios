//
//  RewardListTableCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 10/06/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import UIKit

class RewardListTableCell: UITableViewCell {

    @IBOutlet weak var actionLbl: UILabel!
    @IBOutlet weak var wrapperView: UIView!
    
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var pointsLbl: UILabel!
    
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var statusTxt: UILabel!
    @IBOutlet weak var pointsTxt: UILabel!
    @IBOutlet weak var actionTxt: UILabel!
    @IBOutlet weak var dateTxt: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureData(str : [String:String]) {
        dateTxt.text = "Date".localized
        actionTxt.text = "Action".localized
        pointsTxt.text = "Points".localized
        statusTxt.text = "Status".localized
        statusLbl.text = str["status"]
        actionLbl.text = str["action"]
        dateLbl.text = str["date"]
        pointsLbl.text = str["points"]
        dateTxt.font = mageFont.regularFont(size: 15.0)
        actionTxt.font = mageFont.regularFont(size: 15.0)
        pointsTxt.font = mageFont.regularFont(size: 15.0)
        statusTxt.font = mageFont.regularFont(size: 15.0)
        statusLbl.font = mageFont.regularFont(size: 15.0)
        actionLbl.font = mageFont.regularFont(size: 15.0)
        dateLbl.font = mageFont.regularFont(size: 15.0)
        pointsLbl.font = mageFont.regularFont(size: 15.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
