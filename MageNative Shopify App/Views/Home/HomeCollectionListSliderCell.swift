//
//  HomeCollectionListSliderCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 06/09/19.
//  Copyright © 2019 MageNative. All rights reserved.
//

import UIKit
import SwiftUI


protocol CollectionSliderDelegateLayout{
    func updateLayoutAccordingToCollection(collection:UICollectionView?, productsArray: HomeCollectionListSliderViewModel!, componentName: String,index:Int)
}

class HomeCollectionListSliderCell: UITableViewCell {
  
  @IBOutlet weak var actionButtonView: UIView!
  @IBOutlet weak var headerStackView: UIStackView!
  
  @IBOutlet weak var bottomHeaderSpaceView: UIView!
  @IBOutlet weak var topHeaderSpaceView: UIView!
  @IBOutlet weak var actionButton: UIButton!
  @IBOutlet weak var subTitleLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var headerView: UIView!
    
  var delegate: bannerClicked?
  
//  @IBOutlet weak var dealLabel: UILabel!
  var componentName = ""
//  @IBOutlet weak var dealImage: UIImageView!
  var sliderDelegate: CollectionSliderDelegateLayout?
    var index = 0
  
    var collectionData:HomeCollectionListSliderViewModel?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    var parent : HomeViewController!
  
//    var imageSize: CGSize = CGSize(width: 1, height: 1)
    
  override func awakeFromNib() {
    super.awakeFromNib()
      collectionView.delegate = self
      collectionView.dataSource = self
  }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
  
    func loadData(from viewModel:HomeCollectionListSliderViewModel){

        collectionData = viewModel
        
        self.sliderDelegate?.updateLayoutAccordingToCollection(collection: collectionView, productsArray: collectionData!, componentName: componentName, index: index)
        
        collectionView.backgroundColor = UIColor(light: collectionData?.panel_background_color ?? .white,dark: UIColor.provideColor(type: .newHomeCategorySliderCell).panelBackgroundColor)
        headerView.backgroundColor     = UIColor(light: collectionData?.panel_background_color ?? .white,dark: UIColor.provideColor(type: .newHomeCategorySliderCell).panelBackgroundColor)
        
        
        if(viewModel.header == "1")
        {
            self.titleLabel.textColor = UIColor(light: viewModel.header_title_color ?? .white,dark: UIColor.provideColor(type: .newHomeCategorySliderCell).itemTitleColor)
            
            titleLabel.text = viewModel.header_text
            if(Client.locale == "ar"){
                titleLabel.textAlignment = .right
                subTitleLabel.textAlignment = .right
            }
            else
            {
                titleLabel.textAlignment = .left
                subTitleLabel.textAlignment = .left
            }
            self.titleLabel.font = mageFont.setFont(fontWeight: (viewModel.item_header_font_weight)!, fontStyle: (viewModel.item_header_font_style)!, fontSize: 15.0)
            self.headerStackView.isHidden = false;
            topHeaderSpaceView.isHidden = false;
            bottomHeaderSpaceView.isHidden = false;
            self.headerView.isHidden = false;
            self.headerView.backgroundColor = UIColor(light: viewModel.header_background_color ?? .white,dark: UIColor.provideColor(type: .newHomeCategorySliderCell).panelBackgroundColor)
            self.titleLabel.isHidden = false;
            if(viewModel.header_subtitle != "1"){
                self.subTitleLabel.isHidden = true;
            }
            else
            {
                self.subTitleLabel.isHidden = false;
                self.subTitleLabel.textColor = UIColor(light: viewModel.header_subtitle_color ?? .white,dark: UIColor.provideColor(type: .newHomeCategorySliderCell).itemTitleColor)
                let data = viewModel.header_subtitle_text ?? ""
                self.subTitleLabel.text = data
                self.subTitleLabel.font = mageFont.setFont(fontWeight: (viewModel.header_subtitle_font_weight)!, fontStyle: (viewModel.header_subtitle_title_font_style)!, fontSize: 14.0)
            }
        }
        else
        {
            topHeaderSpaceView.isHidden = true;
            bottomHeaderSpaceView.isHidden = true;
            self.titleLabel.isHidden = true;
            self.headerStackView.isHidden = true;
            self.subTitleLabel.isHidden = true
            self.headerView.isHidden = true;
        }
      
        collectionView.reloadData()
    }
}

extension HomeCollectionListSliderCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collectionData?.items?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionSliderCell", for: indexPath) as! HomeCollectionSliderCell
    let collection = collectionData?.items?[indexPath.row]
   // cell.categoryTitle?.text =   collection?["title"]
      let data = collection?["title"] ?? ""
      cell.categoryTitle.text = data
      
    cell.categoryTitle.font = mageFont.setFont(fontWeight: (collectionData?.item_title_font_weight)!, fontStyle: (collectionData?.item_title_font_style)!)
    switch collectionData?.item_text_alignment {
    case "center":
      cell.categoryTitle.textAlignment = .center
    case "right":
        cell.categoryTitle.textAlignment = Client.locale == "ar" ? .left : .right
      
    default:
        cell.categoryTitle.textAlignment = Client.locale == "ar" ? .right : .left
    }
    if let imageUrl =  collection?["image_url"]?.getURL() {
      cell.categoryImage.setImageFrom(imageUrl)
    }
    if(collectionData?.item_border == "1"){
        cell.categoryImage.makeBorder(width: 1, color: UIColor(light: collectionData?.item_border_color ?? .black, dark: DarkColor.darkBorderColor) ,radius: 0)
    }
    else{
      cell.categoryImage.makeBorder(width: 0, color: collectionData?.item_border_color,radius: 0)
    }
    
    if collectionData?.item_shape?.lowercased() == "square".lowercased() {
      cell.layer.cornerRadius = 0.0
    }
    else {
      cell.layer.cornerRadius = 10.0
    }
      cell.categoryImage.contentMode = .scaleToFill
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.delegate?.bannerDidSelect(banner: collectionData?.items?[indexPath.row], sender: self)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//      return collectionView.calculateHalfCellSize(numberOfColumns: 2.2, imagesize: imageSize)
   
    return CGSize(width: self.collectionView.frame.width/2.3, height: self.collectionView.frame.height - 5)
  }
  
}
