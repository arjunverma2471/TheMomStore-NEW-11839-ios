//
//  FilterFieldsCollectionCell.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 09/03/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit
import MobileBuySDK

class FilterFieldsCollectionCell: UICollectionViewCell {
     lazy var title: UILabel = {
        let label = UILabel()
        label.font = mageFont.regularFont(size: 12.0)
        label.translatesAutoresizingMaskIntoConstraints = false;
         label.textColor =   UIColor(light:  .init(hexString: "#383838"), dark: .white)
        return label;
    }()
    
    
    lazy var filterCount : UILabel = {
        let label = UILabel()
        label.font = mageFont.regularFont(size: 10.0)
        label.textColor = UIColor(light:.init(hexString: "#383838"), dark: .white)
        label.translatesAutoresizingMaskIntoConstraints = false;
        return label;
    }()
   
    
    lazy var filterImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false;
        image.tintColor = .AppTheme()
        return image;
    }()
    
    lazy var borderline: UIView = {
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false;
        border.backgroundColor = .black
        return border;
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    private func initView(){
        self.backgroundColor = .clear
        addSubview(title)
        addSubview(filterImageView)
        addSubview(borderline)
        addSubview(filterCount)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            title.leadingAnchor.constraint(equalTo: filterImageView.trailingAnchor, constant: 10),
            filterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            filterImageView.heightAnchor.constraint(equalToConstant: 30),
            filterImageView.widthAnchor.constraint(equalTo: filterImageView.heightAnchor),
            filterImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            borderline.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1),
            borderline.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            borderline.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            filterCount.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            filterCount.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            filterCount.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            filterCount.widthAnchor.constraint(equalToConstant: 20),title.trailingAnchor.constraint(equalTo: filterCount.leadingAnchor, constant: -2)
            
        ])
        
    }
    
    func configure(filter: AvailableFilterValuesViewModel, selectedFilters: [String]){
        title.text = filter.label
        filterCount.text = "\(filter.count)"
        if(selectedFilters.contains(filter.input)){
            filterImageView.image = UIImage(named: "check")
            filterImageView.tintColor = .AppTheme()
            
        }
        else{
            filterImageView.image = UIImage(named: "unchecked")
            filterImageView.tintColor = UIColor(hexString: "#9E9E9E")
        }
    }
    
    func configurePrice(data:[Double], selectedPrice : [Double]) {
        if let first = data.first, let last = data.last {
           // title.text = "\(first)" + " - " + "\(last)"
            let decFirst = Decimal(string: first.description) ?? 0.0
            let decSecond = Decimal(string: last.description) ?? 0.0
            title.text = Currency.stringFrom(decFirst) + " - " + Currency.stringFrom(decSecond)
            filterCount.text = ""
            if selectedPrice.contains(first) && selectedPrice.contains(last) {
                filterImageView.image = UIImage(named: "check")
                filterImageView.tintColor = .AppTheme()
            }
            else{
                filterImageView.image = UIImage(named: "unchecked")
                filterImageView.tintColor = UIColor(hexString: "#9E9E9E")
            }
        }
        
        
    }
    func configureBC(data: OptionItemValues, index : Int, selectedFilters: [String]){
        // title.text = filter.key + "(\(filter.doc_count))"
         //if let dat = data.values as? [OptionItemValues] {
       
         title.text = data.key + "(\(data.doc_count))"
         if(selectedFilters.contains(data.key)){
                 filterImageView.image = UIImage(named: "check")
             }
             else{
                 filterImageView.image = UIImage(named: "unchecked")
             }
         //}
         
         
     }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
