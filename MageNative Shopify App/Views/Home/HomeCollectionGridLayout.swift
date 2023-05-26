//
//  HomeCollectionGridLayout.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 04/09/19.
//  Copyright © 2019 MageNative. All rights reserved.
//

import UIKit

protocol HomeCollectionGridLayoutUpdate {
    func updateLayoutAccordingToGrid(viewModel:HomeCollectionGridLayoutViewModel?,collection:UICollectionView?,index:IndexPath, imageSize: CGSize?, reload: Bool)
}

class HomeCollectionGridLayout: UITableViewCell {
    
    var viewModel:HomeCollectionGridLayoutViewModel?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionGridHeader: UILabel!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    var delegateLayout:HomeCollectionGridLayoutUpdate?
    var indexPath = IndexPath()
    var parent : HomeViewController!
    var delegate: bannerClicked?
    
    var imageSize = CGSize(width: 1, height: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(from model:HomeCollectionGridLayoutViewModel){
        
        self.viewModel = model
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.reloadData()
       
        collectionGridHeader.text = model.header_title_text
        collectionGridHeader.textColor =  UIColor(light: model.header_title_color ?? .black,dark: .white)
        if model.header == "1"{
            collectionGridHeader.isHidden = false
            headerHeightConstraint.constant = 40
        }else{
            collectionGridHeader.isHidden = true
            headerHeightConstraint.constant = 0
        }
        
        collectionView.backgroundColor =  UIColor(light: model.panel_background_color ?? .white,dark: UIColor.provideColor(type: .newHomeCategorySliderCell).panelBackgroundColor)
        
        self.backgroundColor =  UIColor(light: model.panel_background_color ?? .white,dark: UIColor.provideColor(type: .newHomeCategorySliderCell).panelBackgroundColor)
        
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            if(self.imageSize == CGSize(width: 1, height: 1)){
                if(model.items!.count>0){
                    if let imageUrl = model.items?.first!["image_url"]?.getURL() {
                        self.imageSize=ImageSize.shared.sizeOfImageAt(url: imageUrl) ?? CGSize(width: 1, height: 1)
                        DispatchQueue.main.async {
                            self.delegateLayout?.updateLayoutAccordingToGrid(viewModel: model, collection: self.collectionView, index: self.indexPath, imageSize: self.imageSize,reload: true)
                            self.collectionView.dataSource = self
                            self.collectionView.delegate   = self
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
        delegateLayout?.updateLayoutAccordingToGrid(viewModel: model, collection: collectionView, index: indexPath, imageSize: imageSize,reload: true)
    }
}

extension HomeCollectionGridLayout:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let itemRow = Int(viewModel?.item_rows ?? "0"), let itemInRow = Int(viewModel?.item_in_a_row ?? "0"){
            return itemRow*itemInRow
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionGridLayoutCell", for: indexPath) as? HomeCollectionSliderCell
        if let item =  viewModel?.items?[indexPath.row] {
            setupCell(cell: cell, item: item)
        }
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item =  viewModel?.items?[indexPath.row] {
            self.delegate?.bannerDidSelect(banner: item, sender: self);
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if viewModel?.item_title == "1"{
            //let rows = CGFloat(Int(viewModel?.item_rows ?? "1") ?? 1)
            //let colms = viewModel?.item_in_a_row
            //return CGSize(width: collectionView.frame.width/3-15, height: collectionView.frame.height/rows-10)// return collectionView.calculateCellSize(numberOfColumns: 3)
            var size = collectionView.calculateCellSize(numberOfColumns: 2,of: 75, imagesize: imageSize, spacing: 25)
            size.height = size.height + 30
            return size

        }else {
            //let rows = CGFloat(Int(viewModel?.item_rows ?? "1") ?? 1)
            //return CGSize(width: collectionView.frame.width/3-10, height: collectionView.frame.height/rows-10)
            //return CGSize(width: collectionView.frame.width/3-15, height: UIScreen.main.bounds.width/3)
            let size = collectionView.calculateCellSize(numberOfColumns: 2,of: 75, imagesize: imageSize, spacing: 25)
            return size;
        }
    }
}

extension HomeCollectionGridLayout
{
    
    func setupCell(cell: HomeCollectionSliderCell?, item: [String:String])
    {
        if let imageUrl = item["image_url"]?.getURL() {
            cell?.categoryImage.setImageFrom(imageUrl)
            cell?.categoryImage.backgroundColor = UIColor(light: .white, dark: .black)
            // cell?.categoryImage.contentMode = .scaleAspectFill
        }
        if viewModel?.item_title == "1"{
            cell?.categoryTitle.text = "  "+(item["title"] ?? "")+"  "
            cell?.categoryTitle.isHidden = false
            cell?.categoryTitle.font = mageFont.setFont(fontWeight: (viewModel?.item_font_weight)!, fontStyle: (viewModel?.item_font_style)!)
            cell?.categoryTitle.textColor =  UIColor(light: viewModel?.item_title_color ?? .white,dark: UIColor.provideColor(type: .newHomeCategorySliderCell).itemTitleColor)
        }else {
            cell?.categoryTitle.isHidden = true
        }
        if cell?.categoryTitleHeight != nil {
            if viewModel?.item_title == "1"{
                cell?.categoryImage.layer.masksToBounds = true // Make sure the corners are clipped
                cell?.categoryImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // Mask the top left and top right corners
                cell?.categoryTitleHeight.constant = 30
            }
            else {
                cell?.categoryTitleHeight.constant = 0
                cell?.categoryImage.layer.masksToBounds = true
            }
        }
        cell?.backgroundColor = UIColor(light: viewModel?.cell_background_color ?? .white,dark: UIColor.provideColor(type: .newHomeCategorySliderCell).panelBackgroundColor)
        //cell?.makeBorder(width: 1, color: .lightGray, radius: 5)
        if viewModel?.item_shape?.lowercased() == "square".lowercased() {
            cell?.categoryImage.layer.cornerRadius = 0
            cell?.categoryImage.clipsToBounds = true;
            //cell?.cardView()
            cell?.layer.cornerRadius = 0
        }else {
            cell?.categoryImage.layer.cornerRadius = 5
            cell?.categoryImage.clipsToBounds = true;
           
            cell?.cardView()
            cell?.layer.cornerRadius = 5
        }
        if(viewModel?.item_border != "1")
        {
            cell?.layer.borderWidth = 0;
        }else{
            cell?.layer.borderWidth = 1;
            cell?.layer.borderColor = UIColor(light: viewModel?.item_border_color ?? .white,dark: DarkColor.darkBorderColor).cgColor
            
        }
        switch viewModel?.item_text_alignment {
        case "center":
            cell?.categoryTitle.textAlignment = .center;
        case "right":
            if(Client.locale == "ar"){
                cell?.categoryTitle.textAlignment = .left;
            }
            else{
                cell?.categoryTitle.textAlignment = .right;
            }
        default:
            if(Client.locale == "ar"){
                cell?.categoryTitle.textAlignment = .right;
            }
            else{
                cell?.categoryTitle.textAlignment = .left;
            }
        }
        cell?.categoryTitle.adjustsFontSizeToFitWidth = true
    }
}
