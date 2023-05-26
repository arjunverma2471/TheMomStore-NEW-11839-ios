//
//  VoiceView.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 29/04/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class VoiceView: UIView {

    
    var view : UIView?
    @IBOutlet weak var cancelButton: UIButton!
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
            view?.frame = bounds
            
            // Make the view stretch with containing view
            view?.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            
    //       productImg1.layer.cornerRadius = productImg1.frame.width/2
    //        productImg1.layer.masksToBounds = true
    //
    //         productImage2.layer.cornerRadius = productImage2.frame.width/2
    //        productImage2.layer.masksToBounds = true
    //         productImage3.layer.cornerRadius = productImage3.frame.width/2
    //        productImage3.layer.masksToBounds = true
            // Adding custom subview on top of our view (over any custom drawing > see note below)
            cancelButton.setTitle("", for: .normal)
            addSubview(view!)
           
        }
        
        func loadViewFromNib() -> UIView
        {
            let bundle = Bundle(for: type(of: self))
            let nib = UINib(nibName: "VoiceView", bundle: bundle)
            
            // Assumes UIView is top level and only object in CustomView.xib file
            let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
            return view
        }

}
