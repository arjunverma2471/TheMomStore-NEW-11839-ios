//
//  orderLineItemTableCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 22/05/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import UIKit

class orderLineItemTableCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var orderStatuView: UIView!
  @IBOutlet weak var orderStatus: UILabel!
  @IBOutlet weak var statusImage: UIImageView!
  @IBOutlet weak var financialStatus: UILabel!
  @IBOutlet weak var cancelledStatus: UILabel!
  
    @IBOutlet weak var orderStatusTxt: UILabel!
    var parent:UIViewController?
    var productID = ""
  var lineItems : PageableArray<OrderLineItemViewModel>? {
    didSet {
      self.pageControl.numberOfPages = lineItems?.items.count ?? 0
      collectionView.reloadData()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    collectionView.delegate=self
    collectionView.dataSource=self
  }
  
  func reloadCollData() {
    collectionView.delegate=self
    collectionView.dataSource=self
    collectionView.reloadData()
  }
  
  func configureData(_ orderData:OrderViewModel?) {
      if let productId = orderData?.lineItems.items.first?.model?.node.variant?.product.id {
          self.productID = productId.rawValue
      }
    var cancelledtext = ""
    if orderData?.processedAt != "" && orderData?.processedAt != nil {
      cancelledtext += "Placed On ".localized
      cancelledtext += orderData?.processedAt ?? ""
      cancelledtext += "\n"
    }
    
    if orderData?.cancelAt != "" {
      cancelledtext += "Cancelled At : ".localized
      cancelledtext += orderData?.cancelAt ?? ""
    }
    
    if orderData?.cancelReason != "" {
      cancelledtext += "\n"
      cancelledtext += "Cancelled Reason : ".localized
      cancelledtext += orderData?.cancelReason ?? ""
    }
    
    self.cancelledStatus.text = cancelledtext
    self.financialStatus.text = "Payment Status : ".localized+"\(orderData?.financialStatus ?? "")"
    self.financialStatus.backgroundColor = UIColor.AppTheme()
      self.financialStatus.textColor = UIColor.textColor()
    if let fullfilmentStatus = orderData?.fulfillmentStatus {
      self.orderStatus.text = fullfilmentStatus
      if fullfilmentStatus.lowercased() == "fulfilled" {
        statusImage.image = UIImage(named: "check")
        orderStatuView.backgroundColor = UIColor.systemGreen

      }
      else if fullfilmentStatus.lowercased() == "unfulfilled" {
        statusImage.image = UIImage(named: "cancelled")
        orderStatuView.backgroundColor = UIColor.systemRed
      }
      else {
        statusImage.image = UIImage(named: "pending")
        orderStatuView.backgroundColor = UIColor.systemOrange
      }
    }
      self.cancelledStatus.font = mageFont.regularFont(size: 14.0)
      self.financialStatus.font = mageFont.regularFont(size: 14.0)
      self.orderStatus.font = mageFont.regularFont(size: 14.0)
  }
    
    func configureOrderData(_ orderData:CompleteOrderViewModel?) {
        if let productId = orderData?.lineItems.items.first?.model?.node.variant?.product.id {
            self.productID = productId.rawValue
        }
      var cancelledtext = ""
      if orderData?.processedAt != "" && orderData?.processedAt != nil {
        cancelledtext += "Placed On ".localized
        cancelledtext += orderData?.processedAt ?? ""
        cancelledtext += "\n"
      }
      
      if orderData?.cancelAt != "" {
        cancelledtext += "Cancelled At : ".localized
        cancelledtext += orderData?.cancelAt ?? ""
      }
      
      if orderData?.cancelReason != "" {
        cancelledtext += "\n"
        cancelledtext += "Cancelled Reason : ".localized
        cancelledtext += orderData?.cancelReason ?? ""
      }
      
      self.cancelledStatus.text = cancelledtext
      self.financialStatus.text = "Payment Status : ".localized+"\(orderData?.financialStatus ?? "")"
      self.financialStatus.backgroundColor = UIColor.AppTheme()
        self.financialStatus.textColor = UIColor.textColor()
      if let fullfilmentStatus = orderData?.fulfillmentStatus {
        self.orderStatus.text = fullfilmentStatus
        if fullfilmentStatus.lowercased() == "fulfilled" {
          statusImage.image = UIImage(named: "check")
          orderStatuView.backgroundColor = UIColor.systemGreen

        }
        else if fullfilmentStatus.lowercased() == "unfulfilled" {
          statusImage.image = UIImage(named: "cancelled")
          orderStatuView.backgroundColor = UIColor.systemRed
        }
        else {
          statusImage.image = UIImage(named: "pending")
          orderStatuView.backgroundColor = UIColor.systemOrange
        }
      }
        self.cancelledStatus.font = mageFont.regularFont(size: 14.0)
        self.financialStatus.font = mageFont.regularFont(size: 14.0)
        self.orderStatus.font = mageFont.regularFont(size: 14.0)
    }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return lineItems?.items.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "orderLineItemCollCell", for: indexPath) as? orderLineItemCollCell
    print("i'm here")
    cell?.lineItemImage.setImageFrom(lineItems?.items[indexPath.row].image.getURL())
    cell?.lineItemName.text = lineItems?.items[indexPath.row].title
    cell?.lineItemVariant.text = lineItems?.items[indexPath.row].variantTitle
    cell?.lineItemQuantity.text = "Quantity : ".localized+"\(lineItems?.items[indexPath.row].quantity ?? 0)"
      cell?.lineItemName.font = mageFont.regularFont(size: 14.0)
      cell?.lineItemVariant.font = mageFont.regularFont(size: 14.0)
      cell?.lineItemQuantity.font = mageFont.regularFont(size: 14.0)
    return cell!
  }
  
  
  @objc func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    pageControl.currentPage = Int(self.collectionView.contentOffset.x) / Int(self.collectionView.frame.size.width - 10);
  }
  
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("helooooo")
//        print("product id ====>",self.productID)
        if self.productID != ""{
        let productViewController=ProductVC()
        productViewController.productId = self.productID
        productViewController.isProductLoading = true;
        self.parent?.navigationController?.pushViewController(productViewController, animated: true)
    }
        
        
    }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: (self.parent?.view.frame.width ?? 0.0)-10, height: 310)
  }
  
}
