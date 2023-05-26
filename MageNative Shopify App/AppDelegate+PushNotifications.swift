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

import UserNotifications
extension AppDelegate:UNUserNotificationCenterDelegate, MessagingDelegate {
  
  func registerForPushNotification(application:UIApplication){
      UNUserNotificationCenter.current().delegate = self
    if #available(iOS 10, *) {
      UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in
          if granted {
              DispatchQueue.main.async {
                  application.registerForRemoteNotifications()
              }
          }
          else {
              print("USER DENIED NOTIFICATION")
          }
      }
    }
  }
    

    
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
    Messaging.messaging().subscribe(toTopic: Client.messageTopic)
      Messaging.messaging().delegate = self
      Messaging.messaging().token { token, error in
        if let error = error {
          print("Error fetching FCM registration token: \(error)")
        } else if let token = token {
          print("FCM registration token: \(token)")
            self.registerFCMtoken(token: token)
        }
      }
  }
    
    func registerFCMtoken(token:String) {
        let udid=UIDevice.current.identifierForVendor!.uuidString
        let url=(AppSetUp.baseUrl+"index.php/shopifymobile/shopifyapi/setdevices?mid="+Client.merchantID+"&device_id="+token+"&email=&type=ios&unique_id="+udid).getURL()
        var urlreq=URLRequest(url: url!)
        urlreq.httpMethod="GET"
        urlreq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        AF.request(urlreq).responseData(completionHandler: {
          response in
          switch  response.result {
          case .success:
            print("Success")
          case .failure:
            print("Failure")
          }
          
        })
    }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    print(userInfo)
    let state = UIApplication.shared.applicationState
    let test=userInfo["aps"] as! Dictionary<String,Any>
    let main=test["alert"] as! Dictionary<String,Any>
    if state == .active {
      
      
      let alert=UIAlertController(title: main["title"] as? String, message: main["body"] as? String, preferredStyle: .alert)
      let action=UIAlertAction(title: "Ok".localized, style: .default, handler: { (action: UIAlertAction!) in
        self.openPages(main: main, active: true)
        
      })
      let action_cancel=UIAlertAction(title: "Cancel".localized, style: .destructive, handler: { (action: UIAlertAction!) in
        return
      })
      alert.addAction(action)
      alert.addAction(action_cancel)
      self.window?.rootViewController?.present(alert, animated: true, completion: nil)
      return
    }
    else if state == .background{
      self.openPages(main: main, active: true)
    }
    else if state == .inactive{
      self.openPages(main: main)
    }
    else{
      self.openPages(main: main)
    }
    
  }
  
  func openPages(main:Dictionary<String,Any>, active: Bool = false){
    print(main)

    AnalyticsFirebaseData.shared.firebaseSourceOfOpen(source: "Push Notification")
      
    var tempMain=main
    tempMain.removeValue(forKey: "expired_on")
    UserDefaults.standard.set(tempMain, forKey: "MageNotificationData")
    
    let notType=main["link_type"] as! String
    let notification_id=main["notification_id"] as! String
    if UserDefaults.standard.value(forKey: "NotificationIDS") != nil
    {
      let temp=UserDefaults.standard.value(forKey: "NotificationIDS") as! String
      let data=","+notification_id
      UserDefaults.standard.set(temp+data, forKey: "NotificationIDS")
    }
    else
    {
      UserDefaults.standard.set(notification_id, forKey: "NotificationIDS")
    }
    if(notType == "collection"){
      let data="\(main["link_id"] ?? 0)"
      let str="gid://shopify/Collection/"+data
      UserDefaults.standard.set(["collection":str], forKey: "NotificationData")
        pushRedirect()
    }
    else if (notType == "product"){
      let data=main["link_id"] as! String
      let str="gid://shopify/Product/"+data
      UserDefaults.standard.set(["product":str], forKey: "NotificationData")
        pushRedirect()
    }
    
    else if (notType == "web_address"){
      let data=main["link_id"] as! String
      UserDefaults.standard.set(["web":data], forKey: "NotificationData")
        pushRedirect()
    }
    return
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert, .sound])
  }
  
  
  
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    Messaging.messaging().subscribe(toTopic: Client.messageTopic){ error in
      if error == nil{
        print("Subscribed to topic")
      }
      else{
        print("Not Subscribed to topic")
      }
    }
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
    if response.notification.request.identifier == "magenative_cart_notification_center" {
      //let cartSelect = ["link_type":"cart"]
      //self.openPages(main: cartSelect)
      
    }
    else{
      let state = UIApplication.shared.applicationState
      //let test=userInfo["aps"] as! Dictionary<String,Any>
      
      //print(response.notification.request.content.userInfo)
      //let userInfo = response.notification.request.content.userInfo
      //    let test=userInfo["gcm.notification.data"] as? Dictionary<String,Any>
      let userInfo = response.notification.request.content.userInfo
      print(userInfo)
      let main=userInfo["gcm.notification.data"] as? String
      
      if let data = main?.data(using: .utf8) {
        guard let data = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {return;}
        
        if state == .active {
          self.openPages(main:data, active: true)
        }
        else if state ==
            .background{
          self.openPages(main: data)
        }
        else if state == .inactive{
          self.openPages(main: data)
        }
        else{
          self.openPages(main: data)
        }
      }
    }
    completionHandler()
  }
}
