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
import ChatSDK
import ChatProvidersSDK
import MessagingSDK

class BaseViewController: UIViewController {
  
  static var secondaryDb : Database?
  static var additionalInfoReference: DatabaseReference?
  
  let reachability = try! Reachability()
    var shareButtonItem: UIBarButtonItem!
  override func viewDidLoad() {
    super.viewDidLoad()
      BaseNavigation().makeNaVigationBar(me: self, shareButtonItem: &shareButtonItem)
    if let revealController = self.revealViewController() {
      //  revealController.panGestureRecognizer()
      revealController.tapGestureRecognizer()
    }
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
      if #available(iOS 14.0, *) {
          self.navigationItem.backButtonDisplayMode = .minimal
      } else {
          // Fallback on earlier versions
      }
    if #available(iOS 13.0, *) {
     // self.navigationController?.navigationBar.titleTextAttributes = [
       // NSAttributedString.Key.foregroundColor : UIColor.label ]
    }
    else {
      // Fallback on earlier versions
    }
    if #available(iOS 13.0, *) {
      
     // self.navigationController?.navigationBar.tintColor = .label
    }
    else {
      // Fallback on earlier versions
    }
    //initialseSecondryDatabase()
      self.navigationController?.navigationBar.tintColor = UIColor(light: Client.navigationThemeData?.icon_color ?? .black,dark: UIColor.white)
      self.navigationController?.navigationBar.isTranslucent = false
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
      
      if #available(iOS 13.0, *) {
          let appearance = UINavigationBarAppearance()
          appearance.configureWithOpaqueBackground()
//            appearance.backgroundColor = UIColor.white
          appearance.backgroundColor = UIColor(light: Client.navigationThemeData?.panel_background_color ?? UIColor.white,dark: .black)
          appearance.titleTextAttributes = [.font: mageFont.mediumFont(size: 16),NSAttributedString.Key.foregroundColor: UIColor(light: Client.navigationThemeData?.icon_color ?? .AppTheme(),dark: .white)]
          UINavigationBar.appearance().tintColor = .white
          UINavigationBar.appearance().standardAppearance = appearance
          UINavigationBar.appearance().scrollEdgeAppearance = appearance
          UINavigationBar.appearance().isTranslucent = false
          
          //For aligning navigation title to left
//            let offset = UIOffset(horizontal: -CGFloat.greatestFiniteMagnitude, vertical: 0)
//            UINavigationBar.appearance().standardAppearance.titlePositionAdjustment = offset
//            UINavigationBar.appearance().scrollEdgeAppearance?.titlePositionAdjustment = offset
//            UINavigationBar.appearance().compactAppearance?.titlePositionAdjustment = offset
      }
      else {
      }
    //        FloatingButton.shared.controller = self
    //        FloatingButton.shared.renderFloatingButton()
    setupReachability()
      self.navigationController?.navigationBar.tintColor = UIColor(light: Client.navigationThemeData?.icon_color ?? .black,dark: UIColor.white)
//      if #available(iOS 13.0, *) {
//          let appearance = UINavigationBarAppearance()
//          appearance.configureWithOpaqueBackground()
//          appearance.backgroundColor = Client.navigationThemeData?.panel_background_color//UIColor(hexString: "#B2255E")
//          appearance.titleTextAttributes = [.font: mageFont.mediumFont(size: 16),.foregroundColor:UIColor.white]
//
//          UINavigationBar.appearance().standardAppearance = appearance
//          UINavigationBar.appearance().scrollEdgeAppearance = appearance
//          UINavigationBar.appearance().isTranslucent = false
//      }
  }
  
  func setupReachability(){
    DispatchQueue.main.async {
      self.reachability.whenReachable = { reachability in
        if reachability.connection == .wifi {
          print("Reachable via WiFi")
        } else {
          print("Reachable via Cellular")
        }
        if let topController = UIApplication.topViewController(){
          if topController.title == "NetworkErrorVC"{
            topController.dismiss(animated: true, completion: nil)
          }
        }
      }

      self.reachability.whenUnreachable = { _ in
        print("Not reachable")
        let vc = NetworkErrorVC()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true, completion: nil)
      }

      do {
        try self.reachability.startNotifier()
      } catch {
        print("Unable to start notifier")
      }
    }
  }
  
  deinit{
    reachability.stopNotifier()
  }
  
  func setupNavBarButton(){
    let barButtonItem = UIBarButtonItem()
    barButtonItem.image = #imageLiteral(resourceName: "hamMenu")
    barButtonItem.target = self.revealViewController()
    barButtonItem.action = #selector(SWRevealViewController.revealToggle(_:))
    // self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    self.navigationItem.leftBarButtonItem = barButtonItem
  }
  
  @objc func showMessagingChat(_ sender : UIButton) {
    if customAppSettings.sharedInstance.zendeskChat {
      do {
        let chatEngine = try ChatEngine.engine()
        let viewController = try Messaging.instance.buildUI(engines : [chatEngine],configs : [])
        self.navigationController?.pushViewController(viewController, animated: true)
      } catch {
        // handle error
      }
    }
    
    if customAppSettings.sharedInstance.tidioChat {
      let vc : WebViewController = self.storyboard!.instantiateViewController()
      vc.title = "Chat with Us".localized
      vc.tidioCheck = true
      vc.url = "http://shopifymobileapp.cedcommerce.com/shopifymobile/tidiolivechatapi/chatpanel?shop=\(Client.shopUrl)".getURL()
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}



extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
