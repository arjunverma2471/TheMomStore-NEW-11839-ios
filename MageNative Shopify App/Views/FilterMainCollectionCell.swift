//
//  FilterMainCollectionCell.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 09/03/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class FilterMainCollectionCell: UICollectionViewCell {
    private lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(light: UIColor(hexString: "#383838"),dark: UIColor.provideColor(type: .filterViewController).textColor)
        label.font = mageFont.regularFont(size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.numberOfLines = 0
        return label;
    }()
    
    lazy var selectedFilterCount : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(light: UIColor(hexString: "#6B6B6B"),dark: UIColor.provideColor(type: .filterViewController).textColor)
        label.font = mageFont.regularFont(size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.numberOfLines = 0
        return label;
    }()
    
    private lazy var borderView: UIView = {
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false;
        border.backgroundColor = UIColor.clear
        return border;
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        borderView.backgroundColor = UIColor.clear
      //  backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .filterViewController).backGroundColor)
        if customAppSettings.sharedInstance.boostCommerceFilterEnabled {
            backgroundColor = UIColor(light: .white, dark: .black)
            title.textColor = UIColor(light: .black, dark: .white)
        }
        else {
            backgroundColor = UIColor(light: UIColor(hexString: "#F2F2F2"),dark: UIColor.init(hexString: "#524e50"))
            title.textColor = UIColor(light: .black,dark: UIColor.provideColor(type: .filterViewController).textColor)
        }
        title.font = mageFont.regularFont(size: 12.0)
      //  title.textColor = UIColor(light: .black,dark: UIColor.provideColor(type: .filterViewController).textColor)
        title.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    private func initView(){
        addSubview(title)
        addSubview(borderView)
        addSubview(selectedFilterCount)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            title.leadingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: 10),
            borderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            borderView.topAnchor.constraint(equalTo: topAnchor),
            borderView.bottomAnchor.constraint(equalTo: bottomAnchor),
            borderView.widthAnchor.constraint(equalToConstant: 5),
            selectedFilterCount.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            selectedFilterCount.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            selectedFilterCount.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            selectedFilterCount.widthAnchor.constraint(equalToConstant: 20),
            title.trailingAnchor.constraint(equalTo: selectedFilterCount.leadingAnchor  , constant: -5)
        ])
    }
    
    func configure(filter: AvailableFilterViewModel, selected: Bool, selectedFilterCount:[String:Int]=[:]){
        title.text = filter.filterLabel
     //   if let count = filter.values.first?.id
        if(selected){
            if(UIColor.AppTheme() != .white){
                borderView.backgroundColor = .AppTheme()
                backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .filterViewController).backGroundColor)
                title.font = mageFont.mediumFont(size: 12.0)
                title.textColor = UIColor(light: .black, dark: .white)
            }
            else{
                backgroundColor = UIColor(light: UIColor(hexString: "#F2F2F2"),dark: UIColor.init(hexString: "#524e50"))
                title.textColor = UIColor(light: .black,dark: UIColor.provideColor(type: .filterViewController).textColor)
            }
        }
        let value = selectedFilterCount[filter.filterId] ?? 0
        self.selectedFilterCount.text = value > 0 ? "\(value)" : ""
    }
    func configureBC(filter: FilterOptions, selected: Bool){
        
        title.text = filter.label
        title.font = mageFont.regularFont(size: 14.0)
        if(selected){
            if(UIColor.AppTheme() != .white){
                backgroundColor = .AppTheme()
                title.textColor = .textColor()
            }
            else{
                backgroundColor = .white
                title.textColor = .black
            }
            
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
