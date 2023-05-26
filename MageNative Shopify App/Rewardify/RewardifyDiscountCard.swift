//
//  RewardifyDiscountCard.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 23/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation

import UIKit

class RewardifyDiscountCard: UIView {
  
  @IBOutlet weak var copyButton: UIButton!
  @IBOutlet weak var discountCodeLabel: UILabel!
  @IBOutlet weak var discountAmount: UILabel!
  
  @IBOutlet weak var container: UIView!
  
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
    
    copyButton.backgroundColor    = UIColor.AppTheme()
    copyButton.layer.cornerRadius = 5
    container.layer.cornerRadius  = 5
    copyButton.titleLabel?.font   = mageFont.mediumFont(size: 10)
    copyButton.setTitleColor(UIColor.textColor(), for: .normal)
    discountCodeLabel.font = mageFont.mediumFont(size: 13)
    discountAmount.font    = mageFont.mediumFont(size: 13)
    
    addSubview(view)
  }
  
  func loadViewFromNib() -> UIView
  {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: "RewardifyDiscountCard", bundle: bundle)
    
    // Assumes UIView is top level and only object in CustomView.xib file
    let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    return view
  }
}
