//
//  ProductReviewsCombineView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 17/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
import Cosmos
import AlgoliaSearchClient
class ProductReviewsCombineView : UIView {
    var headingColor = UIColor(light: UIColor(hexString: "#050505"),dark: UIColor.provideColor(type: .productVC).textColor)
    var productRatingBadgeData = [String:String]()
    var screenWidth = UIScreen.main.bounds.width
    var judgeMeRatingCount=String()
    lazy var mainHeading : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = headingColor
        label.text = "Ratings & Review".localized
        label.font = mageFont.mediumFont(size: 14.0)
        return label
    }()
    
    lazy var averageRatingLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.mediumFont(size: 30.0)
        label.textColor = UIColor(light: UIColor(hexString: "#143F6B"),dark: UIColor.provideColor(type: .productVC).textColor)
        //label.textAlignment = .center
        return label
    }()
    
    lazy var averageRating : CosmosView = {
        let view = CosmosView()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.settings.filledColor = UIColor(hexString: "#32C846")
        view.settings.filledBorderColor = UIColor(hexString: "#32C846")
        view.settings.emptyColor = UIColor.white
        view.settings.emptyBorderColor = UIColor(hexString: "#32C846")
        view.settings.filledBorderWidth = 1.0
        view.settings.starSize = 25.0
        view.settings.starMargin = 4
        view.settings.textFont = mageFont.regularFont(size: 15.0)
        view.settings.updateOnTouch = false
        view.settings.minTouchRating = 0.0
        return view
    }()
    
    lazy var verifiedReviewLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.mediumFont(size: 12.0)
        if Client.locale == "ar" {
            label.textAlignment = .right
        }
        else {
            label.textAlignment = .left
        }
        label.textColor = UIColor(hexString: "#383838")
        return label
    }()
    
    lazy var titleHeading : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = headingColor
        label.text = "Customer Review".localized
        label.font = mageFont.mediumFont(size: 14.0)
        return label
    }()
    
    lazy var stackView : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    
    lazy var viewAll : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("View All Review".localized, for: .normal)
        button.titleLabel?.font = mageFont.mediumFont(size: 14.0)
        if Client.locale == "ar" {
            button.contentHorizontalAlignment = .right
        }
        else {
            button.contentHorizontalAlignment = .left
        }
        button.setTitleColor(UIColor(hexString: "#2472C1"), for: .normal)
        return button
    }()
    
    lazy var writeReview : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Write a Review".localized, for: .normal)
        button.titleLabel?.font = mageFont.mediumFont(size: 14.0)
