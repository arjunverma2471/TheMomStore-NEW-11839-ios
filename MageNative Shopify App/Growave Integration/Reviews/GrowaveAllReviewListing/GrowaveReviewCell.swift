//
//  StampedReviewCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 16/09/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class GrowaveReviewCell: UITableViewCell {
    
    let stampedReviewDetail = GrowaveReviewDetail()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupView(){
        self.addSubview(stampedReviewDetail)
        stampedReviewDetail.translatesAutoresizingMaskIntoConstraints = false
        stampedReviewDetail.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stampedReviewDetail.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stampedReviewDetail.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stampedReviewDetail.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    var reviewData: Datum?{
        didSet{
            stampedReviewDetail.reviewData = reviewData
            setupView()
        }
    }
    
    var feraReviewData: FeraProductReviewsData? {
        didSet {
            stampedReviewDetail.setupFeraReview(review: feraReviewData)
            setupView()
        }
    }
    
    var growaveReviewData: GrowaveAllReviewsData? {
        didSet {
            stampedReviewDetail.setupGrowaveReview(review: growaveReviewData)
            setupView()
        }
    }
}
