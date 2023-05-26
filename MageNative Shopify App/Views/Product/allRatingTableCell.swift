//
//  allRatingTableCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 20/03/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import UIKit
import Cosmos


class allRatingTableCell: UITableViewCell {
  
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var review: CosmosView!  
  @IBOutlet weak var ratingText: UILabel!
  @IBOutlet weak var date: UILabel!
  @IBOutlet weak var nameInitials: UILabel!
  @IBOutlet weak var name: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    ratingViewSettings()
    // Initialization code
  }
  
    func ratingViewSettings() {
      //  review.settings.emptyBorderColor = UIColor.AppTheme()
        review.settings.emptyBorderWidth = 1.0
     //   review.settings.filledColor = UIColor.AppTheme()
     //   review.settings.filledBorderColor = UIColor.AppTheme()
        review.settings.filledBorderWidth = 1.0
        review.settings.starSize = 18.0
        review.settings.starMargin = 4
        review.settings.textFont = mageFont.regularFont(size: 15.0)
        review.settings.updateOnTouch = false
    }
    
  func configureData(ratingData:[String:String]) {
    review.settings.starSize = 18.0
    review.settings.starMargin = 4
    nameInitials.layer.cornerRadius = 30.0
    nameInitials.layer.borderColor = UIColor.black.cgColor
    nameInitials.layer.borderWidth = 2.0
    var nameInitial = ""
      let nameArray = ratingData["reviewer_name"]?.components(separatedBy: " ")
      if let nameArr = nameArray{
          for val in nameArr {
            nameInitial += (val.first?.description) ?? ""
          }
      }
      
    //}
    nameInitials.text = nameInitial.uppercased()
      nameInitials.font = mageFont.boldFont(size: 20.0)
    self.name.text = ratingData["reviewer_name"]
    date.text = ratingData["review_date"]
    self.title.text = ratingData["review_title"]
    ratingText.text = ratingData["content"]
    review.rating = Double(ratingData["rating"] ?? "0.0") ?? 0.0
    review.text = ratingData["rating"]
      name.font = mageFont.regularFont(size: 14.0)
      date.font = mageFont.regularFont(size: 14.0)
      title.font = mageFont.regularFont(size: 14.0)
      ratingText.font = mageFont.regularFont(size: 14.0)
      
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
}
