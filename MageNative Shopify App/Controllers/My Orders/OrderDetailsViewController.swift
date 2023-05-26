//
//  OrderDetailsViewController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 22/05/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import UIKit

class OrderDetailsViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var orderId: UILabel!
  
  var orderData : OrderViewModel?
    var paymentOrder : CompleteOrderViewModel?
    var isfromNativeCheckout = false
  var shopifyRecommendedProducts: Array<ProductViewModel>?
  var layoutHeight = [String:CGFloat]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.delegate=self
    self.tableView.dataSource=self
    self.tableView.reloadData()
    self.tableView.rowHeight = UITableView.automaticDimension
    self.tableView.estimatedRowHeight = 44.0
      if isfromNativeCheckout {
          self.orderId.text = "Order #".localized+(paymentOrder?.orderNumber ?? "")
            self.orderId.font = mageFont.regularFont(size: 14.0)
          if let productId = self.paymentOrder?.lineItems.items.first?.model?.node.variant?.product.id {
            self.fetchShopifyRecommendedProducts(productId: productId)
          }
      }
      else {
          self.orderId.text = "Order #".localized+(orderData?.orderNumber ?? "0")
            self.orderId.font = mageFont.regularFont(size: 14.0)
          if let productId = self.orderData?.lineItems.items.first?.model?.node.variant?.product.id {
            self.fetchShopifyRecommendedProducts(productId: productId)
          }
      }
    
    
    
    // Do any additional setup after loading the view.
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 2 {
      guard let count = shopifyRecommendedProducts?.count else {
        return 0
      }
      if(count == 0){
        return 0
      }
      return 1;
    }
    return 1
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0 {
      return UITableView.automaticDimension
    }
    else if indexPath.section == 1 {
      return UITableView.automaticDimension
    }
    else if indexPath.section == 2 {
      return layoutHeight["similarProducts"] ?? 0
    }
    return 0
  }
  
  func fetchShopifyRecommendedProducts(productId: GraphQL.ID) {
    Client.shared.fetchRecommendedProducts(ids: productId,completion: { (response, error) in
      if let response = response {
        self.shopifyRecommendedProducts = response
        self.tableView.reloadData()
      }
    })
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "orderLineItemTableCell", for: indexPath) as? orderLineItemTableCell
      
      cell?.parent=self
      cell?.reloadCollData()
        if isfromNativeCheckout
        {
            cell?.lineItems = self.paymentOrder?.lineItems
            cell?.configureOrderData(self.paymentOrder)
        }
        else {
            cell?.lineItems = self.orderData?.lineItems
            cell?.configureData(self.orderData)
        }
     
      return cell!
    }
    else if indexPath.section == 1 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "orderInfoTableCell", for: indexPath) as? orderInfoTableCell
        if isfromNativeCheckout {
            cell?.configureOrderCompleteDetails(self.paymentOrder)
        }
        else {
            cell?.configureOrderDetails(self.orderData)
        }
        cell?.priceDetails.textColor = UIColor(light: .black,dark: .white)
        cell?.phoneNumber.tintColor = UIColor(light: .black,dark: .white)
        cell?.emailId.tintColor = UIColor(light: .black,dark: .white)
        cell?.phoneNumber.tintColor = UIColor(light: .black,dark: .white)
        cell?.emailId.tintColor = UIColor(light: .black,dark: .white)
        cell?.phoneNumber.setTitleColor(UIColor(light: .black,dark: .white), for: .normal)
        cell?.emailId.setTitleColor(UIColor(light: .black,dark: .white), for: .normal)
      return cell!
    }
    
    else if indexPath.section == 2 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "CrosssellProductsCell", for: indexPath) as! SimilarProductsCell
      cell.products = self.shopifyRecommendedProducts
      cell.parent=self
      cell.recommendedName = "similarProducts"
      cell.delegate = self
      cell.layoutDelegate = self
      cell.headingLabel.text = "You'll Want These Too!".localized
        cell.headingLabel.font = mageFont.regularFont(size: 15.0)
      cell.configure()
      cell.headingLabel.textColor = UIColor(light: UIColor.darkGray,dark: .white)
        cell.productsCollectionView.backgroundColor = UIColor(light: .white,dark: .black)
      cell.backgroundColor = UIColor(light: .white,dark: .black)
      return cell;
    }
    return UITableViewCell()
  }
}


extension OrderDetailsViewController: RecommendedProductsLayoutUpdate{
  func updateLayoutAccordingToGrid(collection: UICollectionView?, productsArray: Array<ProductViewModel>!, recommendedName: String) {
    if(productsArray.count>0){
      if  UIDevice.current.model.lowercased() == "ipad".lowercased() {
        layoutHeight[recommendedName] = (collection?.calculateHalfCellSize(numberOfColumns: 4.0).height ?? 0)
      }
      layoutHeight[recommendedName] = (collection?.calculateHalfCellSize(numberOfColumns: 2.3).height ?? 0) + 55
    }
    tableView.beginUpdates()
    tableView.endUpdates()
  }
}


extension OrderDetailsViewController:productClicked{
  func productCellClicked(product: ProductViewModel, sender: Any) {
    let productViewController=ProductVC()//:ProductViewController = self.storyboard!.instantiateViewController()
    productViewController.product = product
    self.navigationController?.pushViewController(productViewController, animated: true)
  }
}
