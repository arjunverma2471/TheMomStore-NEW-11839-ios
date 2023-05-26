//
//  FlitsCartDiscountTVCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 12/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class FlitsCartDiscountTVCell: UITableViewCell {
  
  //  @IBOutlet weak var parentStack: UIStackView!
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var discountCodeDropDown: UIButton!
    @IBOutlet weak var codeViewContainer: UIView!
  @IBOutlet weak var applyFlitsCode: UIButton!
  @IBOutlet weak var removeFlitsCode: UIButton!
  @IBOutlet weak var flitsCodeTextField: UITextField!
  @IBOutlet weak var flitsDiscountCode: UILabel!
  @IBOutlet weak var codeViewHeight: NSLayoutConstraint!
  
    @IBOutlet weak var discountDropView: UIView!
    @IBOutlet weak var dropdownImage: UIImageView!
    @IBOutlet weak var textFieldHeight: NSLayoutConstraint!
    //  @IBOutlet weak var parentStackHeight: NSLayoutConstraint!
    @IBOutlet weak var wholesaleNoteHeight: NSLayoutConstraint!
    @IBOutlet weak var wholesaleNote: UILabel!
    
    @IBOutlet weak var cartPriceStack: UIStackView!
    
    @IBOutlet weak var shoppingBagStack: UIStackView!
    @IBOutlet weak var shoppingBagLbl: UILabel!
    @IBOutlet weak var shoppingBagVal: UILabel!
    
    @IBOutlet weak var discountStack: UIStackView!
    
    @IBOutlet weak var discountLbl: UILabel!
    
    @IBOutlet weak var discountVal: UILabel!
    
    override func awakeFromNib() {
    super.awakeFromNib()
        
        shoppingBagStack.isHidden = true
        discountCodeDropDown.setTitleColor(UIColor(light: UIColor.black,dark: UIColor.provideColor(type: .cartVc).textColor), for: .normal)
        self.contentView.backgroundColor = UIColor(light: UIColor(hexString: "#F2F2F2"),dark: UIColor(hexString: "#0F0F0F"))
        self.discountDropView.backgroundColor = UIColor(light: UIColor.white,dark: UIColor.provideColor(type: .cartVc).backGroundColor)
        self.parentView.backgroundColor = UIColor(light: UIColor.white,dark: UIColor.provideColor(type: .cartVc).backGroundColor)
        
    applyFlitsCode.titleLabel?.font = mageFont.mediumFont(size: 15.0)
    flitsCodeTextField.font         = mageFont.regularFont(size: 14.0)
        flitsCodeTextField.textColor = UIColor(light: .black,dark: UIColor.provideColor(type: .cartVc).textColor)
    applyFlitsCode.setTitle("Apply".localized, for: .normal)
    applyFlitsCode.backgroundColor  = UIColor.AppTheme()
    applyFlitsCode.tintColor        = UIColor.textColor()
    applyFlitsCode.layer.cornerRadius = 5
    self.selectionStyle = .none
    codeViewHeight.constant = 0
    codeViewContainer.isHidden = true
      discountCodeDropDown.setTitle("Apply Discount Coupon".localized, for: .normal)
      flitsCodeTextField.placeholder = "Discount Code".localized
      if Client.locale == "ar"{
          discountCodeDropDown.semanticContentAttribute = .forceRightToLeft
          discountCodeDropDown.contentHorizontalAlignment = .right
      }else{
          discountCodeDropDown.semanticContentAttribute = .forceLeftToRight
      }
  }
  
  func initialStage(){
    codeViewHeight.constant = 0
    codeViewContainer.isHidden = true
  }
}
