//
//  DealView.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 20/07/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class DealView: UIView {

    @IBOutlet weak var timerStack: UIStackView!
    
    @IBOutlet weak var labelStack: UIStackView!
    
    @IBOutlet weak var dayTimerLabel: UILabel!
    
    @IBOutlet weak var secLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var secTimerLabel: UILabel!
    @IBOutlet weak var minTimerLabel: UILabel!
    @IBOutlet weak var hourTimerLabel: UILabel!
    
    @IBOutlet weak var dealMessageLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
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
            view?.frame = bounds
            
            // Make the view stretch with containing view
            view?.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            dayTimerLabel.clipsToBounds = true;
            dayTimerLabel.layer.cornerRadius = 5;
            hourTimerLabel.layer.cornerRadius = 5;
            hourTimerLabel.clipsToBounds = true;
            minTimerLabel.clipsToBounds = true;
            minTimerLabel.layer.cornerRadius = 5;
            secTimerLabel.clipsToBounds = true;
            secTimerLabel.layer.cornerRadius = 5;
    //       productImg1.layer.cornerRadius = productImg1.frame.width/2
    //        productImg1.layer.masksToBounds = true
    //
    //         productImage2.layer.cornerRadius = productImage2.frame.width/2
    //        productImage2.layer.masksToBounds = true
    //         productImage3.layer.cornerRadius = productImage3.frame.width/2
    //        productImage3.layer.masksToBounds = true
            // Adding custom subview on top of our view (over any custom drawing > see note below)
            
            addSubview(view!)
           
        }
        
        func loadViewFromNib() -> UIView
        {
            let bundle = Bundle(for: type(of: self))
            let nib = UINib(nibName: "DealView", bundle: bundle)
            
            // Assumes UIView is top level and only object in CustomView.xib file
            let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
            return view
        }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
