//
//  productRatingTableCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 16/03/21.
//  Copyright © 2021 MageNative. All rights reserved.
//
/*
import UIKit

class productRatingTableCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
  
  @IBOutlet weak var topLabel: UILabel!
  @IBOutlet weak var viewAll: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!  
  @IBOutlet weak var writeReview: UIButton!
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var noReviewLabel: UILabel!
  
  var isFromShopifyRating=true
  var show_Shimmer = false
  
  var ratingData : productRatingData? {
    didSet {
      guard let ratingData = ratingData else {return}
      pageControl.numberOfPages = ratingData.data.reviews.count
      
    }
  }
  
  var judgeRatingData:judgeMeRatingAndReview? {
    didSet {
      guard let ratingData = judgeRatingData else {return}
      pageControl.numberOfPages = ratingData.reviews.count
    }
  }
  
  var parent = UIViewController()
  
  override func awakeFromNib() {
    super.awakeFromNib()
      
    // Initialization code
  }
  
  func reloadData() {
    pageControl.pageIndicatorTintColor = UIColor.black
    pageControl.currentPageIndicatorTintColor = UIColor.AppTheme()
    collectionView.delegate=self
    collectionView.dataSource=self
    collectionView.reloadData()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if isFromShopifyRating {
      if self.ratingData?.data.reviews.count ?? 0 <= 5 {
        return self.ratingData?.data.reviews.count ?? 0
      }
      return 5
    }
    else {
      if self.judgeRatingData?.reviews.count ?? 0 <= 5 {
        return self.judgeRatingData?.reviews.count ?? 0
      }
      return 5
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productRatingCollCell", for: indexPath) as? productRatingCollCell
    cell?.ratingViewSettings()
    if isFromShopifyRating {
      if self.ratingData?.data != nil {
        if self.ratingData?.data.reviews[indexPath.row] != nil {
          cell?.setReviewData(data: (self.ratingData?.data.reviews[indexPath.row])!)
        }
      }
    }
    else {
      if self.judgeRatingData != nil {
        if self.judgeRatingData?.reviews[indexPath.row] != nil {
          cell?.setJudgeMeReviewData(data: (self.judgeRatingData?.reviews[indexPath.row])!)
        }
      }
    }
    
    return cell!
  }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            cell.setTemplateWithSubviews(show_Shimmer, viewBackgroundColor: .systemBackground)
        } else {
            cell.setTemplateWithSubviews(show_Shimmer, viewBackgroundColor: .white)
        }
    }
  
  @objc func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    pageControl.currentPage = Int(self.collectionView.contentOffset.x) / Int(self.collectionView.frame.size.width);
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.collectionView.frame.width-8, height: 200)
  }
}
*/
