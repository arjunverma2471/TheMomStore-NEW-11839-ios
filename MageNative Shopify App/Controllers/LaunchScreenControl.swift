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

class LaunchScreenControl: UIViewController {
    
    let dispatchGroup = DispatchGroup()
    let versionManager = VersionManager.shared
    
    @IBOutlet weak var statusImage: UIImageView!
    
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialseSecondryDatabase()
        if UserDefaults.standard.value(forKey: "firstlaunch") == nil{
            Client.shared.fetchAvailableLanguage { response in
                if let response = response {
                    LanguageUpdation.selectStore(store: response.keys.first!, code: response.values.first!)
                }
            }
        }
    }
    
    override var prefersStatusBarHidden:Bool{
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension LaunchScreenControl{
    
    func initialseSecondryDatabase(){
        self.setupCountryAndCurrencyCodes()
        
        if UserDefaults.standard.value(forKey: "firstlaunch") != nil{
            self.langSetupIfAlreadyLaunched()
        }
        
        let shopurl = Client.shopUrl.replacingOccurrences(of: ".myshopify.com", with: "")
        FirebaseSetup.shared.configureFirebase()
        //FirebaseApp.configure(name: shopurl, options: FirebaseSetup.initDetails())
        let firebaseApps = FirebaseApp.app(name: shopurl)
        
        Auth.auth(app: firebaseApps!).signIn(withEmail: "manoharsinghrawat@magenative.com", password: "59Xp47nIt") { [weak self] authResult, error in
            
            guard let secondary            = FirebaseApp.app(name: shopurl) else { return assert(false, "Could not retrieve secondary app") }
            BaseViewController.secondaryDb = Database.database(app: secondary)
            let ref                        = BaseViewController.secondaryDb?.reference(withPath: shopurl)
            
            self?.dispatchGroup.enter()
            self?.versionManager.getReference(.version, ref)?.observe(.value, with: { snapshot in
                if let dataObject = snapshot.value as? String {
                    VersionManager.panelVersion = dataObject
                }else{
                    VersionManager.panelVersion = ""
                }
                self?.dispatchGroup.leave()
            })
            
            self?.dispatchGroup.enter()
            self?.versionManager.getReference(.maintenance_mode, ref)?.observe(.value, with: { snapValue in
                if let value = snapValue.value as? Bool, value {
                       self?.showMaintainencePopup()
                       return;
                   }
                self?.dispatchGroup.leave()
            })
            
            self?.dispatchGroup.notify(queue: .main) {
                // Handle the completed tasks here
                if UserDefaults.standard.value(forKey: "firstlaunch") == nil{
                    if VersionManager.panelVersion.isEmpty{
                        self?.setDefaultLanguage()
                    }else{
                        ref?.child("v2").child("default_locale").observe(.value, with: { snapshot in
                            if let val = snapshot.value as? String {
                                UserDefaults.standard.set(true, forKey: "firstlaunch")
                                UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
                                if let store =  self?.getLocalizedLanguage(langCode: val){
                                    print("Default Language from json == ",store,val)
                                    let rtlLanguages = ["ar","ur"]
                                    LanguageUpdation.selectStore(store: store, code: val)
                                }
                            }
                        })
                    }
                }
                
                SideMenuData.shared.getMenuDataFromShopify()
                
                self?.configureApptheme(windowVar: AppDelegate().appDelegate.window!, theme: "auto")
                
                self?.versionManager.getReference(.dark_mode, ref)?.observe(.value, with: {snapshot in
                    if let val = snapshot.value as? String {
                        self?.configureApptheme(windowVar: AppDelegate().appDelegate.window!, theme: val)
                    }
                })
                
                self?.versionManager.getReference(.appthemecolor, ref)?.observe(.value, with: {snapshot in
                    if let val = snapshot.value as? String {
                        UserDefaults.standard.set(val, forKey: "color")
                        Client.shared.setTextColor(val: val)
                    }
                })
                
                self?.versionManager.getReference(.text_color, ref)?.observe(.value, with: {snapshot in
                    if let val = snapshot.value as? String {
                        UIColor.color = UIColor(hexString: val)
                    }
                })
                
                self?.versionManager.getReference(.features, ref)?.observe(.value, with: { snapshot in
                    if let dataObject = snapshot.value as? [String] {
                        customAppSettings.sharedInstance.initializeCustomValue(from: dataObject)
                        (UIApplication.shared.delegate as! AppDelegate).loadHomepage()
                    }
                })
                
                ref?.child("integrations").observe(.value, with: { snapshot in
                    customAppSettings.sharedInstance.checkForIntegrations(from: snapshot)
                })
                
                self?.versionManager.getReference(.available_locale, ref)?.observe(.value, with: { snapshot in
                    if let dataObject = snapshot.value as? [String] {
                        Client.availableLanguageFB = dataObject
                    }
                })
                
                self?.versionManager.getReference(.splash, ref)?.observe(.value, with: {snapshot in
                    //          if let val = snapshot.value as? String {
                    //            //self?.statusImage.sd_setImage(with: URL(string: val))
                    //          }
                })
                
            }  // DispatchGroup Notify Ending here
        }
    }
    
    
    fileprivate func langSetupIfAlreadyLaunched(){
        var val = String()
        if (UserDefaults.standard.bool(forKey: "HasLaunchedOnce")) {
            if let value = UserDefaults.standard.value(forKey: "AppleLanguages") as? [String]{
                val = value[0]
            }
            Client.locale = val
            Client.shared.client = Graph.Client(shopDomain: Client.shopUrl, apiKey: Client.apiKey,locale: Locale(identifier: val))
            Bundle.setLanguage(val)
            let rtlLanguages = ["ar","ar-AE","ur"]
            let semanticContentAttribute: UISemanticContentAttribute = rtlLanguages.contains(val) ? .forceRightToLeft : .forceLeftToRight
            customAppSettings.sharedInstance.rtlSupport = rtlLanguages.contains(val) ? true : false
            self.setSemanticContentAttribute(semanticContentAttribute, for: [UIView.self,UISearchBar.self,UITextView.self,UITextField.self,UIButton.self,UILabel.self,UINavigationBar.self,UICollectionView.self,UIStackView.self
           ])
        }
    }
    
    @objc func setDefaultLanguage(){
        UserDefaults.standard.set(true, forKey: "firstlaunch")
        UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
//        Client.shared.fetchAvailableLanguage { response in
//            if let response = response {
//                LanguageUpdation.selectStore(store: response.keys.first!, code: response.values.first!)
//            }
//        }
    }
    
    fileprivate func showMaintainencePopup(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "maintainence") as! MaintainenceVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    fileprivate func showTrialPopup() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "trial")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        if let btn = vc.view.viewWithTag(1234) as? UIButton {
            btn.setTitle("RETRY".localized, for: .normal)
            btn.addTarget(self, action: #selector(self.reloadApp(_:)), for: .touchUpInside)
        }
    }
    
    @objc func setupCountryAndCurrencyCodes(){
        Client.shared.fetchShop(completion: {
            shopDetails in
            if let currenCode = shopDetails?.currencyCode {
                UserDefaults.standard.setValue(currenCode, forKey: "defaultCurrency")
                if Client.shared.getCurrencyCode() == nil{
                    Client.shared.saveCurrencyCode(currency: currenCode)
                }
            }
            
            if let countryCode = shopDetails?.countryCode {
                if UserDefaults.standard.value(forKey: "mageCountryCode") == nil {
                    Client.shared.saveCountryCode(currency: countryCode)
                }
            }
        })
    }
    
    func configureApptheme(windowVar: UIWindow, theme: String) {
        if #available(iOS 13.0, *) {
            switch theme {
            case "on":
                windowVar.overrideUserInterfaceStyle = .dark
            case "off":
                windowVar.overrideUserInterfaceStyle = .light
            default:
                windowVar.overrideUserInterfaceStyle = .unspecified
            }
        } else {
            // No override user interface style property available
        }
    }
    
    func setSemanticContentAttribute(_ attribute: UISemanticContentAttribute, for views: [UIView.Type]) {
        for view in views {
            view.appearance().semanticContentAttribute = attribute
        }
    }

    func getLocalizedLanguage(langCode:String)->String?{
        let locale: Locale = Locale(identifier: Client.locale)
        let store =  locale.localizedString(forLanguageCode: langCode)
        return store
    }
    
    @objc func reloadApp(_ sender : UIButton) {
        print("To be handled based on further discussion based updates")
    }
}



