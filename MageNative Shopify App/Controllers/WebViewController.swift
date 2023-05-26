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
import WebKit
import StoreKit


class WebViewController: BaseViewController, WKNavigationDelegate {
  
  var webView = WKWebView()
  var url:URL?
  var isLoginRequired = false
  var ischeckout=false
  var isOrder=false
  var checkoutId = ""
    var tidioCheck = false
    var discountCodeApplied = String()
    var discountcodeSDK = String()
    var cartSubTotal = Double()
    

  required init?(coder aDecoder: NSCoder) {
    self.webView = WKWebView(frame: CGRect.zero)
    super.init(coder: aDecoder)
    self.webView.navigationDelegate = self
  }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    loadPage()
  }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false;
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.tabsVisiblty(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = false;
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
  func loadPage()
  {
    self.view.backgroundColor = UIColor.white
    guard let url = url else {return}
    var request = URLRequest(url: url)
    //var _ = ""
    print("--hi--")
    print(url.absoluteString)
    if isLoginRequired && Client.shared.isAppLogin() && !isOrder{
      let tokenArray = Client.shared.getToken() as! [String:Any]
      let tokenValue = tokenArray["token"] as! String
      request.addValue(tokenValue, forHTTPHeaderField: "X-Shopify-Customer-Access-Token")
    }
    request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    let webconfgi = WKWebViewConfiguration()
    webconfgi.processPool = WKProcessPool()
    let bounds = self.view.bounds
    let toplayoutguide = self.navigationController!.view.frame.origin.y ;
      if tidioCheck {
          let frame  = CGRect(x: 0, y: toplayoutguide, width: bounds.width, height: bounds.height-(50+44+100))
          webView = WKWebView(frame: frame, configuration: webconfgi)
      }
      else {
          let frame  = CGRect(x: 0, y: toplayoutguide, width: bounds.width, height: bounds.height-50)
          webView = WKWebView(frame: frame, configuration: webconfgi)
      }
    
    webView.load(request)
    self.view.addSubview(webView)
    
    webView.navigationDelegate = self
    self.view.addLoader()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      if tidioCheck{
        webView.evaluateJavaScript("var meta = document.createElement('meta'); meta.setAttribute( 'name', 'viewport' ); meta.setAttribute( 'content', 'width = device-width, initial-scale=1.0, minimum-scale=0.2, maximum-scale=5.0; user-scalable=1;' ); document.getElementsByTagName('head')[0].appendChild(meta)", completionHandler: nil)
          self.view.stopLoader()
      }
      else {
          self.view.stopLoader()
          if self.discountCodeApplied != "" {
              webView.evaluateJavaScript("var length = document.querySelectorAll('.reduction-code__text').length;for(var i=0; i<length; i++){(document.querySelectorAll('.reduction-code__text')[i]).innerHTML = '\(self.discountCodeApplied)';}", completionHandler: nil)
          }
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {[weak self] in
                  webView.evaluateJavaScript("document.getElementsByClassName ('swell-tab')[0].style.display='none';") { res, err in
                      print("error is \(String(describing: err))")
                  }
          webView.evaluateJavaScript("document.getElementsByClassName ('awesome-iframe')[0].style.display='none';") { res, err in
              print("error is \(String(describing: err))")
          }
      }
      webView.isHidden = false
      webView.isUserInteractionEnabled = true
      let url=webView.url?.absoluteString
      if (url?.contains("thank_you"))!{
          let currency = Client.shared.getCurrencyCode() ?? ""
                  let numofItms = UserDefaults.standard.integer(forKey: "totalCountQ")
                let parameters = [
                  AppEvents.ParameterName.currency: currency,
                  AppEvents.ParameterName.numItems: numofItms
                ] as [AppEvents.ParameterName : Any]
                print("totalPrice=Called in webview did finish=",cartSubTotal)
                AppEvents.shared.logEvent(.purchased, valueToSum: cartSubTotal, parameters: parameters)
          Analytics.logEvent(AnalyticsEventPurchase, parameters:[AnalyticsParameterCurrency: currency,AnalyticsParameterValue: cartSubTotal])
          CartManager.shared.deleteAll()
          self.setupTabbarCount()
          let right=UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(continuePressed(_:)))
          self.navigationItem.rightBarButtonItem=right
      }
  }
  
  func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    self.view.stopLoader()
    let url=webView.url?.absoluteString
    if (url?.contains("thank_you"))!{
      
      Analytics.logEvent(AnalyticsEventPurchase, parameters: [
                          AnalyticsParameterPrice: CartManager.shared.cartCount])
      let right=UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(continuePressed(_:)))
      self.navigationItem.rightBarButtonItem=right
    }
  }
  
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
      
      if let url = navigationAction.request.url {
          if url.absoluteString.contains("/account/login?checkout_url"){
              decisionHandler(.cancel)
              self.view.stopLoader()

                  if let loginNavigation = self.storyboard?.instantiateViewController(withIdentifier:"NewLoginNavigation") as? NewLoginNavigation {
                      loginNavigation.modalPresentationStyle = .overCurrentContext
                      loginNavigation.webViewVC = self
                      self.present(loginNavigation, animated: true, completion: nil)
                  }
              return
          }
      }
  
      
    if let url = navigationAction.request.url {
      print(url.absoluteString)
      if (url.absoluteString.contains("thank_you")){
          let currency = Client.shared.getCurrencyCode() ?? ""
                  let numofItms = UserDefaults.standard.integer(forKey: "totalCountQ")
                let parameters = [
                  AppEvents.ParameterName.currency: currency,
                  AppEvents.ParameterName.numItems: numofItms
                ] as [AppEvents.ParameterName : Any]
                print("totalPrice=Called in webview did finish=",cartSubTotal)
                  
                AppEvents.shared.logEvent(.purchased, valueToSum: cartSubTotal, parameters: parameters)
          
        Analytics.logEvent(AnalyticsEventPurchase, parameters: [
                            AnalyticsParameterPrice: CartManager.shared.cartCount])
        let right=UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(continuePressed(_:)))
        self.navigationItem.rightBarButtonItem=right
        self.navigationItem.leftBarButtonItems=[]
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        /*let arrayToBreakToken=url.absoluteString.components(separatedBy: "/checkouts/")
         let tokenArray=arrayToBreakToken[1].components(separatedBy: "/")
         let token = tokenArray[0]*/
        setOrderRequest(token: self.checkoutId)
        
      }
    }
    
    decisionHandler(.allow)
  }
  
  func setOrderRequest(token:String){
    guard let url = (AppSetUp.baseUrl+"index.php/shopifymobile/shopifyapi/setorder?mid="+Client.merchantID+"&checkout_token="+token).getURL() else {return}
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    self.view.addLoader()
    AF.request(request).responseData(completionHandler: {
      response in
      self.view.stopLoader()
      switch response.result {
      case .success:
        if let data = response.data {
          do {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
              DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                  AppReviewManager.standard.showPopup(controller: self)
                  SKStoreReviewController.requestReview()
                  // Code to be executed
              }
            print(json)
          }catch let err {
            print(err.localizedDescription)
          }
        }
      case .failure:
        guard let error = response.error?.localizedDescription else {return}
        print(error)
      }
    })
  }
  
    func getFrontController()->UIViewController?{
        if(Client.locale != "ar"){
            return self.revealViewController().frontViewController
        }
        else{
            return self.revealViewController().frontViewController
        }
    }
    
  @objc func continuePressed(_ sender: UIButton)
  {
    CartManager.shared.deleteAll()
    self.setupTabbarCount()
    self.navigationController?.popViewController(animated: true)
    if customAppSettings.sharedInstance.showTabbar{
      self.tabBarController?.selectedIndex = 0
    }else{
      self.navigationController?.popToRootViewController(animated: true)
    }
  }
}
