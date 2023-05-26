//
//  NewSideMenuController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 15/12/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit
import RxSwift
import AVFoundation
import ChatSDK
import MessagingSDK
import ChatProvidersSDK

class NewSideMenuController: UIViewController,SWRevealViewControllerDelegate {
    
    var shopCountry:CurrencyViewModel?
    var menus : [MenuObject] = []
    var disposeBag = DisposeBag()
    let value = UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
    
    //MARK :- VIEW
    lazy var scroll: UIScrollView = {
        UIScrollView()
    }()
    
    lazy var containerStack : UIStackView = {
        let stack = UIStackView()
        stack.spacing = 12.0
        stack.axis = .vertical
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 16, left: 16, bottom: 16, right: 16)
        stack.cardView()
        return stack
    }()
    
    lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "close"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.tintColor = UIColor(light: .black,dark: UIColor.provideColor(type: .SideMenuController).white)
        btn.addTarget(self, action: #selector(closeBtnTapped), for: .touchUpInside)
        return btn
    }()
    private lazy var navigationBottomLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false;
        line.backgroundColor = UIColor(hexString: "#D1D1D1")
        line.isHidden = true
        return line;
    }()
    lazy var headerView: UIView = {
        let view = UIView()
        view.addSubview(closeBtn)
        closeBtn.anchor(right: view.trailingAnchor, paddingRight: 8, width: 35, height: 35)
        closeBtn.centerY(inView: view)
        view.addSubview(navigationBottomLine)
        navigationBottomLine.anchor(left: view.leadingAnchor, bottom: view.bottomAnchor, right: view.trailingAnchor, paddingBottom: 2, height: 0.5)
        return view
    }()
    
    lazy var staticItemStackView: UIStackView = {
        let topHeading = UILabel()
        topHeading.font = mageFont.regularFont(size: 14)
        topHeading.textColor = UIColor(light: UIColor(hexString: "#050505", alpha: 1),dark: UIColor.provideColor(type: .SideMenuController).textColor)
        topHeading.text = "Other info".localized
        topHeading.anchor(paddingLeft: 8,height:30)
        let stack = UIStackView(arrangedSubviews: [topHeading])
        stack.spacing = 4
        stack.axis = .vertical
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 12, left: 8, bottom: 12, right: 8)
        stack.clipsToBounds = true
        if #available(iOS 13.0, *) {
           // stack.layer.borderColor =  UIColor(light: UIColor.secondarySystemBackground,dark: .lightGray).cgColor
            stack.layer.borderColor = UIColor(light: .lightGray, dark: .lightGray).cgColor
        }
        stack.layer.cornerRadius = 8
        stack.layer.borderWidth = 0.5//0.25
        return stack
    }()
    
    lazy var categoryItemStackView: UIStackView = {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.goToCategoriesNow(sender:)))
        let topHeading = UILabel()
        topHeading.isUserInteractionEnabled = true
        topHeading.font = mageFont.regularFont(size: 14)
        topHeading.textColor = UIColor(light: UIColor(hexString: "#050505", alpha: 1),dark: UIColor.provideColor(type: .SideMenuController).textColor)
        topHeading.text = "Shop by categories".localized
        topHeading.addGestureRecognizer(tapGesture)
        topHeading.anchor(paddingLeft: 8,height:30)
        let stack = UIStackView(arrangedSubviews: [topHeading])
        stack.spacing = 4.0
        stack.axis = .vertical
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 12, left: 8, bottom: 12, right: 8)
        stack.clipsToBounds = true
        if #available(iOS 13.0, *) {
           // stack.layer.borderColor =  UIColor(light: UIColor.secondarySystemBackground,dark: .lightGray).cgColor
            stack.layer.borderColor = UIColor(light: .lightGray, dark: .lightGray).cgColor
        }
        
        stack.layer.cornerRadius = 8
        stack.layer.borderWidth = 0.5
       
        
        // stack.dropShadow(color: UIColor(hexString: "#383838"), opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 8, scale: true)
        return stack
    }()
    
    //---- customviews ----
    var topLoginView = MenuLoginView()
    var livePreviewView = LivePreviewView()
    var socialMenuView = SocialMenuView()
    var themeView = ThemesView()
    var footerView = FooterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getMenuDataFromShopify()
        self.revealViewController().delegate = self
        self.revealViewController().frontViewShadowColor = .black
        if(Client.locale=="ar"){
            self.revealViewController().rightViewController = self;
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData(_:)), name: NSNotification.Name(rawValue: "loadDrawerAgain"), object: nil);
        
        Client.shared.currencyCode(completion:  {
            response in
            self.shopCountry = response
            //self.treeView.reloadData()
        })
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let overView = UIView()
        overView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        overView.tag = 123
        overView.frame = self.revealViewController().frontViewController.view.frame
        self.revealViewController().frontViewController.view.addSubview(overView)
        self.revealViewController().frontViewController.view.bringSubviewToFront(overView)
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = false
        if(Client.locale=="ar"){
            self.revealViewController().rightViewRevealWidth = UIScreen.main.bounds.size.width
        }
        else{
            self.revealViewController().rearViewRevealWidth = UIScreen.main.bounds.size.width
        }
        if #available(iOS 13.0, *) {
           // stack.layer.borderColor =  UIColor(light: UIColor.secondarySystemBackground,dark: .lightGray).cgColor
            topLoginView.layer.borderColor = UIColor(light: .lightGray, dark: .lightGray).cgColor
        }
        topLoginView.layer.cornerRadius = 8
        topLoginView.layer.borderWidth = 0.5
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = true
        self.revealViewController().frontViewController.view.viewWithTag(123)?.removeFromSuperview()
    }
    
    @objc func reloadData(_ notification: NSNotification) {
        //    getMenuData()
        getMenuDataFromShopify()
    }
    
    @objc func goToCategoriesNow(sender: UITapGestureRecognizer){
        if customAppSettings.sharedInstance.showTabbar{
            self.toggle()
            // self.revealViewController().revealToggle(animated: true)
            if let tabbarControl =  getFrontController() as? TabbarController {
                //          self.revealViewController().revealToggle(animated: true)
                tabbarControl.selectedIndex = 2
            }
        }else{
            let viewController=NewSearchVC()//:SearchViewController = self.storyboard!.instantiateViewController()
            if let tabbarControl =  getFrontController() as? TabbarController {
                self.toggle()
                if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                    navigation.pushViewController(viewController, animated: true)
                }
            }
        }
    }
    
    func getMenuDataFromShopify(){
        self.menus.removeAll()
        addStaticMenuData()
        let data = SideMenuData.shared.menus ?? []
        self.menus.append(contentsOf: data)
        self.getMoreData()
    }
    
    //JS
    func addStaticMenuData() {
        //          for (ind,_) in  menus.enumerated(){
        //              if menus[ind].id == "loginHeader"{
        //                  menus.remove(at: ind)
        //              }
        //          }
        /*if Client.shared.isAppLogin(){
         Client.shared.fetchCustomerDetails(completeion: {
         response,error in
         if let response = response {
         let name = response.displayName!
         self.menus.insert(MenuObject(name: name, id: "loginHeader", image: "",type: "loginHeader",url: ""), at: 0)
         print("DEBUG: header insert")
         }
         })
         }
         else
         {*/
        self.menus.append(MenuObject(name: "Hey Guest".localized, id: "loginHeader", image: "",type: "loginHeader",url: ""))
        print("DEBUG: header insert")
        
        //  }
        
    }
    
    
    func changeTheme(theme: String) -> Int {
        if theme == "dark" {
             return 0
        } else if theme == "light" {
            return 1
        } else if theme == "unspecified" {
            return 2
        }
        return 2
    }
    @objc func valueChanged(_ sender: UISegmentedControl) {
        var value: String = "unspecified"
        if sender.selectedSegmentIndex == 0 {
            if #available(iOS 13.0, *) {
                self.view.window?.overrideUserInterfaceStyle = .dark
                value = "dark"
                UserDefaults.standard.set(value, forKey: "theme")
            } else {
                // Fallback on earlier versions
            }
        }
        else if sender.selectedSegmentIndex == 1 {
            if #available(iOS 13.0, *) {
                self.view.window?.overrideUserInterfaceStyle = .light
                value = "light"
                UserDefaults.standard.set(value, forKey: "theme")
            } else {
                // Fallback on earlier versions
            }
        } else if sender.selectedSegmentIndex == 2 {
            if #available(iOS 13.0, *) {
                self.view.window?.overrideUserInterfaceStyle = .unspecified
                value = "unspecified"
                UserDefaults.standard.set(value, forKey: "theme")
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    func getMoreData() {
        
        if customAppSettings.sharedInstance.inAppWishlist {
            // self.menus.append(MenuObject(name: "My WishList".localized, id: "", image: "Favourite",type: "static",url: ""))
        }
        if customAppSettings.sharedInstance.multiCurrency {
            self.menus.append(MenuObject(name: "Select Your Country".localized, id: "", image: "",type: "currency",url: ""))
        }
        if customAppSettings.sharedInstance.multiLanguage {
            self.menus.append(MenuObject(name: "Language".localized, id: "", image: "",type: "lang",url: ""))
        }
        if customAppSettings.sharedInstance.yotpoLoyalty {
            self.menus.append(MenuObject(name: "Earn Rewards".localized, id: "", image: "",type: "rewards",url: ""))
        }
        
        if customAppSettings.sharedInstance.isKangarooRewardsEnabled {
            self.menus.append(MenuObject(name: "Earn Rewards".localized, id: "", image: "",type: "kangarooRewards",url: ""))
        }
        
        if customAppSettings.sharedInstance.growaveRewardsIntegration {
            self.menus.append(MenuObject(name: "Earn Rewards".localized, id: "", image: "",type: "growaveRewards",url: ""))
        }
        
        // var db : [MenuObject] = []
        if customAppSettings.sharedInstance.smileIntegration {
//            self.menus.append(MenuObject(name: "Rewards".localized, id: "", image: "",type: "smile",url: ""))
        }
        if customAppSettings.sharedInstance.zendeskChat {
            self.menus.append(MenuObject(name: "Help".localized, id: "", image: "",type: "zendesk",url: ""))
        }
        if customAppSettings.sharedInstance.tidioChat {
            self.menus.append(MenuObject(name: "Chats".localized, id: "", image: "",type: "tidio",url: ""))
        }
        
        if customAppSettings.sharedInstance.shopifyInbox {
            self.menus.append(MenuObject(name: "Chat with Us".localized, id: "", image: "", type: "shopifyChat", url: ""))
        }
//        if db.count > 0 {
//            self.menus.append(MenuObject(name: "Help Center".localized, children: db, id: "", image: "", type: "Help Center", url: ""))
//        }
        self.menus.append(MenuObject(name: "Invite Your Friend".localized, id: "", image: "",type: "static",url: ""))
//        self.menus.append(MenuObject(name: "Rate Us", id: "", image: "", type: "ratings", url: ""))
        if(Client.merchantPreview)
        {
            if(Client.merchantID == "18"){
                self.menus.append(MenuObject(name: "Live Preview Of Your Store".localized, id: "123", image: "",type: "qrcode",url: ""))
            }
            else{
                self.menus.append(MenuObject(name: "Move to Demo Store".localized, id: "", image: "",type: "demo",url: ""))
            }
        }
        if(customAppSettings.sharedInstance.whatsappInegration || customAppSettings.sharedInstance.fbIntegration){
            self.menus.append(MenuObject(name: "Social", id: "", image: "",type: "social",url: ""))
        }
//        self.menus.append(MenuObject(name: "ThemeView", id: "", image: "", type: "themeView", url: ""))
        if Client.shared.isAppLogin() {
//            self.menus.append(MenuObject(name: "Logout".localized, id: "", image: "",type: "logout",url: ""))
        }
        self.menus.append(MenuObject(name:  "App "+(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0" ) + " (\(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1.0"))", id: "123", image: "",type: "loginHeader2",url: ""))
        configureStack()
    }
    
    
    
    //MARK: ------Create view------
    func configureUI(){
        self.view.backgroundColor = UIColor.viewBackgroundColor()
        view.addSubview(headerView)
        headerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingTop: 12, paddingLeft: 4,paddingRight: 70, height: 40)
        view.addSubview(scroll)
        scroll.anchor(top: headerView.bottomAnchor, left: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.trailingAnchor,paddingRight: 70)
        scroll.showsVerticalScrollIndicator = false
        scroll.addSubview(containerStack)
        containerStack.anchor(top: scroll.topAnchor, left: scroll.leadingAnchor,bottom: scroll.bottomAnchor,  right: scroll.trailingAnchor)
        containerStack.widthAnchor.constraint(equalTo: scroll.widthAnchor).isActive = true
        
        
    }
    func configureStack(){
        containerStack.subviews.forEach{$0.removeFromSuperview()}
        disposeBag = DisposeBag()
        for (ind,val) in categoryItemStackView.subviews.enumerated(){
            if ind != 0{
                val.removeFromSuperview()
            }
        }
        for (ind,val) in staticItemStackView.subviews.enumerated(){
            if ind != 0{
                val.removeFromSuperview()
            }
        }
//        categoryItemStackView.subviews.forEach{$0.removeFromSuperview()}
//        staticItemStackView.subviews.forEach{$0.removeFromSuperview()}
        print(menus.count)
        menus.forEach{ item in
            switch item.type{
            case "loginHeader":
                containerStack.addArrangedSubview(topLoginView)
                topLoginView.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .SideMenuController).backGroundColor)
                containerStack.addArrangedSubview(categoryItemStackView)
                categoryItemStackView.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .SideMenuController).black)
                containerStack.addArrangedSubview(staticItemStackView)
                staticItemStackView.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .SideMenuController).black)
                topLoginView.anchor(height: 90)
                topLoginView.setup(menu: item)
                topLoginView.tapBtnView.rx.tap.bind{self.navigateAccordingToType(seletedMenu: item)}.disposed(by: disposeBag)
            case "loginHeader2":
                containerStack.addArrangedSubview(footerView)
                footerView.anchor(height: 70)
                footerView.setup(menu: item)
            case "social":
                containerStack.addArrangedSubview(socialMenuView)
                socialMenuView.delegate = self
                if(!customAppSettings.sharedInstance.fbIntegration){
                    socialMenuView.fbButton.isHidden = true;
                }
                if(!customAppSettings.sharedInstance.whatsappInegration){
                    socialMenuView.whatsAppButton.isHidden = true;
                }
            case "qrcode","demo":
                containerStack.addArrangedSubview(livePreviewView)
                livePreviewView.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .SideMenuController).backGroundColor)
                livePreviewView.anchor(height: 100)
                livePreviewView.topBtnView.rx.tap.bind{
                    self.navigateAccordingToType(seletedMenu: item)
                    //self.qrTap()
                }.disposed(by: disposeBag)
                
            case "themeView":
                containerStack.addArrangedSubview(themeView)
                themeView.backgroundColor = .clear
                if let theme = UserDefaults.standard.value(forKey: "theme") as? String {
                    themeView.themeSegments.selectedSegmentIndex = self.changeTheme(theme: theme)
                } else {
                    themeView.themeSegments.selectedSegmentIndex = 2
                }
                themeView.themeSegments.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
                themeView.anchor(height: 100)
            case "logout":
                let button = UIButton()
                button.rx.tap.bind{
                    //  self.delegate?.logoutClicked()
                }.disposed(by: disposeBag)
                button.setTitle("Logout".localized, for: .normal)
                button.setTitleColor(UIColor(hexString: "#2472C1"), for: .normal)
                button.titleLabel?.font = mageFont.setFont(fontWeight: "light", fontStyle: "normal", fontSize: 14)
                button.setImage(UIImage(named: "logoutN")?.withRenderingMode(.alwaysTemplate), for: .normal)
                button.tintColor = UIColor(hexString: "#2472C1")
                if #available(iOS 15.0, *) {
                    var config = UIButton.Configuration.plain()
                    config.imagePadding = 8
                    button.configuration = config
                }
                button.imageView?.contentMode = .scaleAspectFit
                button.anchor(height: 40)
                button.semanticContentAttribute = Client.locale == "ar" ? .forceLeftToRight : .forceRightToLeft
                button.rx.tap.bind{
                        let alert = UIAlertController(title: "", message: "Are you sure you want to log out?".localized, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "No".localized, style: .default, handler: { action in
                          // completion(nil)
                        }))
                        alert.addAction(UIAlertAction(title: "Yes".localized, style: .cancel, handler: {  action in
                            if Client.shared.doLogOut() {
                                NotificationCenter.default.post(name: NSNotification.Name("loadDrawerAgain"), object: nil)
                                if let tabbarControl =  self.getFrontController() as? TabbarController {
                                    self.toggle()
                                    tabbarControl.selectedIndex = 0 // Not using
                                }
                            }
                        }))
                        self.present(alert, animated: true, completion: nil)
                }.disposed(by: disposeBag)
                containerStack.addArrangedSubview(button)
            case "static","lang","currency","rewards","smile","zendesk","tidio","Help Center","shopifyChat"://,"quickLinks"(Removed as discussed with Saif sir)
                let menuItemView = MenuItemView()
                staticItemStackView.addArrangedSubview(menuItemView)
                menuItemView.setup(from: item, level: 0)
                menuItemView.titleButton.rx.tap.bind{
                    self.navigateAccordingToType(seletedMenu: item)
                }.disposed(by: disposeBag)
                //MARK: RightButton tap required only for quicklinks (removed for now)
                /*
                menuItemView.rightButton.rx.tap.bind{
                    //                    //MARK:- 0 level menu items hide/show managed
                    //                    self.staticItemStackView.subviews.forEach{ level1 in
                    //                        if let level1 = level1 as? MenuItemView{
                    //                            level1.subItemStackView.subviews.forEach{$0.removeFromSuperview()}
                    //                            level1.rightButton.setImage(UIImage(named: "rightArrow"), for: .normal)
                    //                        }
                    //                    }
                    //                    //--------------
                    
                    if !menuItemView.isExpanded{
                        menuItemView.isExpanded = true
                        menuItemView.rightButton.setImage(UIImage(named: "bottomArrow"), for: .normal)
                        item.children.forEach{ level1Item in
                            let subMenuItem = MenuItemView()
                            menuItemView.subItemStackView.addArrangedSubview(subMenuItem)
                            subMenuItem.setup(from: level1Item, level: 1)
                            subMenuItem.backgroundColor = UIColor(hexString: "#F2F8FC",alpha: 1)
                            subMenuItem.titleButton.rx.tap.bind{
                                self.navigateAccordingToType(seletedMenu: level1Item)
                            }.disposed(by: self.disposeBag)
                        }
                    }else{
                        menuItemView.subItemStackView.subviews.forEach{$0.removeFromSuperview()}
                        menuItemView.isExpanded = false
                        menuItemView.rightButton.setImage(UIImage(named: "rightArrow"), for: .normal)
                    }
                }.disposed(by: disposeBag)*/
            default:
                let menuItemView = MenuItemView()
                categoryItemStackView.addArrangedSubview(menuItemView)
                menuItemView.setup(from: item, level: 0)
                menuItemView.rightButton.rx.tap.bind{
                    
                    //MARK: 0 level menu items hide/show managed
                    self.categoryItemStackView.subviews.forEach{ level1 in
                        if let level1 = level1 as? MenuItemView{
                            level1.subItemStackView.subviews.forEach{ level2 in
                                if let level2 = level2 as? MenuItemView{
                                    level2.subItemStackView.subviews.forEach{$0.removeFromSuperview()}
                                    level2.rightButton.setImage(UIImage(named: "menuPlus"), for: .normal)
                                }
                            }
                            level1.subItemStackView.subviews.forEach{$0.removeFromSuperview()}
                            level1.rightButton.setImage(UIImage(named: "rightArrow"), for: .normal)
                        }
                    }
                    //--------------
                    
                    if !menuItemView.isExpanded{
                        menuItemView.isExpanded = true
                        menuItemView.rightButton.setImage(UIImage(named: "bottomArrow"), for: .normal)
                        item.children.forEach{ level1Item in
                            let subMenuItem = MenuItemView()
                            menuItemView.subItemStackView.addArrangedSubview(subMenuItem)
                            subMenuItem.setup(from: level1Item, level: 1)
                            subMenuItem.backgroundColor =  UIColor(light: Client.navigationThemeData?.icon_color?.withAlphaComponent(0.08) ?? .white, dark: UIColor(hexString: "#383838",alpha: 0.8))
                            
                            
                            
                            //UIColor(hexString: "#F2F8FC",alpha: 1)
                            subMenuItem.rightButton.rx.tap.bind{
                                
                                //MARK: 1st level menu items hide/show managed
                                self.categoryItemStackView.subviews.forEach{ level1 in
                                    if let level1 = level1 as? MenuItemView{
                                        level1.subItemStackView.subviews.forEach{ level2 in
                                            if let level2 = level2 as? MenuItemView{
                                                level2.subItemStackView.subviews.forEach{$0.removeFromSuperview()}
                                                level2.rightButton.setImage(UIImage(named: "menuPlus"), for: .normal)
                                            }
                                        }
                                    }
                                }//-------------------
                                
                                if !subMenuItem.isExpanded{
                                    subMenuItem.isExpanded = true
                                    subMenuItem.rightButton.setImage(UIImage(named: "menuMinus"), for: .normal)
                                    level1Item.children.forEach{ level2Item in
                                        let level2View = MenuItemView()
                                        subMenuItem.subItemStackView.addArrangedSubview(level2View)
                                        level2View.setup(from: level2Item, level: 2)
                                        level2View.backgroundColor = .white
                                        level2View.titleButton.rx.tap.bind{
                                            self.navigateAccordingToType(seletedMenu: level2Item)
                                        }.disposed(by: self.disposeBag)
                                    }
                                }else{
                                    subMenuItem.subItemStackView.subviews.forEach{$0.removeFromSuperview()}
                                    subMenuItem.isExpanded = false
                                    subMenuItem.rightButton.setImage(UIImage(named: "menuPlus"), for: .normal)
                                }
                            }.disposed(by: self.disposeBag)
                            subMenuItem.titleButton.rx.tap.bind{
                                self.navigateAccordingToType(seletedMenu: level1Item)
                            }.disposed(by: self.disposeBag)
                        }
                    }else{
                        menuItemView.subItemStackView.subviews.forEach{$0.removeFromSuperview()}
                        menuItemView.isExpanded = false
                        menuItemView.rightButton.setImage(UIImage(named: "rightArrow"), for: .normal)
                    }
                    
                    
                }.disposed(by: disposeBag)
                menuItemView.titleButton.rx.tap.bind{
                    self.redirectToProductList(item: item)
                }.disposed(by: disposeBag)
            }
        }
    }
    
    // MARK: -Create view end-------
    func redirectToProductList(item: MenuObject) {
        let seletedMenu = item
        let type = returnString(strToModify:seletedMenu.type)
        if seletedMenu.children.count > 0 && type != "Help Center" && type != "quickLinks"{
            let collectionId = returnString(strToModify: seletedMenu.id)
            let coll = collection(id: collectionId, title: seletedMenu.name)
            let viewControl = ProductListVC()
            viewControl.isfromHome = true
            viewControl.collect = coll
            viewControl.pageTitle   = coll.title ?? ""
            viewControl.subMenuData = seletedMenu.children
            if let tabbarControl =  getFrontController() as? TabbarController {
                self.toggle()
                if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                    navigation.pushViewController(viewControl, animated: true)
                    return
                }
            }
        }
        self.navigateAccordingToType(seletedMenu: seletedMenu)
    }
}
extension NewSideMenuController{
    
