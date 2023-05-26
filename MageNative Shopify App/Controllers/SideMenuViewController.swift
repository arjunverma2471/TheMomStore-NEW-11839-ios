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
//MARK: Non operational for now-> NewSideMenuController
import UIKit
import RATreeView
import AVFoundation
import ChatSDK
import ChatProvidersSDK
import MessagingSDK
import MobileBuySDK
import RxSwift
class SideMenuViewController: UIViewController,SWRevealViewControllerDelegate {
  
  var treeView : RATreeView!
  var menus : [MenuObject] = []
  let endPoint = "shop-mobile/shopifyapi/getnewcategorymenus?mid="//"shopifymobile/shopifyapi/getcategorymenus?mid="
  var checker:MenuObject?=nil
    let value = UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
    var shopCountry:CurrencyViewModel?
    var disposeBag = DisposeBag()
    
    private lazy var navigationView: UIView = {
        let navigation = UIView()
        navigation.translatesAutoresizingMaskIntoConstraints = false;
        return navigation;
    }()
    
    private lazy var navigationBottomLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false;
        line.backgroundColor = UIColor(hexString: "#D1D1D1")
        return line;
    }()
    
    private lazy var navigationImage: UIImageView = {
        let navigation = UIImageView()
        navigation.translatesAutoresizingMaskIntoConstraints = false;
        navigation.image = UIImage(named: "header")
        navigation.contentMode = .scaleAspectFit
        return navigation;
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.setImage(UIImage(named: "close"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button;
    }()
    
  override func viewDidLoad() {
    super.viewDidLoad()
      setupTreeView()
      Client.shared.currencyCode(completion:  {
        response in
        self.shopCountry = response
          self.treeView.reloadData()
      })
   
//  getMenuData()
    getMenuDataFromShopify()
    self.revealViewController().delegate = self
    self.revealViewController().frontViewShadowColor = .black
      if(Client.locale=="ar"){
          self.revealViewController().rightViewController = self;
      }
      
    //NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData(_:)), name: NSNotification.Name(rawValue: "loadDrawerAgain"), object: nil);
  }
  
  @objc func reloadData(_ notification: NSNotification) {
    self.menus.removeAll()
//    getMenuData()
    getMenuDataFromShopify()
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
      //self.revealViewController().rearViewRevealWidth = self.view.frame.width * 0.3
   // self.revealViewController().view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
      
      self.treeView.reloadData()
      
  }
  
  override var prefersStatusBarHidden: Bool {
      return true
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    self.revealViewController().frontViewController.view.isUserInteractionEnabled = true
    self.revealViewController().frontViewController.view.viewWithTag(123)?.removeFromSuperview()
  }
  
  func setupTreeView()
  {
    for item in view.subviews{
      if let temp=item as? RATreeView{
        temp.removeFromSuperview()
      }
    }
      view.addSubview(navigationView)
      navigationView.addSubview(navigationImage)
      navigationView.addSubview(cancelButton)
      navigationView.addSubview(navigationBottomLine)
      NSLayoutConstraint.activate([
        navigationView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
        navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
        navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
        navigationView.heightAnchor.constraint(equalToConstant: 50),
        navigationImage.topAnchor.constraint(equalTo: navigationView.topAnchor),
        navigationImage.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: 0),
        navigationImage.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor, constant: 20),
        cancelButton.trailingAnchor.constraint(equalTo: navigationView.trailingAnchor, constant: -70),
        cancelButton.widthAnchor.constraint(equalToConstant: 25),
        cancelButton.heightAnchor.constraint(equalToConstant: 25),
        cancelButton.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor),
        navigationBottomLine.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor),
        navigationBottomLine.trailingAnchor.constraint(equalTo: navigationView.trailingAnchor),
        navigationBottomLine.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: -2),
        navigationBottomLine.heightAnchor.constraint(equalToConstant: 0.5)
      ])
      navigationImage.bringSubviewToFront(navigationView)
      navigationImage.anchor(width: 120)
      cancelButton.rx.tap.bind{
          if(Client.locale=="ar"){
              self.revealViewController().rightRevealToggle(animated: true)
          }
          else{
              self.revealViewController().revealToggle(animated: true)
          }
      }.disposed(by: disposeBag)
      treeView = RATreeView(frame: CGRect(x: view.frame.minX, y: view.frame.minY+100, width: view.frame.width, height: view.frame.height-100))
    treeView.separatorStyle = RATreeViewCellSeparatorStyle(0)
    treeView.register(UINib(nibName: String(describing: SideMenuTableCell.self), bundle: nil), forCellReuseIdentifier: SideMenuTableCell.className)
      treeView.register(MenuLoginCell.self, forCellReuseIdentifier: MenuLoginCell.className)
      treeView.register(LivePreviewTableCell.self, forCellReuseIdentifier: LivePreviewTableCell.className)
      treeView.register(LogoutTableCell.self, forCellReuseIdentifier: LogoutTableCell.className)
      treeView.register(MenuFooterCell.self, forCellReuseIdentifier: MenuFooterCell.className)
      treeView.register(SocialMenuCell.self, forCellReuseIdentifier: SocialMenuCell.className)
    treeView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    treeView.treeHeaderView = UIView()
    treeView.treeFooterView = UIView()
    view.addSubview(treeView)
    treeView.delegate   = self;
    treeView.dataSource = self;
  }
  
  func getMenuDataFromShopify(){
    addStaticMenuData()
      let data = SideMenuData.shared.menus ?? []
      self.menus.append(contentsOf: data)
      self.getMoreData()
  }

  //JS
    func addStaticMenuData() {
        for (ind,_) in  menus.enumerated(){
            if menus[ind].id == "loginHeader"{
                menus.remove(at: ind)
            }
        }
        if Client.shared.isAppLogin(){
            Client.shared.fetchCustomerDetails(completeion: {
                response,error in
                if let response = response {
                    let name = response.displayName!
                    self.menus.insert(MenuObject(name: name, id: "loginHeader", image: "",type: "loginHeader",url: ""), at: 0)
                    print("DEBUG: header insert")
                }
                self.treeView.dataSource = self
                self.treeView.reloadData()
            })
            
        }
        else
        {
            self.menus.append(MenuObject(name: "Hey Guest".localized, id: "loginHeader", image: "",type: "loginHeader",url: ""))
            print("DEBUG: header insert")

        }
        
    }
  
  func getMenuData()
  {
    addStaticMenuData()
      Client.shared.fetchShopBlog { blogsModel in
          if let blogs = blogsModel{
              guard let url = (AppSetUp.baseUrl + self.endPoint + Client.merchantID).getURL() else {return}
              print("MenuUrl=",url)
              var request = URLRequest(url: url)
              request.httpMethod="GET"
              request.setValue("application/json", forHTTPHeaderField: "Content-Type")
              request.cachePolicy = URLRequest.CachePolicy.returnCacheDataElseLoad
              self.view.addLoader()
              AF.request(request).responseData(completionHandler: {
                response in
                self.view.stopLoader()
                switch response.result {
                case .success:
                  do {
                    if  let json = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any] {
                        if let jsonData=json["data"] as? [Any]{
                            print(jsonData)
                            for item in jsonData.dropFirst(0){
                                if let menus=item as? [String:Any]{
                                    if let submenus = menus["menus"] as? [Any]{
                                        if submenus.count > 0 {
                                            let db  = self.fechSubMenu(submenus)
                                            let temp=MenuObject(name: menus["title"] as! String, children: db, id: "123", image: "",type: "",url: "")
                                            self.menus.append(temp)
                                        }
                                        else
                                        {
                                            /* if(menus["type"] as! String != "blog"){
                                             let temp=MenuObject(name: menus["title"] as! String, id: String(describing: menus["id"]), image: "",type: String(describing: menus["type"]),url: String(describing: menus["url"] ))
                                             self.menus.append(temp)
                                             }*/
                                            if let type = menus["type"] as? String{
                                                if(type != "blog"){
                                                    let temp=MenuObject(name: menus["title"] as! String, id: String(describing: menus["id"]), image: "",type: String(describing: menus["type"]),url: String(describing: menus["url"] ))
                                                    self.menus.append(temp)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                      
                        for index in blogs.items{
                            let temp=MenuObject(name: index.title, id: "", image: "", type: "blog", url: index.onlineStoreUrl?.absoluteString ?? "" )
                            self.menus.append(temp)
                        }      
                     
                        self.getMoreData()
                      print(self.menus)
                    }
                  }
                  catch let error {
                    print(error.localizedDescription)
                  }
                case .failure:
                  print("failure")
                    self.getMoreData()
                      }
                  })
          }
      }
  }
    
    func getMoreData() {
        //self.menus.append(MenuObject(name: "Home".localized, id: "", image: "My Cart",type: "static",url: ""))
       // self.menus.append(MenuObject(name: "My Cart".localized, id: "", image: "My Cart",type: "static",url: ""))
      //self.menus.append(MenuObject(name: "Search Your Product".localized, id: "", image: "",type: "static",url: ""))
          if customAppSettings.sharedInstance.inAppWishlist {
             // self.menus.append(MenuObject(name: "My WishList".localized, id: "", image: "Favourite",type: "static",url: ""))
          }
       // self.menus.append(MenuObject(name: "My Account".localized, id: "", image: "user",type: "static",url: ""))

        if customAppSettings.sharedInstance.multiCurrency {
          self.menus.append(MenuObject(name: "Select Your Country".localized, id: "", image: "",type: "currency",url: ""))
        }
        if customAppSettings.sharedInstance.rtlSupport {
            self.menus.append(MenuObject(name: "Language".localized, id: "", image: "",type: "lang",url: ""))
        }

        if customAppSettings.sharedInstance.yotpoLoyalty {
            self.menus.append(MenuObject(name: "Earn Rewards".localized, id: "", image: "",type: "rewards",url: ""))
        }
        
        if customAppSettings.sharedInstance.growaveRewardsIntegration {
            self.menus.append(MenuObject(name: "Earn Rewards".localized, id: "", image: "",type: "rewards",url: ""))
        }



        var db : [MenuObject] = []
        if customAppSettings.sharedInstance.smileIntegration {
            db.append(MenuObject(name: "Rewards".localized, id: "", image: "",type: "smile",url: ""))
        }
        if customAppSettings.sharedInstance.zendeskChat {
            db.append(MenuObject(name: "Help".localized, id: "", image: "",type: "zendesk",url: ""))
        }
        if customAppSettings.sharedInstance.tidioChat {
            db.append(MenuObject(name: "Chats".localized, id: "", image: "",type: "tidio",url: ""))
        }

        if db.count > 0 {
            self.menus.append(MenuObject(name: "Help Center".localized, children: db, id: "", image: "", type: "Help Center", url: ""))
        }


        self.menus.append(MenuObject(name: "Invite Your Friend".localized, id: "", image: "",type: "static",url: ""))
        if(Client.merchantPreview)
        {
            if(Client.merchantID == "18"){
                self.menus.append(MenuObject(name: "Live Preview Of Your Store".localized, id: "123", image: "",type: "qrcode",url: ""))
            }
            else{
                self.menus.append(MenuObject(name: "Move to Demo Store".localized, id: "", image: "",type: "demo",url: ""))
            }
        }
        
        //self.menus.append(MenuObject(name: "Your Account".localized, id: "", image: "",type: "loginHeader",url: ""))
//        self.menus.append(MenuObject(name: "Home".localized, id: "", image: "My Cart",type: "static",url: ""))
//        self.menus.append(MenuObject(name: "My Cart".localized, id: "", image: "My Cart",type: "static",url: ""))
//      self.menus.append(MenuObject(name: "Search Your Product".localized, id: "", image: "",type: "static",url: ""))
//          if customAppSettings.sharedInstance.inAppWishlist {
//              self.menus.append(MenuObject(name: "My WishList".localized, id: "", image: "Favourite",type: "static",url: ""))
//          }
//        self.menus.append(MenuObject(name: "My Account".localized, id: "", image: "user",type: "static",url: ""))
//
//        if customAppSettings.sharedInstance.multiCurrency {
//          self.menus.append(MenuObject(name: "Select Your Country".localized, id: "", image: "",type: "currency",url: ""))
//        }
//        if customAppSettings.sharedInstance.rtlSupport {
//            self.menus.append(MenuObject(name: "Language".localized, id: "", image: "",type: "lang",url: ""))
//        }
//
//        if customAppSettings.sharedInstance.yotpoLoyalty {
//            self.menus.append(MenuObject(name: "Earn Rewards".localized, id: "", image: "",type: "rewards",url: ""))
//        }
//
//
//        var db : [MenuObject] = []
//        if customAppSettings.sharedInstance.smileIntegration {
//            db.append(MenuObject(name: "Rewards".localized, id: "", image: "",type: "smile",url: ""))
//        }
//        if customAppSettings.sharedInstance.zendeskChat {
//            db.append(MenuObject(name: "Help".localized, id: "", image: "",type: "zendesk",url: ""))
//        }
//        if customAppSettings.sharedInstance.tidioChat {
//            db.append(MenuObject(name: "Chats".localized, id: "", image: "",type: "tidio",url: ""))
//        }
//
//        if db.count > 0 {
//            self.menus.append(MenuObject(name: "Help Center".localized, children: db, id: "", image: "", type: "", url: ""))
//        }
//
//
//        self.menus.append(MenuObject(name: "Invite Your Friend".localized, id: "", image: "",type: "static",url: ""))
        
        if(customAppSettings.sharedInstance.whatsappInegration || customAppSettings.sharedInstance.fbIntegration){
            self.menus.append(MenuObject(name: "Social", id: "", image: "",type: "social",url: ""))
        }
        if Client.shared.isAppLogin() {
         self.menus.append(MenuObject(name: "Logout".localized, id: "", image: "",type: "logout",url: ""))
       }
        //self.menus.append(MenuObject(name: "".localized, id: "123", image: "",type: "",url: "gap"))
        self.menus.append(MenuObject(name:  "App "+(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0" ) + " (\(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1.0"))", id: "123", image: "",type: "loginHeader2",url: ""))
        
        self.treeView.reloadData()
    }
  
  func fechSubMenu(_ submenus: [Any]) -> [MenuObject]{
    var dataObjects=[MenuObject]()
    for item in submenus{
      if let menus=item as? [String:Any]{
        if let submenu = menus["menus"] as? [Any]{
          let db=fechSubMenu(submenu)
          let temp=MenuObject(name: menus["title"] as! String, children: db, id: "123", image: "",type: "",url: "")
          dataObjects.append(temp)
        }
        else
        {
          let db=MenuObject(name: menus["title"] as! String, id: String(describing: menus["id"]), image: "",type: String(describing: menus["type"]),url: String(describing: menus["url"] ))
          dataObjects.append(db)
        }
      }
    }
    return dataObjects
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

extension SideMenuViewController:RATreeViewDataSource {
  
  func treeView(_ treeView: RATreeView, numberOfChildrenOfItem item: Any?) -> Int {
    if let item = item as? MenuObject {
      return item.children.count
    }
    else {
      return self.menus.count
    }
  }
  
  func treeView(_ treeView: RATreeView, heightForRowForItem item: Any) -> CGFloat {
    let item = item as! MenuObject
      switch item.type{
          case "loginHeader" :
              return 100
          case "loginHeader2", "qrcode", "demo", "social":
                  return UITableView.automaticDimension
          
          
          default:
              return 40
      }
      
  }
  
  
  func treeView(_ treeView: RATreeView, child index: Int, ofItem item: Any?) -> Any {
    if let item = item as? MenuObject {
      return item.children[index]
    } else {
      return menus[index] as AnyObject
    }
  }
  
  func treeView(_ treeView: RATreeView, cellForItem item: Any?) -> UITableViewCell {
    let cell = treeView.dequeueReusableCell(withIdentifier: SideMenuTableCell.className) as! SideMenuTableCell
    let item = item as! MenuObject
    
      switch item.type{
      case "loginHeader":
          let cell =  treeView.dequeueReusableCell(withIdentifier: MenuLoginCell.className) as! MenuLoginCell
          cell.setup(menu: item)
          return cell
      case "qrcode","demo":
          let cell =  treeView.dequeueReusableCell(withIdentifier: LivePreviewTableCell.className) as! LivePreviewTableCell
          return cell
      case "logout":
          let cell =  treeView.dequeueReusableCell(withIdentifier: LogoutTableCell.className) as! LogoutTableCell
          cell.delegate = self;
          return cell
      case "social":
          let cell =  treeView.dequeueReusableCell(withIdentifier: SocialMenuCell.className) as! SocialMenuCell
          cell.delegate = self;
          return cell
      case "loginHeader2":
          let cell =  treeView.dequeueReusableCell(withIdentifier: MenuFooterCell.className) as! MenuFooterCell
          cell.setup(menu: item)
          return cell
      default:
         let level = treeView.levelForCell(forItem: item)
          //let detailsText = "Number of children \(item.children.count)"
          cell.selectionStyle = .none
          cell.menu = item
          cell.setup(from: item, level: level)
          cell.rightImage.isHidden=false
          cell.rightImage.image = UIImage(named: "rightArrow")
          cell.customTitleButton.addTarget(self, action: #selector(redirectToProductList(_:)), for: .touchUpInside)
//          if item.children.count > 0 {
//            cell.rightImage.isHidden=false
//            cell.rightImage.image = UIImage(named: "rightArrow")
//          }
//          else {
//            cell.rightImage.isHidden=true
//          }
          return cell
      }
      
  }
  
  func treeView(_ treeView: RATreeView, canEditRowForItem item: Any) -> Bool {
    return false
  }
  
  func treeView(_ treeView: RATreeView, didExpandRowForItem item: Any) {
    if let cell = treeView.cell(forItem: item) as? SideMenuTableCell {
        let item = item as! MenuObject
        if(item.children.count != 0){
            cell.rightImage.image = UIImage(named: "bottomArrow")
        }
      
    }
  }
  
  func treeView(_ treeView: RATreeView, didCollapseRowForItem item: Any) {
    if let cell = treeView.cell(forItem: item) as? SideMenuTableCell {
      cell.rightImage.image = UIImage(named: "rightArrow")
    }
  }
    
    
    @objc func redirectToProductList(_ sender : UIButton) {
        if  let cell = sender.superview?.superview as? SideMenuTableCell{
            let seletedMenu = cell.menu!
              let type = returnString(strToModify:seletedMenu.type)
              if seletedMenu.children.count > 0 && type != "Help Center"{
                  let collectionId = returnString(strToModify: seletedMenu.id)
                  let coll = collection(id: collectionId, title: seletedMenu.name)
                  let viewControl = ProductListVC()
                  viewControl.isfromHome = true
                  viewControl.collect = coll
                  viewControl.title   = coll.title
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
}

extension SideMenuViewController:RATreeViewDelegate {
    
    func navigateAccordingToType(seletedMenu:MenuObject) {
        let type = returnString(strToModify: seletedMenu.type)
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
              if let loginNavigation = self.storyboard?.instantiateViewController(withIdentifier:"NewLoginNavigation") {
                loginNavigation.modalPresentationStyle = .fullScreen
                self.present(loginNavigation, animated: true, completion: nil)
              }
            }
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
                        viewController.url = ("https://shopifymobileapp.cedcommerce.com/shopifymobile/smilerewardapi/generateview?mid=\(Client.merchantID)&cid="+cid).getURL()
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
            
        case "growaveRewards" :
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
          viewControl.title = "All Products".localized
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
            viewControl.title   = coll.title
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
                if let loginNavigation = self.storyboard?.instantiateViewController(withIdentifier:"NewLoginNavigation") {
                  loginNavigation.modalPresentationStyle = .fullScreen
                  self.present(loginNavigation, animated: true, completion: nil)
                }
              }
            }
          case "Invite Your Friend".localized:
              self.toggle()
           // self.revealViewController().revealToggle(animated: true)
              let url = Client.appLiveUrl
            let vc = UIActivityViewController(activityItems: [url as Any], applicationActivities: nil);
            if(UIDevice().model.lowercased() == "ipad".lowercased()){
              vc.popoverPresentationController?.sourceView = self.view
            }
            self.present(vc, animated: true, completion: nil);
          default :
            print("dDSD")
          }
        case "logout":
          if Client.shared.doLogOut() {
            NotificationCenter.default.post(name: NSNotification.Name("loadDrawerAgain"), object: nil)
            if let tabbarControl =  getFrontController() as? TabbarController {
                self.toggle()
              tabbarControl.selectedIndex = 0
            }
          }
        default:
         print("Default value pressed.")
        }
    }
    
  
  func treeView(_ treeView: RATreeView, didSelectRowForItem item: Any) {
    let seletedMenu = item as! MenuObject
    self.navigateAccordingToType(seletedMenu: seletedMenu)
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
      let _ = shopCountry?.availableLanguagesData?.map({ data in
              Stores[data.name] = data.code.lowercased()
            })

            print("Available Languages=",Stores)
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
      switch store {
      case "Arabic":
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


                    (UIApplication.shared.delegate as! AppDelegate).loadHomepage()
                    if let tabbarControl =  getFrontController() as? TabbarController {


                      tabbarControl.tabBar.items![0].title = "Home".localized
                      tabbarControl.tabBar.items![1].title = "Search".localized
                        tabbarControl.tabBar.items![2].title = "Categories".localized
                        tabbarControl.tabBar.items![3].title = "Account".localized
                      //tabbarControl.tabBar.items![2].title = "Cart".localized
//                      if customAppSettings.sharedInstance.inAppWishlist {
//                        tabbarControl.tabBar.items![2].title = "Wishlist".localized
//                        tabbarControl.tabBar.items![3].title = "Account".localized
//                      }
//                      else {
//                        tabbarControl.tabBar.items![2].title = "Account".localized
//                      }
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
    
    (UIApplication.shared.delegate as! AppDelegate).loadHomepage()
  }
}

extension UIViewController {
    func returnString(strToModify:String)->String{
      if strToModify.contains("Optional"){
        let sel=strToModify.components(separatedBy: "(")
        let selected=sel[1].components(separatedBy: ")")
        return selected[0]
      }
      return strToModify
    }
}

protocol LogoutProtocol{
    func logoutClicked()
}

protocol ChatsProtocol{
    func socialClicked(url: String, name: String)
}
extension SideMenuViewController: ChatsProtocol, LogoutProtocol{
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
}
