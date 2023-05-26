//
//  SubscriptionProductView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 20/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
class SubscriptionProductView : UIView, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
  
    var product:ProductViewModel!
    var selectedIndex = 0
    var delegate : subscriptionDelegate?
    var parent : ProductVC!
    var selectedVariant : VariantViewModel?
    var selectedPlanIndex = -1
    
    lazy var headingLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Subscribe Plan".localized
        label.font = mageFont.mediumFont(size: 14.0)
        label.textColor = UIColor(light: UIColor(hexString: "#050505"),dark: UIColor.provideColor(type: .productVC).textColor)
        return label
    }()
    
    lazy var sellingGroupCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 5 , right: 5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false;
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor(light:UIColor.white,dark: UIColor.provideColor(type: .productVC).collectionViewBackgroundColor)
       collectionView.dataSource = self
        collectionView.delegate  = self
        collectionView.register(ProductVariationViewCell.self, forCellWithReuseIdentifier: ProductVariationViewCell.className)
        return collectionView
    }()
    
    lazy var sellingPlanCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 5 , right: 5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false;
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor(light:UIColor.white,dark: UIColor.provideColor(type: .productVC).collectionViewBackgroundColor)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SubscriptionProductViewCell.self, forCellWithReuseIdentifier: SubscriptionProductViewCell.className)
        return collectionView
    }()
    
    
    lazy var bottomView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            view.backgroundColor = .secondarySystemBackground
        } else {
            // Fallback on earlier versions
            view.backgroundColor = .lightGray
        }
        return view
    }()
    
    lazy var offerLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor =  UIColor(light:UIColor.black,dark: UIColor.provideColor(type: .productVC).textColor)
        label.font = mageFont.mediumFont(size: 13.0)
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true

      
        return label
    }()
    
    lazy var subscribeBtn : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Subscribe Plan".localized, for: .normal)
        button.titleLabel?.font = mageFont.mediumFont(size: 15.0)
        button.backgroundColor = UIColor.textColor()
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.AppTheme().cgColor
        button.setTitleColor(UIColor.AppTheme(), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        backgroundColor = UIColor(light:UIColor.white,dark: UIColor.provideColor(type: .productVC).backGroundColor)
        addSubview(headingLabel)
        addSubview(sellingGroupCollectionView)
        addSubview(sellingPlanCollectionView)
        addSubview(bottomView)
        bottomView.addSubview(offerLabel)
        bottomView.addSubview(subscribeBtn)
        headingLabel.anchor(top: safeAreaLayoutGuide.topAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 5, paddingLeft: 15, paddingRight: 16, height: 30)
        sellingGroupCollectionView.anchor(top: headingLabel.bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 16, height: 50)
        sellingPlanCollectionView.anchor(top: sellingGroupCollectionView.bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 16, height: 160)
        
        bottomView.anchor(top: sellingPlanCollectionView.bottomAnchor, left: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: trailingAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 8, paddingRight: 16, height: 65)
        
        offerLabel.anchor(top: bottomView.topAnchor, left: bottomView.leadingAnchor, bottom: bottomView.bottomAnchor, right: subscribeBtn.leadingAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4)
        subscribeBtn.anchor(top: bottomView.topAnchor, left: offerLabel.trailingAnchor, bottom: bottomView.bottomAnchor, right: bottomView.trailingAnchor, paddingTop: 6, paddingLeft: 6, paddingBottom: 6, paddingRight: 6, width : 170)
        
        if selectedVariant != nil {
            bottomView.isHidden = false
        }else{
            bottomView.isHidden = true
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == sellingGroupCollectionView {
            return product.sellingPlansGroups.items.count
        }
        else {
            return product.sellingPlansGroups.items[selectedIndex].sellingPlans.items.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == sellingGroupCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductVariationViewCell.className, for: indexPath) as! ProductVariationViewCell
            cell.textLabel.text = product.sellingPlansGroups.items[indexPath.row].name
            indexPath.row == selectedIndex ? cell.textLabel.selectedItem() : cell.textLabel.unselectedItem()
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubscriptionProductViewCell.className, for: indexPath) as! SubscriptionProductViewCell
            cell.textLabel.text = product.sellingPlansGroups.items[selectedIndex].sellingPlans.items[indexPath.row].name
            cell.textLabel.numberOfLines = 0
            if indexPath.row == selectedPlanIndex {
                cell.outerView.backgroundColor = UIColor(light:.AppTheme(),dark: UIColor.provideColor(type: .productVC).backGroundColor)
                cell.outerView.layer.borderColor=UIColor(light:.AppTheme(),dark: UIColor.provideColor(type: .productVC).tintColor).cgColor
                cell.imgView.isHidden=false
            }
            else {
                cell.outerView.backgroundColor = UIColor(light:UIColor.white,dark: UIColor.provideColor(type: .productVC).backGroundColor)
                cell.outerView.layer.borderColor=UIColor(light:UIColor.black,dark: UIColor.provideColor(type: .productVC).tintColor).cgColor
                cell.imgView.isHidden=true
            }
            cell.outerView.layer.borderWidth = 1.0
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == sellingGroupCollectionView {
            return CGSize(width: 180, height: 40)
        }
        else {
            return CGSize(width: 130, height: 150)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == sellingGroupCollectionView {
            selectedIndex = indexPath.row
            selectedPlanIndex = -1
            parent.sellingPlanId = ""
            sellingGroupCollectionView.reloadData()
            sellingPlanCollectionView.reloadData()
            
        }
        else {
            if let selectedVariant = selectedVariant{
                bottomView.isHidden = false
                let model = product.sellingPlansGroups.items[selectedIndex].sellingPlans.items[indexPath.row]
                let data = selectedVariant.sellingPlan.filter({ $0.id.rawValue == model.id})
                if data.count > 0 {
                    selectedPlanIndex=indexPath.row
                    delegate?.subscriptionSelected(sellingPlan : model)
                    sellingPlanCollectionView.reloadData()
                }else{
                    self.parent.view.makeToast("This selling plan is not available for current variant, please choose another.".localized)
                }
            }else{
                bottomView.isHidden = true
                self.parent.view.makeToast("This selling plan is not available for current variant, please choose another.".localized)
            }
        }
    }
}

protocol subscriptionDelegate {
    func subscriptionSelected(sellingPlan : ProductSellingPlanModel)
}
