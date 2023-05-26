//
//  GrowaveWriteReview.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 16/09/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation


import UIKit
import Cosmos

class GrowaveWriteReview: UIView {
  
  var view: UIView!
  override init(frame: CGRect)
  {
    super.init(frame: frame)
    xibSetup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
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
    
    addSubview(view)
  }
  
  func loadViewFromNib() -> UIView
  {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: "GrowaveWriteReview", bundle: bundle)
  
    // Assumes UIView is top level and only object in CustomView.xib file
    let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    return view
  }
}

