//
//  VoiceSearchView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 22/09/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
class VoiceSearchView: UIView{
    var view: UIView!
    @IBOutlet weak var heading1: UILabel!
    
    @IBOutlet weak var heading2: UILabel!
    @IBOutlet weak var micBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setView()
    }
    
    func setView(){
        view = loadViewFromNib()
        // use bounds not frame or it'll be offset
        view.frame = bounds
        // Make the view stretch with containing view
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        heading1.text = "Speak something to search".localized
        heading1.font = mageFont.mediumFont(size: 16)
        heading2.text = "Listening...".localized
        heading2.font = mageFont.mediumFont(size: 15)
        
        cancelBtn.setTitle("Cancel".localized, for: .normal)
        cancelBtn.tintColor = .systemBlue
        micBtn.backgroundColor = .systemBlue
        micBtn.setTitle("", for: .normal)
        micBtn.setImage(UIImage(named: "micSearch")?.withRenderingMode(.alwaysTemplate), for: .normal)
        micBtn.layer.cornerRadius = 25.0
        micBtn.tintColor = .white
        cancelBtn.titleLabel?.font = mageFont.regularFont(size: 15)
        
        addSubview(view)
    }
    func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "VoiceSearchView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
}
