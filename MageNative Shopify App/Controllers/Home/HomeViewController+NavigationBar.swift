//
//  HomeViewController+NavigationBar.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 14/09/19.
//  Copyright © 2019 MageNative. All rights reserved.
//

import UIKit
import MobileBuySDK
import SwiftUI

extension HomeViewController {
    
    func setupNavLayout(snapshop:[String:Any]?){
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let snapshotKEy = snapshop?.filter{$0.key.contains("top-bar")}.first?.key
        guard let snapshotKey = snapshotKEy else {
            return
        }
        
        if let topBarSettings = snapshop?[snapshotKey] as? [String:Any] {
            navigationViewModel = HomeTopBarViewModel(from: topBarSettings)
            Client.navigationThemeData = navigationViewModel
            setupNavigationBar()
            
//            if(navigationViewModel?.item_banner == "1")
//            {
//                showNavigationBanner()
//            }
//            else{
//                hideNavigationBanner()
//            }
            hideNavigationBanner()
            self.setupTabbar()
            self.middleLogoImage.isHidden = true
            self.middleLogoImage.removeFromSuperview()
            
            switch navigationViewModel?.search_position {
                
            case "search-as-icon":
                self.searchBar2?.isHidden = true
                //self.voiceView.isHidden=true;
                //self.voiceButton.isHidden=true;
                self.serachBox?.isHidden = true
                self.appHeaderLogo?.isHidden = false
                self.searchNavButton?.isHidden = false
                self.headerLogoStackView.isHidden = false;
                self.logoSpacerView.isHidden = false;
            case "middle-width-search":
                self.searchNavButton.isHidden = true
                self.searchBar2.isHidden = true
                //self.voiceView.isHidden=true;
                //self.voiceButton.isHidden=true;
                self.serachBox.isHidden = false
                self.appHeaderLogo.isHidden = true
                self.headerLogoStackView.isHidden = true;
                self.logoSpacerView.isHidden = true;
            case "full-width-search":
                self.searchNavButton.isHidden = true
                self.appHeaderLogo.isHidden = false
                self.searchBar2.isHidden = false
                //self.voiceView.isHidden=false;
                //self.voiceButton.isHidden=false;
                self.serachBox.isHidden = true
                self.headerLogoStackView.isHidden = false;
                self.logoSpacerView.isHidden = false;
            case "middle-logo":
                self.searchBar2?.isHidden = true
                self.serachBox?.isHidden = true
                self.appHeaderLogo?.isHidden = true
                self.searchNavButton?.isHidden = false
                self.headerLogoStackView.isHidden = true;
                self.logoSpacerView.isHidden = true;
                self.middleLogoImage.isHidden = false
//                self.middleLogoImage.backgroundColor = .green
                self.middleLogoImage.translatesAutoresizingMaskIntoConstraints = false
                self.centralView.addSubview(self.middleLogoImage)
                self.middleLogoImage.topAnchor.constraint(equalTo: hampMenu.topAnchor, constant: 0).isActive = true
                self.middleLogoImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
                self.middleLogoImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
                self.middleLogoImage.bottomAnchor.constraint(equalTo: hampMenu.bottomAnchor).isActive = true
                self.middleLogoImage.centerXAnchor.constraint(equalTo: centralView.centerXAnchor, constant: 0).isActive = true
            default:
                print("Hello")
            }
            
        }
        // self.setupTabbar()
    }
    
    func decorateSearchField(textField: UITextField)
    {
        //    let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        //    let rv = SearchFieldRightView()
        //
        //    view.addSubview(rv)
        //    rv.translatesAutoresizingMaskIntoConstraints = false
        //
        //    rv.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        //    rv.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        //    rv.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        //    rv.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        //    rv.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //    rv.heightAnchor.constraint(equalToConstant: 30).isActive = true
        //
        //    textField.rightViewMode = .always
        //    textField.rightView = view
        //
        //    self.searchBar2.textAlignment = .left
        
        textField.backgroundColor = UIColor(light: /*navigationViewModel?.search_background_color ??*/ .white, dark: .black)
        textField.textColor = UIColor(light: navigationViewModel?.search_text_color ?? .gray, dark: .white)
           
//        textField.makeBorder(width: 1, color: UIColor(light: navigationViewModel?.search_border_color ?? .black,dark: .white) , radius: 5)
        
        setPaddingWithImage(image: UIImage(named: "searchFilled")!, textField: textField)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        textField.font = mageFont.lightFont(size: 13)
        textField.attributedText = NSAttributedString(string: navigationViewModel?.search_placeholder ?? "", attributes: [.paragraphStyle: paragraphStyle])
    }
  
