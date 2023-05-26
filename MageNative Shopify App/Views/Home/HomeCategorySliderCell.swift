//
//  HomeCategorySliderCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 13/06/19.
//  Copyright © 2019 MageNative. All rights reserved.
//

import UIKit

/*protocol categoryClicked{
 func categoryDidSelect(category: [String:String]?,sender: Any)
 }*/

class HomeCategorySliderCell: UITableViewCell {
  
  @IBOutlet weak var collectionView: UICollectionView!
  var collectionData:HomeCollectionSliderViewModel?
  var delegate: bannerClicked?
    var parent : HomeViewController!
  
  //  var collections : [[String:String]]?
  override func awakeFromNib() {
    super.awakeFromNib()
    
    // Initialization code
  }
  
  func loadData(from model:HomeCollectionSliderViewModel){
    collectionData = model
      collectionView.backgroundColor = UIColor(light: (collectionData?.panel_background_color) ?? .white,dark: .black)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.reloadData()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
}

extension HomeCategorySliderCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collectionData?.collection?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categorycollectionCell", for: indexPath) as! HomeCollectionSliderCell
    
    let collection = collectionData?.collection?[indexPath.row]
    cell.categoryTitle?.textColor = collectionData?.item_title_color
    
    if let imageUrl =  collection?["image_url"]?.getURL() {
      cell.categoryImage.setImageFrom(imageUrl)
    }
    
    if(!collectionData!.show_item_title){
      cell.categoryTitle?.isHidden = true;
    }
    else
    {
      cell.categoryTitle?.isHidden = false;
      cell.categoryTitle.font = mageFont.setFont(fontWeight: (collectionData?.item_font_weight)!, fontStyle: (collectionData?.item_font_style)!)
    //  cell.categoryTitle?.text =   collection?["title"]
        let data = collection?["title"] ?? ""
            cell.categoryTitle?.text = data
    }
    
    if collectionData?.type == "category-circle" {
      cell.categoryImage.makeBorder(width: 1, color: collectionData?.item_border_color,radius: cell.categoryImage.frame.width/2)
    }
    else {
      if(collectionData?.item_shape == "rounded"){
        cell.categoryImage.makeBorder(width: 1, color: collectionData?.item_border_color,radius: 10)
      }
      else
      {
        cell.categoryImage.makeBorder(width: 1, color: collectionData?.item_border_color,radius: 0)
      }
    }
    if(collectionData?.item_border == "1")
    {
      cell.categoryImage.layer.borderColor = collectionData?.item_border_color?.cgColor
    }
    else{
      cell.categoryImage.layer.borderWidth = 0;
    }
   //   cell.categoryImage.contentMode = .scaleToFill
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.delegate?.bannerDidSelect(banner: collectionData?.collection?[indexPath.row], sender: self)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width/5, height: collectionView.frame.height-10)
  }
}
