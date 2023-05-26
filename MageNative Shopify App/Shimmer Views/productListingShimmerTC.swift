//
//  productListingShimmerTC.swift
//  MageNative Magento Platinum
//
//  Created by Cedcoss on 15/02/22.
//  Copyright © 2022 CEDCOSS Technologies Private Limited. All rights reserved.
//

import UIKit

class productListingShimmerTC: UITableViewCell {

    static let reuseID = "productListingShimmerTC"
    
    var prototypeCount = 2
    
    lazy private var shimmerProductCollection: UICollectionView = { [weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .mageSystemBackground
        
        // Register the collection cells
        collectionView.register(listingShimmerCC.self, forCellWithReuseIdentifier: listingShimmerCC.reuseID)
        collectionView.delegate = self
        collectionView.dataSource = self
       
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(){
        addSubview(shimmerProductCollection)
        shimmerProductCollection.anchor(top: topAnchor, left: leadingAnchor, bottom: bottomAnchor, right: trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }

    func populate(with count:Int){
        self.prototypeCount = count
        shimmerProductCollection.reloadData()
    }
    
}

//MARK: - UICollectionView Implementation

extension productListingShimmerTC:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return prototypeCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listingShimmerCC.reuseID, for: indexPath) as! listingShimmerCC
        cell.populate()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2 - 10 , height: 265)
    }
    
}
extension UIColor {
    static var mageSystemBackground: UIColor {
        if #available(iOS 13.0, *) { return .systemBackground } else { return .white }
    }
}