    func setPaddingWithImage(image: UIImage, textField: UITextField){
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(light:.black, dark: .white)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.frame = CGRect(x: 13.0, y: 7.0, width: 15.0, height: 15.0)
        //For Setting extra padding other than Icon.
        textField.leftViewMode = .always
        view.addSubview(imageView)
        textField.leftViewMode = .always
        textField.leftView = view
    }
    
    
    func showNavigationBanner(){
        let cell = BannerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-5, height: self.view.frame.width*(3/7) + 10))
        cell.singleTopImage = topImageSingle
        cell.configure(from:navigationViewModel!)
        cell.backgroundColor = .clear;
        cell.bannerView.backgroundColor = .clear
        if(UIDevice.current.userInterfaceIdiom == .pad){
            self.backViewHeight.constant = 520;
        }
        else if(UIDevice.current.hasNotch){
            self.backViewHeight.constant = 280;
        }
        else{
            self.backViewHeight.constant = 260
        }
        if(navigationViewModel?.search_position == "full-width-search"){
            self.backViewHeight.constant = self.backViewHeight.constant + 40;
        }
        self.topImageShadowView.isHidden = false;
        //cell.backgroundColor = navigationViewModel?.panel_background_color;
        self.navigation?.backgroundColor = .clear;
        tableView.tableHeaderView = cell
        self.blurView.isHidden = false;
        cell.delegate = self
    }
    
    func setupTabbar(){
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                let appearance = UITabBarAppearance()
                appearance.configureWithOpaqueBackground()
                //            appearance.backgroundColor = .white
                let itemAppearance = UITabBarItemAppearance()
                itemAppearance.normal.iconColor =  self.checkTabColor()/*UIColor(light: .AppTheme(),dark: .AppTheme())*/
                itemAppearance.selected.iconColor = self.checkTabColor()/*UIColor(light: .AppTheme(),dark: .AppTheme())*/
                itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor : self.checkTabColor(), NSAttributedString.Key.font : mageFont.regularFont(size: 10.0)]
                itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor :self.checkTabColor(), NSAttributedString.Key.font : mageFont.regularFont(size: 10.0)]
                appearance.inlineLayoutAppearance  = itemAppearance
                appearance.stackedLayoutAppearance = itemAppearance
                self.tabBarController?.tabBar.standardAppearance = appearance
                if #available(iOS 15.0, *) {
                    self.tabBarController?.tabBar.scrollEdgeAppearance = self.tabBarController?.tabBar.standardAppearance
                } else {
                    // Fallback on earlier versions
                }
                self.tabBarController?.tabBar.items?.forEach { (item) in
                    
                    item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor(light: .AppTheme(),dark: .AppTheme()), NSAttributedString.Key.font : mageFont.regularFont(size: 10.0)], for: .selected)
                    item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor(light: .AppTheme(),dark: .AppTheme()), NSAttributedString.Key.font : mageFont.regularFont(size: 10.0)], for: .normal)
                    
                }
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
    
    func hideNavigationBanner(){
        if(navigationViewModel?.search_position == "full-width-search"){
            self.backViewHeight.constant = 85;
        }
        else{
            self.backViewHeight.constant = 45;
        }
        self.topImageShadowView.isHidden = true;
        self.topImageSingle.image = nil
        self.topImageSingle.backgroundColor = .clear
        self.navigation?.backgroundColor = UIColor(light: navigationViewModel?.panel_background_color ?? .white, dark: .black)
        tableView.tableHeaderView = nil
        self.blurView.isHidden = true;
    }

    @objc func searchButtonClicked(_ sender: UIButton)
    {
        if customAppSettings.sharedInstance.showTabbar{
            self.tabBarController?.selectedIndex = 1;
        }else{
            let viewController=NewSearchVC()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @objc func cartIconClicked(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let data = DBManager.shared.cartProducts?.filter{$0.sellingPlanId != ""}
        if data?.count ?? 0 > 0 {
            let vc : NewCartViewController = storyboard.instantiateViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let vc : CartViewController = storyboard.instantiateViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func wishlistButtonClicked(_ sender: UIButton)
    {
        if customAppSettings.sharedInstance.isGrowaveWishlist && Client.shared.isAppLogin() {
            let vc = GetNavigation.shared.getGrowWishlistController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let viewController:WishlistViewController = self.storyboard!.instantiateViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}



extension HomeViewController{
    
    func setupNavigationBar(){
        
        //    self.navigation?.layer.masksToBounds = false
        //    self.navigation?.layer.shadowRadius = 4
        //    self.navigation?.layer.shadowOpacity = 0.5
        //    self.navigation?.layer.shadowColor = UIColor.lightGray.cgColor
        //    self.navigation?.layer.shadowOffset = CGSize(width: 0 , height:0)
        
        self.searchBar2.placeholder = navigationViewModel?.search_placeholder
        self.hampMenu.isHidden = false;
        self.cartIcon.isHidden = false;
        self.serachBox.placeholder = navigationViewModel?.search_placeholder
        self.appHeaderLogo?.setImageFrom(navigationViewModel?.logo_image_url)
        
        self.backView.backgroundColor = UIColor(light: navigationViewModel?.panel_background_color ?? .white, dark: .black)
        self.middleLogoImage.setImageFrom(navigationViewModel?.logo_image_url)
        self.navigation?.tintColor = UIColor(light: navigationViewModel?.icon_color ?? .black, dark: .white)
        self.cartIcon.tintColor = UIColor(light: navigationViewModel?.icon_color ?? .black, dark: .white)
        self.searchNavButton.tintColor = UIColor(light: navigationViewModel?.icon_color ?? .black, dark: .white)
        self.searchNavButton.setImage(UIImage(named: "searchFilled"), for: .normal)
        self.hampMenu.tintColor = UIColor(light: navigationViewModel?.icon_color ?? .black, dark: .white)
        self.searchNavButton.imageView?.contentMode = .scaleAspectFit
        
        self.wishListIcon?.isHidden = navigationViewModel?.wishlist ?? false
        self.wishListIcon.setImage(UIImage(named: "heartNew")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.cartIcon.setImage(UIImage(named: "bag")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.cartIcon.imageView?.contentMode = .scaleAspectFit
        self.searchNavButton.imageView?.contentMode = .scaleAspectFit
        
        self.wishListIcon.badgeBackgroundColor = navigationViewModel?.count_color ?? UIColor.red;
        self.wishListIcon.badgeTextColor = navigationViewModel?.count_textcolor ?? UIColor.white;
        self.wishListIcon.badgeLabel.layer.borderWidth = 1.2
        self.cartIcon.badgeLabel.layer.borderWidth = 0
        
        if #available(iOS 13.0, *) {
            self.wishListIcon.badgeLabel.layer.borderColor = UIColor.systemBackground.cgColor
            self.cartIcon.badgeLabel.layer.borderColor = UIColor.systemBackground.cgColor
        } else {
            self.wishListIcon.badgeLabel.layer.borderColor = UIColor.white.cgColor
            self.cartIcon.badgeLabel.layer.borderColor = UIColor.white.cgColor
        }
        wishListIcon.isHidden = true
        customAppSettings.sharedInstance.wishlistCheck.subscribe( onNext: {_ in
            if((self.navigationViewModel?.wishlist) == false){//!= nil
                self.wishListIcon.isHidden = true
            }
            else{
                self.wishListIcon.isHidden = false
            }
        }).disposed(by: self.disposeBag)
        
        self.setupNavBarCount()
        
        wishListIcon.badgeEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 10)
        self.cartIcon.badgeBackgroundColor = UIColor(light:  navigationViewModel?.count_color ?? UIColor.red,dark: .white)
        self.cartIcon.badgeTextColor =  UIColor(light: navigationViewModel?.count_textcolor ?? UIColor.white,dark: .black);
        decorateSearchField(textField: self.searchBar2)
        decorateSearchField(textField: self.serachBox)
        cartIcon.badgeEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 10)
        //      if customAppSettings.sharedInstance.rtlSupport {
        let value = UserDefaults.standard.object(forKey: "AppleLanguages") as? [String]
        if value?[0] == "ar"{
            self.hampMenu.addTarget(self.revealViewController(), action:  #selector(SWRevealViewController.rightRevealToggle(_:)), for: .touchUpInside)
        }else{
            self.hampMenu.addTarget(self.revealViewController(), action:  #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        }
        //      }
        //      else {
        //          self.hampMenu.addTarget(self.revealViewController(), action:  #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        //      }
        
        self.wishListIcon.addTarget(self, action: #selector(wishlistButtonClicked(_:)), for: .touchUpInside)
        self.searchNavButton.addTarget(self, action: #selector(searchButtonClicked(_:)), for: .touchUpInside)
        self.cartIcon.addTarget(self, action: #selector(cartIconClicked(_:)), for: .touchUpInside)
        searchBar2.delegate = self
        serachBox.delegate = self
    }
    
    
    func setupNavBarCount(){
        
        self.cartIcon.badge = CartManager.shared.cartCount == 0 ? nil : CartManager.shared.cartCount.description
    
        // self.wishListIcon.badge =  WishlistManager.shared.wishCount == 0 ? nil : WishlistManager.shared.wishCount.description
        
    }
    
    func setupBackgroundHeight(){
        if(UIDevice.current.userInterfaceIdiom == .pad){
            topImageSingleHeightConstraint.constant = 380;
        }
        else if(UIDevice.current.hasNotch){
            topImageSingleHeightConstraint.constant = 220;
        }
        else{
            topImageSingleHeightConstraint.constant = 190;
        }
        topImageShadowView.createArc()
        topImageSingle.createArc()
        topShadowImageView.isHidden = true;
    }
}


extension HomeViewController: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if customAppSettings.sharedInstance.showTabbar{
            self.tabBarController?.selectedIndex = 1;
        }else{
            let viewController=NewSearchVC()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        return false
    }
}

