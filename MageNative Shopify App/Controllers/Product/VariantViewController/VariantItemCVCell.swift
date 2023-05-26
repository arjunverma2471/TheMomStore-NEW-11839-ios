//
//  VariantItemCVCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 13/04/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class VariantItemCVCell: UICollectionViewCell {
  
  lazy var itemLabel:UILabel = {
    let l = UILabel()
    //      l.font = UIFont.init(fontName: "Roboto-Bold", fontSize: 20)
    l.textAlignment = .center
    l.translatesAutoresizingMaskIntoConstraints = false
    l.font = mageFont.regularFont(size: 15.0)
    return l
  }()
  
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func setupView(){
    self.addSubview(itemLabel)
    itemLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    itemLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 3).isActive = true
    itemLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -3).isActive = true
    itemLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
  }
}

extension UILabel {
  
public func unselectedItem()
{
    self.backgroundColor    = UIColor(light: UIColor(hexString: "#F2F2F2"),dark: UIColor.darkGray)
    self.layer.borderColor  = UIColor(light: UIColor(hexString: "#F2F2F2"),dark: UIColor.darkGray).cgColor
  self.layer.borderWidth  = 1
  self.layer.cornerRadius = 2.0
  self.textColor          = UIColor(light: UIColor(hexString: "#6B6B6B"),dark: UIColor.white)
  
}
  public func selectedItem(){
      self.textColor          = UIColor.textColor()
      if(UIColor.AppTheme() == UIColor.white){
          self.textColor          = UIColor.black
      }
      self.backgroundColor    = UIColor.AppTheme()//(hexString: "#EAF2FB")
    self.layer.borderColor  = UIColor.AppTheme().cgColor
    self.layer.borderWidth  = 1
    self.layer.cornerRadius = 2.0
      //AppTheme()
    
  }
}


