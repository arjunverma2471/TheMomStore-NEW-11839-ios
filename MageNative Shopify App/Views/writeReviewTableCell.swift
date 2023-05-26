//
//  writeReviewTableCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 03/05/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import UIKit
import Cosmos

class writeReviewTableCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
 
   // @IBOutlet weak var topSpace: NSLayoutConstraint!
    @IBOutlet weak var titleTextLabel: UILabel!
    
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var writeTeviewTxt: UILabel!
    
    @IBOutlet weak var selectRatingTxt: UILabel!
    
    @IBOutlet weak var fillDetailsTxt: UILabel!
    @IBOutlet weak var outerView: UIView!
  
    @IBOutlet weak var txtLabel: UILabel!
    @IBOutlet weak var addImageHeight: NSLayoutConstraint!
  @IBOutlet weak var addImageBtn: UIButton!
  
  @IBOutlet weak var submiteBtn: Button!
  @IBOutlet weak var collectionView: UICollectionView!
  
  @IBOutlet weak var reviewText: UITextView!
  @IBOutlet weak var title: UITextField!
  
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var name: UITextField!
  @IBOutlet weak var ratineView: CosmosView!
  
  var collectionImages = [String]()
  
  override func awakeFromNib() {
    super.awakeFromNib()
      name.placeholder = "Name".localized
      email.placeholder = "Email".localized
      title.placeholder = "Title".localized
      titleTextLabel.text = "Name displayed publicly like".localized
    // Initialization code
      if(Client.locale == "ar"){
          name.textAlignment = .right
          email.textAlignment = .right
          title.textAlignment = .right
      }else{
          name.textAlignment = .left
          email.textAlignment = .left
          title.textAlignment = .left
      }
      titleButton.semanticContentAttribute = Client.locale == "ar" ? .forceRightToLeft : .forceLeftToRight
      titleButton.contentHorizontalAlignment = Client.locale == "ar" ? .right : .left
  }
  
  func relaodData() {
    self.collectionView.delegate=self
    self.collectionView.dataSource=self
    self.collectionView.reloadData()
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    self.collectionImages.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath) as? writeReviewImagesCollCell
    return cell!
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width/2.5, height: 130)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
}
