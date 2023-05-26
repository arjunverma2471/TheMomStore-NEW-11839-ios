//
//  GrowaveTierView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 27/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
class GrowaveTierView : UIView {
    
    @IBOutlet weak var subHeading: UILabel!
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var imgView: UIImageView!
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
        
        
        addSubview(view)
          self.setView()
      }
    
    func setView() {
        heading.font = mageFont.mediumFont(size: 12.0)
        subHeading.font = mageFont.regularFont(size: 12.0)
        subHeading.numberOfLines = 0
    }
  
      func loadViewFromNib() -> UIView
      {
          let bundle = Bundle(for: type(of: self))
          let nib = UINib(nibName: "GrowaveTierView", bundle: bundle)
          
          // Assumes UIView is top level and only object in CustomView.xib file
          let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
          return view
      }
    
    
}
