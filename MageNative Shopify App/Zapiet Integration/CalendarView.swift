//
//  CalendarView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 29/09/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import Foundation
import FSCalendar
class CalendarView: UIView {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var doneBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    var view:UIView!
    
    override init(frame: CGRect)
    {
      super.init(frame: frame)
      xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
      super.init(coder: aDecoder)
      xibSetup()
    }
    
    func xibSetup()
    {
      view = loadViewFromNib()
      view.frame = bounds
      view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
      addSubview(view)
    }
    
    func loadViewFromNib() -> UIView
    {
      let bundle = Bundle(for: type(of: self))
      let nib = UINib(nibName: "CalendarView", bundle: bundle)
      let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
      return view
    }
    
}