//        if Client.locale == "ar" {
//            button.contentHorizontalAlignment = .right
//        }
//        else {
//            button.contentHorizontalAlignment = .left
//        }
        button.setTitleColor(UIColor(light: UIColor(hexString: "#383838"),dark: UIColor.provideColor(type: .productVC).textColor), for: .normal)
        button.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 4.0
        
        return button
    }()
    lazy var spaceView: UIView = {
        let vw = UIView()
        if #available(iOS 13.0, *) {
            vw.backgroundColor = .secondarySystemBackground
        } else {
            vw.backgroundColor = UIColor(hexString: "#f2f2f2", alpha: 1)
        }
        return vw
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .productVC).backGroundColor)
        addSubview(mainHeading)
        addSubview(averageRatingLabel)
        addSubview(averageRating)
        addSubview(verifiedReviewLabel)
        addSubview(titleHeading)
        addSubview(stackView)
        addSubview(viewAll)
        addSubview(writeReview)
        addSubview(spaceView)
        stackView.subviews.forEach{$0.removeFromSuperview()}
        mainHeading.anchor(top: safeAreaLayoutGuide.topAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 12, paddingLeft: 10, paddingRight: 10, height: 30)
        writeReview.anchor(top: safeAreaLayoutGuide.topAnchor, right: trailingAnchor, paddingTop: 12, paddingRight: 10, width: 130, height: 40)
        averageRatingLabel.anchor(top: mainHeading.bottomAnchor, left: leadingAnchor, paddingTop: 8, paddingLeft: 10, height: 35)
        averageRating.anchor(top: mainHeading.bottomAnchor, left: averageRatingLabel.trailingAnchor , paddingTop: 8, paddingLeft: 12,width : (0.4*screenWidth) ,height: 35)
        verifiedReviewLabel.anchor(top: averageRatingLabel.bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 4, paddingLeft: 10, paddingRight: 10, height: 30)
        spaceView.anchor(top:verifiedReviewLabel.bottomAnchor,left: leadingAnchor,right: trailingAnchor,height: 5)
        titleHeading.anchor(top: spaceView.bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 4, paddingLeft: 10, paddingRight: 10, height: 35)
        stackView.anchor(top: titleHeading.bottomAnchor, left: leadingAnchor, bottom: viewAll.topAnchor, right: trailingAnchor, paddingTop: 8, paddingLeft: 10, paddingBottom: 8, paddingRight: 10)
        viewAll.anchor(top: stackView.bottomAnchor, left: leadingAnchor,bottom: safeAreaLayoutGuide.bottomAnchor,right: trailingAnchor, paddingTop: 8, paddingLeft: 10,paddingBottom: 8,  paddingRight: 8, height: 35)
       
    }
    
    func setupView(productReviews : productRatingData?) {
        stackView.subviews.forEach{$0.removeFromSuperview()}
        if productReviews?.data.reviews.count ?? 0 > 0 {
            averageRatingLabel.text = self.productRatingBadgeData["totalRating"]
            verifiedReviewLabel.text = (self.productRatingBadgeData["totalReview"] ?? "") + " Verified Review".localized
            let rating = (self.productRatingBadgeData["totalRating"] as! NSString).doubleValue
            averageRating.rating = rating
            for items in (productReviews?.data.reviews)!
            {
                let productView = ProductReviewView()
                productView.translatesAutoresizingMaskIntoConstraints = false
                productView.setReviewData(data: items)
                stackView.addArrangedSubview(productView)
                productView.heightAnchor.constraint(equalToConstant: 125).isActive = true
            }
        }
        else {
            // mainHeading.removeFromSuperview()
             averageRatingLabel.removeFromSuperview()
             averageRating.removeFromSuperview()
             verifiedReviewLabel.removeFromSuperview()
             titleHeading.removeFromSuperview()
             stackView.removeFromSuperview()
             viewAll.removeFromSuperview()
             let label = UILabel()
             label.translatesAutoresizingMaskIntoConstraints = false
             label.text =  "Sorry this product does not have any reviews".localized//"No reviews".localized
             label.font = mageFont.mediumFont(size: 12.0)
             addSubview(label)
            label.anchor(top: mainHeading.bottomAnchor, left: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: trailingAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 8, paddingRight: 8, height: 35)
         }
        
    }
    
    func setupJudgeMeReviewData(reviewData : judgeMeRatingAndReview) {
        if reviewData.reviews.count > 0 {
            verifiedReviewLabel.text = (self.judgeMeRatingCount) + " Verified Review".localized
//            var reviws=0
//            for items in self.ratingData {//reviewData.reviews {
//                let productView = ProductReviewView()
//                productView.translatesAutoresizingMaskIntoConstraints = false
//                productView.setupJudgemeData(data: items)
//               // productView.setjudgeMeReviewData(data: items)
//                stackView.addArrangedSubview(productView)
//                let rating = items["rating"].debugDescription ?? ""
//                reviws += (rating as NSString).integerValue
//                productView.heightAnchor.constraint(equalToConstant: 125).isActive = true
//            }
//
//            let avgRating = Double(reviws/(reviewData.reviews.count))
//            averageRatingLabel.text = "\(avgRating)"
//            averageRating.rating = Double(avgRating)
            
            var reviws=0
            var reviewCount=0
            for items in reviewData.reviews {
                if items.curated?.lowercased() == "ok".lowercased() && items.hidden == false{
                
                if(items.pictures.count>0){
                    let pic = (items.pictures.filter{$0.hidden == false})
                    if(pic.count>0){
                        let productView = ProductReviewView()
                        productView.translatesAutoresizingMaskIntoConstraints = false
                        productView.setjudgeMeReviewData(data: items)
                        stackView.addArrangedSubview(productView)
                        let c = items.rating ?? 0
                        print(c)
                        reviws += items.rating ?? 0
                        reviewCount += 1
                        productView.heightAnchor.constraint(equalToConstant: 230).isActive = true
                    }
                    else{
                        let productView = ProductReviewView()
                        productView.translatesAutoresizingMaskIntoConstraints = false
                        productView.setjudgeMeReviewData(data: items)
                        stackView.addArrangedSubview(productView)
                        let c = items.rating ?? 0
                        print(c)
                        reviws += items.rating ?? 0
                        reviewCount += 1
                        productView.heightAnchor.constraint(equalToConstant: 230).isActive = true
                    }
                }
                else{
                    let productView = ProductReviewView()
                    productView.translatesAutoresizingMaskIntoConstraints = false
                    productView.setjudgeMeReviewData(data: items)
                    stackView.addArrangedSubview(productView)
                    let c = items.rating ?? 0
                    print(c)
                    reviws += items.rating ?? 0
                    reviewCount += 1
                    productView.heightAnchor.constraint(equalToConstant: 125).isActive = true
                }
                
               }
            }
            if reviewCount != 0{
                let avgRating = Double(reviws/(reviewCount))//Double(reviws/(reviewData.reviews.count))
                averageRatingLabel.text = "\(avgRating)"
                averageRating.rating = Double(avgRating)
            }
            
        }
        else {
            // mainHeading.removeFromSuperview()
             averageRatingLabel.removeFromSuperview()
             averageRating.removeFromSuperview()
             verifiedReviewLabel.removeFromSuperview()
             titleHeading.removeFromSuperview()
             stackView.removeFromSuperview()
             viewAll.removeFromSuperview()
             let label = UILabel()
             label.translatesAutoresizingMaskIntoConstraints = false
             label.text =  "Sorry this product does not have any reviews".localized//"No reviews".localized
             label.font = mageFont.mediumFont(size: 12.0)
             addSubview(label)
            label.anchor(top: mainHeading.bottomAnchor, left: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: trailingAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 8, paddingRight: 8, height: 35)
         }
        
       
        
    }
    
    func setAliReview(reviewData : Alireviews) {
        if reviewData.data?.data?.count ?? 0 > 0 {
            var reviws=0
        for items in (reviewData.data?.data)! {
            let productView = ProductReviewView()
            productView.translatesAutoresizingMaskIntoConstraints = false
            productView.setAliReviewData(data: items)
            let rating = (items.star as NSString).integerValue
            reviws += rating
            stackView.addArrangedSubview(productView)
            productView.heightAnchor.constraint(equalToConstant: 125).isActive = true
        }
            let avgRating = Double(reviws/(reviewData.data?.data?.count)!)
            averageRatingLabel.text = "\(avgRating)"
            averageRating.rating = Double(avgRating)
            verifiedReviewLabel.text = "\((reviewData.data?.data?.count)!)" + " Verified Review".localized
        }
        else {
            // mainHeading.removeFromSuperview()
             averageRatingLabel.removeFromSuperview()
             averageRating.removeFromSuperview()
             verifiedReviewLabel.removeFromSuperview()
             titleHeading.removeFromSuperview()
             stackView.removeFromSuperview()
             viewAll.removeFromSuperview()
             let label = UILabel()
             label.translatesAutoresizingMaskIntoConstraints = false
             label.text =  "Sorry this product does not have any reviews".localized//"No reviews".localized
             label.font = mageFont.mediumFont(size: 12.0)
             addSubview(label)
            label.anchor(top: mainHeading.bottomAnchor, left: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: trailingAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 8, paddingRight: 8, height: 35)
         }
    }
    
    func setReviewsIOReview(data:[ReviewIOModel], averageRatings : Double) {
        stackView.subviews.forEach{$0.removeFromSuperview()}
        if data.count > 0 {
            for items in data {
                let productView = ProductReviewView()
                productView.translatesAutoresizingMaskIntoConstraints = false
                productView.setReviewIOData(data: items)
                //let rating = (items.rating! as NSString).integerValue
                stackView.addArrangedSubview(productView)
                productView.heightAnchor.constraint(equalToConstant: 125).isActive = true
            }
            averageRatingLabel.text = String(format: "%.1f", averageRatings)
            averageRating.rating = averageRatings
            verifiedReviewLabel.text = "\(data.count)" + " Verified Review".localized
            
        }
        else {
            averageRatingLabel.removeFromSuperview()
            averageRating.removeFromSuperview()
            verifiedReviewLabel.removeFromSuperview()
            titleHeading.removeFromSuperview()
            stackView.removeFromSuperview()
            viewAll.removeFromSuperview()
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text =  "Sorry this product does not have any reviews".localized//"No reviews".localized
            label.font = mageFont.mediumFont(size: 12.0)
            addSubview(label)
           label.anchor(top: mainHeading.bottomAnchor, left: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: trailingAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 8, paddingRight: 8, height: 35)
        
        }
    }
}
