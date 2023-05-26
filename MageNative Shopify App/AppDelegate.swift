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
import CoreData
import ChatSDK
import ChatProvidersSDK
import RealmSwift
import GoogleSignIn
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
       }
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    //selecting_local.DoTheSwizzling()
    //getdata()
      window = UIWindow(frame: UIScreen.main.bounds)
    IQKeyboardManager.shared.enable = true
     
    //_ = recentlyViewedManager.shared
    Client.shared.refreshToken()
     if FirebaseApp.app() == nil {
         FirebaseApp.configure()
     }
    self.registerForPushNotification(application: application)
      // MARK: - Zendesk Chat Account ID
      Chat.initialize(accountKey: "\(Client.zendeskAccountKey)")    //Jue87UwueE4cWks4tzKkpChFMJY9mPan
    getAllCurrency()
      if UserDefaults.standard.value(forKey: "isTranslationOn") == nil {
          UserDefaults.standard.setValue(false, forKey: "isTranslationOn")
      }
      
//      self.setUpTabbarNavbar()
      let config = Realm.Configuration(
        // Set the new schema version. This must be greater than the previously used
        // version (if you've never set a schema version before, the version is 0).
        schemaVersion: 2,

        // Set the block which will be called automatically when opening a Realm with
        // a schema version lower than the one set above
        migrationBlock: { migration, oldSchemaVersion in
          // We haven’t migrated anything yet, so oldSchemaVersion == 0
          if (oldSchemaVersion < 1) {
            // Nothing to do!
            // Realm will automatically detect new properties and removed properties
            // And will update the schema on disk automatically
          }
        })

      // Tell Realm to use this new configuration object for the default Realm
      Realm.Configuration.defaultConfiguration = config
      let _ = try? Realm()
                  _ = CartManager.shared
                  _ = WishlistManager.shared
          if let keys = launchOptions?.keys {
            print(keys)
            if !keys.contains(.remoteNotification) {
              pushRedirect()
            }
          }
          else{
            pushRedirect()
          }
      // Now that we've told Realm how to handle the schema change, opening the file
      // will automatically perform the migration
      AnalyticsFirebaseData.shared.firebaseSourceOfOpen(source: "Direct")
      ApplicationDelegate.shared.application(
        application,
        didFinishLaunchingWithOptions: launchOptions
      )
    return true
  }
    
    func configureApptheme(window: UIWindow) {
        if let theme = UserDefaults.standard.value(forKey: "theme") as? String {
            if theme == "dark" {
                if #available(iOS 13.0, *) {
                    self.window?.overrideUserInterfaceStyle = .dark
                } else {
                    // Fallback on earlier versions
                }
            } else if theme == "light" {
                if #available(iOS 13.0, *) {
                    self.window?.overrideUserInterfaceStyle = .light
                } else {
                    // Fallback on earlier versions
                }
            } else {
                if #available(iOS 13.0, *) {
                    self.window?.overrideUserInterfaceStyle = .unspecified
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
    
    func setUpTabbarNavbar() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(light: Client.navigationThemeData?.panel_background_color ?? UIColor.white,dark: .black)
            appearance.titleTextAttributes = [.font: mageFont.mediumFont(size: 16),NSAttributedString.Key.foregroundColor: UIColor(light: Client.navigationThemeData?.icon_color ?? .AppTheme(),dark: .white)]
            UINavigationBar.appearance().tintColor = Client.navigationThemeData?.icon_color
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().isTranslucent = false
        }
        else {
        }
    }
  
    func application(
      _ app: UIApplication,
      open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
      
      if GIDSignIn.sharedInstance.handle(url) {
        return true
      }else if ApplicationDelegate.shared.application(
        app,
        open: url,
        sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
        annotation: options[UIApplication.OpenURLOptionsKey.annotation]
      ){
        return true
      }else {
        return false
      }
    }
    
    public func application(_ application: UIApplication, open url: URL,sourceApplication: String?, annotation: Any) -> Bool {
      return ApplicationDelegate.shared.application(
        application,
        open: (url as URL?)!,
        sourceApplication: sourceApplication,
        annotation: annotation)
    }
  
    func loadHomepage(){
      let story = UIStoryboard(name: "Main", bundle: nil)
      let viewControl = story.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
      self.window?.rootViewController = viewControl
      self.window?.makeKeyAndVisible()
    }
    
    func pushRedirect(){
//      initialseSecondryDatabase()
//      loadHomepage()
        loadApp()
    }
    
    func redirectPushNotifications(){
      if(UserDefaults.standard.value(forKey: "MageNotificationData") != nil){
        let story = UIStoryboard(name: "Main", bundle: nil)
        let viewControl = story.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
        self.window?.rootViewController = viewControl
        self.window?.makeKeyAndVisible()
      }
    }
  
  func getdata(){
    
    guard let url = (AppSetUp.baseUrl + "shopifymobile/shopifyapi/appdata?mid=" + Client.merchantID).getURL() else {return}
    var request = URLRequest(url: url)
    request.httpMethod="GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.cachePolicy = URLRequest.CachePolicy.returnCacheDataElseLoad
    AF.request(request).responseData(completionHandler: {
      response in
      switch response.result {
      case .success:
        do {
          guard let json = try? JSON(data: response.data!) else{return;}
          let success = json["success"].boolValue
          if success == true{
            let loginbg = json["login_page_background_image"].stringValue
            let header = json["app_header_logo"].stringValue
            var colorCode = json["app_theme_color"].stringValue
            if colorCode.lowercased().contains("fffff") || colorCode.lowercased().contains("fcfcf"){
              colorCode = "000000"
            }
            let scanner = Scanner(string:colorCode)
            var color:UInt32 = 0;
            scanner.scanHexInt32(&color)
            let mask = 0x000000FF
            let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
            let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
            let b = CGFloat(Float(Int(color) & mask)/255.0)
            let colorBrightness = ((r * 299) + (g * 587) + (b * 114)) / 1000;
            if (colorBrightness < 0.5)
            {
              UserDefaults.standard.set("#FFFFFF", forKey: "TextColor")
            }else{
              UserDefaults.standard.set("#000000", forKey: "TextColor")
            }
            UserDefaults.standard.set(loginbg, forKey: "loginbg")
            UserDefaults.standard.set(header, forKey: "header")
            UserDefaults.standard.set(colorCode, forKey: "color")
          }
        }
      case .failure:
        print("failed")
      }
    })
  }
  
  func getAllCurrency()
  {
    let url="http://shopifymobileapp.cedcommerce.com/shopifymobile/shopifyapi/getcurrencyrates"
    var urlreq=URLRequest(url: URL(string: url)!)
    urlreq.httpMethod="GET"
    urlreq.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let task=URLSession.shared.dataTask(with: urlreq, completionHandler: {data,response,error in
      guard error == nil && data != nil else
      {
        return;
      }
      
      // check for http errors
      if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode/100 != 2
      {
        DispatchQueue.main.sync
        {
          print("statusCode should be 200, but is \(httpStatus.statusCode)")
          print("response = \(String(describing: response))")
        }
        return;
      }
      DispatchQueue.main.sync
      {
        do {
          let json=try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
          //print("--currency rates--\(json)")
          if json!["success"] as! Int == 1
          {
            let data = json!["data"]! as! Dictionary<String,Any>
            let rates = data["rates"] as! Dictionary<String,Any>
            UserDefaults.standard.set(rates, forKey: "rates")
            if UserDefaults.standard.value(forKey: "Store") != nil
            {
              //self.load_app()
            }
          }
        }
        catch{ }
      }
    })
    task.resume()
  }
  
  func load_app()
  {
    let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
    rootviewcontroller.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LaunchScreenControl")
    let mainwindow = (UIApplication.shared.delegate?.window!)!
    mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
    UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
    }) { (finished) -> Void in
    }
  }
 
  func application(_ application: UIApplication,
                   continue userActivity: NSUserActivity,
                   restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool{
    print("Continue User Activity called: ")
      let state = UIApplication.shared.applicationState
      if(state == .inactive){
          DispatchQueue.main.asyncAfter(deadline: .now()+8.0) {
              if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
                let url = userActivity.webpageURL!
                print(url.absoluteString)
                let urlstring = url.absoluteString
                if(urlstring.contains("?pid=")){
                  let pid = urlstring.components(separatedBy: "?pid=")
                  UserDefaults.standard.set(["product":pid.last!], forKey: "NotificationData")
                  let notficData: [String:Any] = ["link_type":"product","link_id":pid.last!]
                  UserDefaults.standard.set(notficData, forKey: "MageNotificationData")
                    self.loadHomepage()
                }
                else if(urlstring.contains("?cid=")){
                  let pid = urlstring.components(separatedBy: "?cid=")
                  let str="gid://shopify/Collection/"+pid.last!
                  UserDefaults.standard.set(["collection":str], forKey: "NotificationData")
                  let notficData: [String:Any] = ["link_type":"collection","link_id":str]
                  UserDefaults.standard.set(notficData, forKey: "MageNotificationData")
                }
              }
          }
      }
      else{
          if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            let url = userActivity.webpageURL!
            print(url.absoluteString)
            let urlstring = url.absoluteString
            if(urlstring.contains("?pid=")){
              let pid = urlstring.components(separatedBy: "?pid=")
              UserDefaults.standard.set(["product":pid.last!], forKey: "NotificationData")
              let notficData: [String:Any] = ["link_type":"product","link_id":pid.last!]
              UserDefaults.standard.set(notficData, forKey: "MageNotificationData")
                self.loadHomepage()
            }
            
            else if(urlstring.contains("?cid=")){
              let pid = urlstring.components(separatedBy: "?cid=")
              let str="gid://shopify/Collection/"+pid.last!
              UserDefaults.standard.set(["collection":str], forKey: "NotificationData")
              let notficData: [String:Any] = ["link_type":"collection","link_id":str]
              UserDefaults.standard.set(notficData, forKey: "MageNotificationData")
            }
          }
      }
    return true
  }
  

  func loadApp(){
    let story = UIStoryboard(name: "Main", bundle: nil)
    let viewControl = story.instantiateViewController(withIdentifier: "LaunchScreenControl") as? LaunchScreenControl
    self.window?.rootViewController = viewControl
//      viewControl!.window = self.window
    self.window?.makeKeyAndVisible()
  }
    
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
      AppEvents.shared.activateApp()
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    self.saveContext()
  }
  
  // MARK: - Core Data stack
  
  lazy var persistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    let container = NSPersistentContainer(name: "MageNative_Shopify_App")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        
        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  // MARK: - Core Data Saving support
  
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
}


