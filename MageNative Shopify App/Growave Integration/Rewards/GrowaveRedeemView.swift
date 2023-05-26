//
//  GrowaveRedeemView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 01/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
class GrowaveRedeemView : UIView{
    
    @IBOutlet weak var reject: UIButton!
    @IBOutlet weak var headingLabel: UILabel!
    
    @IBOutlet weak var accept: UIButton!
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
          setView()
        
        addSubview(view)
      }
    
    func setView() {
        accept.setTitle("Yes", for: .normal)
        accept.backgroundColor = .AppTheme()
        accept.setTitleColor(.white, for: .normal)
        accept.setupFont(fontType: .Medium)
        reject.setTitle("No".localized, for: .normal)
        reject.backgroundColor = .white
        reject.setTitleColor(.AppTheme(), for: .normal)
        reject.layer.borderWidth = 1.0
        reject.layer.borderColor = UIColor.AppTheme().cgColor
        reject.setupFont(fontType: .Medium)
        headingLabel.font = mageFont.mediumFont(size: 12.0)
    }
    
   
      func loadViewFromNib() -> UIView
      {
          let bundle = Bundle(for: type(of: self))
          let nib = UINib(nibName: "GrowaveRedeemView", bundle: bundle)
          
          // Assumes UIView is top level and only object in CustomView.xib file
          let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
          return view
      }
    
}
