//
//  GrowaveActivityTableCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 30/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
class GrowaveActivityTableCell : UITableViewCell {
    
    @IBOutlet weak var heading: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subHeading: UILabel!
    override func awakeFromNib() {
          super.awakeFromNib()
          // Initialization code
      }

      override func setSelected(_ selected: Bool, animated: Bool) {
          super.setSelected(selected, animated: animated)

          // Configure the view for the selected state
      }
    
    func setData(model:GrowavePointActivityModel) {
        heading.font = mageFont.mediumFont(size: 12.0)
        subHeading.font = mageFont.regularFont(size: 12.0)
        dateLabel.font = mageFont.regularFont(size: 10.0)
        switch model.type {
        case "redeem" :
            heading.text = model.spendingTitle
            subHeading.text = "- \(model.spendPoints) Points"
        case "manual" :
            heading.text = model.manualTitle
            subHeading.text = "+ \(model.earnedPoints) Points"
        default :
            heading.text = model.title
            subHeading.text = "+ \(model.earnedPoints) Points"
        }
        
        
        
        dateLabel.text = self.timeStringFromUnixTime(unixTime: model.creation_time)
        
    }
    
    func timeStringFromUnixTime(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        // Returns date formatted as 12 hour time.
        dateFormatter.dateFormat = "MMM dd YYYY hh:mm a"
        return dateFormatter.string(from: date as Date)
    }

    
    
}
