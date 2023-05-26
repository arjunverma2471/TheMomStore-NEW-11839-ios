//
//  StampedReviewDetail.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 16/09/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation


import UIKit
import Cosmos

class GrowaveReviewDetail: UIView {
  
  var view: UIView!
  
  @IBOutlet weak var nameInitials: UILabel!
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var reviewDate: UILabel!
  @IBOutlet weak var starRating: CosmosView!
  @IBOutlet weak var reviewTitle: UILabel!
  @IBOutlet weak var reviewDesc: UILabel!
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var recommendationHeight: NSLayoutConstraint!
  
  var reviewData: Datum?{
    didSet{
      if let reviewData = reviewData {
        name.text = reviewData.author
        reviewDate.text = reviewData.reviewDate
        reviewTitle.text = reviewData.reviewTitle
        reviewDesc.text  = reviewData.reviewMessage
        nameInitials.text = reviewData.author?.first?.description
        
        
//        if reviewData.isRecommend ?? false{
//          recommendation.text = "👍 I recommend this product"
//          recommendation.isHidden = false
//          recommendationHeight.constant = 20
//        }else{
//          recommendation.isHidden = true
//          recommendationHeight.constant = 0
//        }
        
        if let rating = reviewData.reviewRating{
          starRating.rating = Double(rating)
        }
      }
    }
  }
  
  
  override init(frame: CGRect)
  {
    super.init(frame: frame)
    xibSetup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    xibSetup()
  }
  
  func xibSetup()
  {
    view = loadViewFromNib()
    
    // use bounds not frame or it'll be offset
    view.frame = bounds
    // Make the view stretch with containing view
    view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
    // Adding custom subview on top of our view (over any custom drawing > see note below)
    
    nameInitials.layer.masksToBounds = true
    nameInitials.layer.cornerRadius  = 45 * 0.5
//    starRating.settings.filledColor = UIColor(hexString: "#32C846")
//    starRating.settings.filledBorderColor = UIColor(hexString: "#32C846")
//    starRating.settings.emptyColor = UIColor.white
//    starRating.settings.emptyBorderColor = UIColor(hexString: "#32C846")
    starRating.settings.filledBorderWidth = 1.0
    starRating.settings.starSize = 15.0
    starRating.settings.starMargin = 4
    starRating.settings.textFont = mageFont.regularFont(size: 15.0)
    starRating.settings.updateOnTouch = false
    starRating.settings.minTouchRating = 0.0
    addSubview(view)
  }
  
  func loadViewFromNib() -> UIView
  {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: "GrowaveReviewDetail", bundle: bundle)
  
    // Assumes UIView is top level and only object in CustomView.xib file
    let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    return view
  }
    
    func setupFeraReview(review: FeraProductReviewsData?) {
        name.text = review?.customer?.displayName
        reviewTitle.text = review?.heading
        reviewDesc.text  = review?.body
        nameInitials.text = review?.customer?.displayName?.first?.description
        if let tempDate = review?.updatedAt {
            let date = tempDate.toDate()
            let dateString = date?.toString(withFormat: "d, MMM yyyy") ?? "N/A"
            reviewDate.text = dateString
        }
        else {
            reviewDate.text = "N/A"
        }
        if let rating = review?.rating {
          starRating.rating = Double(rating)
        }
      }
    
    func setupGrowaveReview(review: GrowaveAllReviewsData?) {
        name.text = review?.author
        reviewTitle.text = review?.title
        reviewDesc.text  = review?.body
        nameInitials.text = review?.author?.first?.description
        if let tempDate = review?.creationDate {
            let date = tempDate.toDate(withFormat: "yyyy-MM-dd HH:mm:ss")
            let dateString = date?.toString(withFormat: "d, MMM yyyy") ?? "N/A"
            reviewDate.text = dateString
        }
        else {
            reviewDate.text = "N/A"
        }
        if let rating = review?.rate {
            starRating.rating = Double(rating) ?? 0
        }
      }
}

extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ")-> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.locale = .current
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        
        return date
        
    }

}
extension Date {
    func toString(withFormat format: String = "EEEE ، d MMMM yyyy") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeZone = .current
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)
        
        return str
    }
}
