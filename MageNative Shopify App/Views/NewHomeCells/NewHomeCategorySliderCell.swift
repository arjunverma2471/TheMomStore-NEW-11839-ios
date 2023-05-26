//
//  NewHomeCategorySliderCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 16/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class NewHomeCategorySliderCell: UITableViewCell {

  var parent: HomeViewController?
    
  @IBOutlet weak var collectionView: UICollectionView!
  
  var collectionData:HomeCollectionSliderViewModel?{
    didSet{
//      _ = collectionData?.collection?.map({ category in
//        if category["link_type"]?.description == "list_collection"{
//          viewAllButton.isHidden = true
//        }else{
//          viewAllButton.isHidden = true
//        }
//      })
    }
  }
    
  var delegate: bannerClicked?
  
  override func awakeFromNib() {
    super.awakeFromNib()
      self.selectionStyle = .none
    let lang = Client.shared.getLanguageCode().rawValue.lowercased() == "ar"
    if lang{
      collectionView.semanticContentAttribute = .forceRightToLeft
    }else{
      collectionView.semanticContentAttribute = .forceLeftToRight
    }
//      viewAllButton.isHidden = true
//    viewAllButton.titleLabel?.font = mageFont.setFont(fontWeight: "light", fontStyle: "normal", fontSize: 14)
//    viewAllButton.addTarget(self, action: #selector(goToCategories(_:)), for: .touchUpInside)
  }
  
  @objc func goToCategories(_ sender: UIButton){
    if customAppSettings.sharedInstance.showTabbar{
      self.parent?.tabBarController?.selectedIndex = 1;
    }else{
      let viewController=NewSearchVC()
      self.parent?.navigationController?.pushViewController(viewController, animated: true)
    }
  }
  
  func loadData(from model:HomeCollectionSliderViewModel){
    collectionData = model
      collectionView.backgroundColor = UIColor(light: collectionData?.panel_background_color ?? .white,dark: UIColor.provideColor(type: .newHomeCategorySliderCell).panelBackgroundColor)
    self.backgroundColor = UIColor(light: collectionData?.panel_background_color ?? .white,dark: UIColor.provideColor(type: .newHomeCategorySliderCell).panelBackgroundColor)
      
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.reloadData()
    
    let nib = UINib(nibName: NewHomeCollectionSliderCell.className, bundle: nil)
    collectionView.register(nib, forCellWithReuseIdentifier: "newcategorycollectionCell")
  }
}

extension NewHomeCategorySliderCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collectionData?.collection?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newcategorycollectionCell", for: indexPath) as! NewHomeCollectionSliderCell
     
    let collection = collectionData?.collection?[indexPath.row]
      cell.categoryTitle?.numberOfLines = 2
      cell.categoryTitle?.lineBreakMode = .byWordWrapping
    cell.categoryTitle?.textColor = UIColor(light: collectionData?.item_title_color ?? .black,dark: UIColor.provideColor(type: .newHomeCategorySliderCell).itemTitleColor)
    cell.categoryTitle.adjustsFontSizeToFitWidth = false
      
    if let imageUrl =  collection?["image_url"]?.getURL() {
        cell.categoryImage.setImageFrom(imageUrl)
    }
    
    if(!collectionData!.show_item_title){
      cell.categoryTitle?.isHidden = true;
    }
    else
    {
      cell.categoryTitle?.isHidden = false;
        cell.categoryTitle.font = mageFont.setFont(fontWeight: (collectionData?.item_font_weight)!, fontStyle: (collectionData?.item_font_style)!, fontSize: 11.0)
        cell.categoryTitle?.text = collection?["title"] ?? ""
    }
    
      switch collectionData?.type {
      case "category-circle","category-slider":
          cell.categoryImage.makeBorder(width: 1, color: collectionData?.item_border_color,radius: cell.categoryImage.frame.width/2)
      case "category-card":
          cell.heightConstant.constant = CGFloat(67)
          switch collectionData?.item_shape {
          case "rectangle":
              cell.heightConstant.constant = CGFloat(48)
              cell.categoryImage.makeBorder(width: 1, color: collectionData?.item_border_color,radius: 0)
          case "square":
              cell.categoryImage.makeBorder(width: 1, color: collectionData?.item_border_color,radius: 0)
          case "circle":
              cell.categoryImage.makeBorder(width: 1, color: collectionData?.item_border_color,radius: min(cell.categoryImage.frame.size.width, cell.categoryImage.frame.size.height) / 2)
          default:
              cell.categoryImage.makeBorder(width: 1, color: collectionData?.item_border_color,radius: 0)
          }
      default:
          cell.categoryImage.makeBorder(width: 1, color: collectionData?.item_border_color,radius: 0)
      }
      if collectionData?.cornerRadius != "0" && collectionData?.item_shape != "circle"{
          if let radius = collectionData?.cornerRadius{
              switch radius {
              case "4":
                  cell.categoryImage.makeBorder(width: 1, color: collectionData?.item_border_color,radius: 7)
              case "8":
                  cell.categoryImage.makeBorder(width: 1, color: collectionData?.item_border_color,radius: 15)
              case "12":
                  cell.categoryImage.makeBorder(width: 1, color: collectionData?.item_border_color,radius: 23)
              case "16":
                  let rad = collectionData?.item_shape == "rectangle" ? 18 : 28
                  cell.categoryImage.makeBorder(width: 1, color: collectionData?.item_border_color,radius: CGFloat(rad))
              case "20":
                  let rad = collectionData?.item_shape == "rectangle" ? 24 : cell.categoryImage.frame.height/2
                  cell.categoryImage.makeBorder(width: 1, color: collectionData?.item_border_color,radius: rad)
              default:
                  cell.categoryImage.makeBorder(width: 1, color: collectionData?.item_border_color,radius: 0)
              }
          }
      }
      
    if(collectionData?.item_border == "1")
    {
        cell.categoryImage.layer.borderColor = UIColor(light: collectionData?.item_border_color ?? .white,dark: DarkColor.darkBorderColor).cgColor
    }
    else{
      cell.categoryImage.layer.borderWidth = 0;
    }
   return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.delegate?.bannerDidSelect(banner: collectionData?.collection?[indexPath.row], sender: self)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width/5, height: collectionView.frame.height-5)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

