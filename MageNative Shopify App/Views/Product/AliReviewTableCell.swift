//
//  AliReviewTableCell.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 28/07/21.
//  Copyright © 2021 MageNative. All rights reserved.
//


//

import UIKit

class AliReviewTableCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
  
  @IBOutlet weak var topLabel: UILabel!
  @IBOutlet weak var viewAll: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var writeReview: UIButton!
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var noReviewLabel: UILabel!
  
  var isFromShopifyRating=true
  
  
    var ratingData : Alireviews? {
    didSet {
      guard let ratingData = ratingData else {return}
        pageControl.numberOfPages = ratingData.data?.data?.count ?? 0
      
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
    if self.ratingData?.data?.data?.count ?? 0 <= 5 {
      return self.ratingData?.data?.data?.count ?? 0
    }
    return 5
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productRatingCollCell", for: indexPath) as? productRatingCollCell
    cell?.ratingViewSettings()
    if self.ratingData?.data?.data?[indexPath.row] != nil {
      cell?.setAliReview(data: (self.ratingData?.data?.data?[indexPath.row])!)
    }
    
    return cell!
  }
  
  @objc func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    pageControl.currentPage = Int(self.collectionView.contentOffset.x) / Int(self.collectionView.frame.size.width);
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.collectionView.frame.width-8, height: 200)
  }
}
