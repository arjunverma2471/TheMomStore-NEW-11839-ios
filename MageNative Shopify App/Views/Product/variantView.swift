//
//  variantView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 21/08/19.
//  Copyright © 2019 MageNative. All rights reserved.
//

import UIKit

class variantView: UIView {
  
  @IBOutlet weak var variantTitle: UILabel!
  @IBOutlet weak var variantViewHeight: NSLayoutConstraint!
  @IBOutlet weak var variantViewOption: UIView!
  
  var view:UIView!
  
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
    view.frame = bounds
    view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
    addSubview(view)
  }
  
  func loadViewFromNib() -> UIView
  {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: "variantView", bundle: bundle)
    let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    return view
  }
}
