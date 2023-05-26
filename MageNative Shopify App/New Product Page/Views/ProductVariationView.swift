//
//  ProductVariationView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 18/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
import MobileBuySDK
import SwiftUI
class ProductVariationView : UIView {
    var option : MobileBuySDK.Storefront.ProductOption!
    var selectedVariant: VariantViewModel?{
      didSet{
          selectedVariant?.selectedOptions.forEach { data in
          let dict = [data.name:data.value]
          VariantSelectionManager.shared.setUserSelectedVariants(dict)
        }
      }
    }
    lazy var productHeading : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.regularFont(size: 14.0)
        return label
    }()
    
    lazy var collectionView : UICollectionView = {
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
        collectionView.register(ProductVariationViewCell.self, forCellWithReuseIdentifier: ProductVariationViewCell.className)
        return collectionView
    }()
    
    //Add DropDown
    lazy var dropDownBtn: UIButton = {
        let dropBtn = UIButton()
        dropBtn.translatesAutoresizingMaskIntoConstraints = false;
        //dropBtn.backgroundColor = .blue
        dropBtn.layer.cornerRadius = 2
        dropBtn.layer.borderColor = UIColor.black.cgColor
        dropBtn.layer.borderWidth = 0.5
        dropBtn.addTarget(self, action: #selector(showVariants(_:)), for: .touchUpInside)
        dropBtn.setTitleColor(.black, for: .normal)
        dropBtn.titleLabel?.font = mageFont.mediumFont(size: 14.0)
        dropBtn.contentHorizontalAlignment = .left
        dropBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return dropBtn
    }()
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .productVC).backGroundColor)
        addSubview(productHeading)
       addSubview(collectionView)
        productHeading.anchor(top: safeAreaLayoutGuide.topAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 12, paddingLeft: 10, paddingRight: 16, height: 35)
        collectionView.anchor(top: productHeading.bottomAnchor, left: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: trailingAnchor, paddingTop: 4, paddingLeft: 10, paddingBottom: 4, paddingRight: 10)
        
        
        //Start-->New Code
        addSubview(dropDownBtn)
        dropDownBtn.anchor(top: productHeading.bottomAnchor, left: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: trailingAnchor, paddingTop: 4, paddingLeft: 16, paddingBottom: 4, paddingRight: 16)
        if customAppSettings.sharedInstance.isDropDownVariant{
            collectionView.isHidden = true
            dropDownBtn.isHidden = false
        }
        else{
            collectionView.isHidden = false
            dropDownBtn.isHidden = true
        }
        //End-->New Code
        
    }
    
    @objc func showVariants(_ sender : UIButton) {
        let dropDown = DropDown(anchorView: sender)
        var dataSource = [String]()
        dataSource = option.values
        dropDown.dataSource = dataSource
        dropDown.selectionAction = {[unowned self](index, item) in
            sender.setTitle(item, for: UIControl.State());
            self.dropDownBtn.titleLabel?.text = item
            guard let itemVal = option?.values[index], let itemName = option?.name else {return}
            let dict = [itemName:itemVal]
            VariantSelectionManager.shared.setUserSelectedVariants(dict)
        }
        
        dropDown.bottomOffset = CGPoint(x: 0, y:sender.bounds.height)
        if dropDown.isHidden {
            dropDown.setAlignment(dropDown)
            let _ = dropDown.show();
        } else {
            dropDown.hide();
        }
    }
    func setupView() {
        productHeading.text = option.name
        dropDownBtn.setTitle(option.values.first, for: .normal)
        
    }
    
    
}
extension ProductVariationView : UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return option.values.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductVariationViewCell.className, for: indexPath) as! ProductVariationViewCell
        cell.textLabel.text = option.values[indexPath.row]
        cell.textLabel.font = mageFont.regularFont(size: 12)
        
        VariantSelectionManager.shared.userSelectedVariants[option!.name] == option?.values[indexPath.row] ? cell.textLabel.selectedItem() : cell.textLabel.unselectedItem()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 90, height: 35)
        let widthString = NSString(string: option.values[indexPath.row])
               let width = widthString.size(withAttributes: [.font: mageFont.regularFont(size: 17)]).width
               return CGSize(width: width + 15, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let itemVal = option?.values[indexPath.row], let itemName = option?.name else {return}
        let dict = [itemName:itemVal]
        VariantSelectionManager.shared.setUserSelectedVariants(dict)
        collectionView.reloadData()
    }
}
