//
//  NewCartViewController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 21/04/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import PassKit
import MobileBuySDK
import RxSwift
import RxCocoa
import FSCalendar
class NewCartViewController : BaseViewController {

    var products = [CartLineItemViewModel]()
    var cartCheckout : CartCheckoutViewModel!
    var cartManager = CartManager.shared
    var cartQtyError = 0
    var discountCodeApplied = String()
    var discountCodeSDK = String()
    var crosssellProducts: Array<ProductViewModel>?
    var layoutHeight = [String:CGFloat]()
    var upsellProducts: Array<ProductViewModel>?
    var showDiscountSection = false
    let disposeBag = DisposeBag()
    var applyDiscountCode=""
    var selectedAddress = String()
    var deliveryCellBtn = true
    var pickupCellBtn = false
    var shippingBtn = false
    var minDate = String()
    var maxDate = String()
    var deliveryDate = String()
    var deliveryTime = String()
    var invalidDays = [SwiftyJSON.JSON]()
    var isDeliveryPossible = false
    var showDeliveryDate = false
    var deliveryJSON = SwiftyJSON.JSON()
    var initialSelected = 0
    var calendarView : CalendarView!
    let dateFormatter = DateFormatter()
    var deliveryWeekDay = String()
    var minDateForCalendar = Date()
    var maxDateForCalendar = Date()
    var locationArray = [String]()
    var pickupJSON = SwiftyJSON.JSON()
    var locationsArray = [SwiftyJSON.JSON]()
    var isDataLoaded = false
    var pickupEligible = false
    var shippingEligible = false
    var deliveryEligible = false
    var isDateSelected = false
    var deliveryDateJSON = SwiftyJSON.JSON()
    var cartQtyLabel = UILabel()
    
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkoutOptions: UIStackView!
    @IBOutlet weak var checkoutView: UIView!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var totalAmt: UILabel!
    @IBOutlet weak var clearCartCiew: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    let shimmer = customShimmerView(cellsArray: [cartproductShimmerTC.reuseID], productListCount: 10)
    
    override func viewDidLoad() {
    super.viewDidLoad()
        //add shimmer
        view.addSubview(shimmer)
        shimmer.frame = view.bounds
        view.bringSubviewToFront(shimmer)
        self.setupTable()
//        self.title = "Cart".localized
//        self.navigationItem.title = "Cart".localized
        
        let space = UIView()
        space.anchor(width: 30)
        let title = UILabel()
        title.font = mageFont.mediumFont(size: 15)
        title.text = "Bag".localized
        cartQtyLabel.font = mageFont.regularFont(size: 12)
        self.cartQtyLabel.textColor = UIColor(hexString: "#383838")
        self.cartQtyLabel.text = " (\((CartManager.shared.cartCount == 0 ? nil : CartManager.shared.cartCount.description) ?? "") "+"Items)".localized
        let spacer = UIView()
        let constraint = spacer.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat.greatestFiniteMagnitude)
        constraint.isActive = true
        constraint.priority = .defaultLow

