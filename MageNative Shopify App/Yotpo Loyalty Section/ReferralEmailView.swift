//
//  ReferralEmailView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 10/06/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import Foundation
import UIKit
class ReferralEmailView:  UIView{
    
    @IBOutlet weak var labelInfo: UILabel!
    @IBOutlet weak var topHeading: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var sendEmail: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
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
        sendEmail.backgroundColor = UIColor.AppTheme()
        sendEmail.setTitleColor(UIColor.textColor(), for: .normal)
        topHeading.textColor = UIColor.textColor()
        topHeading.text = "Tell Your Friends".localized
        labelInfo.text = "Just enter their email addresses (separated by a comma) and we'll share your link with them".localized
        emailTextField.placeholder = "Email Addresses".localized
        sendEmail.setTitle("Send Emails".localized, for: .normal)
        topHeading.font = mageFont.boldFont(size: 20.0)
        labelInfo.font = mageFont.mediumFont(size: 15.0)
        emailTextField.font = mageFont.regularFont(size: 15.0)
        sendEmail.titleLabel?.font = mageFont.mediumFont(size: 15.0)
        // Make the view stretch with containing view
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ReferralEmailView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
