//
//  ProductRecommendedView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 17/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
class ProductRecommendedView : UIView {
    
    var recommendedProducts = Array<ProductViewModel>()
    var delegate:productClicked?
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.regularFont(size: 14.0)
        label.text = "You May Also Like".localized
        label.textColor = UIColor(light: UIColor.init(hexString: "#050505"),dark: UIColor.provideColor(type: .productVC).textColor)
        return label
    }()
    
    lazy var productCollection : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 8, left: 5, bottom: 5 , right: 5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false;
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .productVC).collectionViewBackgroundColor)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductRecommendedViewCell.self, forCellWithReuseIdentifier: ProductRecommendedViewCell.className)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .productVC).collectionViewBackgroundColor)
        addSubview(titleLabel)
        addSubview(productCollection)
        
        titleLabel.anchor(top: safeAreaLayoutGuide.topAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 8, paddingLeft: 10, paddingRight: 10, height: 30)
        productCollection.anchor(top: titleLabel.bottomAnchor, left: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: trailingAnchor, paddingTop: 2, paddingLeft: 10, paddingBottom: 5, paddingRight: 0)
        
    }
}

extension ProductRecommendedView : UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendedProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:ProductRecommendedViewCell.className, for: indexPath) as! ProductRecommendedViewCell
        cell.setupView(model: (recommendedProducts[indexPath.row]))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
      if  UIDevice.current.model.lowercased() == "ipad".lowercased() {
          //return collectionView.calculateHalfCellSize(numberOfColumns: 3.1)
          return collectionView.calculateHalfCellSize(numberOfColumns: 5.1)
      }
        
//        let ar = CGFloat(130.0/174.0)
//        let height = (self.productCollection.bounds.width/2.3) / ar
//        return CGSize(width: self.productCollection.bounds.width / 2.3, height: height + 100)
        
        return collectionView.calculateHalfCellSize(numberOfColumns: 2.3, of :130)
        
    }
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.productCellClicked(product: (recommendedProducts[indexPath.row].model?.viewModel)!, sender: self)
    }
}
