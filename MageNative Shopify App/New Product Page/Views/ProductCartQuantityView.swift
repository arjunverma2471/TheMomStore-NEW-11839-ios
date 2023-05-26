//
//  ProductCartQuantityView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 18/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
class ProductCartQuantityView : UIView , UITextFieldDelegate {
    
    let screenHeight = UIScreen.main.bounds.height
    var quantityArray = ["1","2","3","4","5","6","7","8","9","10"]
    var initialSelected = 0
    var selectedQuantity = "1"
    var customQuantity = ""
    let notAllowedCharacters = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_.";
    var outOfStockCheck = false
    var selectedVariant : VariantViewModel!
    
    lazy var alphaView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(light:UIColor.black.withAlphaComponent(0.5),dark: UIColor.provideColor(type: .productVC).tintColor.withAlphaComponent(0.5))
        return view
    }()
    
    lazy var closeButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "closebtn"), for: .normal)
        return button
    }()
    
    
    lazy var mainView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(light:UIColor.white,dark: UIColor.provideColor(type: .productVC).backGroundColor)
        return view
    }()
    
    lazy var mainHeading : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select Quantity".localized
        label.font = mageFont.mediumFont(size: 14.0)
        label.textColor = UIColor(light:UIColor(hexString: "#050505"),dark: UIColor.provideColor(type: .productVC).textColor)
        return label
    }()
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0 , right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false;
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor(light:.white,dark: UIColor.provideColor(type: .productVC).collectionViewBackgroundColor)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductVariationViewCell.self, forCellWithReuseIdentifier: ProductVariationViewCell.className)
        collectionView.register(ProductQuantityTextFieldCell.self, forCellWithReuseIdentifier: ProductQuantityTextFieldCell.className)
        return collectionView
    }()
    
    lazy var addToBag : UIButton = {
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "union"), for: .normal)
        if Client.locale == "ar" {
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        }
        else {
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        }
        
        
        button.setTitle("Add To Bag".localized, for: .normal)
        button.titleLabel?.font = mageFont.mediumFont(size: 16.0)
        button.backgroundColor = UIColor.AppTheme()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData(){
        if(outOfStockCheck){
            quantityArray = ["1"]
        }
        else{
            quantityArray = ["1","2","3","4","5","6","7","8","9","10"]
        }
        collectionView.reloadData()
    }
    
    func initView() {
        
        addSubview(alphaView)
        addSubview(mainView)
        addSubview(closeButton)
        addSubview(mainHeading)
        addSubview(collectionView)
        addSubview(addToBag)
        alphaView.anchor(top: safeAreaLayoutGuide.topAnchor, left: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        mainView.anchor(left: leadingAnchor, bottom: alphaView.bottomAnchor, right: trailingAnchor, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: (0.2*screenHeight))
        closeButton.anchor(top: mainView.topAnchor, right: trailingAnchor, paddingTop: -8, paddingRight: 8, width: 30, height: 30)
        mainHeading.anchor(top: mainView.topAnchor, left: mainView.leadingAnchor, right: mainView.trailingAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 35)
        collectionView.anchor(top: mainHeading.bottomAnchor, left: mainView.leadingAnchor, right: trailingAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16, height : 60)
        addToBag.anchor(top: collectionView.bottomAnchor, left: mainView.leadingAnchor, bottom: mainView.bottomAnchor, right: mainView.trailingAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 8, paddingRight: 16, height: 45)
        
    }
    
}
extension ProductCartQuantityView : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(outOfStockCheck){
            return quantityArray.count
        }
        return quantityArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == quantityArray.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductQuantityTextFieldCell.className, for: indexPath) as! ProductQuantityTextFieldCell
            cell.textField.delegate = self
            cell.textField.text = customQuantity
            cell.textField.keyboardType = .numberPad
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductVariationViewCell.className, for: indexPath) as! ProductVariationViewCell
            cell.textLabel.text = quantityArray[indexPath.row]
            initialSelected == indexPath.row ? cell.textLabel.selectedItem() : cell.textLabel.unselectedItem()
            cell.textLabel.layer.cornerRadius = 25.0
            cell.textLabel.layer.masksToBounds = true
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == quantityArray.count {
        }
        else {
            selectedQuantity = quantityArray[indexPath.row]
            if !self.selectedVariant.currentlyNotInStock {
                       if self.selectedVariant.availableQuantity != "" {
                           let availableQuantity = Int(self.selectedVariant.availableQuantity) ?? 0
                           let selectedQty = Int(quantityArray[indexPath.row]) ?? 0
                           if Int(self.selectedVariant.availableQuantity) ?? 0 > 0  {
                               if selectedQty > availableQuantity {
                                   self.showmsg(msg: "Only \(availableQuantity) quantities left.".localized)
                                   selectedQuantity = (self.selectedVariant.availableQuantity)
                                   return;
                               }
                           }
                       }
                    }
            initialSelected = indexPath.row
            customQuantity = ""
            collectionView.reloadData()
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("INPUT TEXT===>>",textField.text ?? "")
        customQuantity = textField.text ?? ""
        if !self.selectedVariant.currentlyNotInStock {
                   if self.selectedVariant.availableQuantity != "" {
                       let availableQuantity = Int(self.selectedVariant.availableQuantity) ?? 0
                       let selectedQty = Int(customQuantity) ?? 0
                       if Int(self.selectedVariant.availableQuantity) ?? 0 > 0  {
                           if selectedQty > availableQuantity {
                               self.showmsg(msg: "Only \(availableQuantity) quantities left.".localized)
                               customQuantity = (self.selectedVariant.availableQuantity)
                               return;
                           }
                       }
                   }
        }
        
    }
    
    func textField(_ theTextField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        for i in 0..<string.count {
            let c = (string as NSString).character(at: i)
            if !NSCharacterSet(charactersIn: "0123456789").characterIsMember(c) {
                return false
            }
        }
        return true
    }
}

