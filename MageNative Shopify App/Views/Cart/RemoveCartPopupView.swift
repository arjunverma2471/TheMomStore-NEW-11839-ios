//
//  RemoveCartPopupView.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 21/07/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class RemoveCartPopupView: UIView {

    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var removeCartLabel: UILabel!
    
    @IBOutlet weak var confirmationLabel: UILabel!
    
    @IBOutlet weak var removeButtonLabel: UIButton!
    
    @IBOutlet weak var moveToWishlistLabel: UIButton!
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
        view?.frame = bounds
        view?.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view!)
       
    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "RemoveCartPopupView", bundle: bundle)
        
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