    func getLocalizedLanguage(langCode:String)->String?{
        let locale: Locale = Locale(identifier: Client.locale)
        let store =  locale.localizedString(forLanguageCode: langCode)
        return store
    }
    
    @objc func closeBtnTapped(){
        let value = UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
        if value[0] == "ar"
        {
            self.revealViewController().rightRevealToggle(animated: true)
        }else{
            self.revealViewController().revealToggle(animated: true)
        }
    }
    func toggle(){
        let value = UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
        if value[0] == "ar"
        {
            self.revealViewController().rightRevealToggle(animated: true)
        }else{
            self.revealViewController().revealToggle(animated: true)
        }
    }
    
    // use this when switching the language
    func changeLanguagePressed(){
        print(Client.shared.getLanguageCode())
        var Stores = [String:String]()
        
        if VersionManager.panelVersion == "v2"{
            Client.availableLanguageFB.map { data in
                if let store =  self.getLocalizedLanguage(langCode: data){
                    Stores[store] = data
                }
            }
        }else{
            let _ = shopCountry?.availableLanguagesData?.map({ data in
                    Stores[data.name] = data.code.lowercased()
                  })
        }
        
//        let _ = shopCountry?.availableLanguagesData?.map({ data in
//            Stores[data.name] = data.code.lowercased()
//        })

        print("Available Languages=",Stores)
        let value = UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
        if value[0]=="ar"
        {
            self.revealViewController().rightRevealToggle(animated: true)
        }else{
            self.revealViewController().revealToggle(animated: true)
        }
        
        let actionsheet = UIAlertController(title: "Select Language".localized, message: nil, preferredStyle: .alert)
        
        for (key,value) in Stores {
            actionsheet.addAction(UIAlertAction(title: key, style: UIAlertAction.Style.default,handler: {
                action -> Void in
                if value != Client.locale{
                    self.selectStore(store:key,code: value)
                }
                //                    self.selectStore(store:key,code: value)
            }))
        }
        actionsheet.addAction(UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel, handler: {
            action -> Void in
        }))
        self.present(actionsheet, animated: true, completion: nil)
    }
    //"French"://Arabic
    func selectStore(store:String,code:String){
        print("Selection==",store,code)
        UserDefaults.standard.removeObject(forKey: "HomeDataJSON")
        Client.homeStaticThemeJSON = Data()
        Client.homeStaticThemeColor = ""
        switch code {
        case "ar":
            UserDefaults.standard.removeObject(forKey: "AppleLanguages")
            UserDefaults.standard.set(["ar"], forKey: "AppleLanguages")
            Client.locale = "ar"
            Client.shared.client = Graph.Client(shopDomain: Client.shopUrl, apiKey: Client.apiKey,locale: Locale(identifier: "ar"))
            Bundle.setLanguage("ar")
            customAppSettings.sharedInstance.rtlSupport = true;
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            UISearchBar.appearance().semanticContentAttribute = .forceRightToLeft
            UITextView.appearance().semanticContentAttribute = .forceRightToLeft
            UITextField.appearance().semanticContentAttribute = .forceRightToLeft
            UIButton.appearance().semanticContentAttribute = .forceRightToLeft
            UILabel.appearance().semanticContentAttribute = .forceRightToLeft
            UICollectionView.appearance().semanticContentAttribute = .forceRightToLeft
            UIStackView.appearance().semanticContentAttribute = .forceRightToLeft
            
            
            
//            (UIApplication.shared.delegate as! AppDelegate).loadHomepage()
            (UIApplication.shared.delegate as! AppDelegate).pushRedirect()
            if let tabbarControl =  getFrontController() as? TabbarController {
                tabbarControl.tabBar.items![0].title = "Home".localized
                tabbarControl.tabBar.items![1].title = "Search".localized
                tabbarControl.tabBar.items![2].title = "Categories".localized
                tabbarControl.tabBar.items![3].title = "Account".localized
            }
        default:
            UserDefaults.standard.removeObject(forKey: "AppleLanguages")
            UserDefaults.standard.set([code], forKey: "AppleLanguages")
            Client.locale = code
            customAppSettings.sharedInstance.rtlSupport = false;
            Client.shared.client = Graph.Client(shopDomain: Client.shopUrl, apiKey: Client.apiKey,locale: Locale(identifier: code))
            Bundle.setLanguage(code)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            UISearchBar.appearance().semanticContentAttribute = .forceLeftToRight
            UITextView.appearance().semanticContentAttribute = .forceLeftToRight
            UITextField.appearance().semanticContentAttribute = .forceLeftToRight
            UIButton.appearance().semanticContentAttribute = .forceLeftToRight
            UILabel.appearance().semanticContentAttribute = .forceLeftToRight
            UICollectionView.appearance().semanticContentAttribute = .forceLeftToRight
            UIStackView.appearance().semanticContentAttribute = .forceLeftToRight
            
            if let tabbarControl =  getFrontController() as? TabbarController {
                tabbarControl.tabBar.items![0].title = "Home".localized
                tabbarControl.tabBar.items![1].title = "Search".localized
                tabbarControl.tabBar.items![2].title = "Categories".localized
                tabbarControl.tabBar.items![3].title = "Account".localized
            }
            (UIApplication.shared.delegate as! AppDelegate).pushRedirect()
        }
    }
    
    func loadapp()
    {
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        rootviewcontroller.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LaunchScreenControl")
        let mainwindow = (UIApplication.shared.delegate?.window!)!
        mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
        UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
        }) { (finished) -> Void in
        }
    }
    

    func navigateAccordingToType(seletedMenu:MenuObject) {
        let type = returnString(strToModify: seletedMenu.type)
        print(type)
        switch type {
        case "loginHeader":
            if let tabbarControl =  getFrontController() as? TabbarController {
                // self.revealViewController().revealToggle(animated: true)
                self.toggle()
                if Client.shared.isAppLogin(){
                    if customAppSettings.sharedInstance.showTabbar{
                        tabbarControl.selectedIndex = customAppSettings.sharedInstance.inAppWishlist ? 3 : 2
                    }else{
                        let viewController:AccountViewController = self.storyboard!.instantiateViewController()
                        if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                            navigation.pushViewController(viewController, animated: true)
                        }
                    }
                }
                else
                {
                    if customAppSettings.sharedInstance.isSimplyOTPEnabled {
                        let nav = UINavigationController(rootViewController: EnterPhoneNumberViewController())
                        nav.modalPresentationStyle = .fullScreen
                        self.present(nav, animated: true)
                    }
                    else {
                        if let loginNavigation = self.storyboard?.instantiateViewController(withIdentifier:"NewLoginNavigation") {
                            loginNavigation.modalPresentationStyle = .fullScreen
                            self.present(loginNavigation, animated: true, completion: nil)
                        }
                    }
                }
                return
            }
        case "Shop By Categories" :
            if customAppSettings.sharedInstance.showTabbar{
                self.toggle()
                // self.revealViewController().revealToggle(animated: true)
                if let tabbarControl =  getFrontController() as? TabbarController {
                    //          self.revealViewController().revealToggle(animated: true)
                    tabbarControl.selectedIndex = 2
                }
            }else{
                let viewController=NewSearchVC()//:SearchViewController = self.storyboard!.instantiateViewController()
                if let tabbarControl =  getFrontController() as? TabbarController {
                    self.toggle()
                    if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                        navigation.pushViewController(viewController, animated: true)
                    }
                }
            }
        case "collect":
            self.toggle()
            // self.revealViewController().revealToggle(animated: true)
            //let viewController:CollectionViewController = self.storyboard!.instantiateViewController()
            
            if let tabbarControl =  getFrontController() as? TabbarController {
                
                tabbarControl.selectedIndex = 2;
            }
            break;
        case "theme" :
            let viewController=PreviewThemesController()
            if let tabbarControl =  getFrontController() as? TabbarController {
                self.toggle()
                if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                    navigation.pushViewController(viewController, animated: true)
                }
            }
            
        case "qrcode":
            let cameraMediaType = AVMediaType.video
            let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
            toggle()
            if(cameraAuthorizationStatus == .notDetermined){
                AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                    DispatchQueue.main.async {
                        if granted {
                            print("Granted access to \(cameraMediaType)")
                            let viewController:ScanViewController = self.storyboard!.instantiateViewController()
                            if let tabbarControl =  self.getFrontController() as? TabbarController {
                                if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                                    navigation.pushViewController(viewController, animated: true)
                                }
                            }
                        }
                        else
                        {
                            let alertController = UIAlertController(
                                title: "Camera Access Disabled",
                                message: "Please open this app's settings and set Camera access to 'Always'.",
                                preferredStyle: .alert)
                            
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                            alertController.addAction(cancelAction)
                            
                            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                                if let url = NSURL(string:UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(url as URL)
                                }
                            }
                            alertController.addAction(openAction)
                            alertController.modalPresentationStyle = .fullScreen
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
            }
            else if(cameraAuthorizationStatus == .restricted){
                break;
            }
            else if(cameraAuthorizationStatus == .denied){
                let alertController = UIAlertController(
                    title: "Camera Access Disabled",
                    message: "Please open this app's settings and set Camera access to 'Always'.",
                    preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                    if let url = NSURL(string:UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url as URL)
                    }
                }
                alertController.addAction(openAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else if(cameraAuthorizationStatus == .authorized){
                let viewController:ScanViewController = self.storyboard!.instantiateViewController()
                
                if let tabbarControl =  getFrontController() as? TabbarController {
                    if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                        navigation.pushViewController(viewController, animated: true)
                    }
                }
            }
        case "demo" :
            self.toggle()
            Client.shared.setApiId(id: "c572b018c17d62853985e19b2b11a9a4")
            Client.shared.setMerchantId(merchantId: "18")
            Client.shared.setShopUrl(url: "magenative.myshopify.com")
            Bundle.setLanguage("en")
            UserDefaults.standard.removeObject(forKey: "AppleLanguages")
            UserDefaults.standard.removeObject(forKey: "firstlaunch")
            UserDefaults.standard.removeObject(forKey: "HasLaunchedOnce")
            UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
            Client.locale = "en"
            customAppSettings.sharedInstance.rtlSupport = false;
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            UISearchBar.appearance().semanticContentAttribute = .forceLeftToRight
            UITextView.appearance().semanticContentAttribute = .forceLeftToRight
            UITextField.appearance().semanticContentAttribute = .forceLeftToRight
            UIButton.appearance().semanticContentAttribute = .forceLeftToRight
            UILabel.appearance().semanticContentAttribute = .forceLeftToRight
            UICollectionView.appearance().semanticContentAttribute = .forceLeftToRight
            UIStackView.appearance().semanticContentAttribute = .forceLeftToRight
            UserDefaults.standard.synchronize()
            self.clearMerchantData()
            (UIApplication.shared.delegate as! AppDelegate).getdata()
            (UIApplication.shared.delegate as! AppDelegate).pushRedirect()
            
        case "smile" :
            if !Client.shared.isAppLogin() {
                if let loginNavigation = self.storyboard?.instantiateViewController(withIdentifier:"NewLoginNavigation") {
                    loginNavigation.modalPresentationStyle = .fullScreen
                    self.present(loginNavigation, animated: true, completion: nil)
                }
            }else{
                Client.shared.fetchCustomerDetails(completeion: {
                    response,error   in
                    if let response = response {
                        var cid = ""
                        if let str = response.customerId {
                            let str1 = str.components(separatedBy: "/")
                            cid = str1.last!
                            print(cid)
                        }
                        let viewController:WebViewController = self.storyboard!.instantiateViewController()
                        viewController.url =  ("https://shopifymobileapp.cedcommerce.com/shopifymobile/smilerewardapi/generateview?mid=\(Client.merchantID)&cid="+cid).getURL()
                        if let tabbarControl =  self.getFrontController() as? TabbarController {
                            self.toggle()
                            // self.revealViewController().revealToggle(animated: true)
                            if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                                navigation.pushViewController(viewController, animated: true)
                            }
                        }
                        
                    }else {
                        self.showErrorAlert(error: error?.localizedDescription)
                    }
                })
            }
            
        case "zendesk" :
            do {
                let chatEngine = try ChatEngine.engine()
                let viewController = try Messaging.instance.buildUI(engines : [chatEngine],configs : [])
                
                if let tabbarControl =  getFrontController() as? TabbarController {
                    self.toggle()
                    // self.revealViewController().revealToggle(animated: true)
                    if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                        navigation.pushViewController(viewController, animated: true)
                    }
                }
            } catch {
                // handle error
            }
            
        case "tidio" :
            let vc : WebViewController = self.storyboard!.instantiateViewController()
            vc.title = "Chat with Us".localized
            vc.tidioCheck = true
            vc.url = "http://shopifymobileapp.cedcommerce.com/shopifymobile/tidiolivechatapi/chatpanel?shop=\(Client.shopUrl)".getURL()
            if let tabbarControl =  getFrontController() as? TabbarController {
                self.toggle()
                //  self.revealViewController().revealToggle(animated: true)
                if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                    navigation.pushViewController(vc, animated: true)
                }
            }
            
        case "shopifyChat" :
            let vc : WebViewController = self.storyboard!.instantiateViewController()
            vc.title = "Chat with Us".localized
            vc.url = "https://shopifymobileapp.cedcommerce.com/shopifymobile/shopifychatapi/chatpanel?shop=\(Client.shopUrl)".getURL()
            if let tabbarControl =  getFrontController() as? TabbarController {
                self.toggle()
                if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                    navigation.pushViewController(vc, animated: true)
                }
            }
        case "currency":
            currencynavigate()
        case "lang":
            changeLanguagePressed()
        case "page","blog":
            if seletedMenu.children.count == 0 {
                let url = returnString(strToModify: seletedMenu.url)
                let viewController:WebViewController = storyboard!.instantiateViewController()
                if type == "blog"{
                    viewController.url = url.getURL()
                }
                else{
                    viewController.url = ("https://" + Client.shopUrl + url).getURL()
                }
                
                if let tabbarControl =  getFrontController() as? TabbarController {
                    self.toggle()
                    //  self.revealViewController().revealToggle(animated: true)
                    if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                        navigation.pushViewController(viewController, animated: true)
                    }
                }
            }
        case "ratings":
            AppReviewManager.standard.showPopup(controller: self)
        case "rewards":
            if Client.shared.isAppLogin() {
                    let viewControl:RewardPointsViewController = self.storyboard!.instantiateViewController()
                    if let tabbarControl =  getFrontController() as? TabbarController {
                        self.toggle()
                        // self.revealViewController().revealToggle(animated: true)
                        if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                            navigation.pushViewController(viewControl, animated: true)
                        }
                    }
            }
            else {
                let viewControl:RewardViewController = self.storyboard!.instantiateViewController()
                if let tabbarControl =  getFrontController() as? TabbarController {
                    self.toggle()
                    //   self.revealViewController().revealToggle(animated: true)
                    if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                        navigation.pushViewController(viewControl, animated: true)
                    }
                }
            }
        case "kangarooRewards":
            if Client.shared.isAppLogin() {
                let viewControl = KangarooRewardsViewController()
                if let tabbarControl =  getFrontController() as? TabbarController {
                    self.toggle()
                    if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                        navigation.pushViewController(viewControl, animated: true)
                    }
                }
            }
            else {
                let viewControl = GrowaveRewardsController()
                if let tabbarControl =  getFrontController() as? TabbarController {
                    self.toggle()
                    if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                        navigation.pushViewController(viewControl, animated: true)
                    }
                }
                
            }
        case "growaveRewards":
            if Client.shared.isAppLogin() {
                let viewControl = GrowaveRewardsViewController()
                if let tabbarControl =  getFrontController() as? TabbarController {
                    self.toggle()
                    if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                        navigation.pushViewController(viewControl, animated: true)
                    }
                }
            }
            else {
                let viewControl = GrowaveRewardsController()
                if let tabbarControl =  getFrontController() as? TabbarController {
                    self.toggle()
                    if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                        navigation.pushViewController(viewControl, animated: true)
                    }
                }
                
            }
        case "collection-all":
            if customAppSettings.sharedInstance.showTabbar{
                if let tabbarControl =  getFrontController() as? TabbarController {
                    self.toggle()
                    tabbarControl.selectedIndex = 2
                }
            }else{
                let viewController=NewSearchVC()//:SearchViewController = self.storyboard!.instantiateViewController()
                if let tabbarControl =  getFrontController() as? TabbarController {
                    self.toggle()
                    if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                        navigation.pushViewController(viewController, animated: true)
                    }
                }
            }
        case "CATALOG":
            let viewControl = ProductListVC()//:ProductListViewController = self.storyboard!.instantiateViewController()
            viewControl.isfromHome = true
            viewControl.fetchAllProduct = true
            viewControl.pageTitle = "All Products".localized
            if let tabbarControl =  getFrontController() as? TabbarController {
                self.toggle()
                //  self.revealViewController().revealToggle(animated: true)
                if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                    navigation.pushViewController(viewControl, animated: true)
                }
            }
        case "COLLECTION":
            if seletedMenu.children.count == 0 {
                let collectionId = returnString(strToModify: seletedMenu.id)
                let coll = collection(id: collectionId, title: seletedMenu.name)
                let viewControl = ProductListVC() //:ProductListViewController = self.storyboard!.instantiateViewController()
                viewControl.isfromHome = true
                viewControl.collect = coll
//                viewControl.title   = coll.title
                viewControl.pageTitle = coll.title ?? ""
                if let tabbarControl =  getFrontController() as? TabbarController {
                    self.toggle()
                    //  self.revealViewController().revealToggle(animated: true)
                    if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                        navigation.pushViewController(viewControl, animated: true)
                    }
                }
            }
            
        case "product":
            let viewController=ProductVC()//:ProductViewController = storyboard!.instantiateViewController()
            let productId = returnString(strToModify: seletedMenu.id)
            let str="gid://shopify/Product/"+productId
            //      let str1 = (str).data(using: String.Encoding.utf8)
            //      let base64 = str1!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            viewController.productId = str
            viewController.isProductLoading = true
            
            if let tabbarControl =  getFrontController() as? TabbarController {
                self.toggle()
                //  self.revealViewController().revealToggle(animated: true)
                if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                    navigation.pushViewController(viewController, animated: true)
                }
            }
        case "HTTP","SHOP_POLICY","PAGE","BLOG":
            let viewController:WebViewController = self.storyboard!.instantiateViewController()
            viewController.title = seletedMenu.name
            viewController.url   = seletedMenu.url.getURL()
            if let tabbarControl =  getFrontController() as? TabbarController {
                self.toggle()
                // self.revealViewController().revealToggle(animated: true)
                if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                    
                    navigation.pushViewController(viewController, animated: true)
                }
            }
            
            
        case "links":
            Client.shared.fetchShop(completion: {
                response in
                let viewController:WebViewController = self.storyboard!.instantiateViewController()
                viewController.title = seletedMenu.name
                if seletedMenu.name == "Privacy Policy".localized{
                    viewController.url = response?.privacyPolicyUrl
                }else if seletedMenu.name == "Refund Policy".localized{
                    viewController.url = response?.refundPolicyUrl
                }else if seletedMenu.name == "Terms of services".localized{
                    viewController.url = response?.termsOfService
                }else{}
                if let tabbarControl =  self.getFrontController() as? TabbarController {
                    self.toggle()
                    // self.revealViewController().revealToggle(animated: true)
                    if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                        navigation.pushViewController(viewController, animated: true)
                    }
                }
            })
        case "contact":
            let contactus:ContactUsViewController = self.storyboard!.instantiateViewController()
            contactus.title = "Contact Us".localized
            if let tabbarControl =  getFrontController() as? TabbarController {
                self.toggle()
                //  self.revealViewController().revealToggle(animated: true)
                if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                    navigation.pushViewController(contactus, animated: true)
                }
            }
        case "static":
            switch seletedMenu.name{
            case "Home".localized:
                if let tabbarControl =  getFrontController() as? TabbarController {
                    self.toggle()
                    //  self.revealViewController().revealToggle(animated: true)
                    tabbarControl.selectedIndex = 0
                }
            case "My Cart".localized:
                let data = DBManager.shared.cartProducts?.filter{$0.sellingPlanId != ""}
                if data?.count ?? 0 > 0 {
                    let viewController:NewCartViewController = self.storyboard!.instantiateViewController()
                    if let tabbarControl =  getFrontController() as? TabbarController {
                        self.toggle()
                        if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                            navigation.pushViewController(viewController, animated: true)
                        }
                    }
                }
                else {
                    let viewController:CartViewController = self.storyboard!.instantiateViewController()
                    if let tabbarControl =  getFrontController() as? TabbarController {
                        self.toggle()
                        if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                            navigation.pushViewController(viewController, animated: true)
                        }
                    }
                }
            case "Search Your Product".localized:
                if customAppSettings.sharedInstance.showTabbar{
                    if let tabbarControl =  getFrontController() as? TabbarController {
                        self.toggle()
                        tabbarControl.selectedIndex = 1
                    }
                }else{
                    let viewController=NewSearchVC()//:SearchViewController = self.storyboard!.instantiateViewController()
                    if let tabbarControl =  getFrontController() as? TabbarController {
                        self.toggle()
                        if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                            navigation.pushViewController(viewController, animated: true)
                        }
                    }
                }
            case "My WishList".localized:
                let viewController:WishlistViewController = self.storyboard!.instantiateViewController()
                if let tabbarControl =  getFrontController() as? TabbarController {
                    self.toggle()
                    if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                        navigation.pushViewController(viewController, animated: true)
                    }
                }
            case "My Account".localized:
                if let tabbarControl =  getFrontController() as? TabbarController {
                    self.toggle()
                    // self.revealViewController().revealToggle(animated: true)
                    if Client.shared.isAppLogin(){
                        if customAppSettings.sharedInstance.showTabbar{
                            tabbarControl.selectedIndex = 3
                        }else{
                            let viewController:AccountViewController = self.storyboard!.instantiateViewController()
                            if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                                navigation.pushViewController(viewController, animated: true)
                            }
                        }
                    }
                    else
                    {//NewLoginNavigation
                        //LoginNavigationController
                        if customAppSettings.sharedInstance.isSimplyOTPEnabled {
                            let nav = UINavigationController(rootViewController: EnterPhoneNumberViewController())
                            nav.modalPresentationStyle = .fullScreen
                            self.present(nav, animated: true)
                        }
                        else {
                            if let loginNavigation = self.storyboard?.instantiateViewController(withIdentifier:"NewLoginNavigation") {
                                loginNavigation.modalPresentationStyle = .fullScreen
                                self.present(loginNavigation, animated: true, completion: nil)
                            }

                        }
                    }
                }
            case "Invite Your Friend".localized:
                self.toggle()
                // self.revealViewController().revealToggle(animated: true)
                let url = Client.appLiveUrl
                let vc = UIActivityViewController(activityItems: [url as Any], applicationActivities: nil);
                if(UIDevice().model.lowercased() == "ipad".lowercased()){
                    if let popoverController = vc.popoverPresentationController {
                        guard let viewToPresent = UIApplication.getTopViewController()?.view else {return}
                        popoverController.sourceView = viewToPresent //to set the source of your alert
                        popoverController.sourceRect = CGRect(x: viewToPresent.bounds.midX, y: viewToPresent.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
                        popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
                    }
                }
                self.present(vc, animated: true, completion: nil);
            default :
                print("dDSD")
            }
            
        default:
            print("Default value pressed.")
        }
    }
    func clearMerchantData(){
        UserDefaults.standard.removeObject(forKey: "HomeDataJSON")
        FirebaseSetup.shared.firebaseInitialiseCheck = false;
        if(UserDefaults.standard.valueExists(forKey: "mageInfo")){
            UserDefaults.standard.removeObject(forKey: "mageInfo")
        }
        UserDefaults.standard.set(false, forKey: "mageShopLogin")
        if(UserDefaults.standard.valueExists(forKey: "defaultCurrency")){
            UserDefaults.standard.removeObject(forKey: "defaultCurrency")
        }
        WishlistManager.shared.clearWishlist()
        CartManager.shared.deleteAll()
        customAppSettings.sharedInstance.disableCustomSettings()
        Client.shared.client = Graph.Client(shopDomain: Client.shopUrl, apiKey: Client.apiKey, locale: Locale(identifier: Client.locale))
    }
    
    func currencynavigate(){
        Client.shared.currencyCode(completion: {
            response in
            self.toggle()
            // self.revealViewController().revealToggle(animated: true)
            if let response = response{
                let currency = response.nameIsoCode?.sorted{$0.name < $1.name}
                
                let actionsheet = UIAlertController(title: "Select Country".localized, message: nil, preferredStyle: .alert)
                for item in currency! {
                    print(item)
                    let action = UIAlertAction(title: item.name, style: UIAlertAction.Style.default,handler: {
                        action -> Void in
                        self.selectCurrencyStore(store: item.currencyCode)
                        self.selectCountryStore(store:item.code)
                    })
                    actionsheet.addAction(action)
                }
                actionsheet.addAction(UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel, handler: {
                    action -> Void in
                }))
                self.present(actionsheet, animated: true, completion: nil)
            }
        })
    }
    
    func selectCurrencyStore(store:String){
        CurrencyCode.shared.saveCurrencyCode(code: store)
        //      UserDefaults.standard.set(store, forKey: "mageCurrencyCode")
        Client.shared.saveCurrencyCode(currency: store)
        load_app()
    }
    
    func selectCountryStore(store:String){
        UserDefaults.standard.removeObject(forKey: "countryCode")
        UserDefaults.standard.set(store, forKey: "countryCode")
        UserDefaults.standard.set(store, forKey: "mageCountryCode")
        Client.shared.saveCountryCode(currency: store)
        load_app()
    }
    
    func load_app()
    {
        Client.homeStaticThemeJSON = Data()
        Client.homeStaticThemeColor = ""
        (UIApplication.shared.delegate as! AppDelegate).loadHomepage()
    }
}

