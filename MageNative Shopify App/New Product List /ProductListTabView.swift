//
//  ProductListTabView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 12/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
class ProductListTabView : UIView {
    
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var gridButton: UIButton!
    var view: UIView!
    
    @IBOutlet weak var backgroundView: UIView!
    override init(frame: CGRect)
    {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
  
    func xibSetup()
    {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        // Make the view stretch with containing view
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        sortButton.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .productGridCollectionCell).backGroundColor)
        listButton.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .productGridCollectionCell).backGroundColor)
        filterButton.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .productGridCollectionCell).backGroundColor)
        gridButton.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .productGridCollectionCell).backGroundColor)
        view.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .productGridCollectionCell).backGroundColor)
        backgroundView.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .productGridCollectionCell).backGroundColor)
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        
        addSubview(view)
        addViewToSort()
    }
    

    
    
    func addViewToSort(){
        let viewRight = UIView()
        viewRight.backgroundColor = .lightGray.withAlphaComponent(0.5)
        let viewLeft = UIView()
        viewLeft.backgroundColor = .lightGray.withAlphaComponent(0.5)
        viewRight.translatesAutoresizingMaskIntoConstraints = false
        viewLeft.translatesAutoresizingMaskIntoConstraints = false
        sortButton.addSubview(viewRight)
        sortButton.addSubview(viewLeft)
        viewRight.topAnchor.constraint(equalTo: sortButton.topAnchor, constant: 15).isActive = true
        viewRight.bottomAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: -15).isActive = true
        viewRight.trailingAnchor.constraint(equalTo: sortButton.trailingAnchor, constant: -5).isActive = true
        viewRight.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        viewLeft.topAnchor.constraint(equalTo: sortButton.topAnchor, constant: 15).isActive = true
        viewLeft.bottomAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: -15).isActive = true
        viewLeft.leadingAnchor.constraint(equalTo: sortButton.leadingAnchor, constant: -5).isActive = true
        viewLeft.widthAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ProductListTabView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    
    
}
