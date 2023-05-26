//
//  SimilarProductView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 14/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
import BottomPopup
class SimilarProductView : BottomPopupViewController {
    var delegate: SelectedProductDelegate?
    
    var height: CGFloat?
        var topCornerRadius: CGFloat?
        var presentDuration: Double?
        var dismissDuration: Double?
        var shouldDismissInteractivelty: Bool?

        
        // MARK: - BottomPopupAttributesDelegate Variables
        override var popupHeight: CGFloat { height ?? 400.0 }
    var similarProducts : Array<ProductViewModel>?
    
    
    lazy var productHeading : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.boldFont(size: 14.0)
        label.text = "Similar Products".localized
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
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SimilarProductViewCell.self, forCellWithReuseIdentifier: SimilarProductViewCell.className)
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    
    func initView() {
        view.backgroundColor = .white
        view.addSubview(productHeading)
        view.addSubview(productCollection)
        productHeading.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingTop: 12, paddingLeft: 8, paddingRight: 8, height: 35)
        productCollection.anchor(top: productHeading.bottomAnchor, left: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.trailingAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
    }
}


extension SimilarProductView : UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarProducts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:SimilarProductViewCell.className, for: indexPath) as! SimilarProductViewCell
        cell.setupView(model: (similarProducts?[indexPath.row])!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      if  UIDevice.current.model.lowercased() == "ipad".lowercased() {
          return collectionView.calculateHalfCellSize(numberOfColumns: 3.1)
      }
        return collectionView.calculateHalfCellSize(numberOfColumns: 2.3, of : 100)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = (similarProducts?[indexPath.row].model?.viewModel)!
        if let delegate = self.delegate {
            delegate.getSelectedProduct(value: product)
        }
        dismiss(animated: true, completion: nil)
      
    }
    
}
