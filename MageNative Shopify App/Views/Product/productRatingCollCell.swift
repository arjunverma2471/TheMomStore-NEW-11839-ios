//
//  productRatingCollCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 16/03/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import UIKit
import Cosmos

class productRatingCollCell: UICollectionViewCell {
    
    @IBOutlet weak var reviewInitials: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var ratingText: UILabel!
    @IBOutlet weak var reviewTitle: UILabel!
    
    var shimmeringAnimatedItems: [UIView] {
            [
                reviewInitials,
                name,
                date,
                ratingView,
                ratingText,
                reviewTitle
            ]
        }
    
    func ratingViewSettings() {
       // ratingView.settings.emptyBorderColor = UIColor.AppTheme()
        ratingView.settings.emptyBorderWidth = 1.0
     //   ratingView.settings.filledColor = UIColor.AppTheme()
      //  ratingView.settings.filledBorderColor = UIColor.AppTheme()
        ratingView.settings.filledBorderWidth = 1.0
        ratingView.settings.starSize = 18.0
        ratingView.settings.starMargin = 4
        ratingView.settings.textFont = mageFont.regularFont(size: 15.0)
        ratingView.settings.updateOnTouch = false
    }
    
    
    func setReviewData(data:productRatingAndReviews) {
        reviewInitials.layer.cornerRadius = 30.0
        reviewInitials.layer.borderColor = UIColor.black.cgColor
        reviewInitials.layer.borderWidth = 2.0
        var nameInitial = ""
        let nameArray = data.reviewer_name.components(separatedBy: " ")
            for val in nameArray {
                nameInitial += (val.first?.description) ?? ""
            }
        reviewInitials.text = nameInitial.uppercased()
        reviewInitials.font = mageFont.boldFont(size: 20.0)
        self.name.text = data.reviewer_name
        date.text = data.review_date
        ratingText.text = data.content
        ratingView.rating = Double(data.rating) ?? 0.0
        ratingView.text = data.rating
        reviewTitle.text = data.review_title
        name.font=mageFont.regularFont(size: 15.0)
        date.font=mageFont.regularFont(size: 15.0)
        ratingText.font=mageFont.regularFont(size: 15.0)
        reviewTitle.font=mageFont.regularFont(size: 15.0)
    }
    
    func setJudgeMeReviewData(data:Review) {
        reviewInitials.layer.cornerRadius = 30.0
        reviewInitials.layer.borderColor = UIColor.black.cgColor
        reviewInitials.layer.borderWidth = 2.0
        var nameInitial = ""
        let nameArray = data.reviewer.name.components(separatedBy: " ")
        for val in nameArray {
            nameInitial += (val.first?.description) ?? ""
        }
        reviewInitials.text = nameInitial.uppercased()
        reviewInitials.font = mageFont.boldFont(size: 20.0)
        self.name.text = data.reviewer.name
        date.text = data.updated_at
        ratingText.text = data.body
        ratingView.rating = Double(data.rating ?? 0)// ?? 0.0
        ratingView.text = data.rating?.description
        reviewTitle.text = data.title
        name.font=mageFont.regularFont(size: 15.0)
        date.font=mageFont.regularFont(size: 15.0)
        ratingText.font=mageFont.regularFont(size: 15.0)
        reviewTitle.font=mageFont.regularFont(size: 15.0)
    }
    
    
    func setAliReview(data:AliReviewData) {
        reviewInitials.layer.cornerRadius = 30.0
        reviewInitials.layer.borderColor = UIColor.black.cgColor
        reviewInitials.layer.borderWidth = 2.0
        var nameInitial = ""
        let nameArray = data.author.components(separatedBy: " ")
        for val in nameArray {
            if let desc = val.first?.description{
                nameInitial += desc
            }
            
        }
        reviewInitials.text = nameInitial.uppercased()
        reviewInitials.font = mageFont.boldFont(size: 20.0)
        self.name.text = data.author
        date.text = data.created_at
        ratingText.text = data.content
        ratingView.rating = Double(data.star) ?? 0.0
        ratingView.text = data.star
        reviewTitle.text = ""
        name.font=mageFont.regularFont(size: 15.0)
        date.font=mageFont.regularFont(size: 15.0)
        ratingText.font=mageFont.regularFont(size: 15.0)
        reviewTitle.font=mageFont.regularFont(size: 15.0)
    }
    
}
