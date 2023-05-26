//
//  orderInfoTableCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 22/05/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import UIKit

class orderInfoTableCell: UITableViewCell {
  
  @IBOutlet weak var refundView: UIView!  
  @IBOutlet weak var refundReason: UILabel!
  @IBOutlet weak var customerAddress: UILabel!
  @IBOutlet weak var customerNAme: UILabel!
  @IBOutlet weak var totalPrice: UILabel!
  @IBOutlet weak var priceDetails: UILabel!
  @IBOutlet weak var emailId: UIButton!
  @IBOutlet weak var phoneNumber: UIButton!
  
    @IBOutlet weak var updateTxt: UILabel!
    @IBOutlet weak var totalTxt: UILabel!
    @IBOutlet weak var deliveryTxt: UILabel!
  
    override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func configureOrderDetails(_ orderData:OrderViewModel?) {
    let lang = Client.shared.getLanguageCode().rawValue.lowercased() == "ar"
    totalPrice.textAlignment = lang ? .left : .right
    if lang {
      emailId.semanticContentAttribute = .forceRightToLeft
      phoneNumber.semanticContentAttribute = .forceRightToLeft
      emailId.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
      phoneNumber.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }else{
      emailId.semanticContentAttribute = .forceLeftToRight
      phoneNumber.semanticContentAttribute = .forceLeftToRight
      emailId.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
      phoneNumber.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
   
    
    self.customerNAme.text = "\(orderData?.name ?? "") \(orderData?.phoneNumber ?? "")"
    var address = ""
    address += "\(orderData?.shippingAddress?.address1 ?? "")"
    //address += "\n\(orderData?.shippingAddress?.address2 ?? "")"
    address += "\n\(orderData?.shippingAddress?.zip ?? "")"
    address += "\n\(orderData?.shippingAddress?.city ?? "") , \(orderData?.shippingAddress?.country ?? "") "
    self.customerAddress.text = address
    
    self.totalPrice.text = "\(orderData?.totalPrice ?? "")"
    var priceDetails = ""
    priceDetails += "Subtotal : ".localized+"\(orderData?.subTotal ?? "")"+"\n"
    priceDetails += "\n"+"Shipping (Standard Shipping) : ".localized+"\(orderData?.shippingPrice ?? "")"+"\n"
    priceDetails += "\n"+"Tax : ".localized+"\(orderData?.taxPrice ?? "")"+"\n"
    self.priceDetails.text = priceDetails
    
    self.emailId.setTitle(orderData?.email ?? "", for: .normal)
    if orderData?.phoneNumber != "" {
      self.phoneNumber.setTitle(orderData?.phoneNumber ?? "", for: .normal)
    }
    else {
      self.phoneNumber.setTitle("N/A", for: .normal)
    }
      deliveryTxt.text = "Delivery Address".localized
      totalTxt.text = "Total Order Price".localized
      updateTxt.text = "Updates sent to".localized
      deliveryTxt.font = mageFont.mediumFont(size: 15.0)
      totalTxt.font = mageFont.mediumFont(size: 15.0)
      updateTxt.font = mageFont.mediumFont(size: 15.0)
    
    if orderData?.refundPrice != "" && orderData?.refundPrice != nil {
      self.refundView.isHidden=false
      self.refundReason.text = "Total Refunded Amount".localized+"\n\(orderData?.refundPrice ?? "")"
    }
    else {
      self.refundView.isHidden=true
    }
      if Client.locale == "ar"{
          self.emailId.semanticContentAttribute = .forceRightToLeft
          self.phoneNumber.semanticContentAttribute = .forceRightToLeft
          self.emailId.contentHorizontalAlignment = .right
          self.phoneNumber.contentHorizontalAlignment = .right
      }else{
          self.emailId.semanticContentAttribute = .forceLeftToRight
          self.phoneNumber.semanticContentAttribute = .forceLeftToRight
      }
  }
    
    func configureOrderCompleteDetails(_ orderData:CompleteOrderViewModel?) {
      self.customerNAme.text = "\(orderData?.name ?? "") \(orderData?.phoneNumber ?? "")"
      var address = ""
      address += "\(orderData?.shippingAddress?.address1 ?? "")"
      //address += "\n\(orderData?.shippingAddress?.address2 ?? "")"
      address += "\n\(orderData?.shippingAddress?.zip ?? "")"
      address += "\n\(orderData?.shippingAddress?.city ?? "") , \(orderData?.shippingAddress?.country ?? "") "
      self.customerAddress.text = address
      
      self.totalPrice.text = "\(orderData?.totalPrice ?? "")"
      var priceDetails = ""
      priceDetails += "Subtotal : ".localized+"\(orderData?.subTotal ?? "")"
      priceDetails += "\n"+"Shipping (Standard Shipping) : ".localized+"\(orderData?.shippingPrice ?? "")"
      priceDetails += "\n"+"Tax : ".localized+"\(orderData?.taxPrice ?? "")"
      self.priceDetails.text = priceDetails
      
      self.emailId.setTitle(orderData?.email ?? "", for: .normal)
      if orderData?.phoneNumber != "" {
        self.phoneNumber.setTitle(orderData?.phoneNumber ?? "", for: .normal)
      }
      else {
        self.phoneNumber.setTitle("N/A", for: .normal)
      }
        deliveryTxt.text = "Delivery Address".localized
        totalTxt.text = "Total Order Price".localized
        updateTxt.text = "Updates sent to".localized
        deliveryTxt.font = mageFont.mediumFont(size: 15.0)
        totalTxt.font = mageFont.mediumFont(size: 15.0)
        updateTxt.font = mageFont.mediumFont(size: 15.0)
      
      if orderData?.refundPrice != "" && orderData?.refundPrice != nil {
        self.refundView.isHidden=false
        self.refundReason.text = "Total Refunded Amount".localized+"\n\(orderData?.refundPrice ?? "")"
      }
      else {
        self.refundView.isHidden=true
      }
    }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
