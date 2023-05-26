//
//  FilterPriceCollectionCell.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 11/03/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

import TTRangeSlider

class FilterPriceCollectionCell:
    UICollectionViewCell,TTRangeSliderDelegate {
    var closureToPriceUpdate: (([String:String]) -> Void)?
    private lazy var minLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.text = "Min".localized
        label.font = mageFont.regularFont(size: 14.0)
        return label;
    }()
    
    private lazy var maxLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.text = "Max".localized
        label.font = mageFont.regularFont(size: 14.0)
        return label;
    }()
    
    var priceSlider: TTRangeSlider = TTRangeSlider()
    
    
    var parent: ProductFilterViewController?
    var filterParent : BoostCommerceFilterVC?
//    lazy var minTextfield: UITextField = {
//        let textfield = UITextField()
//        textfield.translatesAutoresizingMaskIntoConstraints = false;
//        textfield.borderStyle = .line
//        textfield.keyboardType = .decimalPad
//        return textfield;
//    }()
//    lazy var maxTextfield: UITextField = {
//        let textfield = UITextField()
//        textfield.translatesAutoresizingMaskIntoConstraints = false;
//        textfield.borderStyle = .line
//        textfield.keyboardType = .decimalPad
//        return textfield;
//    }()
//
//    private lazy var topStack: UIStackView = {
//        let stack = UIStackView()
//        stack.translatesAutoresizingMaskIntoConstraints = false;
//        stack.distribution = .fillEqually
//        return stack;
//    }()
//
//    private lazy var bottomStack: UIStackView = {
//        let stack = UIStackView()
//        stack.translatesAutoresizingMaskIntoConstraints = false;
//        stack.distribution = .fillEqually
//        return stack;
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func initView(){
        self.isMultipleTouchEnabled = true
        self.backgroundColor = .clear
        addSubview(priceSlider)
        addSubview(minLabel)
        addSubview(maxLabel)
        priceSlider.translatesAutoresizingMaskIntoConstraints = false;
        isMultipleTouchEnabled = true
        priceSlider.delegate = self;
        priceSlider.tintColor = UIColor.AppTheme()
        priceSlider.tintColorBetweenHandles = UIColor.AppTheme()
        NSLayoutConstraint.activate([
            priceSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            priceSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            priceSlider.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            //priceSlider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            minLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            minLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            maxLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            maxLabel.topAnchor.constraint(equalTo: minLabel.topAnchor)
        ])
    }
    
    func configure(filter: AvailableFilterValuesViewModel, selectedPrice: [String:String]){
        if let input = filter.input.toJSON() as? [String:AnyObject]{
            if let price = input["price"] as? [String:Double]{
                priceSlider.minValue = Float("\(price["min"]!)")!
                priceSlider.maxValue = Float("\(price["max"]!)")!
                priceSlider.selectedMinimum = Float("\(price["min"]!)")!
                priceSlider.selectedMaximum = Float("\(price["max"]!)")!
                
            }
        }
        if(!selectedPrice.isEmpty){
            priceSlider.selectedMinimum = Float(selectedPrice["min"]!)!
            priceSlider.selectedMaximum = Float(selectedPrice["max"]!)!
        }
        
    }
    func configureBC(filter: PriceRange, selectedPrice: [String:String]){
        //if let input = filter.input.toJSON() as? [String:AnyObject]{
           // if let price = filter as? [String:Double]{
        priceSlider.minValue = Float("\(filter.min)")!
        priceSlider.maxValue = Float("\(filter.max)")!
                priceSlider.selectedMinimum = Float("\(filter.min)")!
                priceSlider.selectedMaximum = Float("\(filter.max)")!
                
          //  }
        //}
        if(!selectedPrice.isEmpty){
            priceSlider.selectedMinimum = Float(selectedPrice["min"]!)!
            priceSlider.selectedMaximum = Float(selectedPrice["max"]!)!
        }
        
    }
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        if customAppSettings.sharedInstance.boostCommerceFilterEnabled{
            filterParent?.selectedprice["min"] = "\(selectedMinimum)"
            filterParent?.selectedprice["max"] = "\(selectedMaximum)"
            self.closureToPriceUpdate?(filterParent?.selectedprice ?? [:])
            
        }else{
            parent?.selectedprice["min"] = "\(selectedMinimum)"
            parent?.selectedprice["max"] = "\(selectedMaximum)"
            self.closureToPriceUpdate?(parent?.selectedprice ?? [:])
        }
    }



}
