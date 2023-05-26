//
//  ProductHeaderView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 12/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
import AVKit
class ProductHeaderView : UIView {
   
    lazy var imageCollection : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0 , right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false;
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .productVC).collectionViewBackgroundColor)
        collectionView.semanticContentAttribute = Client.locale == "ar" ? .forceRightToLeft : .forceLeftToRight
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.register(ProductHeaderImageCollectionCell.self, forCellWithReuseIdentifier: ProductHeaderImageCollectionCell.className)
        collectionView.register(ProductHeaderVideoCollectionCell.self, forCellWithReuseIdentifier: ProductHeaderVideoCollectionCell.className)
        return collectionView
    }()
    
    lazy var pageControl : UIPageControl = {
        let control = UIPageControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            control.backgroundColor = UIColor(light: UIColor.secondarySystemBackground, dark: .black)
        } else {
            // Fallback on earlier versions
        }
        control.pageIndicatorTintColor = UIColor(hexString: "#D1D1D1")
        control.currentPageIndicatorTintColor = UIColor(hexString: "#6B6B6B")
        return control
    }()
    
    lazy var shareButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "productShare"), for: .normal)
        return button
    }()
    
    lazy var rotateButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "360view"), for: .normal)
        return button
    }()
    
    lazy var arButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "AR"), for: .normal)
        button.isHidden = false
        return button
    }()
    lazy var virtualButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "AR"), for: .normal)
        button.isHidden = false
        return button
    }()
  lazy var wishlistButton : UIButton = {
      let button = UIButton()
      button.translatesAutoresizingMaskIntoConstraints = false
      button.setImage(UIImage(named: "heartEmpty"), for: .normal)
      button.isHidden = false
    //  button.backgroundColor = UIColor.viewBackgroundColor()
//      button.layer.cornerRadius = 15
//      button.layer.borderWidth = 0.8
//      button.layer.borderColor = UIColor(hexString: "#d1d1d1", alpha: 1).cgColor
      return button
  }()
  
    
    lazy var sizeChart : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "sizeChart"), for: .normal)
        return button
    }()
    
    
    
    lazy var outOfStockLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Out of Stock".localized
        label.textAlignment = .center
        label.font = mageFont.mediumFont(size: 13.0)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor(hexString: "#F55353").withAlphaComponent(0.7)
        label.isHidden = true
        return label
    }()
    
    var delegate : productHeaderDelegate?
    
    
    
    // MARK:- Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var imagesArray = [String]()
    var productMediaData = [ProductMediaViewModel]()
    var productMedia : [ProductMediaViewModel]? {
      didSet {
        productMediaData = [ProductMediaViewModel]()
        guard let productVideoData = productMedia else {return}
        for val in productVideoData {
          if val.type != .model3d {
            self.productMediaData.append(val)
          }
          else {
            if customAppSettings.sharedInstance.augmentedReality {
              self.arButton.isHidden=false
            }
          }
        }
          //imagesArray = productMediaData.map{$0.imageUrl}
        pageControl.numberOfPages = productMediaData.count
        self.imageCollection.reloadData()
      }
    }
    
    
    
    
    func initView() {
        addSubview(imageCollection)
        addSubview(pageControl)
        addSubview(outOfStockLabel)
        addSubview(shareButton)
        addSubview(rotateButton)
//        addSubview(wishlistButton)
        addSubview(arButton)
        addSubview(sizeChart)
        addSubview(virtualButton)
        
        let height = UIScreen.main.bounds.height
        imageCollection.anchor(top: safeAreaLayoutGuide.topAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: (height*0.7))
        pageControl.anchor(top: imageCollection.bottomAnchor, left: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: trailingAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, height: 15)
        rotateButton.anchor(bottom: imageCollection.bottomAnchor, right: shareButton.leadingAnchor, paddingBottom: 10, paddingRight: 12, width: 50, height: 30)
//       wishlistButton.anchor(top: imageCollection.topAnchor, right: trailingAnchor, paddingTop: 8, paddingRight: 8, width: 0, height: 0)
      
        arButton.anchor(top: imageCollection.topAnchor, right: trailingAnchor, paddingTop: 8, paddingRight: 8, width: 30, height: 30)
        virtualButton.anchor(top: arButton.bottomAnchor, right: trailingAnchor, paddingTop: 8, paddingRight: 8, width: 30, height: 30)
        shareButton.anchor(bottom: imageCollection.bottomAnchor, right: trailingAnchor, paddingBottom: 10, paddingRight: 8, width: 35, height: 35)
        outOfStockLabel.anchor(left: leadingAnchor, bottom: imageCollection.bottomAnchor, right: trailingAnchor, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, height: 35)
        sizeChart.anchor(left: leadingAnchor, bottom: imageCollection.bottomAnchor, paddingLeft: 8, paddingBottom: 4, width: 30, height: 30)
    }
    
}
extension ProductHeaderView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productMediaData.count+imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.row<productMediaData.count){
            if productMediaData[indexPath.row].type == .image {
                let cell       = collectionView.dequeueReusableCell(withReuseIdentifier: ProductHeaderImageCollectionCell.className, for: indexPath) as! ProductHeaderImageCollectionCell
                cell.productImage.setImageFrom(productMediaData[indexPath.row].imageUrl.getURL())
              return cell
            }
            else if productMediaData[indexPath.row].type == .externalVideo {
              
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductHeaderVideoCollectionCell.className, for: indexPath) as! ProductHeaderVideoCollectionCell
              
              let videoUrl = productMediaData[indexPath.row].embeddedUrlExternalVideo
                if let id = videoUrl.components(separatedBy: "/").last {
                  cell.productVideo.load(withVideoId: id, playerVars: [  "autoplay"     : 0,
                                                                        "playsinline"  : 0,
                                                                        "controls"     : "1",
                                                                        "showinfo"     : "0",
                                                                        "origin"       : "http://www.youtube.com"])
                }
                cell.productVideo.clipsToBounds=true
              
              return cell
            }
            else if productMediaData[indexPath.row].type == .video {
                let cell       = collectionView.dequeueReusableCell(withReuseIdentifier: ProductHeaderImageCollectionCell.className, for: indexPath) as! ProductHeaderImageCollectionCell
              
                cell.productImage.setImageFrom(productMediaData[indexPath.row].videoPreviewImage.getURL())
              
              return cell
            }
        }
        else{
            let cell       = collectionView.dequeueReusableCell(withReuseIdentifier: ProductHeaderImageCollectionCell.className, for: indexPath) as! ProductHeaderImageCollectionCell
            cell.productImage.setImageFrom(imagesArray[indexPath.row-productMediaData.count].getURL())
          return cell
        }
        
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.row<productMediaData.count){
            if productMediaData[indexPath.row].type == .image {
                delegate?.productImageClicked(position: indexPath.row, image: "")
            }
            else if productMediaData[indexPath.row].type == .video {
                if let videoUrl = productMedia?[indexPath.row].videoUrl.getURL() {
                    delegate?.productVideoClicked(url: videoUrl)
                }
            }
        }
        else{
            delegate?.productImageClicked(position: indexPath.row, image: imagesArray[indexPath.row-productMediaData.count])
        }
        
    }
    
    @objc func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
      pageControl.currentPage = Int(self.imageCollection.contentOffset.x) / Int(self.imageCollection.frame.size.width);
    }
    
    
}

extension ProductHeaderView : UICollectionViewDelegateFlowLayout {
            
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return collectionView.bounds.size
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
}


protocol productHeaderDelegate {
    func productImageClicked(position:Int, image: String)
    func productVideoClicked(url:URL)
}
