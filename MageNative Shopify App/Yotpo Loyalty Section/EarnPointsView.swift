//
//  EarnPointsView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 11/06/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import Foundation
import UIKit
class EarnPointsView: UIView {
    @IBOutlet weak var outerView: UIView!
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var topHaedingLbl: UILabel!
   
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var redirectBtn: UIButton!
    
    
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
        outerView.backgroundColor = UIColor.AppTheme()
        topHaedingLbl.font = mageFont.regularFont(size: 15.0)
        descriptionLabel.font = mageFont.regularFont(size: 15.0)
        bottomLabel.font = mageFont.regularFont(size: 15.0)
        dateBtn.titleLabel?.font = mageFont.mediumFont(size: 15.0)
        redirectBtn.titleLabel?.font = mageFont.mediumFont(size: 15.0)
        dateBtn.setTitle("Select Date".localized, for: .normal)
        redirectBtn.setTitle("Take Me There".localized, for: .normal)
        // Make the view stretch with containing view
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "EarnPointsView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
}
