//
//  RewardifyDashboardView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 22/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation

import UIKit

class RewardifyDashboardView: UIView {
   
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var totalAmountHeading: UILabel!
  @IBOutlet weak var totalAmountVal: UILabel!
  @IBOutlet weak var totalSpendHeading: UILabel!
  @IBOutlet weak var totalSpendVal: UILabel!
  
  var view: UIView!
    
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
        // Adding custom subview on top of our view (over any custom drawing > see note below)
      
      
//      containerView.backgroundColor = UIColor.AppTheme()
      totalAmountHeading.textColor = UIColor.textColor()
      totalAmountVal.textColor = UIColor.textColor()
      totalAmountHeading.font = mageFont.boldFont(size: 15)
      totalAmountVal.font = mageFont.boldFont(size: 13)
      
      totalSpendHeading.textColor = UIColor.textColor()
      totalSpendVal.textColor = UIColor.textColor()
      totalSpendHeading.font = mageFont.boldFont(size: 15)
      totalSpendVal.font = mageFont.boldFont(size: 13)
      
      addSubview(view)
    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "RewardifyDashboardView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
