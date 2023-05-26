//
//  NewSearchVC.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 23/09/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit
import Speech

class NewSearchVC: UIViewController {
    // speech recognition
    var voiceSearchView: VoiceSearchView!
    let speechRecongniser = SFSpeechRecognizer() // Used for Voice search
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    var detectionTimer: Timer!
    fileprivate var products: PageableArray<ProductListViewModel>!
    var recentSearchItems = [String]()
    var datasourceArray = [String]()
    var imageLabeler: ImageLabeler?
    lazy var recentSearchView = RecentSearchView()
    //Fast Simon Properties
    var fastSimonAPIHandler: FastSimonAPIHandler?
    var fastSimonProducts  : [Item]?
    //Boost Commerce Properties
    var boostCommerceAPIHandler: BoostCommerceAPIHandler?
    var boostCommerceProducts  : [Product]?
    var custom = EmptyView()
   lazy var searchBar: UISearchBar = {
       let bar = UISearchBar()
           bar.placeholder = "Search by products & brands".localized
       
        bar.layer.borderWidth = 1.0
        bar.layer.borderColor = UIColor(hexString: "#d1d1d1", alpha: 1).cgColor
        if #available(iOS 13.0, *) {
            bar.searchTextField.font = mageFont.regularFont(size: 12)
            bar.searchTextField.backgroundColor = UIColor(light: UIColor.viewBackgroundColor(), dark: UIColor.provideColor(type: .newSearchVC).backGroundColor)
            let leftImg = UIImage(named: "searchFilled")
            let leftImageView = UIImageView.init(image: leftImg)
            leftImageView.tintColor = UIColor(light: .black, dark: UIColor.provideColor(type: .newSearchVC).tintColor)
            bar.searchTextField.leftView = leftImageView
            bar.searchTextField.rightView = nil
            bar.searchBarStyle = .default
            bar.compatibleSearchTextField.textColor = UIColor(light: .black, dark: UIColor.provideColor(type: .newSearchVC).textColor)
            bar.compatibleSearchTextField.backgroundColor = UIColor(light: .white, dark: UIColor.provideColor(type: .newSearchVC).backGroundColor)
            bar.barTintColor = UIColor(light: .white, dark: UIColor.provideColor(type: .newSearchVC).backGroundColor)
            
            let rightView = UIView()
            let lineView = UIView()
            lineView.backgroundColor = UIColor(hexString: "#6B6B6B", alpha: 1)
            let micBtn = UIButton()
            micBtn.setImage(UIImage(named: "micSearch"), for: .normal)
            micBtn.tintColor = UIColor(light: .AppTheme(), dark: UIColor.provideColor(type: .newSearchVC).tintColor)
            rightView.addSubview(lineView)
            rightView.backgroundColor = UIColor(light: UIColor.viewBackgroundColor(), dark: UIColor.provideColor(type: .newSearchVC).backGroundColor)
            lineView.anchor(top: rightView.topAnchor,left: rightView.leadingAnchor,bottom: rightView.bottomAnchor,paddingTop: 8,paddingLeft: 0,paddingBottom: 8,width: 1)
            lineView.centerY(inView: rightView)
            rightView.addSubview(micBtn)
            micBtn.anchor(left:lineView.trailingAnchor)
            micBtn.center(inView: rightView)
            rightView.anchor(width: 34)
            micBtn.addTarget(self, action: #selector(searchBarVoiceBtnTapped(_:)), for: .touchUpInside)
            bar.addSubview(rightView)
            rightView.anchor(top:bar.topAnchor,bottom: bar.bottomAnchor,right: bar.trailingAnchor,paddingTop: 0,paddingBottom: 0,paddingRight: 4)
            rightView.centerY(inView: bar)
            if Client.locale == "ar"{
                bar.searchTextField.textAlignment = .right
            }else{
                bar.searchTextField.textAlignment = .left
            }
        } else {
            // Fallback on earlier versions
        }
        return bar
    }()
 
    lazy var cameraBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 2.0
//        btn.imageView?.centerY(inView: btn)
//        btn.imageView?.anchor(right:btn.titleLabel?.trailingAnchor,paddingRight: 8)
        btn.titleLabel?.font = mageFont.regularFont(size: 12)
        btn.setTitle("  "+"Take a photo".localized+" ", for: .normal)
        btn.setImage(UIImage(named: "cameraSearch"), for: .normal)
        btn.setTitleColor(UIColor(hexString: "#6B6B6B", alpha: 1), for: .normal)
        btn.backgroundColor = UIColor(light: UIColor(hexString: "#F2F2F2", alpha: 1), dark: UIColor.provideColor(type: .newSearchVC).white)
        btn.tintColor = UIColor(hexString: "#6B6B6B", alpha: 1)
        btn.layer.cornerRadius = 2.0
        
