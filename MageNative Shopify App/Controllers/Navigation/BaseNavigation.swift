//
//  BaseNavigation.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 15/07/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class BaseNavigation: UINavigationController {
    var darkColors = DarkColor()
    var currentViewController:UIViewController?
    //var
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
      override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
              self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
          if #available(iOS 13.0, *) {
              let appearance = UINavigationBarAppearance()
              appearance.configureWithOpaqueBackground()
    
              appearance.backgroundColor = UIColor(light: Client.navigationThemeData?.panel_background_color ?? UIColor.white,dark: .black)
              appearance.titleTextAttributes = [.font: mageFont.mediumFont(size: 16),NSAttributedString.Key.foregroundColor: UIColor(light: Client.navigationThemeData?.icon_color ?? .AppTheme(),dark: .white)]
              UINavigationBar.appearance().tintColor = .white
              UINavigationBar.appearance().standardAppearance     = appearance
              UINavigationBar.appearance().scrollEdgeAppearance   = appearance
              UINavigationBar.appearance().isTranslucent = false

              //For aligning navigation title to left
  //            let offset = UIOffset(horizontal: -CGFloat.greatestFiniteMagnitude, vertical: 0)
  //            UINavigationBar.appearance().standardAppearance.titlePositionAdjustment = offset
  //            UINavigationBar.appearance().scrollEdgeAppearance?.titlePositionAdjustment = offset
  //            UINavigationBar.appearance().compactAppearance?.titlePositionAdjustment = offset
          }
          else {
          }
    }
     
    
    func makeNaVigationBar(me:UIViewController?,shareButtonItem: inout UIBarButtonItem!){
        self.darkColors = UIColor.provideColor(type: .navBar)
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
             appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(light: Client.navigationThemeData?.panel_background_color ?? UIColor.white,dark: .black)
            appearance.titleTextAttributes = [.font: mageFont.mediumFont(size: 16)]
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().isTranslucent = false

        }
        else {
        }
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        backButton.addTarget(self, action: #selector(backfunc(sender:)), for: .touchUpInside)
        backButton.setImage(UIImage(named:"backArrow"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit;
        currentViewController = me
        let backBarButton = UIBarButtonItem(customView: backButton)
        
        //Make search item
        let searchButton=UIButton(type: .custom)
        searchButton.frame=CGRect(x: 0, y: 0, width: 15, height: 15)
        searchButton.setImage(UIImage(named: "searchImg"), for: .normal)
        searchButton.imageView?.contentMode = .scaleAspectFit;
        searchButton.addTarget(self, action: #selector(searchNavigate), for: .touchUpInside)
        
        let wishlistButton=UIButton(type: .custom)
        wishlistButton.frame=CGRect(x: 0, y: 0, width: 15, height: 15)
        wishlistButton.setImage(UIImage(named: "heartNew"), for: .normal)
        wishlistButton.imageView?.contentMode = .scaleAspectFit;
        wishlistButton.addTarget(self, action: #selector(wishlistNavigate), for: .touchUpInside)
        let wishlistButtonNav = UIBarButtonItem(customView: wishlistButton)
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 13
        
        //let searchButtonNav =  UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(searchNavigate))
        let searchButtonNav = UIBarButtonItem(customView: searchButton)
        //Make cart item
        let cartbutton = BadgeButton()
        cartbutton.frame=CGRect(x: 0, y: 0, width: 15, height: 15)
        cartbutton.setImage(UIImage(named: "bag"), for: .normal)
        cartbutton.imageView?.contentMode = .scaleAspectFit;
        cartbutton.addTarget(self, action: #selector(viewCart(sender:)), for: .touchUpInside)
//        cartbutton.tintColor = Client.navigationThemeData?.icon_color
        cartbutton.badgeTextColor = Client.navigationThemeData?.count_textcolor ?? UIColor.white;
        let cart = UIBarButtonItem(customView: cartbutton)
        cartbutton.badge = CartManager.shared.cartCount == 0 ? nil : CartManager.shared.cartCount.description
        cart.tag = 786;
        
        //        let sharebutton = UIButton()
        //        sharebutton.frame=CGRect(x: 0, y: 0, width: 15, height: 15)
        //        sharebutton.setImage(UIImage(named: "share"), for: .normal)
        //        sharebutton.imageView?.contentMode = .scaleAspectFit;
        //        //sharebutton.addTarget(self, action: #selector(viewCart(sender:)), for: .touchUpInside)
        //        shareButtonItem = UIBarButtonItem(customView: sharebutton)
        
        
        
        //let navigationTitle = UIButton(frame: CGRect(x: 0, y: 0, width: 110, height: 70))
        //navigationTitle.addTarget(self, action: #selector(homeClicked(sender:)), for: .touchUpInside);
        
        if let me = me as? WishlistViewController{
            /*if customAppSettings.sharedInstance.showTabbar{
                me.navigationItem.leftBarButtonItems = []
            }
            else{*/
                me.navigationItem.leftBarButtonItems = [backBarButton]
       //     }
            
            me.navigationItem.rightBarButtonItems = []
        }
        else if let me = me as? NewSearchVC{
            if customAppSettings.sharedInstance.showTabbar{
                me.navigationItem.leftBarButtonItems = []
            }
            else{
                me.navigationItem.leftBarButtonItems = [backBarButton]
            }
            me.navigationItem.rightBarButtonItems = []
        }else if let me = me as? ProductFilterViewController{
            me.navigationItem.leftBarButtonItems = [backBarButton]
            me.navigationItem.rightBarButtonItems = []
        }
        else if let me = me as? CategoryListVC{
            if customAppSettings.sharedInstance.showTabbar{
                me.navigationItem.leftBarButtonItems = []
            }
            else{
                me.navigationItem.leftBarButtonItems = [backBarButton]
            }
            if(customAppSettings.sharedInstance.inAppWishlist){
                me.navigationItem.rightBarButtonItems = []//[cart,space,wishlistButtonNav,space, searchButtonNav]
            }
            else{
                me.navigationItem.rightBarButtonItems = []//[cart,space, searchButtonNav]
            }
        }
        else if let me = me as? HomeViewController{
            me.navigationItem.leftBarButtonItems = []
            me.navigationItem.rightBarButtonItems = []
        }
        else if let me = me as? ProductVC{
            me.navigationItem.leftBarButtonItems = [backBarButton]
            if(customAppSettings.sharedInstance.inAppWishlist){
                me.navigationItem.rightBarButtonItems = [wishlistButtonNav,space, searchButtonNav]
            }
            else{
                me.navigationItem.rightBarButtonItems = [searchButtonNav]
            }
        }
        else if let me = me as? SearchViewController{
            me.navigationItem.leftBarButtonItems = [backBarButton]
            if(customAppSettings.sharedInstance.inAppWishlist){
                me.navigationItem.rightBarButtonItems = [cart,wishlistButtonNav]
            }
            else{
                me.navigationItem.rightBarButtonItems = [cart]
            }
        }
        else if let me = me as? CartViewController{
            me.navigationItem.leftBarButtonItems = [backBarButton]
            if(customAppSettings.sharedInstance.inAppWishlist){
                me.navigationItem.rightBarButtonItems = [wishlistButtonNav]
            }
            else{
                me.navigationItem.rightBarButtonItems = []
            }
        }
        else if let me = me as? AccountViewController{
            me.navigationItem.leftBarButtonItems = []//backBarButton
            me.navigationItem.rightBarButtonItems = []
        } else if let me = me as? CouponListController {
            me.navigationItem.leftBarButtonItems = [backBarButton]//backBarButton
            me.navigationItem.rightBarButtonItems = []
        }
        else if let me = me as? NotificationCenterVC {
            me.navigationItem.leftBarButtonItems = []//backBarButton
            me.navigationItem.rightBarButtonItems = []
        }
        else{
            me?.navigationItem.leftBarButtonItems = [backBarButton]
            if(customAppSettings.sharedInstance.inAppWishlist){
                me?.navigationItem.rightBarButtonItems = [cart,space,wishlistButtonNav,space, searchButtonNav]
            }
            else{
                me?.navigationItem.rightBarButtonItems = [cart,space, searchButtonNav]
            }
        }
    }
    
    
    
    @objc func searchNavigate()
    {
        if customAppSettings.sharedInstance.showTabbar{
            self.tabBarController?.selectedIndex = 1
            let vc = GetNavigation.shared.getSearchController()
            self.tabBarController?.navigationController?.setViewControllers([vc], animated: true)
        }
        else{
            let vc = GetNavigation.shared.getSearchController()
            if let lstView = self.viewControllers.last?.view {
                self.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    @objc func wishlistNavigate()
    {
        if customAppSettings.sharedInstance.isGrowaveWishlist && Client.shared.isAppLogin(){
            let vc = GetNavigation.shared.getGrowWishlistController()
            self.pushViewController(vc, animated: true)
        }
        else{
            let vc:WishlistViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController()
            
            if let lstView = self.viewControllers.last?.view {
                self.pushViewController(vc, animated: true)
            }
            
            
        }
       
    }
    
    @objc func viewCart(sender:UIButton){
        
        let vc = GetNavigation.shared.getCartController()
        if let lstView = self.viewControllers.last?.view {
            self.pushViewController(vc, animated: true)
        }
    }
    
    
    @objc func backfunc(sender:UIButton){
        //let mainview = self.sideDrawerViewController?.mainViewController  as? wooMageNavigation
        let mainview = self;
        let result =  mainview.popViewController(animated: true)
        print(result ?? "text")
    }
  
}
extension UIViewController{
    func setUpNavigationTheme(){
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(light: Client.navigationThemeData?.panel_background_color ?? UIColor.white,dark: .black)//UIColor(hexString: "#B2255E")
            appearance.titleTextAttributes = [.font: mageFont.mediumFont(size: 16),NSAttributedString.Key.foregroundColor: UIColor(light: Client.navigationThemeData?.icon_color ?? .AppTheme(),dark: .white)]
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().isTranslucent = false
        }
    }
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
