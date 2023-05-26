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

class TabbarController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupTabbar()
        self.setupVC()
    }
 
    func setupVC() {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = story.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let searchVC = GetNavigation.shared.getSearchController()
        let categoryVC = GetNavigation.shared.getCategoriesController()
        let accountVC : AccountViewController = story.instantiateViewController()
        
        viewControllers = [
            createNavControllers(rootViewController: homeVC, title: "Home".localized, image: UIImage(named: "Unselected-Home")!, selectedImage: UIImage(named: "Selected-Home")!),
            createNavControllers(rootViewController: searchVC, title: "Search".localized, image: UIImage(named: "Selected-Search")!, selectedImage: UIImage(named: "HighlightSearch")!),
            createNavControllers(rootViewController: categoryVC, title: "Categories".localized, image: UIImage(named: "Unselected-Category")!, selectedImage: UIImage(named: "Selected-Category")!), createAccountNavControllers(rootViewController: accountVC, title: "Account".localized, image: UIImage(named: "Unselected-Account")!, selectedImage: UIImage(named: "Selected-Account")!),
            createNavControllers(rootViewController: NotificationCenterVC(), title: "Notifications".localized, image: UIImage(named: "Unselected-Notification")!, selectedImage: UIImage(named: "Selected-Notification")!)
        ]
    }
    
    func createNavControllers(rootViewController:UIViewController, title:String, image : UIImage,selectedImage : UIImage) -> UIViewController {
        let navController = BaseNavigation(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.tabBarItem.selectedImage = selectedImage
        rootViewController.navigationItem.title = title
        return navController
    }
    
    func createAccountNavControllers(rootViewController:UIViewController, title:String, image : UIImage,selectedImage : UIImage) -> UIViewController {
            let navController = AccountNavigation(rootViewController: rootViewController)
            navController.tabBarItem.title = title
            navController.tabBarItem.image = image
            navController.restorationIdentifier = "AccountNavigation"
            navController.tabBarItem.selectedImage = selectedImage
            rootViewController.navigationItem.title = title
            return navController
        
    }
    
    
    func setupTabbar(){
        if #available(iOS 13.0, *) {
                   let appearance = UITabBarAppearance()
                   appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .tabBar).backGroundColor)
            let itemAppearance = UITabBarItemAppearance()
            
            itemAppearance.normal.iconColor =  self.checkTabColor()
            itemAppearance.selected.iconColor = self.checkTabColor()
            itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor : self.checkTabColor(), NSAttributedString.Key.font : mageFont.regularFont(size: 10.0)]
            itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor : self.checkTabColor(), NSAttributedString.Key.font : mageFont.regularFont(size: 10.0)]
                   appearance.inlineLayoutAppearance = itemAppearance
                   appearance.stackedLayoutAppearance = itemAppearance
                   tabBar.standardAppearance = appearance
                   if #available(iOS 15.0, *) {
                       tabBar.scrollEdgeAppearance = tabBar.standardAppearance
                   } else {
                       // Fallback on earlier versions
                   }
               }
        
    }
    
    func checkTabColor()-> UIColor{
        let themeColor = UIColor.AppTheme().toHexString().lowercased()
        let textColor  = UIColor.textColor().toHexString().lowercased()
        switch themeColor {
        case  "#ffffff", "#000000":
            switch textColor {
            case  "#ffffff", "#000000":
                return UIColor(light: .black,dark: .white)
            default:
                return UIColor.textColor()
            }
        default:
            return UIColor.AppTheme()
        }
    }

    //New --> NewLoginNavigation
    // Original --> LoginNavigationController
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let navigation = viewController as? UINavigationController{
            if !Client.shared.isAppLogin() {
                if navigation.restorationIdentifier == "AccountNavigation" {
                    if let loginNavigation = self.storyboard?.instantiateViewController(withIdentifier:"NewLoginNavigation") {
                        loginNavigation.modalPresentationStyle = .overCurrentContext
                        self.present(loginNavigation, animated: true, completion: nil)
                    }
                    return false
                }
            }
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UITabBar {
  func tabsVisiblty(_ isVisiblty: Bool = customAppSettings.sharedInstance.showTabbar){
    /*if isVisiblty {
        self.isHidden = false
        self.layer.zPosition = 0
    } else {
        self.isHidden = true
        self.layer.zPosition = -1
    }}*/
      
      if isVisiblty {
          if customAppSettings.sharedInstance.hideTabbarOnProduct{
              self.isHidden = true
              self.layer.zPosition = -1
              //self.isTranslucent = true
          }
          else{
              self.isHidden = false
              self.layer.zPosition = 0
              //self.isTranslucent = false
          }
      }
      else{
          self.isHidden = true
          self.layer.zPosition = -1
          //self.isTranslucent = true;
      }
  }
}

struct TabbarCustomizationOptions {
    var iconDefaultColor: UIColor = UIColor.darkGray
    var iconSelectedColor: UIColor = UIColor.iconColor
    var tabbarBackgroundColor:UIColor = UIColor.white
    var displayMenuItems: Bool = true
    var rootViewController: UIViewController
    var iconImage = UIImage(named: "placeholder")
    var recognizer: String
    var title: String
}
