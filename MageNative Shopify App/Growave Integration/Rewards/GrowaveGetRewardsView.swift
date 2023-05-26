//
//  GrowaveGetRewardsView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 27/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
class GrowaveGetRewardsView : UIView {
    
    @IBOutlet weak var mainHeading: UILabel!
    @IBOutlet weak var earnButton: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var subHeading: UILabel!
    
    
  //  var onEarnTap:(()->Void)?
    
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
        mainHeading.font = mageFont.mediumFont(size: 12.0)
        subHeading.font = mageFont.regularFont(size: 12.0)
        subHeading.numberOfLines = 0
        earnButton.backgroundColor = .AppTheme()
        earnButton.setTitleColor(.white, for: .normal)
        earnButton.setupFont(fontType: .Medium)
        //earnButton.addTarget(self, action: #selector(onEarn), for: .touchUpInside)
    }
    
//    @objc func onEarn() {
//        onEarnTap?()
//    }
      
      func loadViewFromNib() -> UIView
      {
          let bundle = Bundle(for: type(of: self))
          let nib = UINib(nibName: "GrowaveGetRewardsView", bundle: bundle)
          
          // Assumes UIView is top level and only object in CustomView.xib file
          let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
          return view
      }
    
    
}
