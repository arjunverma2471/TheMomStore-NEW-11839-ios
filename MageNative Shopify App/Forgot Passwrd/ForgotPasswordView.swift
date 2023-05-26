//
//  ForgotPasswordView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 17/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
class ForgotPasswordView : UIView {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var subheading: UILabel!
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var mainHeading: UILabel!
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
        
        self.setupView()
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func setupView() {
        self.closeButton.tintColor = UIColor(light: .black,dark: .white)
        // Do any additional setup after loading the view.
        view.layer.borderColor = UIColor(light: .clear,dark: .white).cgColor
        view.layer.borderWidth = 2.0
        emailView.layer.borderColor = UIColor(light: UIColor.lightGray.withAlphaComponent(0.5),dark: .white).cgColor
        emailView.backgroundColor = UIColor(light: .white,dark: .black)
        emailView.layer.borderWidth = 0.5
        mainHeading.text = "Forgot Password".localized
        subheading.text = "Enter your email id we will send reset link on your email id".localized
        mainHeading.font = mageFont.boldFont(size: 13.0)
        subheading.font = mageFont.regularFont(size: 13.0)
        email.font = mageFont.mediumFont(size: 15.0)
        submitButton.titleLabel?.font = mageFont.mediumFont(size: 15.0)
        email.placeholder = "Email".localized
        submitButton.setTitle("Submit".localized, for: .normal)
        submitButton.backgroundColor = UIColor.AppTheme()
        submitButton.setTitleColor(.textColor(), for: .normal)
        if(Client.locale == "ar"){
            email.textAlignment = .right
            mainHeading.textAlignment = .right
            subheading.textAlignment = .right
        }
        else{
            email.textAlignment = .left
            mainHeading.textAlignment = .left
            subheading.textAlignment = .left
        }
    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ForgotPasswordView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
