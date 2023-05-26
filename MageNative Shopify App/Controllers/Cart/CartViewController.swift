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
import SafariServices
import UserNotifications
import RxSwift
import RxCocoa
import PassKit
import FSCalendar
import MobileBuySDK
import AlgoliaSearchClient
import SwiftyJSON
import Alamofire
import CommonCrypto

public enum checkoutType{
    case webcheckout
    case applePay
}

class CartViewController: BaseViewController , FSCalendarDelegate , FSCalendarDataSource , FSCalendarDelegateAppearance{
    
    @IBOutlet weak var tableView: UITableView!
    
    var cartManager = CartManager.shared
    var products = [LineItemViewModel]()
    var crosssellProducts: Array<ProductViewModel>?
    var layoutHeight = [String:CGFloat]()
    var upsellProducts: Array<ProductViewModel>?
    var checkoutViewModelArray: CheckoutViewModel?
    let disposeBag = DisposeBag()
    var giftCard = ""
    var paySession: PaySession?
    var appleCheckoutCompleted=false
    var cartQtyError = 0
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
    var discountCodeApplied = String()
    var discountCodeSDK = String()
    var deliveryDateJSON = SwiftyJSON.JSON()
    var wholesaleDataFetched = false
    var wholesaleDiscountedPrice=0.0
    var showGiftSection = false
    var showDiscountSection = false
    var applyDiscountCode = ""
    var previousTotalCartValue:Decimal=0.0
    var wholeSalePercentage:Double=0.0
    var discCode = ""
    
    var isDateSelected = false
    
    var dict = [String : Any]()
    var flitsDC: String?
    var flitsSpendRuleID: String?
    var customerID: String?
    let flitsCellIndexPath = IndexPath(row: 1, section: 4)
    var applyFlitsCouponCode = Bool()
    var pickupEligible = false
    var shippingEligible = false
    var deliveryEligible = false
    var discountsCoupons: [CouponData]?
    
    @IBOutlet weak var checkoutHeight: NSLayoutConstraint!
    //@IBOutlet weak var grandTotalLabel: UILabel!
    //@IBOutlet weak var grandTotalLbl: UILabel!
    //@IBOutlet weak var discountStackHeight: NSLayoutConstraint!
    //  @IBOutlet weak var discountStack: UIStackView!
    
    @IBOutlet weak var shippingNoticeLabel: UILabel!
    @IBOutlet weak var clearCartCiew: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var checkoutOptions: UIStackView!
    @IBOutlet weak var checkoutView: UIView!
    @IBOutlet weak var totalAmount: UILabel!
    
    @IBOutlet weak var totalAmountView: UIStackView!
    //@IBOutlet weak var discStackHeight: NSLayoutConstraint!
    // @IBOutlet weak var discStack: UIStackView!
    // @IBOutlet weak var discountedLabel: UILabel!
    //@IBOutlet weak var discountlbl: UILabel!
    @IBOutlet weak var totalAmt: UILabel!
    
    @IBOutlet var containerView: UIView!
    let shimmer = customShimmerView(cellsArray: [cartproductShimmerTC.reuseID], productListCount: 10)
    var cartQtyLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.backgroundColor = UIColor(light: UIColor(hexString: "#F2F2F2"), dark: UIColor(hexString: "#0F0F0F"))
        //add shimmer
        tableView.backgroundColor = UIColor(light: UIColor(hexString: "#F2F2F2"), dark: UIColor(hexString: "#0F0F0F"))
        view.addSubview(shimmer)
        shimmer.frame = view.bounds
        view.bringSubviewToFront(shimmer)
        setupTable()
        
        shippingNoticeLabel.text = "Taxes and shipping calculated at checkout".localized
        shippingNoticeLabel.textColor = UIColor(light: UIColor(hexString: "#383838"),dark: UIColor.provideColor(type: .cartVc).textColor)
        shippingNoticeLabel.font = mageFont.setFont(fontWeight: "light", fontStyle: "light", fontSize: 12)
        //self.title = "Cart".localized
        
        let titleWidth = ("Bag".localized as NSString).size(withAttributes: [NSAttributedString.Key.font: mageFont.mediumFont(size: 15)]).width//width calculate
        