        return btn
    }()
    lazy var qrBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 2.0
//        btn.imageView?.centerY(inView: btn)
       // btn.imageView?.anchor(right:btn.titleLabel?.leadingAnchor,paddingRight: 8)
        btn.titleLabel?.font = mageFont.regularFont(size: 12)
        btn.setTitle("  "+"Scan code".localized+" ",for: .normal)
        btn.setTitleColor(UIColor(hexString: "#6B6B6B", alpha: 1), for: .normal)
        btn.setImage(UIImage(named: "searchScan"), for: .normal)
        btn.backgroundColor = UIColor(light: UIColor(hexString: "#F2F2F2", alpha: 1), dark: UIColor.provideColor(type: .newSearchVC).white
        )
        btn.tintColor = UIColor(hexString: "#6B6B6B", alpha: 1)
        btn.layer.cornerRadius = 2.0
        return btn
    }()
    lazy var captureScanView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cameraBtn,qrBtn])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fillEqually
        stack.alignment = .fill
        qrBtn.addTarget(self, action: #selector(barcodeScannerClicked(_:)), for: .touchUpInside)
        cameraBtn.addTarget(self, action: #selector(imageSearchClicked(_:)), for: .touchUpInside)
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          
        speechRecongniser?.delegate = self
         requestAuth()
        if customAppSettings.sharedInstance.isFastSimonSearchEnabled {
            fastSimonAPIHandler = FastSimonAPIHandler()
        }
        if customAppSettings.sharedInstance.boostCommerceEnabled {
            boostCommerceAPIHandler = BoostCommerceAPIHandler()
        }
        // Do any additional setup after loading the view.
        recentSearchView.selectRecentItem = {[weak self] item in self?.selectRecentItem(item: item)}
        searchBar.delegate = self;
        configureUI()
        hideKeyboardWhenTappedAround()
       
    }
    
    func configureUI(){
        view.backgroundColor = UIColor.viewBackgroundColor()
        view.addSubview(searchBar)
        searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leadingAnchor,right: view.trailingAnchor,paddingTop:8, paddingLeft: 8,paddingRight: 8,height: 40)
        view.addSubview(captureScanView)
        captureScanView.anchor(top: searchBar.bottomAnchor,left: view.leadingAnchor,right: view.trailingAnchor,paddingTop: 8,paddingLeft: 8,paddingRight: 8, height: 40)
        view.addSubview(recentSearchView)
        recentSearchView.anchor(top: captureScanView.bottomAnchor,left: view.leadingAnchor,right: view.trailingAnchor, paddingTop: 8,paddingLeft: 0,paddingRight: 0,height: 140)
        recentSearchView.clearBtn.addTarget(self, action: #selector(clearBtnTapped(_:)), for: .touchUpInside)
        recentSearchView.clearBtn.titleLabel?.font = mageFont.setFont(fontWeight: "normal", fontStyle: "normal",fontSize: 10)
    }
    @objc func barcodeScannerClicked(_ sender: UIButton){
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ScanViewController.className) as! ScanViewController //= self.storyboard!.instantiateViewController()
      viewController.barcodeScannerCheck = true;
      viewController.delegate = self;
      self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    @objc func clearBtnTapped(_ sender: UIButton){
        self.recentSearchItems.removeAll()
        recentSearchView.isHidden = true
        UserDefaults.standard.removeObject(forKey: "recentSearchKeys")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if customAppSettings.sharedInstance.showTabbar{
            self.navigationController?.navigationBar.isHidden = true;
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }else{
            self.navigationController?.navigationBar.isHidden = false;
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // addEmptyView()
        self.tabBarController?.tabBar.tabsVisiblty()
        self.products = nil
        self.searchBar.text = ""
        let item = UserDefaults.standard.value(forKey: "recentSearchKeys") as? [String] ?? []
        
        if item.count == 0{
            self.recentSearchView.isHidden = true
        }else{
            self.recentSearchView.isHidden = false
        }
        self.recentSearchView.recentSearchData = item
       
        
    }
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        if customAppSettings.sharedInstance.showTabbar{
//            self.navigationController?.navigationBar.isHidden = true
//        }else{
//            self.navigationController?.navigationBar.isHidden = false
//        }
//    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        if customAppSettings.sharedInstance.showTabbar{
//            self.navigationController?.setNavigationBarHidden(true, animated: false)
//        }else{
//            self.navigationController?.setNavigationBarHidden(false, animated: false)
//        }
//    }
    
    private func selectRecentItem(item: String){
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.text = item
        }
        loadProducts(searchText:item)
    }
}

extension NewSearchVC: UISearchBarDelegate,UISearchDisplayDelegate{
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchProduct), object: nil)
    self.perform(#selector(searchProduct), with: nil, afterDelay: 1.65)
  }
  func loadProducts(searchText:String){
//    searchBar.resignFirstResponder()
    if(searchText != ""){
        removeEmptyView()
        
      DispatchQueue.global(qos: .background).async {
          Client.shared.searchProductsForQuery(for: searchText, completion: {
        response,error   in
        if let response = response {
            self.products = response
            self.products.items=[]
            for item in response.items {
              self.products.items.append(item)
            }
            if self.products != nil{
                AnalyticsFirebaseData.shared.firebaseSearchEvent(term: searchText)
                if searchText != "" && !(self.recentSearchItems.contains(searchText)){
                    self.recentSearchItems.append(searchText)
                    if self.recentSearchItems.count > 7{
                        self.recentSearchItems.remove(at: 0)
                    }
                    UserDefaults.standard.setValue(self.recentSearchItems, forKey: "recentSearchKeys")
                }
            }
            if(self.products.items.count == 0){
                self.addEmptyView()
                /*self.view.makeToast("No Products Found In Collection".localized, duration: 2.0, position: .center);*/
                
                //return custom;
              return;
            }
          DispatchQueue.main.async {
              let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: SearchViewController.className) as! SearchViewController
              vc.searchText = searchText
              self.navigationController?.navigationBar.isHidden = false
              self.navigationController?.setNavigationBarHidden(false, animated: false)
              self.navigationController?.pushViewController(vc, animated: true)
             
          }
        }
        else {
          //self.showErrorAlert(error: error?.localizedDescription)
        }
      })
      }
    }
    else
    {
        if(self.products != nil){
            self.products = nil
            // self.products.items=[]
            self.recentSearchView.isHidden = true
        }
        
    }
  }
  
    @objc func searchProduct(){
    if let searchText = searchBar.text{
        //imageSize = CGSize(width: 1, height: 1)
      if customAppSettings.sharedInstance.isFastSimonSearchEnabled{
        loadFastSimonProducts(searchText:searchText)
      }else if customAppSettings.sharedInstance.boostCommerceEnabled {
        loadBoostCommerceProducts(searchText: searchText)
      }else{
        loadProducts(searchText:searchText)
      }
    }
  }
  
    func addEmptyView(){
        self.custom = EmptyView()
        self.custom.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(self.custom)
        NSLayoutConstraint.activate([
            self.custom.heightAnchor.constraint(equalToConstant: 350),
            self.custom.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 50),
            self.custom.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            self.custom.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
        ])
        self.custom.delegate = self;
        self.custom.configure(imageName: "emptySearch", title: EmptyData.searchTitle, subtitle: EmptyData.searchDescription)
    }
    
    func removeEmptyView(){
        self.custom.removeFromSuperview()
    }
    
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    self.navigationController?.navigationBar.isHidden = false
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    if let _ = searchBar.text {
      searchBar.resignFirstResponder()
    }
  }
}