extension NewSideMenuController: ChatsProtocol, LogoutProtocol{
    func socialClicked(url: String, name: String) {
        switch name{
        case "whatsapp":
            let txt = Client.whatsappMsg
            guard let whatsappURL = "https://api.whatsapp.com/send?phone=\(url)&text=\(txt)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?.getURL() else {return}
            if UIApplication.shared.canOpenURL(whatsappURL) {
                UIApplication.shared.open(whatsappURL)
            } else {
            }
        default:
            let viewController:WebViewController = self.storyboard!.instantiateViewController()
            viewController.url = url.getURL()
            if let tabbarControl =  getFrontController() as? TabbarController {
                self.toggle()
                if let navigation = tabbarControl.viewControllers![tabbarControl.selectedIndex] as? UINavigationController {
                    navigation.pushViewController(viewController, animated: true)
                }
            }
        }
    }
    
    func logoutClicked() {
        if Client.shared.doLogOut() {
            NotificationCenter.default.post(name: NSNotification.Name("loadDrawerAgain"), object: nil)
            if let tabbarControl =  getFrontController() as? TabbarController {
                self.toggle()
                tabbarControl.selectedIndex = 0
            }
        }
        
    }
    
    func getFrontController()->UIViewController?{
        if(Client.locale != "ar"){
            return self.revealViewController().frontViewController
        }
        else{
            return self.revealViewController().frontViewController
        }
    }
    func qrTap(){
        print("fjhrjfg")
    }
}
extension UIView{
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
extension UIApplication {
    
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

