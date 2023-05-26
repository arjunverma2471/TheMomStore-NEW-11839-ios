/**
 * CedCommerce
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the End User License Agreement (EULA)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://cedcommerce.com/license-agreement.txt
 *
 * @category  Ced
 * @package   MageNative
 * @author    CedCommerce Core Team <connect@cedcommerce.com >
 * @copyright Copyright CEDCOMMERCE (http://cedcommerce.com/)
 * @license      http://cedcommerce.com/license-agreement.txt
 */

import UIKit
import RxSwift

class OrdersViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var orders:PageableArray<OrderViewModel>!
    var email = ""
    var disposeBag = DisposeBag()
  override func viewDidLoad() {
    super.viewDidLoad()
      self.navigationItem.title = "MY ORDERS".localized
    setupTableView()
    WebViewCookies().clearCookies()
    self.view.addLoader()
    Client.shared.fetchCustomerOrders(completion: {
      response,error  in
      self.view.stopLoader()
      if let response = response {
        self.orders = response
        self.tableView.reloadData()
      }
      else {
        //self.showErrorAlert(error: error?.localizedDescription)
      }
    })
  }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        FloatingButton.shared.controller = self
//        FloatingButton.shared.renderFloatingButton()
    }
    
  
  func setupTableView(){
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.emptyDataSetDelegate = self
    self.tableView.emptyDataSetSource = self
    self.tableView.estimatedRowHeight = UITableView.automaticDimension
    self.tableView.rowHeight = 50.0
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

extension OrdersViewController:UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return orders?.items.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: MyOrdersCell.className) as! MyOrdersCell
    let order = orders.items[indexPath.row]
    cell.configureFrom(order)
      if customAppSettings.sharedInstance.returnPrime {
          if order.fulfillmentStatus == "FULFILLED" {
              cell.returnBtn.isHidden = false
          }
          else {
              cell.returnBtn.isHidden = true
          }
      }
      else {
          cell.returnBtn.isHidden = true
      }
      if customAppSettings.sharedInstance.shipwayIntegration {
          if order.fulfillmentStatus == "FULFILLED" {
              cell.trackButton.isHidden = false
              
          }
          else {
              cell.trackButton.isHidden = true
          }
      }
      else {
          cell.trackButton.isHidden = true
      }
      cell.trackButton.rx.tap.bind{
          self.trackOrder(orderId: order.orderNumber)
      }.disposed(by: disposeBag)
      cell.returnBtn.tag = indexPath.row
      cell.returnBtn.addTarget(self, action: #selector(returnOrder(_:)), for: .touchUpInside)
    cell.outerView.cardView()
    cell.viewOrder.addTarget(self, action: #selector(viewOrder(_:)), for: .touchUpInside)
    cell.viewOrder.tag = indexPath.row
      cell.reorderBtn.backgroundColor = UIColor.AppTheme()
    cell.reorderBtn.addTarget(self, action: #selector(reorderPressed(_:)), for: .touchUpInside)
    cell.reorderBtn.tag = indexPath.row
    return cell
  }
    @objc func trackOrder(orderId: String){
        let webView : WebViewController = self.storyboard!.instantiateViewController()
        webView.url = ShipwayApiConstant.shared.getShipwayTrackingApi(orderId: orderId)
        self.navigationController?.pushViewController(webView, animated: true)
    }

    @objc func returnOrder(_ sender:UIButton) {
        let orderNumber = orders.items[sender.tag].orderNumber
        let channelId = Client.returnChannelId
        let url = "https://admin.returnprime.com/external/fetch-order?order_number=\(orderNumber)&email=\(email)&store=\(Client.shopUrl)&channel_id=\(channelId)"
        guard let urlReq = url.getURL() else {return}
        let webView : WebViewController = self.storyboard!.instantiateViewController()
        webView.url = urlReq
        self.navigationController?.pushViewController(webView, animated: true)
    }
  
  @objc func viewOrder(_ sender:UIButton) {
      if customAppSettings.sharedInstance.nativeOrderPage {
          let orderViewControl:OrderDetailsViewController = self.storyboard!.instantiateViewController()
          //    let tokenArray = Client.shared.getToken() as! [String:Any]
          //    let tokenValue = tokenArray["token"] as! String
          //    print("--token--\(tokenValue)")
          //    orderViewControl.url = order.statusUrl
          //    orderViewControl.isLoginRequired = true
          //    //orderViewControl.isOrder = true;
          let order = orders.items[sender.tag]
          orderViewControl.orderData = order
          self.navigationController?.pushViewController(orderViewControl, animated: true)
      }
      else {
          let vc : WebViewController = self.storyboard!.instantiateViewController()
          let order = orders.items[sender.tag]
          let url = order.statusUrl
          vc.url = url
          vc.isOrder = true
          self.navigationController?.pushViewController(vc, animated: true)
      }
    
    
  }
  
  
  @objc func reorderPressed(_ sender:UIButton) {
      SweetAlert().showAlert("Confirmation".localized, subTitle: "Do you want to re-order the items available in this Order?".localized, style: AlertStyle.warning, buttonTitle:"No".localized, buttonColor:UIColor(hexString: "#cd7b72") , otherButtonTitle:  "Yes".localized, otherButtonColor:UIColor(hexString: "#29b456")) { (isOtherButton) -> Void in
      if isOtherButton == true {
        print("Cancel Button  Pressed")
      }
      else {
        let order = self.orders.items[sender.tag]
        let items  = order.model?.node.lineItems
        
        var reOrderProductData = [[String:String]]()
        if items?.edges.count ?? 0 > 0 {
          for edges in (items?.edges)! {
            let productId = edges.node.variant?.product.id.description ?? ""
            let variantId = edges.node.variant?.id.description ?? ""
            let qty = edges.node.quantity.description
            reOrderProductData.append(["productId":productId,"variantId":variantId,"qty":qty])
          }
         
          if reOrderProductData.count > 0 {
            self.fetchOrderProductDetails(reorderData: reOrderProductData) { _ in
                _ = SweetAlert().showAlert("Completed!".localized, subTitle: "Your Items have been added to the Cart".localized, style: AlertStyle.success)
            }
          }
        }
      }
    }
  }
  
  func fetchOrderProductDetails(reorderData:[[String:String]],completion: @escaping (String?) -> Void) {
    var i = 0
    self.view.addLoader()
    for values in reorderData {
      if let productId = values["productId"] {
        Client.shared.fetchSingleProduct(of: productId){
          response,error   in
          if let response = response {
            if response.variants.items.count > 0 {
              for variants in response.variants.items {
                if variants.id == values["variantId"] {
                  i = i+1
                  let cartProduct = CartProduct(product: response, variant: WishlistManager.shared.getVariant(variants), quantity: Int(values["qty"] ?? "") ?? 0)
                  CartManager.shared.addToCart(cartProduct)
                  self.setupTabbarCount()
                }
              }
            }
          }
          if i == reorderData.count {
            self.view.stopLoader()
            completion("completed")
          }
        }
      }
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension;
  }
}

extension OrdersViewController:UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

  }
}


extension OrdersViewController:DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
  /*func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    return NSAttributedString(string: EmptyData.orderEmptyTitle)
  }
  
  func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    return NSAttributedString(string: EmptyData.orderDescription)
  }*/
  
  func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
    return orders?.items.count == 0
  }
  
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        let custom = EmptyView()
        custom.delegate = self;
        custom.configure(imageName: "emptyOrder", title: EmptyData.orderEmptyTitle, subtitle: EmptyData.orderDescription)
        return custom;
    }
}