extension NewSearchVC: BarcodeProtocol{
  func searchBarcode(text: String) {
    if(text == ""){
        self.view.makeToast("No Products Found In Collection".localized, duration: 2.0, position: .center);
      return;
    }
    loadProducts(searchText:text)
  }
    func loadBoostCommerceProducts(searchText: String){
      if searchText == ""{
        self.boostCommerceProducts?.removeAll()
       // self.productsCollectionView.reloadData()
      }else{
        guard let searchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        self.view.addLoader()
        let params = ["q":searchText]
        boostCommerceAPIHandler?.getInstantSearchResults(params, completion: { [weak self] feed in
          self?.view.stopLoader()
          guard let feed = feed else {return}
            self?.boostCommerceProducts?.removeAll()
          self?.boostCommerceProducts = feed.products
            if self?.boostCommerceProducts?.count ?? 0 > 0 {
                if searchText != "" && !(self!.recentSearchItems.contains(searchText)){
                    self!.recentSearchItems.append(searchText)
                    if self!.recentSearchItems.count > 7{
                        self!.recentSearchItems.remove(at: 0)
                    }
                    UserDefaults.standard.setValue(self!.recentSearchItems, forKey: "recentSearchKeys")
                }
            }
            if self?.boostCommerceProducts?.count ?? 0 == 0 {
                self?.addEmptyView()
                return;
            }
            DispatchQueue.main.async {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: SearchViewController.className) as! SearchViewController
                vc.searchText = searchText
                self?.navigationController?.navigationBar.isHidden = false
                self?.navigationController?.setNavigationBarHidden(false, animated: false)
                self?.navigationController?.pushViewController(vc, animated: true)
               
            }
        //  self?.productsCollectionView.reloadData()
        })
      }
    }
    
    
    //MARK: Fast Simon
    func loadFastSimonProducts(searchText: String){
      
      if searchText == "" {
        self.fastSimonProducts?.removeAll()
          self.recentSearchView.isHidden = true
       // self.productsCollectionView.reloadData()
      }else{
          removeEmptyView()
        guard let searchTxt = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        self.view.addLoader()
        fastSimonAPIHandler?.getAutoCompleteProducts(searchTxt) { [weak self] feed in
          self?.view.stopLoader()
          guard let feed = feed else {
            return
          }
          self?.fastSimonProducts?.removeAll()
          self?.fastSimonProducts = feed.items
            if self?.fastSimonProducts?.count ?? 0 > 0 {
                if searchTxt != "" && !(self!.recentSearchItems.contains(searchText)){
                    self!.recentSearchItems.append(searchText)
                    if self!.recentSearchItems.count > 7{
                        self!.recentSearchItems.remove(at: 0)
                    }
                    UserDefaults.standard.setValue(self!.recentSearchItems, forKey: "recentSearchKeys")
                }
            }
            if self?.fastSimonProducts?.count ?? 0 == 0 {
                self?.addEmptyView()
                return;
            }
            DispatchQueue.main.async {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: SearchViewController.className) as! SearchViewController
                vc.searchText = searchText
                self?.navigationController?.navigationBar.isHidden = false
                self?.navigationController?.setNavigationBarHidden(false, animated: false)
                self?.navigationController?.pushViewController(vc, animated: true)
               
            }
          }
         
        }
      }
    }
    
    
