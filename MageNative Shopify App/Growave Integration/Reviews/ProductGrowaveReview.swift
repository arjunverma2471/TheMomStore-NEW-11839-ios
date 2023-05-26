//
//  ProductStampedReview.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 16/09/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation

import UIKit
import Cosmos

class ProductGrowaveReview: UIView {
    let feraViewModel = FeraViewModel()
    @IBOutlet weak var starRating: CosmosView!
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var ratingAll: UILabel!
    @IBOutlet weak var mainstack: UIStackView!
    @IBOutlet weak var loadallReview: UIButton!
    @IBOutlet weak var writeReview: UIButton!
    var feraRatings = 0
    var feraRatingsCount = 0
    var stampedReviewDetailModel: StampedReviewDetailModel?{
        didSet{
            
            if var stampedReviewDetailModel = stampedReviewDetailModel {
                
                if let rating = stampedReviewDetailModel.rating{
                    starRating.rating = Double(rating)
                }
                ratingAll.text = stampedReviewDetailModel.rating?.description
                
                
                let reviewCount = stampedReviewDetailModel.data?.count ?? 0
                if reviewCount > 0{
                    
                    _ = stampedReviewDetailModel.data?.enumerated( ).map { index,reviewData in
                        
                        let stampedReviewDetail = GrowaveReviewDetail()
                        //            stampedReviewDetail.translatesAutoresizingMaskIntoConstraints = false
                        
                        stampedReviewDetail.reviewData = reviewData
                        //            stampedReviewDetail.heightAnchor.constraint(equalToConstant: 200).isActive = true
                        self.mainstack.addArrangedSubview(stampedReviewDetail)
                        
                    }
                }
            }
        }
    }
    
    var view: UIView!
    
    override init(frame: CGRect)
    {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        setupView()
        xibSetup()
    }
    
    func setupView() {
        heading.text = "Customer Reviews".localized
        writeReview.setTitle("Write Review".localized, for: .normal)
        loadallReview.setTitle("Load all reviews".localized, for: .normal)
    }
    
    func xibSetup()
    {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        // Make the view stretch with containing view
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        writeReview.layer.cornerRadius = 5
        loadallReview.layer.cornerRadius = 5
        starRating.isUserInteractionEnabled = false
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ProductGrowaveReview", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}

extension ProductGrowaveReview {
    func setupFeraReviewView(reviews: [FeraProductReviewsData], ratings: CGFloat, ratingsCount: CGFloat) {
        starRating.rating = Double(ratings)
        ratingAll.text = "\(ratingsCount)"
        var res = 0
        if reviews.count > 0 && reviews.count > 5 {
            while res < 5 {
                showReviews(reviewData: reviews[res])
                res += 1
            }
        }
        else {
            while res < reviews.count {
                showReviews(reviewData: reviews[res])
                res += 1
            }
        }
    }
    
    private func showReviews(reviewData: FeraProductReviewsData) {
        DispatchQueue.main.async {[weak self] in
            let feraReviewDetail = GrowaveReviewDetail()
            feraReviewDetail.setupFeraReview(review: reviewData)
            self?.mainstack.addArrangedSubview(feraReviewDetail)
        }
    }
}
extension ProductGrowaveReview {
    func setupGrowaveReviewView(reviews: [GrowaveAllReviewsData], ratings: String, ratingsCount: String) {
        starRating.rating = Double(ratings) ?? 0
        ratingAll.text = ratingsCount
        var res = 0
        if reviews.count > 0 && reviews.count > 5 {
            while res < 5 {
                showGrowaveReviews(reviewData: reviews[res])
                res += 1
            }
        }
        else {
            while res < reviews.count {
                showGrowaveReviews(reviewData: reviews[res])
                res += 1
            }
        }
    }
    
    private func showGrowaveReviews(reviewData: GrowaveAllReviewsData) {
        DispatchQueue.main.async {[weak self] in
            let feraReviewDetail = GrowaveReviewDetail()
            feraReviewDetail.setupGrowaveReview(review: reviewData)
            self?.mainstack.addArrangedSubview(feraReviewDetail)
        }
    }
}