        let stack = UIStackView(arrangedSubviews: [space,title, cartQtyLabel, spacer ])
        stack.axis = .horizontal
        navigationItem.titleView = stack
  }
    func setupTable(){
      self.tableView.dataSource = self
      self.tableView.delegate = self
       // self.tableView.reloadData()
        //For Discount work
        let nib = UINib(nibName: FlitsCartDiscountTVCell.className, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: FlitsCartDiscountTVCell.className)
        //
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(true)
        self.applyDiscountCode = ""
        self.checkForCartUpdate()
        let shopUrl = Client.shopUrl.replacingOccurrences(of: ".myshopify.com", with: "")
        let ref = BaseViewController.secondaryDb?.reference(withPath: shopUrl).child("additional_info")
        ref?.child("personalise").observe(.value, with: {
          [weak self] snapshot in
          if let dataObject = snapshot.value as? Bool {
            self?.crosssellProducts = []
            if(dataObject) && (customAppSettings.sharedInstance.aiProductRecomendaton) {
              self?.loadRecommendedProducts();
            }
            else{
              self?.tableView.reloadData()
            }
          }
        }) 
      // JS
     self.tabBarController?.tabBar.tabsVisiblty()
  //   setupNavBar()
     // END
      //self.tabBarController?.tabBar.isHidden=false
        
        self.pickupEligible = false
        self.shippingEligible = false
        self.deliveryEligible = false
        deliveryCellBtn=true
        pickupCellBtn=false
        shippingBtn=false
        locationArray = [String]()
        locationsArray = [SwiftyJSON.JSON]()
        deliveryDate = ""
        deliveryTime = ""
        if DBManager.shared.cartProducts?.count ?? 0 > 0 {
            if customAppSettings.sharedInstance.zapietIntegration {
                self.checkForAvailableZapietMethod(checkoutMethod: "pickup")
                
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
      self.navigationController?.navigationBar.isHidden = false;
        self.navigationController?.setNavigationBarHidden(false, animated: true)
      WebViewCookies().clearCookies()
    }
    
    func loadRecommendedProducts()
    {
      if(DBManager.shared.cartProducts?.count ?? 0 > 0){
        
        var crosssellProductIds = [String]()
        for index in DBManager.shared.cartProducts! {
          crosssellProductIds.append(index.id.components(separatedBy: "/").last!)
        }
        
        Client.shared.fetchRecommendedProducts(query: [ "queries": [["id": "query1","max_recommendations": 8,"recommendation_type": "cross_sell", "product_ids":crosssellProductIds],["id": "query2","max_recommendations": 8,"recommendation_type": "bought_together", "product_ids":crosssellProductIds]]]) { (json, error) in
          if let json = json{
            if let status = json["status"] as? String{
              if(status.lowercased() == "ok"){
                if let query1 = json["query1"] as? [String:Any]{
                  if let products = query1["products"] as? [[String:Any]]{
                    var ids = [GraphQL.ID]()
                    for index in products{
                      let str="gid://shopify/Product/\(index["product_id"]!)"
                      let graphId = GraphQL.ID(rawValue: str)
                      
                      ids.append(graphId)
                    }
                    
                    Client.shared.fetchMultiProducts(ids: ids, completion: { [weak self] (response, error) in
                      if let response = response {
                        self?.crosssellProducts = response
                        self?.tableView.reloadData()
                      }else {
                        
                      }
                    })
                  }
                }
                if let query1 = json["query2"] as? [String:Any]{
                  if let products = query1["products"] as? [[String:Any]]{
                    var ids = [GraphQL.ID]()
                    for index in products{
                      let str="gid://shopify/Product/\(index["product_id"]!)"
                      let graphId = GraphQL.ID(rawValue: str)
                      
                      ids.append(graphId)
                    }
                    
                    Client.shared.fetchMultiProducts(ids: ids, completion: { (response, error) in
                      if let response = response {
                        self.upsellProducts = response
                        self.tableView.reloadData()
                      }else {
                      }
                    })
                  }
                }
              }
            }
          }
        }
      }
    }
    
    
    
    func checkForCartUpdate() {
        if DBManager.shared.cartProducts?.count ?? 0 > 0 {
          let cartItems = DBManager.shared.cartProducts!
         // self.view.addLoader()
            Client.shared.createCartCheckout(with: cartItems, discountCode: self.applyDiscountCode) { checkout,error   in
         //   self.view.stopLoader()
            if let checkout = checkout {
                self.cartCheckout = checkout
                self.products = checkout.lineItems
                self.setupTabbarCount()
                self.setUpClearCartView()
                self.setUpCheckoutView()
                self.shimmer.removeFromSuperview()
                self.tableView.reloadData()
            }
          }
        }
        else {
          products = [CartLineItemViewModel]()
          self.setUpClearCartView()
          self.setUpCheckoutView()
          self.setupTabbarCount()
          self.shimmer.removeFromSuperview()
          self.tableView.reloadData()
        }
        
    }
    
    func setUpClearCartView() {
      
        self.clearCartCiew.backgroundColor = UIColor(light: UIColor(hexString: "#F2F2F2"),dark: UIColor.provideColor(type: .cartVc).backGroundColor)
        self.clearCartCiew.isHidden=false
        if(DBManager.shared.cartProducts?.count ?? 0 > 0){
            self.clearCartCiew.isHidden=false
            self.clearButton.setImage(UIImage(named: "delete_accountN"), for: .normal)
            self.clearButton.setTitle("", for: .normal)
            self.clearButton.backgroundColor = .clear
            self.clearButton.tintColor = .AppTheme()
            self.clearButton.titleLabel?.font = mageFont.regularFont(size: 15.0)
            self.clearButton.addTarget(self, action: #selector(deleteCompleteCart(_:)), for: .touchUpInside)
            self.countLabel.text = "Click here to clear your all cart item".localized
            self.countLabel.textColor = UIColor(light: UIColor(hexString: "#383838"),dark: UIColor.provideColor(type: .cartVc).textColor)
            self.countLabel.font = mageFont.regularFont(size: 12.0)
        }
        else
        {
            self.clearCartCiew.isHidden=true
        }
    }
    
    func setUpCheckoutView() {
      if(DBManager.shared.cartProducts?.count ?? 0 > 0){
        self.checkoutView.isHidden=false
          self.totalAmt.text = "Sub Total".localized
          self.totalAmt.font = mageFont.regularFont(size: 14.0)
          self.totalAmount.font = mageFont.mediumFont(size: 16.0)
      
          self.checkoutView.cardView()
          shippingLabel.text = "Taxes and shipping calculated at checkout".localized
          shippingLabel.textColor = UIColor(light: UIColor(hexString: "#383838"),dark: UIColor.provideColor(type: .cartVc).textColor)
          shippingLabel.font = mageFont.setFont(fontWeight: "light", fontStyle: "light", fontSize: 12)
        self.checkoutView.cardView()
        if self.checkoutOptions.arrangedSubviews.count > 0 {
          for view in checkoutOptions.arrangedSubviews {
            view.removeFromSuperview()
          }
        }
        let webCheckout = Button()
        webCheckout.setTitle("Checkout".localized, for: .normal)
        webCheckout.addTarget(self, action: #selector(self.proceedCheckout(sender:)), for: .touchUpInside)
        webCheckout.tag=2345
        self.checkoutOptions.addArrangedSubview(webCheckout)
        if AppSetUp.applePayEnable {
          //Adding Apple Pay Button if supported
          if PKPaymentAuthorizationController.canMakePayments() {
            let applePay = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black)
            applePay.addTarget(self, action: #selector(self.proceedCheckout(sender:)), for: .touchUpInside)
            self.checkoutOptions.addArrangedSubview(applePay)
          }
        }
          if let checkout = cartCheckout {
              totalAmount.text = "\(Currency.formatter.string(from: checkout.totalPrice as NSDecimalNumber)!)"
          }
        else{
          totalAmount.text = Currency.stringFrom(CartManager.shared.cartSubtotal)
        }
          self.totalAmount.font = mageFont.regularFont(size: 14.0)
      }
      else {
        self.checkoutView.isHidden=true
      }
    }
    
    @objc func deleteCompleteCart(_ sender:UIButton) {
        SweetAlert().showAlert("Warning".localized, subTitle: "Do you want to clear all your items \n from Bag?".localized, style: AlertStyle.warning, buttonTitle:"No".localized, buttonColor:UIColor(hexString: "#cd7b72") , otherButtonTitle:  "Yes".localized, otherButtonColor:UIColor(hexString: "#29b456")) { (isOtherButton) -> Void in
          if isOtherButton == true {
            print("Cancel Button  Pressed")
          }
          else {
              DBManager.shared.clearCartData()
              self.cartQtyLabel.text = " (\((CartManager.shared.cartCount == 0 ? nil : CartManager.shared.cartCount.description) ?? "") "+"Items)".localized
              self.checkForCartUpdate()
            _ = SweetAlert().showAlert("Deleted!".localized, subTitle: "Your Cart has been Cleared!".localized, style: AlertStyle.success)
          }
        }
    }
    
    @objc func proceedCheckout(sender:UIButton) {
      
      /*if self.cartQtyError > 0 {
        _ = SweetAlert().showAlert("Warning".localized, subTitle: "Some of the products in your cart are either Out of Stock or not available in the requested quantity. Please Update your cart in order to Proceed to Checkout.".localized, style: AlertStyle.warning)
        return;
      }*/
      if sender.tag == 2345 {
        self.proceedToCheckout(ofType: .webcheckout)
      }
      else {
        self.proceedToCheckout(ofType: .applePay)
      }
    }
    
    func proceedToCheckout(ofType checkoutType: checkoutType) {
        let cartItems = DBManager.shared.cartProducts
        var customAttribute = [MobileBuySDK.Storefront.AttributeInput]()
        var zapietID = ""
        if customAppSettings.sharedInstance.zapietIntegration {
            if deliveryCellBtn {
                if isDeliveryPossible {
                    let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! CartPincodeChecker
                    if cell.pincodeTextfield.text == "" {
                        self.showErrorAlert(error: "Please enter pincode".localized)
                        return;
                    }
                    else if self.deliveryDate == "" {
                        self.view.showmsg(msg: "Please select delivery date".localized)
                        return
                    }
                    else if self.deliveryTime == "" {
                        self.view.showmsg(msg: "Please select delivery time".localized)
                        return
                    }
                    else {
                        customAttribute.append(MobileBuySDK.Storefront.AttributeInput.create(key: "Delivery-Date", value: deliveryDate))
                        customAttribute.append(MobileBuySDK.Storefront.AttributeInput.create(key: "Delivery-Time", value: self.deliveryTime))
                        customAttribute.append(MobileBuySDK.Storefront.AttributeInput.create(key: "Delivery-Location-Id", value: deliveryDateJSON[0]["id"].stringValue))
                        customAttribute.append(MobileBuySDK.Storefront.AttributeInput.create(key: "Checkout-Method", value: "delivery"))
                        zapietID = "M=D&L=\(deliveryDateJSON[0]["id"].stringValue)&D=\(deliveryDate)T\(self.deliveryTime)Z"
                        customAttribute.append(MobileBuySDK.Storefront.AttributeInput.create(key: "_ZapietId", value: zapietID))
                    }
                }
                else {
                    self.view.showmsg(msg: "Please check availability at another pincode".localized)
                    return
                    
                }
            }
            else if pickupCellBtn {
                
                if self.deliveryDate == "" {
                    self.view.showmsg(msg: "Please select delivery date".localized)
                    return
                }
                if self.deliveryTime == "" {
                    self.view.showmsg(msg: "Please select delivery time".localized)
                    return
                }
                customAttribute.append(MobileBuySDK.Storefront.AttributeInput.create(key: "Checkout-Method", value: "pickup"))
                customAttribute.append(MobileBuySDK.Storefront.AttributeInput.create(key: "Pickup-Location-Company", value: locationsArray[initialSelected]["company_name"].stringValue))
                customAttribute.append(MobileBuySDK.Storefront.AttributeInput.create(key: "Pickup-Location-Address-Line-1", value: locationsArray[initialSelected]["address_line_1"].stringValue))
                customAttribute.append(MobileBuySDK.Storefront.AttributeInput.create(key: "Pickup-Location-City", value: locationsArray[initialSelected]["city"].stringValue))
                customAttribute.append(MobileBuySDK.Storefront.AttributeInput.create(key: "Pickup-Location-Region", value: locationsArray[initialSelected]["region"].stringValue))
                customAttribute.append(MobileBuySDK.Storefront.AttributeInput.create(key: "Pickup-Location-Postal-Code", value: locationsArray[initialSelected]["postal_code"].stringValue))
                customAttribute.append(MobileBuySDK.Storefront.AttributeInput.create(key: "Pickup-Location-Country", value: locationsArray[initialSelected]["country"].stringValue))
                customAttribute.append(MobileBuySDK.Storefront.AttributeInput.create(key: "Pickup-Date", value: deliveryDate))
                customAttribute.append(MobileBuySDK.Storefront.AttributeInput.create(key: "Pickup-Time", value: self.deliveryTime))
                zapietID = "M=P&L=\(locationsArray[initialSelected]["id"].stringValue)Z"
                customAttribute.append(MobileBuySDK.Storefront.AttributeInput.create(key: "_ZapietId", value: zapietID))
            }
            
            
        }
        
        self.view.addLoader()
        Client.shared.createCartCheckout(with: cartItems!,custom:customAttribute, discountCode: self.applyDiscountCode) { response,error in
            self.view.stopLoader()
            guard let checkout = response else {return}
            self.proceedCheckout(checkout: checkout, checkoutType: checkoutType)
        }
    }
    
    func proceedCheckout(checkout: CartCheckoutViewModel,checkoutType: checkoutType)
    {
      let checkoutCreate: (CartCheckoutViewModel) -> Void = { checkout in
        switch checkoutType {
        case .webcheckout:
          self.openWebCheckout(checkout)
          
        case .applePay:
          Client.shared.fetchShop { shop in
            guard let _ = shop?.shopName else {
              print("Failed to fetch shop name.")
              return
            }
            Client.shared.fetchShop(completion: {
              shop in
              if let shopName = shop?.shopName{
             //  self.authorizePaymentFor(shopName, in: checkout)
              }
            })
          }
        }
      }
        checkoutCreate(checkout)
    }
    
    
    
    // ----------------------------------
    //  MARK: - Discount Codes -
    //
    
    func checkForAppOnlyDiscount(applyDiscountCode:String = "",completion: @escaping (String?) -> Void) {
   
          let url = "https://shopifymobileapp.cedcommerce.com/shopifymobilenew/discountpaneldataapi/getdiscountcodes?mid=\(Client.merchantID)&customer_code=\(applyDiscountCode)"
          print(url)
          self.view.addLoader()
          guard let urlRequest = url.getURL() else {return}
          var request = URLRequest(url: urlRequest)
          request.httpMethod="GET"
          let task=URLSession.shared.dataTask(with: request, completionHandler: {data,response,error in
            DispatchQueue.main.sync
            {
              do {
                guard let data = data else {return;}
                guard let json = try? JSON(data:data) else {return;}
                  print(json)
                  self.view.stopLoader()
                  if json["success"].stringValue == "true" {
                      self.discountCodeSDK = json["discount_code"].stringValue
                      self.discountCodeApplied = applyDiscountCode
                      completion(json["discount_code"].stringValue)
                  }
                  else {
                      self.discountCodeSDK = ""
                      self.discountCodeApplied = ""
                      completion(applyDiscountCode)
                  }
              }
            }
          })
          task.resume()
      
  }
  
   
}

extension NewCartViewController : UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
      return products.count > 0 ? 7 : 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.products.count > 0 ? self.products.count : 0
        }
        else if section == 1{
            return 1
        }
        else if(section == 2){
         return 1
        }
          else if section == 3 {
              if deliveryCellBtn {
                  return 1
              }
              else if pickupCellBtn {
                  return locationArray.count + 2
              }
              else {
                  return 1
              }
          }
          else if section == 4 {
              if isDeliveryPossible {
                  return 2
              }
              else {
                  return 0
              }
          }
        else if section == 5{
            return 0
//            guard let count = upsellProducts?.count else {
//              return 0
//            }
//            if(count == 0){
//              return 0
//            }
//            return 1;
        }
        
      else {
          return 0
//        guard let count = crosssellProducts?.count else {
//          return 0
//        }
//        if(count == 0){
//          return 0
//        }
//        return 1;
      }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      if(indexPath.section == 0){
        return UITableView.automaticDimension
      }
        if indexPath.section == 1 {
            return self.showDiscountSection ? 135 : 50
        }
        else if(indexPath.section == 2){
            if customAppSettings.sharedInstance.zapietIntegration {
                return 175
            }
            else {
                return 0
            }
        }
          else if indexPath.section == 3 {
              if customAppSettings.sharedInstance.zapietIntegration {
                  if deliveryCellBtn {
                      return 120
                  }
                  else if pickupCellBtn {
                      if indexPath.row == 0 {
                          return 60
                      }
                      else if indexPath.row == 1 {
                          return 50
                      }
                      else {
                          if isDataLoaded {
                              return UITableView.automaticDimension
                          }
                          else {
                              return 0
                          }
                      }
                  }
                  else {
                      return 50
                  }
              }
              else {
                  return 0
              }
          }
          else if indexPath.section == 4 {
              if customAppSettings.sharedInstance.zapietIntegration {
                  if isDeliveryPossible {
                      if indexPath.row == 0 {
                          return 60
                      }
                      else {
                          if isDateSelected {
                              return 60
                          }
                          else {
                              return 0
                          }
                      }
                  }
                  else {
                      return 0
                  }
              }
              else {
                  return 0
              }
          }
      
        else if indexPath.section == 5
      {
            return layoutHeight["upsell"] ?? 0
      }
        else {
            return layoutHeight["crosssell"] ?? 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewCartProductCell", for: indexPath) as! NewCartProductCell
            cell.delegate = self
            cell.configure(from: products[indexPath.row])
            cell.parent=self
            cell.cardView()
            return cell
            
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: FlitsCartDiscountTVCell.className) as! FlitsCartDiscountTVCell
            cell.discountCodeDropDown.titleLabel?.font = mageFont.mediumFont(size: 15.0)
            cell.discountCodeDropDown.addTarget(self, action: #selector(showHideDiscountSection(_:)), for: .touchUpInside)
            if self.showDiscountSection {
                cell.textFieldHeight.constant = 40
                cell.flitsCodeTextField.isHidden = false
                cell.applyFlitsCode.isHidden = false
                cell.wholesaleNote.isHidden = true
                cell.wholesaleNoteHeight.constant = 0
                cell.dropdownImage.image = UIImage(named: "bottomArrow")
            
            }
            else {
           
                cell.flitsCodeTextField.isHidden = true
                cell.applyFlitsCode.isHidden = true
                cell.textFieldHeight.constant = 0
                cell.wholesaleNote.isHidden = true
                cell.wholesaleNoteHeight.constant = 0
                cell.dropdownImage.image = UIImage(named: "rightArrow")
            }
            var discCode = ""
            cell.applyFlitsCode.rx.tap.bind{[weak self] in
                discCode = cell.flitsCodeTextField.text ?? ""
                if discCode == "" {
                    self?.view.showmsg(msg: "Please enter discount code".localized)
                    return;
                }
                cell.flitsDiscountCode.text   = discCode
                self?.applyDiscountCode = discCode
                self?.applyShopifyDiscountCode(discountCode: self?.applyDiscountCode ?? "")
                cell.codeViewHeight.constant  = 30
                cell.codeViewContainer.isHidden = false
            }.disposed(by: disposeBag)
            
            cell.removeFlitsCode.rx.tap.bind{[weak self] in
                cell.flitsCodeTextField.text  = discCode
                self?.applyDiscountCode = ""
                self?.checkForCartUpdate()
                cell.codeViewHeight.constant  = 0
                cell.codeViewContainer.isHidden = true
            }.disposed(by: disposeBag)
            return cell
        }
        else if(indexPath.section == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartPickupCell", for: indexPath) as! CartPickupCell
            cell.deliveryBtn.isHidden = self.deliveryEligible ? false : true
            cell.pickupBtn.isHidden = self.pickupEligible ? false : true
            cell.shippingBtn.isHidden = self.shippingEligible ? false : true
            cell.setupData()
            if deliveryCellBtn {
                cell.deliveryBtn.backgroundColor = UIColor(hexString: "#dadada")
            }
            else if pickupCellBtn {
                cell.pickupBtn.backgroundColor = UIColor(hexString: "#dadada")
            }
            else {
                cell.shippingBtn.backgroundColor = UIColor(hexString: "#dadada")
            }
            cell.pickupBtn.addTarget(self, action: #selector(pickupBTnPressed(_:)), for: .touchUpInside)
            cell.deliveryBtn.addTarget(self, action: #selector(deliveryBtnPressed(_:)), for: .touchUpInside)
            cell.shippingBtn.addTarget(self, action: #selector(shippingBTnPressed(_:)), for: .touchUpInside)
            return cell
            
          
        }
        else if indexPath.section == 3 {
            if deliveryCellBtn {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CartPincodeChecker", for: indexPath) as! CartPincodeChecker
                cell.pincodeTextfield.text = ""
                cell.resultLabel.text = ""
                cell.headingLabel.text = "Find out if we deliver to you".localized
                cell.pincodeTextfield.placeholder = "Enter your postal code".localized
                if Client.locale == "ar" {
                    cell.pincodeTextfield.textAlignment = .right
                }
                else {
                    cell.pincodeTextfield.textAlignment = .left
                }
                cell.pincodeTextfield.font = mageFont.regularFont(size: 15.0)
                cell.resultLabel.font = mageFont.regularFont(size: 15.0)
                cell.headingLabel.font = mageFont.regularFont(size: 15.0)
                cell.searchPincode.addTarget(self, action: #selector(searchForPincode(_:)), for: .touchUpInside)
                return cell
            }
            else if pickupCellBtn {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CartCalendarCell", for: indexPath) as! CartCalendarCell
                    if deliveryDate != "" {
                        cell.calendarBtn.setTitle(deliveryDate, for: .normal)
                    }
                    else {
                        cell.calendarBtn.setTitle("Select delivery date".localized, for: .normal)
                    }
                    
                    cell.calendarBtn.addTarget(self, action: #selector(showDeliveryDateLayout(_:)), for: .touchUpInside)
                    return cell
                }
                else if indexPath.row == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryTimeCell", for: indexPath) as! DeliveryTimeCell
                    if self.deliveryTime != "" {
                        cell.deliveryTimeBtn.setTitle(self.deliveryTime, for: .normal)
                    }
                    else {
                        cell.deliveryTimeBtn.setTitle("Select delivery time".localized, for: .normal)
                    }
                    
                    cell.deliveryTimeBtn.addTarget(self, action: #selector(showTimeSlots(_:)), for: .touchUpInside)
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CartAddressCell", for: indexPath) as! CartAddressCell
                    let rowData = indexPath.row - 2
                    cell.addressLabel.text = locationArray[rowData]
                    cell.addressLabel.numberOfLines = 0
                    if rowData == initialSelected {
                        cell.imageBtn.setImage(UIImage(named: "radio_checked"), for: .normal)
                    }
                    else {
                        cell.imageBtn.setImage(UIImage(named: "radio_unchecked"), for: .normal)
                    }
                    cell.imageBtn.tag = rowData
                    cell.imageBtn.addTarget(self, action: #selector(selectAnotherAddress(_:)), for: .touchUpInside)
                    return cell
                }
               // let cell = tableView.dequeueReusableCell(withIdentifier: <#T##String#>, for: indexPath)
                
            
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CartShippingCell",for: indexPath) as! CartShippingCell
                cell.textLabel?.text = "Please click the checkout button to continue".localized
                cell.textLabel?.font = mageFont.regularFont(size: 15.0)
                cell.textLabel?.textColor = UIColor.black
                return cell
            }
        }
        else if indexPath.section == 4 {
  //          let cell = tableView.dequeueReusableCell(withIdentifier: "CartCalendarCell", for: indexPath) as! CartCalendarCell
  //          cell.calendarBtn.setTitle("Select delivery date and time".localized, for: .normal)
  //          cell.calendarBtn.titleLabel?.font  = mageFont.regularFont(size: 15.0)
  //          cell.calendarBtn.addTarget(self, action: #selector(showDeliveryDateLayout(_:)), for: .touchUpInside)
  //          return cell
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CartCalendarCell", for: indexPath) as! CartCalendarCell
                cell.calendarBtn.setTitle("Select delivery date and time", for: .normal)
                cell.calendarBtn.addTarget(self, action: #selector(showDeliveryDateLayout(_:)), for: .touchUpInside)
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryTimeCell", for: indexPath) as! DeliveryTimeCell
                cell.deliveryTimeBtn.setTitle("Select delivery time".localized, for: .normal)
                cell.deliveryTimeBtn.addTarget(self, action: #selector(showTimeSlots(_:)), for: .touchUpInside)
                return cell
            }
        }
        
        else if indexPath.section == 5{
            
            let cell       = tableView.dequeueReusableCell(withIdentifier: "BundleProductsCell", for: indexPath) as! SimilarProductsCell
            cell.products = upsellProducts
            cell.parent=self
            cell.recommendedName = "upsell"
            cell.delegate = self
            cell.layoutDelegate = self
            cell.updateDelegate=self
            cell.headingLabel.text = "FREQUENTLY BOUGHT TOGETHER PRODUCTS".localized
            cell.headingLabel.font = mageFont.regularFont(size: 15.0)
            cell.configure()
            cell.headingLabel.textColor = UIColor.darkGray
            cell.productsCollectionView.backgroundColor = UIColor.white
            cell.backgroundColor = UIColor.white
            return cell;
            
       
      }
        else {
            let cell       = tableView.dequeueReusableCell(withIdentifier: "CrosssellProductsCell", for: indexPath) as! SimilarProductsCell
            cell.products = crosssellProducts
            cell.parent=self
            cell.recommendedName = "crosssell"
            cell.delegate = self
            cell.updateDelegate=self
            cell.layoutDelegate = self
            cell.headingLabel.text = "YOU MAY ALSO LIKE".localized
            cell.headingLabel.font = mageFont.regularFont(size: 15.0)
            cell.configure()
            cell.headingLabel.textColor = UIColor.darkGray
            cell.productsCollectionView.backgroundColor = UIColor.white
            cell.backgroundColor = UIColor.white
            return cell;
        }
    }
    
    func applyShopifyDiscountCode(discountCode:String="")
    {
        self.checkForAppOnlyDiscount(applyDiscountCode: discountCode) { discCode in
            self.applyDiscountCode = discCode ?? ""
            self.checkForCartUpdate()
        }
    }
    
    @objc func showHideDiscountSection(_ sender : UIButton) {
        self.showDiscountSection.toggle()
        self.tableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .fade)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if(indexPath.section == 0){
        if indexPath.row < DBManager.shared.cartProducts?.count ?? 0  {
          let productViewController=ProductVC()//:ProductViewController = self.storyboard!.instantiateViewController()
          productViewController.productId = cartManager.getCartProductID(product: products[indexPath.row])
          productViewController.isProductLoading = true;
          self.navigationController?.pushViewController(productViewController, animated: true)
        }
      }
    }
  }

extension NewCartViewController:productClicked{
  func productCellClicked(product: ProductViewModel, sender: Any) {
    let productViewController=ProductVC()
    productViewController.product = product
    self.navigationController?.pushViewController(productViewController, animated: true)
  }
}

extension NewCartViewController: RecommendedProductsLayoutUpdate{
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

extension NewCartViewController: updateCartData {
  func reloadcartData() {
    self.checkForCartUpdate()
  }
}


extension NewCartViewController:cartQuantityChange {
  func updateCartQuantity(sender: NewCartProductCell, quantity: Int, model: CartLineItemViewModel?) {
    guard let index = tableView.indexPath(for: sender) else {return}
    if quantity <= 0{
      cartManager.deleteCartQty(products[index.row])
    }else{
      cartManager.updateCartQuantityProduct(products[index.row], with: quantity)
    }
      self.applyDiscountCode=""
      self.cartQtyLabel.text = " (\((CartManager.shared.cartCount == 0 ? nil : CartManager.shared.cartCount.description) ?? "") "+"Items)".localized
    self.checkForCartUpdate()
  }
}

extension NewCartViewController:DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return self.cartManager.cartCount == 0
    }
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        let custom = EmptyView()
        custom.delegate = self;
        custom.configure(imageName: "emptyCart", title: EmptyData.cartEmptyTitle.localized, subtitle: EmptyData.cartDescription.localized)
        return custom;
    }
}


extension NewCartViewController {
    func openWebCheckout(_ checkout: CartCheckoutViewModel){
        let vc:WebViewController = (self.storyboard!.instantiateViewController())
        vc.checkoutId = checkout.id
        let subTotal    = Double(truncating: (CartManager.shared.cartSubtotal) as NSNumber)
        vc.cartSubTotal = subTotal
        vc.url = checkout.checkoutUrl
        if Client.shared.isAppLogin() {
            vc.isLoginRequired=true
            vc.ischeckout=true
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func authorizePaymentFor(_ shopName: String, in checkout: CartCheckoutViewModel) {
      
     /* let payCurrency = PayCurrency(currencyCode: checkout.currencyCode, countryCode: "CA")
      
      let payItems    = checkout.lineItems.map { item in
        PayLineItem(price: item.individualPrice, quantity: item.quantity)
      }
      
      let payCheckout = PayCheckout(
        id:              checkout.id,
        lineItems:       payItems,
        giftCards:       nil,
        discount:        nil,
        shippingDiscount: nil,
        shippingAddress: nil,
        shippingRate:    nil,
        currencyCode:    checkout.currencyCode, totalDuties: 0.0,
        subtotalPrice:   checkout.subtotalPrice,
        needsShipping:   checkout.requiresShipping,
        totalTax:        checkout.totalTax,
        paymentDue:      checkout.paymentDue
      )
      let paySession      = PaySession(shopName: shopName, checkout: payCheckout, currency: payCurrency, merchantID: Client.merchantID)
      paySession.delegate = self
      self.paySession     = paySession
      paySession.authorize()*/
    }
    
}
extension NewCartViewController : FSCalendarDelegate, FSCalendarDataSource{
    @objc func pickupBTnPressed(_ sender : UIButton) {
        self.pickupCellBtn = true
        self.deliveryCellBtn = false
        self.shippingBtn = false
        self.isDeliveryPossible = false
        self.isDateSelected = false
        self.deliveryTime = ""
        self.deliveryDate = ""
        sender.backgroundColor = UIColor(hexString: "#dadada")
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! CartPickupCell
        cell.deliveryBtn.backgroundColor = UIColor.white
        cell.shippingBtn.backgroundColor = UIColor.white
        
  //      self.getLocation()
        self.tableView.reloadData()
        
    }
    
    @objc func deliveryBtnPressed(_ sender : UIButton) {
        self.deliveryCellBtn = true
        self.pickupCellBtn = false
        self.shippingBtn = false
        self.isDeliveryPossible = false
        self.isDateSelected = false
        self.deliveryTime = ""
        self.deliveryDate = ""
        sender.backgroundColor = UIColor(hexString: "#dadada")
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! CartPickupCell
        cell.pickupBtn.backgroundColor = UIColor.white
        cell.shippingBtn.backgroundColor = UIColor.white
        self.deliveryTime = ""
        self.deliveryDate = ""
        
        tableView.reloadSections(NSIndexSet(index: 3) as IndexSet, with: .fade)
        tableView.reloadSections(NSIndexSet(index: 4) as IndexSet, with: .fade)
    }
    
    @objc func showDeliveryDateLayout(_ sender : UIButton) {
        calendarView = CalendarView(frame: CGRect(x: 0, y: 0 , width: self.view.frame.width - 20, height: 250))
        calendarView.center = CGPoint(x: view.frame.size.width  / 2, y: view.frame.size.height/2 - 60)//self.view.center
        self.view.addSubview(calendarView)
        calendarView.calendar.delegate = self
        calendarView.calendar.dataSource = self
        calendarView.tag = 1221;
        calendarView.headingLabel.text = "SELECT DATE".localized
        calendarView.doneBtn.setTitle("DONE".localized, for: .normal)
        calendarView.cancelBtn.setTitle("CANCEL".localized, for: .normal)
        calendarView.headingLabel.font = mageFont.mediumFont(size: 16.0)
        calendarView.doneBtn.titleLabel?.font = mageFont.mediumFont(size: 15.0)
        calendarView.cancelBtn.titleLabel?.font = mageFont.mediumFont(size: 15.0)
        calendarView.cancelBtn.addTarget(self, action: #selector(cancelBtnPressed(_:)), for: .touchUpInside)
        calendarView.view.layer.borderWidth = 1.0
        calendarView.view.layer.borderColor = UIColor.black.cgColor
        calendarView.doneBtn.addTarget(self, action: #selector(dateSelected(_:)), for: .touchUpInside)
    }
    
    @objc func cancelBtnPressed(_ sender : UIButton) {
        self.view.viewWithTag(1221)?.removeFromSuperview()
    }
    
    @objc func showTimeSlots(_ sender : UIButton) {
        let dropDown = DropDown(anchorView: sender)
        var dataSource = [String]()
        if deliveryCellBtn {
            let timeFrom = deliveryDateJSON[0]["available_from"].stringValue
            let timeTo = deliveryDateJSON[0]["available_until"].stringValue
            dataSource.append("\(timeFrom) : \(timeTo)")
        }
        else if pickupCellBtn {
            let weekDay = self.deliveryWeekDay.lowercased()
            if  let weekJSon = self.pickupJSON["daysOfWeek"]["\(weekDay)"] as? SwiftyJSON.JSON{
                var minHour = ((weekJSon["min"]["hour"].stringValue ) as NSString).integerValue
                let maxHour = ((weekJSon["max"]["hour"].stringValue ) as NSString).integerValue
                let minMinute = (weekJSon["min"]["minute"].stringValue)
              //  let maxMinute = ((weekJSon["max"]["minute"].stringValue ) as NSString).integerValue
                while minHour < maxHour {
                    var str = "\(minHour):\(minMinute) - "
                    minHour += 1;
                    str += "\(minHour):\(minMinute)"
                    dataSource.append(str)
                }
            }
           
        }
        dropDown.dataSource = dataSource
        dropDown.selectionAction = {[unowned self](index, item) in
            sender.setTitle(item, for: UIControl.State());
            self.deliveryTime = item
        }
        
        dropDown.bottomOffset = CGPoint(x: 0, y:sender.bounds.height)
        if dropDown.isHidden {
            dropDown.setAlignment(dropDown);
            let _ = dropDown.show();
        } else {
            dropDown.hide();
        }
    }
    
    func timeConversion24(time12: String) -> String {
        let dateAsString = time12
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"//"h:mm a"
        let date = dateFormatter.date(from: dateAsString)

        dateFormatter.dateFormat = "h:mm a"
        let date24 = dateFormatter.string(from: date ?? Date())
        print(date24)
        return date24
    }
    
    @objc func dateSelected(_ sender : UIButton) {
        if deliveryCellBtn {
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 4)) as? CartCalendarCell {
                cell.calendarBtn.setTitle(self.deliveryDate, for: .normal)
                self.getDeliveryTime(locationId: self.deliveryJSON["id"].stringValue, deliveryDate: self.deliveryDate)
            }
        }
        else if pickupCellBtn {
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as? CartCalendarCell {
                cell.calendarBtn.setTitle(self.deliveryDate, for: .normal)
            }
        }
        
        self.view.viewWithTag(1221)?.removeFromSuperview()
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if deliveryCellBtn {
            self.deliveryDate = dateFormatter.string(from: date)
            self.deliveryWeekDay = date.weekdayName
            self.isDateSelected = true
            self.tableView.reloadSections(IndexSet(integer: 4), with: .fade)
        }
        else if pickupCellBtn {
            self.deliveryDate = dateFormatter.string(from: date)
            self.deliveryWeekDay = date.weekdayName
            self.isDateSelected = true
            self.tableView.reloadSections(IndexSet(integer: 3), with: .fade)
        }
       
    }

    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let day = Calendar.current.component(.weekday, from: date)
        for item in invalidDays {
            if item.intValue == day {
                return false
            }
        }
        return true
     //   let invalidDate = (day as NSString).integerValue + 1
        
    }
  
    func minimumDate(for calendar: FSCalendar) -> Date {
        if minDate != "" {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let minDAte = dateFormatter.date(from: minDate)
            let finalDAte = Calendar.current.date(byAdding: .day, value: 1, to: minDAte!) ?? Date()
            self.minDateForCalendar = finalDAte
            return finalDAte
            
        }
        else {
            return Date()
        }
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        if maxDate != "" {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let maxD = dateFormatter.date(from: maxDate) ?? Date()
            self.maxDateForCalendar = maxD
            return maxD
        }
        else {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let finalDAte = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
            return finalDAte
        }
    }
    
    @objc func shippingBTnPressed(_ sender :UIButton) {
        self.shippingBtn = true
        self.deliveryCellBtn = false
        self.pickupCellBtn = false
        self.isDeliveryPossible = false
        self.isDateSelected = false
        self.deliveryTime = ""
        self.deliveryDate = ""
        sender.backgroundColor = UIColor(hexString: "#dadada")
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! CartPickupCell
        cell.pickupBtn.backgroundColor = UIColor.white
        cell.deliveryBtn.backgroundColor = UIColor.white
        tableView.reloadSections(NSIndexSet(index: 3) as IndexSet, with: .fade)
        tableView.reloadSections(NSIndexSet(index: 4) as IndexSet, with: .fade)
    }
    @objc func selectAnotherAddress(_ sender : UIButton) {
        initialSelected = sender.tag
        self.selectedAddress = self.locationArray[sender.tag]
        tableView.reloadSections(NSIndexSet(index: 3) as IndexSet, with: .fade)
    }
    
    @objc func searchForPincode(_ sender : UIButton) {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! CartPincodeChecker
        if cell.pincodeTextfield.text == "" {
            self.showErrorAlert(error: "Please enter pincode".localized)
            return;
        }
        let pincode = cell.pincodeTextfield.text ?? ""
        self.getDeliveryLocation(pincode: pincode) { json in
            if json?["id"].stringValue != "" {
                self.getDeliveryDates(locationId: json?["id"].stringValue ?? "") { data in
                    cell.resultLabel.text = "Good news! We can deliver to you.".localized
                    cell.resultLabel.textColor = UIColor.gray
                    self.showDeliveryDate = true
                    self.isDeliveryPossible = true
                    self.maxDate = data!["maxDate"].stringValue
                    self.minDate = data!["minDate"].stringValue
                    self.invalidDays = data!["disabled"].arrayValue
                    self.deliveryJSON = json!
                    self.tableView.reloadSections(IndexSet(integer: 4), with: .fade)
                }
                
            }
            else {
                cell.resultLabel.text = json?["error"]["message"].stringValue
                cell.resultLabel.numberOfLines = 0
                cell.resultLabel.textColor = UIColor.red
                self.isDeliveryPossible = false
                self.tableView.reloadSections(IndexSet(integer: 4), with: .fade)
            }
        }
    }
}