//    func loadProducts(searchText:String){
//  //    searchBar.resignFirstResponder()
//      if(searchText != ""){
//          removeEmptyView()
//
//        DispatchQueue.global(qos: .background).async {
//            Client.shared.searchProductsForQuery(for: searchText, completion: {
//          response,error   in
//          if let response = response {
//              self.products = response
//              self.products.items=[]
//              for item in response.items {
//                self.products.items.append(item)
//              }
//              if self.products != nil{
//                  if searchText != "" && !(self.recentSearchItems.contains(searchText)){
//                      self.recentSearchItems.append(searchText)
//                      if self.recentSearchItems.count > 7{
//                          self.recentSearchItems.remove(at: 0)
//                      }
//                      UserDefaults.standard.setValue(self.recentSearchItems, forKey: "recentSearchKeys")
//                  }
//              }
//              if(self.products.items.count == 0){
//                  self.addEmptyView()
//                  /*self.view.makeToast("No Products Found In Collection".localized, duration: 2.0, position: .center);*/
//
//                  //return custom;
//                return;
//              }
//            DispatchQueue.main.async {
//                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: SearchViewController.className) as! SearchViewController
//                vc.searchText = searchText
//                self.navigationController?.navigationBar.isHidden = false
//                self.navigationController?.setNavigationBarHidden(false, animated: false)
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//          }
//          else {
//            //self.showErrorAlert(error: error?.localizedDescription)
//          }
//        })
//        }
//      }
//      else
//      {
//          if(self.products != nil){
//              self.products = nil
//              // self.products.items=[]
//              self.recentSearchView.isHidden = true
//          }
//
//      }
//    }
//
//}
extension NewSearchVC:DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return self.products.items.count == 0
    }
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        let custom = EmptyView()
        custom.delegate = self;
        custom.configure(imageName: "emptySearch", title: EmptyData.searchTitle, subtitle: EmptyData.searchDescription)
        return custom;
    }
}
