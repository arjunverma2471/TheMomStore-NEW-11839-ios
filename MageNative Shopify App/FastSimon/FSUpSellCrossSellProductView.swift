//
//  FSUpSellCrossSellProductView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 14/07/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit

class FSUpSellCrossSellProductView : UIView {
    
    var recommendedProducts = [ProductViewModel]()
    var delegate:productClicked?
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.mediumFont(size: 16.0)
        label.text = "Fast Simon".localized
        label.textColor = UIColor(light: UIColor.init(hexString: "#050505"),dark: UIColor.provideColor(type: .productVC).textColor)
        return label
    }()
    
    lazy var productCollection : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 8, left: 5, bottom: 5 , right: 5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .productVC).collectionViewBackgroundColor)
        collectionView.translatesAutoresizingMaskIntoConstraints = false;
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FastSimonProductDetailCVCell.self, forCellWithReuseIdentifier: FastSimonProductDetailCVCell.className)
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
        titleLabel.anchor(top: safeAreaLayoutGuide.topAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8, height: 35)
        productCollection.anchor(top: titleLabel.bottomAnchor, left: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: trailingAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
    }
}

extension FSUpSellCrossSellProductView : UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendedProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:FastSimonProductDetailCVCell.className, for: indexPath) as! FastSimonProductDetailCVCell
        cell.setupView(model: (recommendedProducts[indexPath.row]))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      if  UIDevice.current.model.lowercased() == "ipad".lowercased() {
          //return collectionView.calculateHalfCellSize(numberOfColumns: 3.1)
          return collectionView.calculateHalfCellSize(numberOfColumns: 5.1)
      }
        return collectionView.calculateHalfCellSize(numberOfColumns: 2.3, of : 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.productCellClicked(product: (recommendedProducts[indexPath.row].model?.viewModel)!, sender: self)
    }
}