        let titleQtyWidth = (" (\((CartManager.shared.cartCount == 0 ? nil : CartManager.shared.cartCount.description) ?? "") "+"Items)".localized as NSString).size(withAttributes: [NSAttributedString.Key.font: mageFont.regularFont(size: 12)]).width//width calculate
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: titleWidth, height: 30))
        title.font = mageFont.mediumFont(size: 15)
        title.text = "Bag".localized
        title.textColor =  UIColor(light: Client.navigationThemeData?.icon_color ?? .white, dark: .white)
        cartQtyLabel.frame = CGRect(x: 0, y: 0, width: titleQtyWidth, height: 30)
        cartQtyLabel.font = mageFont.regularFont(size: 12)
        if CartManager.shared.cartCount == 0{
            self.cartQtyLabel.text = ""
        }else{
            self.cartQtyLabel.text = " (\(CartManager.shared.cartCount.description) "+"Items)".localized
        }
        self.cartQtyLabel.textColor = UIColor(light: Client.navigationThemeData?.icon_color ?? .white, dark: .white)
        let stack = UIStackView(arrangedSubviews: [title, cartQtyLabel])
        stack.distribution = .fill
        stack.axis         = .horizontal
        navigationItem.leftBarButtonItems?.append(UIBarButtonItem(customView: stack))
        self.navigationController?.navigationBar.tintColor = Client.navigationThemeData?.icon_color
    }
    
    func getCoupons() {
        let params = ["mid": Client.merchantID]
        Client.shared.fetchCoupons(query: params) { couponsData, error in
            if let coupons = couponsData {
                self.discountsCoupons = coupons.data
                self.tableView.reloadData()
            }
        }
    }
    
    func setUpCheckoutView() {
        if(DBManager.shared.cartProducts?.count ?? 0 > 0){
            totalAmount.textAlignment = Client.shared.getLanguageCode().rawValue.lowercased() == "ar" ? .left : .right
            self.checkoutView.isHidden=false
            self.totalAmt.text = "Sub Total".localized
            self.totalAmt.font = mageFont.regularFont(size: 14.0)
            self.totalAmount.font = mageFont.mediumFont(size: 16.0)
            self.checkoutView.cardView()
            if self.checkoutOptions.arrangedSubviews.count > 0 {
                for view in checkoutOptions.arrangedSubviews {
                    view.removeFromSuperview()
                }
            }
            let webCheckout = Button()
            webCheckout.setTitle("Proceed to Checkout".localized, for: .normal)
            webCheckout.backgroundColor = UIColor.AppTheme()
            webCheckout.setTitleColor(UIColor.textColor(), for: .normal)
            webCheckout.addTarget(self, action: #selector(self.proceedCheckout(sender:)), for: .touchUpInside)
            webCheckout.tag = 2345
            webCheckout.titleLabel?.font = mageFont.regularFont(size: 16)
            self.checkoutOptions.addArrangedSubview(webCheckout)
            if AppSetUp.applePayEnable {
                //Adding Apple Pay Button if supported
                if PKPaymentAuthorizationController.canMakePayments() {
                    let applePay = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black)
                    applePay.addTarget(self, action: #selector(self.proceedCheckout(sender:)), for: .touchUpInside)
                    self.checkoutOptions.addArrangedSubview(applePay)
                }
            }
            if let checkout = checkoutViewModelArray{
                if checkout.paymentDue < self.previousTotalCartValue {
                    totalAmount.text = "\(Currency.formatter.string(from: self.previousTotalCartValue as NSDecimalNumber)!)"
                }
                else {
                    totalAmount.text = "\(Currency.formatter.string(from: checkout.lineItemsTotal as NSDecimalNumber)!)"
                }
                if self.applyDiscountCode != "" || checkout.discountPercentage != nil || checkout.discountAmount != nil{
                    self.checkoutHeight.constant = 100// 170
                    totalAmountView.backgroundColor = UIColor(light: .white,dark:  UIColor.black)
                    checkoutView.backgroundColor = UIColor(light: .white,dark: UIColor.black)
                    self.totalAmount.text = "\(Currency.formatter.string(from: checkout.paymentDue as NSDecimalNumber)!)"
                }
                else {
                    self.checkoutHeight.constant = 100
                    totalAmountView.backgroundColor = UIColor(light: .white,dark:  UIColor.black)
                    checkoutView.backgroundColor = UIColor(light: .white,dark: UIColor.black)
                }
            }
            else{
                totalAmount.text = Currency.stringFrom(CartManager.shared.cartSubtotal)
            }
        }
        else {
            self.checkoutView.isHidden=true
            self.checkoutHeight.constant = 0
        }
    }
    
    @objc func proceedCheckout(sender:UIButton) {
        
        //Checking flits code status
        
        /*  if self.cartQtyError > 0 {
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
    
    func setUpClearCartView() {
        self.clearCartCiew.backgroundColor = UIColor(light: UIColor(hexString: "#f2f2f2"),dark: UIColor(hexString: "#0F0F0F"))
        
        self.clearCartCiew.isHidden=false
        if(DBManager.shared.cartProducts?.count ?? 0 > 0){
            self.clearCartCiew.isHidden=false
            self.clearButton.setImage(UIImage(named: "delete_accountN"), for: .normal)
            self.clearButton.setTitle("", for: .normal)
            self.clearButton.backgroundColor = .clear
            self.clearButton.tintColor = UIColor(light: .black,dark: .white)
            self.clearButton.titleLabel?.font = mageFont.regularFont(size: 15.0)
            self.clearButton.addTarget(self, action: #selector(deleteCompleteCart(_:)), for: .touchUpInside)
            self.countLabel.text = "Click here to clear your all bag item".localized
            self.countLabel.textColor = UIColor(light: UIColor(hexString: "#383838"),dark: UIColor.provideColor(type: .cartVc).textColor)
            self.countLabel.font = mageFont.regularFont(size: 12.0)
            
        }
        else
        {
            self.clearCartCiew.isHidden=true
        }
    }
    
    func checkForFirstDiscount(customerId: String) {
        
        let params: [String: String] = ["merchant": Client.merchantID,"customer_id": customerId]

        Client.shared.checkForFirstSaleDiscount(query: params) { json, error in
            if let response = json {
                let isOrderedBefore = response["success"].boolValue
                if isOrderedBefore == false {
                    self.applyDiscountCode(discountCode: Client.firstOrderCouponCode)
                    
                } else {
                    
                }
            }
            
        }
    }
    
    //JS
    func getCustomerID(){
        Client.shared.fetchCustomerDetails(completeion: {
            response,error   in
            if let response = response {
                self.customerID = response.customerId?.components(separatedBy: "/").last ?? ""
                if DBManager.shared.cartProducts?.count ?? 0 > 0{
                    if customAppSettings.sharedInstance.firstOrderDiscount {
                        self.checkForFirstDiscount(customerId: self.customerID ?? "")
                    }
                }
               
            }
        })
    }
    
    func availableSpendRules(){
        
        if let cell =  self.tableView.cellForRow(at: self.flitsCellIndexPath) as? FlitsCartDiscountTVCell {
            cell.initialStage()
            self.applyFlitsCouponCode = false
        }
        
        guard let encoded = dict.convtToJson().base64Encoded(),let cid = self.customerID else{return}
        Networking.shared.sendRequestUpdated(api: "https://app.getflits.com/api/1/\(Client.flitsUserId)/\(cid)/credit/get_spent_rules?token=\(Client.flitsToken)", type: .POST, params: ["cart":encoded], includePureURLString: true) { [weak self] (result) in
            switch result{
            case .success(let data):
                do{
                    let json                     = try JSON(data: data)
                    print("Available SPend Rules ==",json)
                    print("Rule_ID",json["code"]["rules"][0]["rule"]["id"].stringValue)
                    self?.flitsSpendRuleID = json["code"]["rules"][0]["rule"]["id"].stringValue
                    let decoder                  = JSONDecoder()
                    decoder.keyDecodingStrategy  = .convertFromSnakeCase
                    self?.applyStoreCredits()
                }catch let error {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func applyStoreCredits(){
        var checkoutID = String()
        if DBManager.shared.cartProducts?.count ?? 0 > 0 {
            // Checkout Id MD5
            let cartItems = DBManager.shared.cartProducts!
            Client.shared.createCheckout(with: cartItems) { checkout,error, errorIfCheckoutIsNil   in
                if let checkout = checkout {
                    checkoutID = checkout.id
                    //Test:
                    print(checkoutID)
                    let md5Data = self.MD5(string:checkoutID)
                    
                    let md5Hex =  md5Data.map { String(format: "%02hhx", $0) }.joined()
                    print("md5Hex: \(md5Hex)")
                    // End
                    
                    guard let encoded = self.dict.convtToJson().base64Encoded(), let flitsSpendRuleID = self.flitsSpendRuleID,let cid = self.customerID else{return}
                    let params = ["spent_rule_id":flitsSpendRuleID,"cart_token":md5Hex,"data":encoded]
                    Networking.shared.sendRequestUpdated(api: "https://app.getflits.com/api/1/\(Client.flitsUserId)/\(cid)/credit/apply_credit?token=\(Client.flitsToken)", type: .POST, params: params, includePureURLString: true) { (result) in
                        switch result{
                        case .success(let data):
                            do{
                                let json                     = try JSON(data: data)
                                print("applyStoreCredits ==",json)
                                let decoder                  = JSONDecoder()
                                decoder.keyDecodingStrategy  = .convertFromSnakeCase
                                
                                self.flitsDC = json["code"].stringValue
                                if let cell =  self.tableView.cellForRow(at: self.flitsCellIndexPath) as? FlitsCartDiscountTVCell {
                                    
                                    cell.flitsDiscountCode.text   = self.flitsDC
                                    cell.codeViewHeight.constant  = 30
                                    
                                    cell.codeViewContainer.isHidden = false
//                                    self.applyDiscountCode(discountCode: flitsDC)
                                }
                                self.tableView.reloadRows(at: [self.flitsCellIndexPath], with: UITableView.RowAnimation.none)
                                guard  let cell =  self.tableView.cellForRow(at: self.flitsCellIndexPath) as? FlitsCartDiscountTVCell else {return}
//                                cell.initialStage()
                                
                            }catch let error {
                                print(error)
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
        }
    }
    //END
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        print("Count$$")
        self.getCoupons()
        self.applyDiscountCode = ""
        self.showDiscountSection=false
        self.showGiftSection=false
        self.pickupEligible = false
        self.shippingEligible = false
        self.deliveryEligible = false
        deliveryCellBtn=true
        pickupCellBtn=false
        shippingBtn=false
        if Client.shared.isAppLogin(){
            self.getCustomerID()
           
        }
       
        //    self.checkForCartUpdate()
        
        if DBManager.shared.cartProducts?.count ?? 0 > 0 {
            if customAppSettings.sharedInstance.zapietIntegration {
                self.checkForAvailableZapietMethod(checkoutMethod: "pickup")
                
            }
        }
        
        
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
        
//        self.tabBarController?.tabBar.tabsVisiblty()
       
        locationArray = [String]()
        self.deliveryDate = ""
        self.deliveryTime = ""
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false;
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.checkForCartUpdate()
        WebViewCookies().clearCookies()
        
        
        
        
    }
    
    func loadRecommendedProducts()
    {
        if(DBManager.shared.cartProducts?.count ?? 0 > 0){
            
            var crosssellProductIds = [String]()
            for index in DBManager.shared.cartProducts! {
                //let decodedData = Data(base64Encoded: index.id)!
                //let decodedString = String(data: decodedData, encoding: .utf8)!
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
                                        //                    let str1 = (str).data(using: String.Encoding.utf8)
                                        //                    let base64 = str1!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
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
                                        //                    let str1 = (str).data(using: String.Encoding.utf8)
                                        //                    let base64 = str1!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
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
    
    @objc func deleteCompleteCart(_ sender:UIButton) {
        SweetAlert().showAlert("Warning!".localized, subTitle: "Do you want to clear all your items \n from Bag?".localized, style: AlertStyle.warning, buttonTitle:"No".localized, buttonColor:UIColor(hexString: "#cd7b72") , otherButtonTitle:  "Yes".localized, otherButtonColor:UIColor(hexString: "#29b456")) { (isOtherButton) -> Void in
            if isOtherButton == true {
                print("Cancel Button  Pressed")
            }
            else {
                DBManager.shared.clearCartData()
                
                self.cartQtyLabel.text = " (\((CartManager.shared.cartCount == 0 ? "" : CartManager.shared.cartCount.description) ) "+"Items)".localized
                self.checkForCartUpdate()
                  
//                _ = SweetAlert().showAlert("Deleted!".localized, subTitle: "Your Cart has been Cleared!".localized, style: AlertStyle.success)
                
                if customAppSettings.sharedInstance.showTabbar{
                  self.tabBarController?.selectedIndex = 0
                    self.navigationController?.popToRootViewController(animated: true)
                }else{
                    self.navigationController?.popToRootViewController(animated: true)
                }
               
            }
        }
    }
    
    func checkForCartUpdate(){
        self.cartQtyError = 0
        print("checkForCartUpdate@@@")
        if DBManager.shared.cartProducts?.count ?? 0 > 0 {
            let cartItems = DBManager.shared.cartProducts!
            self.view.addLoader()
            Client.shared.createCheckout(with: cartItems) { [self] checkout,error, errorIfCheckoutIsNil   in
                self.view.stopLoader()
                if let checkout = checkout {
                    self.checkoutViewModelArray = checkout
                    self.previousTotalCartValue = checkout.lineItemsTotal
                    self.products = checkout.lineItems
                    if DBManager.shared.cartProducts?.count ?? 0 > 0 {
                        if customAppSettings.sharedInstance.wholesalePricingDiscount {
                            self.getWholesaleData()
                        }
                    }
                    self.dict.removeAll()
                    self.dict = ["token":Client.flitsToken,
                                 "note":checkout.note?.description,
                                 "attr":[],
                                 "total_discount":0,
                                 "total_weight":0.0,
                                 "item_count":self.products.count,
                                 "total_price":checkout.totalPrice * 100,
                                 "original_total_price":checkout.totalPrice * 100,
                                 "currency":Client.shared.getCountryCode()
                                 
                    ] as [String : Any]
                    
                    var allItems = [[String:Any]]()
                    
                    for items in self.products {
                        
                        var item                = [String:Any]()
                        item["id"]              = items.variantID?.components(separatedBy: "/").last ?? ""
                        item["key"]             = "\(items.variantID?.components(separatedBy: "/").last ?? ""):\(Client.apiKey)"
                        item["properties"]      = ""
                        item["variant_id"]      = items.variantID?.components(separatedBy: "/").last ?? ""
                        item["product_id"]      = items.model?.node.variant?.product.id.description.components(separatedBy: "/").last ?? ""
                        item["quantity"]        = items.quantity
                        item["price"]           = items.totalPrice * 100
                        item["original_price"]  = items.totalPrice * 100
                        item["total_discount"]  = items.totalPrice * 100
                        item["line_price"]      = items.totalPrice * 100
                        item["original_line_price"] = items.totalPrice * 100
                        item["taxable"]         = true
                        item["vendor"]          = ""
                        
                        allItems.append(item)
                        
                        if !items.currentlyNotInStock {
                            if !(items.availableQuantity < 0 ) {
                                if items.availableQuantity == 0 || (items.quantity > items.availableQuantity) {
                                    self.cartQtyError += 1
                                }
                            }
                        }
                    }
                    
                    //JS
                    self.dict["items"] = allItems
                    //END
                    
                    if customAppSettings.sharedInstance.flitsIntegration{
                        if Client.shared.isAppLogin(){
                            self.availableSpendRules()
                        }
                    }
                    
                    print("****** CART QUANTITY ERROR *****")
                    print(self.cartQtyError)
                    
                  
                        self.shimmer.removeFromSuperview()
                    
                   
                    
                    self.setupTabbarCount()
                    
                    self.tableView.reloadData()
                    self.checkoutViewModelArray = checkout
                    
                    
                    self.setUpCheckoutView()
                    self.setUpClearCartView()
                    if checkoutViewModelArray?.discountPercentage == nil && self.applyDiscountCode != "" {
                        self.applyDiscountCode(discountCode: self.applyDiscountCode)
                       
                    } else if self.applyDiscountCode != "" {
                        self.removeDiscountCode()
                    }
                    if(self.giftCard != ""){
                        self.applyGiftCard(giftCard: self.giftCard)
                    }
                }
                else if let errorIfCheckoutIsNil = errorIfCheckoutIsNil {
                    print("inside cart checkout nil error")
                    self.view.showmsg(msg: errorIfCheckoutIsNil)
                //    self.shimmer.removeFromSuperview()   no need to stop shimmer if cart is not formed
                
                
                self.setupTabbarCount()
//                self.setUpClearCartView()
//                self.setUpCheckoutView()
//
//                self.tableView.reloadData()
                }
                else
                {
                    // self.showErrorAlert(errors: error)
                    self.cartManager.showCartQuantityError(on: self, error: error)
                    error?.forEach({
                        let errormsg = $0.errorMessage
                        guard let errors =  $0.errorFields else {return}
                        if errors.contains("quantity") && errors.count == 4 {
                            guard let index = Int(errors[2]) else {return}
                            let quantity = errormsg.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                            guard let intVal = Int(quantity) else {return}
                            self.cartManager.updateCartQuantity(self.products[index], with: intVal)
                        }
                    })
                    
                    self.shimmer.removeFromSuperview()
                    
                    
                    self.setupTabbarCount()
                    self.setUpClearCartView()
                    self.setUpCheckoutView()
                    
                    self.tableView.reloadData()
                }
                
            }
        }
        else {
            self.shimmer.removeFromSuperview()
            products = [LineItemViewModel]()
            
            self.setUpClearCartView()
            self.setUpCheckoutView()
            self.setupTabbarCount()
            self.tableView.reloadData()
        }
    }
    
    func setupTable(){
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(CartCheckoutCell.self, forHeaderFooterViewReuseIdentifier: CartCheckoutCell.className)
        //Flits
        let nib = UINib(nibName: FlitsCartDiscountTVCell.className, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: FlitsCartDiscountTVCell.className)
        //Rewardify Cell
        let nib1 = UINib(nibName: RewardifyCartTVCelll.className, bundle: nil)
        self.tableView.register(nib1, forCellReuseIdentifier: RewardifyCartTVCelll.className)
        let nib2 = UINib(nibName: CartCheckoutPriceTC.className, bundle: nil)
        self.tableView.register(nib2, forCellReuseIdentifier: CartCheckoutPriceTC.className)
        let nib3 = UINib(nibName: SavingCornerView.className, bundle: nil)
        self.tableView.register(nib3, forCellReuseIdentifier: SavingCornerView.className)
        let nib4 = UINib(nibName: DiscountCouponCell.className, bundle: nil)
        self.tableView.register(nib4, forCellReuseIdentifier: DiscountCouponCell.className)
        let nib5 = UINib(nibName: CartValueStackViewCell.className, bundle: nil)
        self.tableView.register(nib5, forCellReuseIdentifier: CartValueStackViewCell.className)
        tableView.register(KangarooCartPointsTableCell.self, forCellReuseIdentifier: KangarooCartPointsTableCell.reuseId)
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension CartViewController:UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return products.count > 0 ? 10 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return  products.count
        }
        
        
        else if(section == 1){
            return 1
        }
        else if section == 2 {
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
        else if section == 3 {
            if isDeliveryPossible {
                return 2
            }
            else {
                return 0
            }
        }
        else if(section == 4){
            return 3
        }
        else if section == 7{
            guard let count = upsellProducts?.count else {
                return 0
            }
            if(count == 0){
                return 0
            }
            return 1;
        } else if section == 5 {
            guard let count = discountsCoupons?.count else {
                return 0
            }
            if count > 0 {
                return 2
            } else {
                return 0
            }
           
        } else if section == 6 {
            return 1
        }
        else if section == 8{
            return 0
//            guard let count = crosssellProducts?.count else {
//                return 0
//            }
//            if(count == 0){
//                return 0
//            }
//            return 1;
        }
        else {
            return customAppSettings.sharedInstance.isKangarooRewardsEnabled && Client.shared.isAppLogin() ?  1 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: CartProductCell.className) as! CartProductCell
            cell.delegate = self
            cell.errorDelegate = self
            cell.configure(from: products[indexPath.row])
            cell.parent=self
            cell.cardView()
            return cell
        }
        else if(indexPath.section == 1){
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
        else if indexPath.section == 2 {
            if deliveryCellBtn {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CartPincodeChecker", for: indexPath) as! CartPincodeChecker
                cell.pincodeTextfield.text = ""
                cell.resultLabel.text = ""
                cell.headingLabel.text = "Find out if we deliver to you".localized
                cell.pincodeTextfield.placeholder = "Enter your postal code".localized
                cell.pincodeTextfield.keyboardType = .numberPad
                cell.pincodeTextfield.delegate = self
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
                    cell.addressLabel.font = mageFont.regularFont(size: 14)
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
        else if indexPath.section == 3 {
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
        else if(indexPath.section == 4)
        {
            switch indexPath.row{
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: CartCouponCell.className) as! CartCouponCell
                cell.showGiftCard.titleLabel?.font = mageFont.mediumFont(size: 15.0)
                cell.showGiftCard.addTarget(self, action: #selector(showHideGiftCard(_:)), for: .touchUpInside)
                if self.showGiftSection {
                    cell.applyCouponCode.isHidden = false
                    cell.couponTextField.isHidden = false
                    cell.dropdownImage.image = UIImage(named: "bottomArrow")
                }
                else {
                    cell.applyCouponCode.isHidden = true
                    cell.couponTextField.isHidden = true
                    cell.dropdownImage.image = UIImage(named: "rightArrow")
                }
                
                cell.applyCouponCode.titleLabel?.font = mageFont.mediumFont(size: 15.0)
                cell.couponTextField.font = mageFont.regularFont(size: 14.0)
                cell.applyCouponCode.setTitle("Apply".localized, for: .normal)
                if(giftCard != "")
                {
                    cell.applyCouponCode.setTitle("Remove".localized, for: .normal)
                    cell.couponTextField.text = giftCard
                    cell.couponTextField.isEnabled = false;
                }
                else
                {
                    cell.couponTextField.text = ""
                    cell.couponTextField.isEnabled = true;
                }
                cell.applyCouponCode.rx.tap.bind{[weak self] in
                    if(cell.applyCouponCode.currentTitle == "Apply".localized){
                        if(cell.couponTextField.text != "")
                        {
                            self?.applyGiftCard(giftCard: cell.couponTextField.text!)
                        }
                        else {
                            self?.view.showmsg(msg: "Please enter coupon code".localized)
                        }
                    }
                    else
                    {
                        if(cell.couponTextField.text != ""){
                            if let checkout = self?.checkoutViewModelArray{
                                self?.removeGiftCard(giftCard: checkout.giftCardId!)
                            }
                        }
                    }
                }.disposed(by: disposeBag)
                return cell;
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: FlitsCartDiscountTVCell.className) as! FlitsCartDiscountTVCell
                cell.discountCodeDropDown.titleLabel?.font = mageFont.mediumFont(size: 15.0)
                cell.discountCodeDropDown.addTarget(self, action: #selector(showHideDiscountSection(_:)), for: .touchUpInside)
                
               
                cell.applyFlitsCode.setTitle("APPLY", for: .normal)
                cell.applyFlitsCode.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                if self.showDiscountSection {
                    cell.dropdownImage.image = UIImage(named: "bottomArrow")
                    cell.textFieldHeight.constant = 40
                    cell.flitsCodeTextField.isHidden = false
                    cell.applyFlitsCode.isHidden = false
                    cell.flitsCodeTextField.text = ""
                    
                    
                    if customAppSettings.sharedInstance.wholesalePricingDiscount && Client.shared.isAppLogin() {
                        cell.wholesaleNote.text = "Note : Shopify Discount will be applied on regular prices".localized
                        cell.wholesaleNote.font = mageFont.regularFont(size: 12.0)
                        cell.wholesaleNoteHeight.constant = 25
                        cell.wholesaleNote.isHidden = false
                    }
                    else {
                        cell.wholesaleNote.isHidden = true
                        cell.wholesaleNoteHeight.constant = 0
                    }
                }
                else {
                    cell.dropdownImage.image = UIImage(named: "rightArrow")
                    cell.textFieldHeight.constant = 0
                    cell.wholesaleNoteHeight.constant = 0
                    cell.codeViewHeight.constant  = 0
                    cell.flitsCodeTextField.isHidden = true
                    cell.applyFlitsCode.isHidden = true
                    cell.codeViewHeight.constant = 0
                    cell.flitsCodeTextField.text = ""
                }
                cell.flitsCodeTextField.isUserInteractionEnabled = true
                //Mark: Checkout Price-------
                if let checkout = checkoutViewModelArray{
                    if checkout.paymentDue < self.previousTotalCartValue {
                        cell.shoppingBagVal.text = "\(Currency.formatter.string(from: self.previousTotalCartValue as NSDecimalNumber)!)"
                    }
                    else {
                        cell.shoppingBagVal.text = "\(Currency.formatter.string(from: checkout.lineItemsTotal as NSDecimalNumber)!)"
                    }
                    //"\(Currency.formatter.string(from: checkout.paymentDue as NSDecimalNumber)!)"
                    
                    if self.applyDiscountCode != "" || checkout.discountPercentage != nil || checkout.discountAmount != nil{
                        cell.discountStack.isHidden = false
                        cell.discountLbl.text = "Discount Applied".localized
                        cell.discountLbl.textColor = UIColor(light: .black,dark: UIColor.provideColor(type: .cartVc).textColor)
                        if applyDiscountCode != "" {
                            cell.applyFlitsCode.setTitle("REMOVE", for: .normal)
                            cell.flitsCodeTextField.isUserInteractionEnabled = false
                        }
                        cell.flitsCodeTextField.text = self.applyDiscountCode.uppercased()
                        cell.discountLbl.font = mageFont.regularFont(size: 14.0)
                        cell.discountVal.font = mageFont.regularFont(size: 14.0)
                        cell.shoppingBagLbl.font = mageFont.regularFont(size: 14.0)
                        cell.shoppingBagVal.font = mageFont.regularFont(size: 14.0)
                        if checkout.discountAmount != nil {
                            cell.discountVal.text = Currency.stringFrom(checkout.discountAmount ?? 0.0)
                        }
                        //                    self.grandTotalLbl.text = "Sub Total".localized
                        //                    self.grandTotalLabel.text = "\(Currency.formatter.string(from: checkout.paymentDue as NSDecimalNumber)!)"
                        if checkout.discountPercentage != nil {
                            if let percentage = checkout.discountPercentage {
                                cell.discountVal.text = "-\(percentage)% "//+"OFF".localized
                            }
                        }
                        cell.shoppingBagLbl.text = "Shopping Bag Total".localized
                        if customAppSettings.sharedInstance.wholesalePricingDiscount && wholesaleDataFetched {
                            cell.discountVal.text = "-\(self.wholeSalePercentage)% "+"OFF".localized
                            //self.grandTotalLabel.text = Currency.stringFrom(Decimal(self.wholesaleDiscountedPrice))
                        }
                        
                        if Client.locale == "ar"{
                            cell.discountVal.textAlignment = .left
                            cell.shoppingBagVal.textAlignment = .left
                        }else{
                            cell.discountVal.textAlignment = .right
                            cell.shoppingBagVal.textAlignment = .right
                        }
                    }
                    else {
                        cell.discountStack.isHidden = true
                    }
                }
                else{
                    cell.shoppingBagVal.text = Currency.stringFrom(CartManager.shared.cartSubtotal)
                }
                
                
                
//                Flits
                if cell.codeViewContainer.isHidden{
                    if applyDiscountCode != "" {

                    } else {
                        cell.flitsCodeTextField.text = self.applyDiscountCode
                        cell.flitsCodeTextField.text = self.applyDiscountCode
                    }


                }else{
//                    cell.flitsCodeTextField.text = ""

//                    cell.flitsCodeTextField.isEnabled = true;
                }
                if(cell.codeViewHeight.constant==0){
//                    cell.flitsCodeTextField.isEnabled = true;

                }
                else{
                    cell.flitsCodeTextField.isEnabled = true;
                }
                cell.applyFlitsCode.addTarget(self, action: #selector(applyCode(_:)), for: .touchUpInside)
                
                cell.removeFlitsCode.addTarget(self, action: #selector(removeCode(_:)), for: .touchUpInside)
                
                //cell.codeViewHeight.constant = 0
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: RewardifyCartTVCelll.className, for: indexPath) as! RewardifyCartTVCelll
                cell.parent = self
                cell.setupView()
                return cell
            default: return UITableViewCell()
            }
        } else if indexPath.section == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartValueStackViewCell", for: indexPath) as! CartValueStackViewCell
            if let checkout = checkoutViewModelArray{
                if checkout.paymentDue < self.previousTotalCartValue {
                    cell.shoppingValue.text = "\(Currency.formatter.string(from: self.previousTotalCartValue as NSDecimalNumber)!)"
                }
                else {
                    cell.shoppingValue.text = "\(Currency.formatter.string(from: checkout.lineItemsTotal as NSDecimalNumber)!)"
                    cell.shoppingBagLbl.text = "Shopping Bag Total".localized
                    cell.shoppingBagLbl.font = mageFont.regularFont(size: 14.0)
                    cell.shoppingValue.font = mageFont.regularFont(size: 14.0)
                }
                //"\(Currency.formatter.string(from: checkout.paymentDue as NSDecimalNumber)!)"
                
                if self.applyDiscountCode != "" || checkout.discountPercentage != nil || checkout.discountAmount != nil{
                    cell.discountStack.isHidden = false
                    cell.discountlb.text = "Discount Applied".localized
                    cell.discountlb.textColor = UIColor(light: .black,dark: UIColor.provideColor(type: .cartVc).textColor)
                    
                   
                    cell.discountlb.font = mageFont.regularFont(size: 14.0)
                    cell.discountVaslue.font = mageFont.regularFont(size: 14.0)
                    cell.shoppingBagLbl.font = mageFont.regularFont(size: 14.0)
                    cell.shoppingValue.font = mageFont.regularFont(size: 14.0)
                    if checkout.discountAmount != nil {
                        cell.discountVaslue.text = Currency.stringFrom(checkout.discountAmount ?? 0.0)
                    }
                    //                    self.grandTotalLbl.text = "Sub Total".localized
                    //                    self.grandTotalLabel.text = "\(Currency.formatter.string(from: checkout.paymentDue as NSDecimalNumber)!)"
                    if checkout.discountPercentage != nil {
                        if let percentage = checkout.discountPercentage {
                            cell.discountVaslue.text = "-\(percentage)% "//+"OFF".localized
                        }
                        
                    }
                    cell.shoppingBagLbl.text = "Shopping Bag Total".localized
                    
                    if customAppSettings.sharedInstance.wholesalePricingDiscount && wholesaleDataFetched {
                        cell.discountVaslue.text = "-\(self.wholeSalePercentage)% "+"OFF".localized
                        //self.grandTotalLabel.text = Currency.stringFrom(Decimal(self.wholesaleDiscountedPrice))
                    }
                    
                    if Client.locale == "ar"{
                        cell.discountVaslue.textAlignment = .left
                        cell.shoppingValue.textAlignment = .left
                    }else{
                        cell.discountVaslue.textAlignment = .right
                        cell.shoppingValue.textAlignment = .right
                    }
                   
                }
                else {
                    
                     
                    cell.discountStack.isHidden = true
                }
            }
            else{
                cell.shoppingValue.text = Currency.stringFrom(CartManager.shared.cartSubtotal)
                
            }
            
          return cell
        }
        else if indexPath.section == 7{
            
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
            cell.productsCollectionView.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .cartVc).backGroundColor)
            cell.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .cartVc).backGroundColor)
            return cell;
            
            
        } else if indexPath.section == 5 {
            if indexPath.row == 0 {
                let cell    = tableView.dequeueReusableCell(withIdentifier: "SavingCornerView", for: indexPath) as! SavingCornerView
                return cell
            } else {
                let cell    = tableView.dequeueReusableCell(withIdentifier: "DiscountCouponCell", for: indexPath) as! DiscountCouponCell
                if let coupon = self.discountsCoupons {
                    if let discount = coupon[0].discount {
                        cell.configure(discount: discount)
                    }
                }
                cell.copyButton.addTarget(self, action: #selector(tapCopyCoupon), for: .touchUpInside)
                cell.viewAllButton.addTarget(self, action: #selector(tapViewAll), for: .touchUpInside)
                return cell
            }
            
        }
        
        
        
        
        /*else if indexPath.section == 6{
         let cell       = tableView.dequeueReusableCell(withIdentifier: "CartCheckoutPriceTC", for: indexPath) as! CartCheckoutPriceTC
         cell.discountLbl.text = "Discount Applied".localized
         cell.discountLbl.font = mageFont.regularFont(size: 14.0)
         cell.discountValue.font = mageFont.mediumFont(size: 16.0)
         if let checkout = checkoutViewModelArray{
         if checkout.discountAmount != nil {
         cell.discountValue.text = Currency.stringFrom(checkout.discountAmount ?? 0.0)
         }
         if checkout.discountPercentage != nil {
         if let percentage = checkout.discountPercentage {
         cell.discountValue.text = "-\(percentage)% "+"OFF".localized
         }
         
         }
         }
         self.totalAmt.text = "Shopping Bag Total".localized
         return cell
         }*/
        else if indexPath.section == 8{
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
            cell.productsCollectionView.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .cartVc).backGroundColor)
            cell.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .cartVc).backGroundColor)
            return cell;
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "KangarooCartPointsTableCell" , for: indexPath) as! KangarooCartPointsTableCell
            cell.payWithPointsApi = { [weak self] in
                self?.fetchAmounts()
            }
            cell.useCopyButton = { [weak self] in
                self?.copyToPasteBoard()
            }
            cell.removePointsFromCoupon = { [weak self] in
                self?.removeDiscountCode()
                cell.copyButtonHeightConstraint?.constant = 0
                cell.couponTextHeightConstraint?.constant = 0
                
            }
            return cell
        }
    }
    
    @objc func applyCode(_ sender : UIButton) {
        print("applyCode")
        if let cell =  self.tableView.cellForRow(at: self.flitsCellIndexPath) as? FlitsCartDiscountTVCell {
            
            if applyDiscountCode != "" {
                cell.flitsCodeTextField.text  = discCode
                cell.codeViewHeight.constant  = 0
                
                cell.codeViewContainer.isHidden = true
                self.removeDiscountCode()
            } else {
                discCode = cell.flitsCodeTextField.text ?? ""
                if discCode == "" {
                    self.view.showmsg(msg: "Please enter discount code".localized)
                    return;
                }
                cell.flitsDiscountCode.text   = discCode
//                cell.codeViewHeight.constant  = 30
                cell.codeViewContainer.isHidden = true
                cell.codeViewContainer.isHidden = true
                self.applyDiscountCode(discountCode: discCode)
            }
  
           
        }
        
    }
    
    @objc func removeCode(_ sender : UIButton) {
        self.view.makeToast("Copied")
        UIPasteboard.general.string = self.flitsDC
        
//        print("removeCode")
//        if let cell =  self.tableView.cellForRow(at: self.flitsCellIndexPath) as? FlitsCartDiscountTVCell {
//            cell.flitsCodeTextField.text  = discCode
//            cell.codeViewHeight.constant  = 0
//
//            cell.codeViewContainer.isHidden = true
//            self.removeDiscountCode()
//        }
    }
    
    
    func applyDiscountCode(discountCode:String="") {
        self.checkForAppOnlyDiscount(applyDiscountCode: discountCode) { discCode in
            Client.shared.applyCouponCode(discCode ?? "", to: self.checkoutViewModelArray?.id ?? "") { checkout, error in
                if let error=error, error.count > 0 {
                    if let cell =  self.tableView.cellForRow(at: self.flitsCellIndexPath) as? FlitsCartDiscountTVCell {
                        
                        cell.codeViewHeight.constant  = 0
                        
                        cell.codeViewContainer.isHidden = true;
                    }
                    
                    self.showErrorAlert(errors: error)
                    self.applyDiscountCode = ""
                    if customAppSettings.sharedInstance.wholesalePricingDiscount {
                        self.wholesaleDataFetched = false
                    }
                    self.checkoutViewModelArray = checkout
                    self.setUpCheckoutView()
                    self.tableView.reloadData()
                }
                else {
                    if(self.checkoutViewModelArray?.paymentDue == checkout?.paymentDue) && !customAppSettings.sharedInstance.isKangarooRewardsEnabled{
                        self.showErrorMsg(msg: "Above coupon code not applicable for above Products".localized)
                        self.removeDiscountCode()
                       
                        if let cell =  self.tableView.cellForRow(at: self.flitsCellIndexPath) as? FlitsCartDiscountTVCell {
                            cell.codeViewHeight.constant  = 0
                            cell.flitsCodeTextField.text = ""
                            cell.codeViewContainer.isHidden = true;
                        }
                        return;
                    }
                    
                    if customAppSettings.sharedInstance.flitsIntegration{
                        self.applyDiscountCode = discCode ?? ""
                    }else{
                        self.applyDiscountCode = discountCode
                    }
                    if customAppSettings.sharedInstance.wholesalePricingDiscount {
                        self.wholesaleDataFetched = false
                    }
                    self.checkoutViewModelArray = checkout
                    self.setUpCheckoutView()
                    
                    self.shimmer.removeFromSuperview()
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func removeDiscountCode() {
        Client.shared.removeCouponCode(to: checkoutViewModelArray?.id ?? "") { checkout,error  in
            if let checkout = checkout {
                self.applyDiscountCode = ""
                if customAppSettings.sharedInstance.wholesalePricingDiscount && Client.shared.isAppLogin() {
                    self.getWholesaleData()
                }
                self.checkoutViewModelArray = checkout
                self.setUpCheckoutView()
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func showHideGiftCard(_ sender : UIButton) {
        self.showGiftSection.toggle()
        self.tableView.reloadSections(NSIndexSet(index: 4) as IndexSet, with: .fade)
    }
    
    @objc func showHideDiscountSection(_ sender : UIButton) {
        self.showDiscountSection.toggle()
        self.tableView.reloadSections(NSIndexSet(index: 4) as IndexSet, with: .fade)
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
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! CartPickupCell

        cell.deliveryBtn.backgroundColor =  UIColor(light: .white, dark: UIColor.provideColor(type: .cartVc).backGroundColor)
        cell.pickupBtn.backgroundColor = UIColor(light: .white, dark: UIColor.provideColor(type: .cartVc).backGroundColor)

        tableView.reloadSections(NSIndexSet(index: 2) as IndexSet, with: .fade)
        tableView.reloadSections(NSIndexSet(index: 3) as IndexSet, with: .fade)
    }
    
    @objc func selectAnotherAddress(_ sender : UIButton) {
        initialSelected = sender.tag
        self.selectedAddress = self.locationArray[sender.tag]
        tableView.reloadSections(NSIndexSet(index: 2) as IndexSet, with: .fade)
    }
    
    
    @objc func pickupBTnPressed(_ sender : UIButton) {
        self.pickupCellBtn = true
        self.deliveryCellBtn = false
        self.shippingBtn = false
        self.isDeliveryPossible = false
        self.isDateSelected = false
        self.deliveryTime = ""
        self.deliveryDate = ""
       
        sender.backgroundColor = UIColor(hexString: "#dadada")
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! CartPickupCell
        cell.deliveryBtn.backgroundColor =  UIColor(light: .white, dark: UIColor.provideColor(type: .cartVc).backGroundColor)
        cell.shippingBtn.backgroundColor = UIColor(light: .white, dark: UIColor.provideColor(type: .cartVc).backGroundColor)
        
        tableView.reloadSections(NSIndexSet(index: 2) as IndexSet, with: .fade)
        tableView.reloadSections(NSIndexSet(index: 3) as IndexSet, with: .fade)
        //      self.getLocation()
//        self.tableView.reloadData()
        
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
      
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! CartPickupCell

        cell.pickupBtn.backgroundColor =  UIColor(light: .white, dark: UIColor.provideColor(type: .cartVc).backGroundColor)
        cell.shippingBtn.backgroundColor = UIColor(light: .white, dark: UIColor.provideColor(type: .cartVc).backGroundColor)

        self.deliveryTime = ""
        self.deliveryDate = ""
        
        tableView.reloadSections(NSIndexSet(index: 2) as IndexSet, with: .fade)
        tableView.reloadSections(NSIndexSet(index: 3) as IndexSet, with: .fade)
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
        calendarView.view.layer.borderColor = UIColor(light: .black, dark: .white).cgColor
        calendarView.doneBtn.addTarget(self, action: #selector(dateSelected(_:)), for: .touchUpInside)
    }
    
    @objc func cancelBtnPressed(_ sender : UIButton) {
        self.view.viewWithTag(1221)?.removeFromSuperview()
    }
    
    @objc func showTimeSlots(_ sender : UIButton) {
            let dropDown = DropDown(anchorView: sender)
            var dataSource = [String]()
            if deliveryCellBtn {
                for slot in deliveryDateJSON.arrayValue {
                    let timeFrom = slot["available_from"].stringValue
                    let timeTo = slot["available_until"].stringValue
                    dataSource.append("\(timeFrom) : \(timeTo)")
                }
            }
            else if pickupCellBtn {
                let weekDay = self.deliveryWeekDay.lowercased()
                let weekJSon = self.pickupJSON["daysOfWeek"]["\(weekDay)"]
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
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as? CartCalendarCell {
                if self.deliveryDate == "" {
                    if self.minDate != ""{
                        self.deliveryDate = self.minDate
                        cell.calendarBtn.setTitle(self.deliveryDate, for: .normal)
                    }else{
                        cell.calendarBtn.setTitle("Select delivery date".localized, for: .normal)
                    }
                }
                else{
                    cell.calendarBtn.setTitle(self.deliveryDate, for: .normal)
                    self.getDeliveryTime(locationId: self.deliveryJSON["id"].stringValue, deliveryDate: self.deliveryDate)
                }
            }
        }
        else if pickupCellBtn {
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? CartCalendarCell {
                if self.deliveryDate == "" {
                    if self.minDate != ""{
                        self.deliveryDate = self.minDate
                        cell.calendarBtn.setTitle(self.deliveryDate, for: .normal)
                    }else{
                        cell.calendarBtn.setTitle("Select delivery date".localized, for: .normal)
                    }
                }
                else{
                    cell.calendarBtn.setTitle(self.deliveryDate, for: .normal)
                }
            }
        }
        
        self.view.viewWithTag(1221)?.removeFromSuperview()
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if deliveryCellBtn {
            self.deliveryDate = dateFormatter.string(from: date)
            self.deliveryWeekDay = date.weekdayName
            self.isDateSelected = true
            self.tableView.reloadSections(IndexSet(integer: 3), with: .fade)
        }
        else if pickupCellBtn {
            self.deliveryDate = dateFormatter.string(from: date)
            self.deliveryWeekDay = date.weekdayName
            self.isDateSelected = true
            self.tableView.reloadSections(IndexSet(integer: 2), with: .fade)
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
    
    
    @objc func moveProductToWishlist(_ sender:UIButton) {
        self.view.addLoader()
        let proId = cartManager.getProductId(product: products[sender.tag])
        Client.shared.fetchSingleProduct(of: proId){[weak self]
            response,error in
            if let response = response {
                
                let selectedVariant = self?.products[sender.tag].variantID
                if let variants = response.variants.items.filter({$0.id == selectedVariant}).first {
                    
                    let product = CartProduct(product: response, variant: WishlistManager.shared.getVariant(variants))
                    guard let _ = response.model?.viewModel else {return}
                    
                    
                    if !(WishlistManager.shared.isProductVariantinWishlist(product: product)) {
                        WishlistManager.shared.addToWishList(product)
                    }
                    self?.cartManager.deleteQty(self!.products[sender.tag])
                    self?.view.stopLoader()
                    // DBManager.shared.removeFromCart(product: self!.products[sender.tag])
                    self?.cartQtyLabel.text = " (\((CartManager.shared.cartCount == 0 ? nil : CartManager.shared.cartCount.description) ?? "") "+"Items)".localized
                    self?.checkForCartUpdate()
                    self?.setupTabbarCount()
                }
            }
            else {
                print("error")
                //self.showErrorAlert(error: error?.localizedDescription)
            }
        }
    }
    
    @objc func tapCopyCoupon(_ sender: UIButton){
        self.view.makeToast("Copied")
        if let discounts = self.discountsCoupons {
            UserDefaults.standard.set(discounts[0].discount?.title, forKey: "coupon")
            UIPasteboard.general.string = discounts[0].discount?.title
        }
        
    }
    @objc func tapViewAll(_ sender: UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "CouponListController") as! CouponListController
        vc.coupons = self.discountsCoupons
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CartViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0){
            if indexPath.row < DBManager.shared.cartProducts?.count ?? 0  {
                let productViewController=ProductVC()//:ProductViewController = self.storyboard!.instantiateViewController()
                productViewController.productId = cartManager.getProductId(product: products[indexPath.row])
                productViewController.isProductLoading = true;
                self.navigationController?.pushViewController(productViewController, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 230
//            return UITableView.automaticDimension
        }
        else if(indexPath.section == 1){
            if customAppSettings.sharedInstance.zapietIntegration {
                return 175
            }
            else {
                return 0
            }
        }
        else if indexPath.section == 2 {
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
        else if indexPath.section == 3 {
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
        }else if(indexPath.section == 4){
            switch indexPath.row{
            case 0:
                return showGiftSection ? 100 : 0
            case 1:
                let priceHeight = CGFloat(60.0)
                if self.showDiscountSection {
                    if customAppSettings.sharedInstance.wholesalePricingDiscount {
                        if self.applyDiscountCode != "" {
                            return 130
                        }
                        else {
                            return 100
                        }
                    }
                    else {
                        if self.applyDiscountCode != "" {
                            return 120
                        }
                        else {
                            if self.flitsDC != nil {
                                return 150
                            } else {
                                return 120
                            }
                        }
                    }
                }
                else {
                    return 50
                }
            case 2:
                return customAppSettings.sharedInstance.rewardify && Client.shared.isAppLogin() ? 50 : 0
            default: return 0
            }
        } else if indexPath.section == 6 {
            if self.applyDiscountCode != "" {
                return 75
            }
            else {
                return 75
            }
        }
        else if indexPath.section == 7
        {
            return layoutHeight["upsell"] ?? 0
        } else if indexPath.section == 5 {
            if indexPath.row == 0 {
                return 25
            } else {
                return 150
            }
        }
        else if indexPath.section == 8{
            return layoutHeight["crosssell"] ?? 0
        }
        else {
            return customAppSettings.sharedInstance.isKangarooRewardsEnabled && Client.shared.isAppLogin() ? UITableView.automaticDimension : 0
        }
    }
    
    //  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //    guard let count = crosssellProducts?.count else{
    //      return footerView()
    //    }
    //    if(count >= 0){
    //      if(section == 3){
    //        return footerView()
    //      }
    //      return UIView()
    //    }
    //    else{
    //      guard let count = upsellProducts?.count else{
    //        return footerView()
    //      }
    //      if(count >= 0){
    //        if(section == 2){
    //          return footerView()
    //        }
    //        return UIView()
    //      }
    //      else{
    //        if(section == 0 || section == 1){
    //          return footerView()
    //        }
    //      }
    //    }
    //    return UIView()
    //
    //
    //  }
    //
    //  func footerView() -> UIView{
    //    let cell       = CartCheckoutCell(reuseIdentifier: CartCheckoutCell.className)
    //    cell.cardView()
    //    if let checkout = checkoutViewModelArray{
    //      cell.setupTotal(amount: checkout.paymentDue, giftCard: true)
    //    }
    //    else{
    //      cell.setupTotal()
    //    }
    //    cell.delegate = self
    //    return cell
    //  }
    //
    //  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //    if(section == 3){
    //      return 0
    //    }
    //    else{
    //      return 0
    //    }
    //  }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.section == 0){
            if indexPath.row < cartManager.cartProducts.count {
                return true
            }else {
                return false
            }
        }
        return false;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            cartManager.deleteQty(products[indexPath.row])
            tableView.reloadData()
            self.cartQtyLabel.text = " (\((CartManager.shared.cartCount == 0 ? nil : CartManager.shared.cartCount.description) ?? "") "+"Items)".localized
            self.setupTabbarCount()
            self.checkForCartUpdate()
        default:
            break
        }
        
        
    }
    @objc func searchForPincode(_ sender : UIButton) {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! CartPincodeChecker
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
                    self.tableView.reloadSections(IndexSet(integer: 3), with: .fade)
                }
                
            }
            else {
                cell.resultLabel.text = json?["error"]["message"].stringValue
                cell.resultLabel.numberOfLines = 0
                cell.resultLabel.adjustsFontSizeToFitWidth = true
                cell.resultLabel.textColor = UIColor.red
                self.isDeliveryPossible = false
                self.tableView.reloadSections(IndexSet(integer: 3), with: .fade)
            }
            
        }
        
    }
    
    func proceedToCheckout(ofType checkoutType: checkoutType) {
        let cartItems = DBManager.shared.cartProducts
        
        var customAttribute = [MobileBuySDK.Storefront.AttributeInput]()
        var productAttribute = [MobileBuySDK.Storefront.AttributeInput]()
        var zapietID = ""
        if customAppSettings.sharedInstance.zapietIntegration {
            if deliveryCellBtn {
                if isDeliveryPossible {
                    let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! CartPincodeChecker
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
                customAttribute.append(MobileBuySDK.Storefront.AttributeInput.create(key: "Pickup-Location-Address-Line-2", value: locationsArray[initialSelected]["address_line_2"].stringValue))
                customAttribute.append(MobileBuySDK.Storefront.AttributeInput.create(key: "Pickup-Location-City", value: locationsArray[initialSelected]["city"].stringValue))
                customAttribute.append(MobileBuySDK.Storefront.AttributeInput.create(key: "Pickup-Location-Region", value: locationsArray[initialSelected]["region"].stringValue))
                customAttribute.append(MobileBuySDK.Storefront.AttributeInput.create(key: "Pickup-Location-Postal-Code", value: locationsArray[initialSelected]["postal_code"].stringValue))
                customAttribute.append(MobileBuySDK.Storefront.AttributeInput.create(key: "Pickup-Location-Country", value: locationsArray[initialSelected]["country"].stringValue))
                zapietID = "M=P&L=\(locationsArray[initialSelected]["id"].stringValue)Z"
            }
            productAttribute.append(MobileBuySDK.Storefront.AttributeInput.create(key: "_ZapietId", value: zapietID))
            
        }
        self.view.addLoader()
        self.view.isUserInteractionEnabled = false
        Client.shared.createCheckout(with: cartItems!, custom: customAttribute,productInput: productAttribute) { checkout,error,  errorIfCheckoutIsNil  in
            self.view.stopLoader()
            self.view.isUserInteractionEnabled = true
            
            guard let checkout = checkout else {
                //self.showErrorAlert(errors: error)
                return
            }
            
            
            if(self.giftCard != ""){
                Client.shared.applyGiftCardCode([self.giftCard], to: checkout.id) { (checkout, error) in
                    if let checkout = checkout{
                        self.checkoutViewModelArray = checkout
                        self.proceedCheckout(checkout: checkout,checkoutType: checkoutType)
                    }
                }
            }
            else {
                self.proceedCheckout(checkout: checkout,checkoutType: checkoutType)
            }
        }
        
    }
    func proceedCheckout(checkout: CheckoutViewModel,checkoutType: checkoutType)
    {
        let checkoutCreate: (CheckoutViewModel) -> Void = { checkout in
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
                            self.authorizePaymentFor(shopName, in: checkout)
                        }
                    })
                }
            }
        }
        //Change According TO New Discount Work
        if self.applyDiscountCode != "" {
            Client.shared.applyCouponCode(self.applyDiscountCode, to: checkout.id) { checkout,error  in
                if let checkout = checkout {
                    checkoutCreate(checkout)
                } else {
                }
            }
            
        }
        else {
            checkoutCreate(checkout)
        }
        
        /* if applyFlitsCouponCode{
         checkoutCreate(checkout)
         }else{
         self.promptForDiscountCode { discountCode in
         if let discountCode = discountCode {
         Client.shared.applyCouponCode(discountCode, to: checkout.id) { checkout,error  in
         if let checkout = checkout {
         checkoutCreate(checkout)
         } else {
         //   self.showErrorAlert(title: "Error".localized, error: error?.localizedDescription)
         }
         }
         } else {
         checkoutCreate(checkout)
         }
         }
         }*/
    }
    
    func authorizePaymentFor(_ shopName: String, in checkout: CheckoutViewModel) {
        
        let payCurrency = PayCurrency(currencyCode: checkout.currencyCode, countryCode: "CA")
        
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
        paySession.authorize()
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
                        //                      UserDefaults.standard.set(code, forKey: "DiscountCodeApplied")
                        //                      UserDefaults.standard.set(json["discount_code"].stringValue, forKey: "DiscountCodeSDK")
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
    
    func applyGiftCard(giftCard: String){
        if let checkout = checkoutViewModelArray{
            Client.shared.applyGiftCardCode([giftCard], to: checkout.id) { (checkout, error) in
                if let checkout = checkout{
                    if(checkout.giftCardId != nil){
                        self.giftCard = giftCard
                        self.checkoutViewModelArray = checkout
                        self.tableView.reloadData()
                    }
                    else {
                        self.view.makeToast("Invalid gift card code".localized, duration: 2.0, position: .center)
                    }
                }
            }
        }
    }
    
    func removeGiftCard(giftCard: GraphQL.ID){
        if let checkout = checkoutViewModelArray{
            Client.shared.removeGiftCardCode(giftCard, to: checkout.id) { (checkout, error) in
                if let checkout = checkout{
                    self.checkoutViewModelArray = checkout
                    self.giftCard = ""
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension CartViewController:cartQuantityUpdate {
    func updateCartQuantity(sender: CartProductCell, quantity: Int, model: LineItemViewModel?) {
        guard let index = tableView.indexPath(for: sender) else {return}
        if quantity <= 0{
            cartManager.deleteQty(products[index.row])
        }else{
            cartManager.updateCartQuantity(products[index.row], with: quantity)
        }
        if CartManager.shared.cartCount == 0{
            self.cartQtyLabel.text = ""
        }else{
            self.cartQtyLabel.text = " (\(CartManager.shared.cartCount.description) "+"Items)".localized
        }
//        self.cartQtyLabel.text = " (\((CartManager.shared.cartCount == 0 ? nil : CartManager.shared.cartCount.description) ?? "") "+"Items)".localized
        self.checkForCartUpdate()
    }
}


extension CartViewController{
    func openWebCheckout(_ checkout: CheckoutViewModel){
        if customAppSettings.sharedInstance.nativeCheckout {
            if Client.shared.isAppLogin(){
                Client.shared.fetchCustomerDetails {
                    response,error   in
                    self.view.stopLoader()
                    if let response = response {
                        let vc = NativeAddressListing()
                        vc.email     = response.email ?? ""
                        vc.checkoutID=checkout.checkId
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else {
                        //self.showErrorAlert(error: error?.localizedDescription)
                    }
                }
            }else{
                let vc = NativeAddressListing()
                vc.checkoutID = checkout.checkId
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else {
            //self.cartManager.deleteAll()
            //self.setupTabbarCount()
            let vc:WebViewController = (self.storyboard!.instantiateViewController())
            let subTotal    = Double(truncating: (CartManager.shared.cartSubtotal) as NSNumber)
            vc.cartSubTotal = subTotal
            vc.discountcodeSDK = self.discountCodeSDK
            vc.discountCodeApplied = self.discountCodeApplied
            vc.checkoutId = checkout.id
            if(!Client.shared.isAppLogin()){
                //let vc:WebViewController = storyboard!.instantiateViewController()
                vc.isLoginRequired=true
                vc.url=checkout.webURL
                print(checkout.webURL)
                vc.ischeckout=true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                let tokenArray = Client.shared.getToken() as! [String:Any]
                let tokenValue = tokenArray["token"] as! String
                
                Client.shared.checkoutCustomerAssociateV2(checkoutId: checkout.checkId, token: tokenValue) { [weak self](check, error) in
                    vc.isLoginRequired=true
                    vc.url=check?.webURL
                    vc.ischeckout=true
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
            Client.shared.fetchCompletedOrder(checkout.id, completion: {
                response  in
                
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["magenative_cart_notification_center"])
            })
        }
    }
}

extension CartViewController:DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    /*func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
     return NSAttributedString(string: EmptyData.cartEmptyTitle)
     }
     
     
     
     func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state:UIControl.State) -> NSAttributedString! {
     return NSAttributedString(string: "Start Shopping".localized)
     }
     
     func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
     return NSAttributedString(string: EmptyData.cartDescription)
     }
     
     func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
     if customAppSettings.sharedInstance.showTabbar{
     self.tabBarController?.selectedIndex = 0
     }else{
     self.navigationController?.popToRootViewController(animated: true)
     }
     }*/
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

extension CartViewController:productClicked{
    func productCellClicked(product: ProductViewModel, sender: Any) {
        let productViewController=ProductVC()//:ProductViewController = self.storyboard!.instantiateViewController()
        productViewController.product = product
        self.navigationController?.pushViewController(productViewController, animated: true)
    }
}

extension CartViewController: RecommendedProductsLayoutUpdate{
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


extension CartViewController: updateCartData {   
    func reloadcartData() {
        self.checkForCartUpdate()
    }
}
extension Date {
    // returns weekday name (Sunday-Saturday) as String
    var weekdayName: String {
        let formatter = DateFormatter(); formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }
}

extension CartViewController{
    func setupNavBar(){
        if !customAppSettings.sharedInstance.showTabbar{
            var navigationViewModel :HomeTopBarViewModel?
            let hampMenu = UIBarButtonItem(image: UIImage(named: "hamMenu"), style: .plain, target: revealViewController(), action:#selector(SWRevealViewController.revealToggle(_:)))
            hampMenu.tintColor = navigationViewModel?.icon_color
            self.navigationItem.leftBarButtonItem  = hampMenu
        }
    }
}


extension CartViewController{
    func MD5(string: String) -> Data {
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        
        return digestData
    }
}

extension CartViewController : UITextFieldDelegate{
    func textField(_ theTextField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        for i in 0..<string.count {
            let c = (string as NSString).character(at: i)
            if !NSCharacterSet(charactersIn: "0123456789").characterIsMember(c) {
                return false
            }
        }
        return true
    }
}
extension CartViewController:ShowError{
    func showErrorMsg(msg: String) {
        var style = ToastStyle()
        style.backgroundColor = UIColor(hexString: "#143F6B")
        style.titleColor = UIColor.white
        self.view.makeToast(msg.localized, duration: 2.0, position: .center, style: style)
    }
}
extension CartViewController {
    func showAlertToUseKangarooPoints() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {[weak self] in
            SweetAlert().showAlert("Pay with Points!".localized, subTitle: "Do you want to use \n coupon points for this purchase?".localized, style: AlertStyle.warning, buttonTitle:"No".localized, buttonColor:UIColor(hexString: "#cd7b72") , otherButtonTitle:  "Yes".localized, otherButtonColor:UIColor(hexString: "#29b456")) { (isOtherButton) -> Void in
                if isOtherButton == true {
                    print("Cancel Button  Pressed")
                }
                else {
                    self?.fetchAmounts()
                }
            }
        })
    }
    
    func fetchAmounts() {
        if let checkout = checkoutViewModelArray{
            let amount = checkout.lineItemsTotal
            let subtotal = checkout.subtotalPrice
            payWithKangarooPoints(amount: "\(amount)", subtotal: "\(subtotal)")
        }
    }
    
    func copyToPasteBoard() {
        if let cell =  self.tableView.cellForRow(at: IndexPath(row: 0, section: 9)) as? KangarooCartPointsTableCell {
            let pasteboard = UIPasteboard.general
            pasteboard.string = cell.couponText.text ?? ""
            self.view.showmsg(msg: "Code Copied")
            
        }
    }
    
    
    func payWithKangarooPoints(amount: String, subtotal: String) {
        let kangarooViewModel = KangarooRewardsViewModel()
        kangarooViewModel.kangarooPayWithPoints(amount: amount, subtotal: subtotal) {[weak self] result in
            switch result {
            case .success:
                if let code = kangarooViewModel.pointsCoupon?.ecomCoupon?.code {
                    DispatchQueue.main.async {
                        if let cell =  self?.tableView.cellForRow(at: IndexPath(row: 0, section: 9)) as? KangarooCartPointsTableCell {
                            cell.couponText.text = code
                            cell.couponTextHeightConstraint?.constant = 45
                            cell.copyButtonHeightConstraint?.constant = 45
                            self?.tableView.reloadSections(NSIndexSet(index: 9) as IndexSet, with: .fade)

                           // self?.showCouponAlert(code: code)
                        }
                        
                    }
                }
            case .failed(let err):
                print("The err is \(err)")
                DispatchQueue.main.async {
                    if let cell =  self?.tableView.cellForRow(at: IndexPath(row: 0, section: 9)) as? KangarooCartPointsTableCell {
                        self?.view.showmsg(msg: err)
                        cell.couponTextHeightConstraint?.constant = 0
                        cell.copyButtonHeightConstraint?.constant = 0
                        self?.tableView.reloadSections(NSIndexSet(index: 9) as IndexSet, with: .fade)
                    }
                }
            }
        }
    }
}
                                  
