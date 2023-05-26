//
//  GrowaveBirthdayView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 02/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
class GrowaveBirthdayView : UIView {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var dateField: SkyFloatingLabelTextField!
    @IBOutlet weak var headingLabel: UILabel!
    
    
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
          self.setView()
        addSubview(view)
      }
    
    func setView() {
        headingLabel.font = mageFont.mediumFont(size: 12.0)
        saveButton.setTitle("Save".localized, for: .normal)
        saveButton.backgroundColor = UIColor.AppTheme()
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.setupFont(fontType: .Medium)
    }
    
    
   
      func loadViewFromNib() -> UIView
      {
          let bundle = Bundle(for: type(of: self))
          let nib = UINib(nibName: "GrowaveBirthdayView", bundle: bundle)
          
          // Assumes UIView is top level and only object in CustomView.xib file
          let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
          return view
      }
    
    
}
