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

extension CartManager
{
  func getAccessLocalNotification(){
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .badge, .sound]) { [unowned self] (granted, error) in
      if granted {
        self.scheduleNotification()
      } else {
        print("Not granted")
      }
    }
  }
    
  func scheduleNotification(){
    
    let notificationContent = UNMutableNotificationContent()
    notificationContent.title = ""
    notificationContent.subtitle = "Something left in your cart!".localized
    notificationContent.body = "Make hurry before product gets out of stock.".localized
    notificationContent.sound = UNNotificationSound.default
    // Add Trigger
    let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval:86400, repeats: true)
    // Create Notification Request
    let notificationRequest = UNNotificationRequest(identifier: "magenative_cart_notification_center", content: notificationContent, trigger: notificationTrigger)
    // Add Request to User Notification Center
    
    if customAppSettings.sharedInstance.abandonedCartCompaigns {
      UNUserNotificationCenter.current().add(notificationRequest) { (error) in
        if let error = error {
          print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
        }
      }
    }
    
   
  }
}
