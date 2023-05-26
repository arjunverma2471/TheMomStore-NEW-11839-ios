//
//  HomeViewController+Initialise.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 06/04/20.
//  Copyright © 2020 MageNative. All rights reserved.
//

import Foundation
import CryptoKit

extension HomeViewController
{
    func setupTable()
    {
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.emptyDataSetDelegate = self
        self.tableView?.emptyDataSetSource = self
        self.tableView.showsVerticalScrollIndicator = false
        
        self.tableView.register(HomeSpacerCell.self, forCellReuseIdentifier: "HomeSpacerCell")
        
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0.0
        } else {
            // Fallback on earlier versions
        }
        let nib = UINib(nibName: NewHomeCategorySliderCell.className, bundle: nil)
        self.tableView?.register(nib, forCellReuseIdentifier: NewHomeCategorySliderCell.className)
        let nib1 = UINib(nibName: HomeAnnouncementBarCell.className, bundle: nil)
        self.tableView?.register(nib1, forCellReuseIdentifier: HomeAnnouncementBarCell.className)
        
        if Client.homeStaticThemeJSON.isEmpty {
            self.addRefreshViewControl()
        }
        else {
            //no need to refresh in case of static theme
        }
        
        
        //      if let val = UserDefaults.standard.value(forKey: "staticJSONEnabled") as? Bool {
        //          if val {
        //              //no need to refresh in case of static theme
        //          }
        //          else {
        //              self.addRefreshViewControl()
        //          }
        //      }
        //      else {
        //          self.addRefreshViewControl()
        //      }
        
    }
    
    func addRefreshViewControl() {
        refreshViewControl = UIRefreshControl()
        
        let shopUrl = Client.shopUrl.replacingOccurrences(of: ".myshopify.com", with: "")
        let ref = BaseViewController.secondaryDb?.reference(withPath: shopUrl).child("additional_info")
        
        VersionManager.shared.getReference(.appthemecolor, ref)?.observe(.value, with: {
            snapshot in
            if let dataObject = snapshot.value as? String {
                UserDefaults.standard.set(dataObject, forKey: "color")
                Client.shared.setTextColor(val: dataObject)
                self.refreshViewControl?.tintColor = UIColor(hexString: dataObject)
            }
        })
        self.tableView?.addSubview(refreshViewControl!)
        refreshViewControl?.addTarget(self, action: #selector(self.getHomeData), for: UIControl.Event.valueChanged)
    }
    
    @objc  func getHomeData(updateHomeData:Bool = false){
        personalisedProductsHide = false;
        
        let shopurl = Client.shopUrl.replacingOccurrences(of: ".myshopify.com", with: "")
        if let _ = BaseViewController.secondaryDb{
            if updateHomeData{
                saveHomeDataBg(shopUrl: shopurl)
            }else{
                loadHome(shopUrl: shopurl)
            }
        }
        else{
            FirebaseSetup.shared.configureFirebase()
            DispatchQueue.global(qos: .userInteractive).async {
                
                //FirebaseApp.configure(name: shopurl, options: FirebaseSetup.initDetails())
                let firebaseApps = FirebaseApp.app(name: shopurl)
                
                Auth.auth(app: firebaseApps!).signIn(withEmail: "manoharsinghrawat@magenative.com", password: "59Xp47nIt") { [weak self] authResult, error in
                    
                    guard let secondary = FirebaseApp.app(name: shopurl)
                    else { return assert(false, "Could not retrieve secondary app") }
                    BaseViewController.secondaryDb = Database.database(app: secondary)
                    DispatchQueue.main.async {
                        if updateHomeData{
                            self?.saveHomeDataBg(shopUrl: shopurl)
                        }else{
                            self?.loadHome(shopUrl: shopurl, firstTime: true)
                        }
                    }
                }
            }
        }
    }
    
    
    func loadHome(shopUrl: String, firstTime: Bool = false){
        
        let ref = BaseViewController.secondaryDb?.reference(withPath: shopUrl)
        
        VersionManager.shared.getReference(.homepage_component, ref)?.observe(.value, with: {
            snapshot in
            if let dataObject = snapshot.value as? String {
                do {
                    do {
                        print("--home--")
                        print(dataObject)
                        var request = URLRequest(url: URL(string: dataObject)!)
                        request.httpMethod="GET"
                        AF.request(request).responseData(completionHandler: {
                            response in
                            switch response.result {
                            case .success:
                                do {
                                    if  let json = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as? [String:Any] {
                                        print(json)
                                        print("Actual Sort Data =======>",self.sortOrder  as Any)
                                        
                                        //START ---FOR TESTING
                                        print("Is Insta Enabled ===>",customAppSettings.sharedInstance.isInstaFeed)
                                        if customAppSettings.sharedInstance.isInstaFeed{
                                            print("yes")
                                            var newDict = [String:Any]()
                                            let instaPos = customAppSettings.sharedInstance.instaFeedPosition
                                            var i = instaPos
                                            if var tempData = json["sort_order"] as? [String : Any] {
                                                print("Temp Data =======>", tempData)
                                                
                                                print("insta postion ==>",instaPos)
                                                for (key,value) in tempData.sorted(by: {JSON(rawValue: $0.value) ?? 0 < JSON(rawValue: $1.value) ?? 0})
                                                {
                                                    if value as! Int >= instaPos
                                                    {
                                                        i+=1
                                                        print("Value of I===>",i)
                                                        tempData.updateValue(i, forKey: key)
                                                    }
                                                }
                                                
                                                print("After shift + 1 to keys===>", tempData)
                                                tempData["insta-feed"] = instaPos
                                                newDict = tempData
                                            }
                                            self.sortOrder = sort_order.init(fields: newDict)
                                            print("New Sort Data =======>",self.sortOrder  as Any)
                                            //END ---FOR TESTING
                                        }
                                        else{
                                            print("no")
                                            //ORIGINAL
                                            self.sortOrder =  sort_order.init(fields: json["sort_order"] as? [String : Any])
                                        }
                                        
                                        print("Final Sort Data =======>",self.sortOrder  as Any)
                                        
                                        self.dataSource = json
                                        
                                        self.fetchProducts_Test()
                                        //Saving home data
                                        UserDefaults.standard.setValue(response.data!, forKey: "HomeDataJSON")
                                        //END
                                        print("HomeDataJSON==",json)
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                                            //                              self.shimmer.removeFromSuperview()
                                            self.setupNavLayout(snapshop: json)
                                            //                              self.tableView.reloadData()
                                            // self.view.stopLoader()
                                        }
                                        DispatchQueue.main.async {
                                            //                          self.tableView.reloadData()
                                            self.setupNavLayout(snapshop: json)
                                            //                          self.view.stopLoader()
                                            //                            self.refreshViewControl?.endRefreshing()
                                            
                                        }
                                    }
                                }catch{                      print("catchedblock")
                                }
                            case .failure:
                                print("failed")
                            }
                        })
                    }
                }
            }
        })
    }
    
    
    func saveHomeDataBg(shopUrl: String){
        let ref = BaseViewController.secondaryDb?.reference(withPath: shopUrl)
        
        VersionManager.shared.getReference(.homepage_component, ref)?.observe(.value, with: {
            snapshot in
            if let dataObject = snapshot.value as? String {
                do {
                    do {
                        print("--home--")
                        print(dataObject)
                        var request = URLRequest(url: URL(string: dataObject)!)
                        request.httpMethod="GET"
                        AF.request(request).responseData(completionHandler: {
                            response in
                            switch response.result {
                            case .success:
                                do {
                                    
                                    if  let json = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as? [String:Any] {
                                        print(json)
                                        self.sortOrder =  sort_order.init(fields: json["sort_order"] as? [String : Any])
                                        self.dataSource = json
                                        
                                        self.fetchProducts_Test()
                                        //Saving home data
                                        UserDefaults.standard.setValue(response.data!, forKey: "HomeDataJSON")
                                        //Included for handling preview updation on the spot
                                        self.tableView.reloadData()
                                        
                                        if self.navigationController?.topViewController.self is HomeViewController{
                                            self.setupNavLayout(snapshop: json)
                                        }
                                        //END
                                    }
                                }catch{
                                    print("catchedblock")
                                }
                            case .failure:
                                print("failed")
                            }
                        })
                    }
                }
            }
        })
    }
    
    // Preloading Cells
    func fetchProducts_Test(){
        
        guard let dataSource = self.dataSource else {return}
        for (key,_) in dataSource {
            print("Key==",key)
            switch key {
            //Need to be debugged
            case let str where str.contains("product-list-slider"):
                if let data = dataSource[key] as? [String:Any]{
                    let viewModel = HomeProductListSliderViewModel(from: data)
    
                    let fetchProductsBlock = { (products: [ProductViewModel]) in
                        DispatchQueue.main.async {
                            if let index = self.sortOrder?.fields?[key] as? Int{
                                self.productsArray[index] = products
                                DispatchQueue.main.asyncAfter(deadline: .now()) {
                                    self.shimmer.removeFromSuperview()
                                    self.tableView.reloadData()
                                    self.refreshViewControl?.endRefreshing()
                                }
                            }
                        }
                    }
                    if viewModel.linking == "newest_first" {
                        DispatchQueue.global(qos: .background).async {
                            if let linkActionValue = viewModel.item_link_action_value, !linkActionValue.isEmpty {
                                Client.shared.fetchProducts(coll: collection(id: linkActionValue, title: viewModel.type), sortKey: MobileBuySDK.Storefront.ProductCollectionSortKeys.created, reverse: true, after: nil) { (products, _, _, _) in
                                    guard let products = products else { return }
                                    let productsArray = products.items.compactMap { $0.model?.node.viewModel as? ProductViewModel }
                                    let limitedProducts = Array(productsArray.prefix(10))
                                    fetchProductsBlock(limitedProducts)
                                }
                            } else {
                                Client.shared.fetchShopAllProducts(after: nil, with: MobileBuySDK.Storefront.ProductSortKeys.createdAt, reverse: true) { (products) in
                                    guard let products = products else { return }
                                    let productsArray = products.items.compactMap { $0.model?.node.viewModel as? ProductViewModel }
                                    let limitedProducts = Array(productsArray.prefix(10))
                                    fetchProductsBlock(limitedProducts)
                                }
                            }
                        }
                    }else{
                        var graphIds = [GraphQL.ID]()
                        for index in viewModel.item_value ?? [String](){
                            let str="gid://shopify/Product/"+index
                            let graphId = GraphQL.ID(rawValue: str)
                            graphIds.append(graphId)
                        }
                        DispatchQueue.global(qos: .userInitiated).async {
                            Client.shared.fetchMultiProducts(ids: graphIds, completion: { [weak self](response, error) in
                                if let response = response {
                                    if(response.count>0){
                                        //Product Data setting
                                        DispatchQueue.main.async {
                                            if let index = self?.sortOrder?.fields?[key] as? Int{
                                                self?.productsArray[index] = response
                                                
                
                                                
                                                DispatchQueue.main.asyncAfter(deadline: .now()) {
                                                    self?.shimmer.removeFromSuperview()
                                                    self?.tableView.reloadData()
                                                    self?.refreshViewControl?.endRefreshing()
                                                }
                                            }
                                        }
                                    }
                                }else {
                                    self?.showErrorAlert(error: error?.localizedDescription)
                                }
                            })
                        }
                    }
                }
            case let str where str.contains("fixed-customisable-layout"):
                if let data = dataSource[key] as? [String:Any]{
                    let viewModel = HomeFixedCustomisableLayoutViewModel(from: data)
                    
                    if(viewModel.item_layout_type == "grid")
                    {
                        switch viewModel.item_row {
                        case "3","2","1","infinite":
                        
                            if viewModel.linking == "newest_first" && viewModel.linkValue == ""{
                                let productCount = viewModel.productIds?.count ?? 0
                                DispatchQueue.global(qos: .userInitiated).async {
                                    
                                    Client.shared.fetchShopAllProducts(limit:productCount,after: nil, with: MobileBuySDK.Storefront.ProductSortKeys.createdAt, reverse: true) { (products) in
                                        guard let products = products else { return }
                                       
                                        DispatchQueue.main.async {
                                            if let index = self.sortOrder?.fields?[key] as? Int{
                                                self.productsArray[index] = products
                                                self.shimmer.removeFromSuperview()
                                                self.tableView.reloadData()
                                                self.refreshViewControl?.endRefreshing()
                                            }
                                        }
                                    }
                                }
                            }else{
                                
                                Client.shared.searchProductsForQuery(for:  viewModel.queryString ?? "",ids: viewModel.productIds ?? [String](), limit: viewModel.productIds?.count ?? 0, completion: {
                                    [weak self] response,ad  in
                                    DispatchQueue.main.async {
                                        if let response = response {
                                            if let index = self?.sortOrder?.fields?[key] as? Int{
                                                self?.productsArray[index] = response
                                                self?.shimmer.removeFromSuperview()
                                                self?.tableView.reloadData()
                                                self?.refreshViewControl?.endRefreshing()
                                            }
                                        }
                                    }
                                })
                            }
                            
                        default:
                            print("default")
                            let cursor:String?=nil
                            let  collectionid = collection(id: "1", title: "1")
                            Client.shared.fetchProducts(coll:collectionid,after:cursor, completion: {
                                [weak self] response,image,error,handle    in
                                DispatchQueue.main.async {
                                    if let response = response {
                                        if cursor != nil {
                                        }
                                        else {
                                            if let index = self?.sortOrder?.fields?[key] as? Int{
                                                self?.productsArray[index] = response
                                                self?.shimmer.removeFromSuperview()
                                                self?.tableView.reloadData()
                                                self?.refreshViewControl?.endRefreshing()
                                            }
                                        }
                                    }
                                    else {
                                        self?.showErrorAlert(error: error?.localizedDescription)
                                    }
                                }
                            })
                        }
                    }
                    else{
                        Client.shared.searchProductsForQuery(for:  viewModel.queryString ?? "",ids: viewModel.productIds ?? [String](), limit: viewModel.productIds?.count ?? 0, completion: {
                            [weak self] response,ad  in
                            DispatchQueue.main.async {
                                if let response = response {
                                    if let index = self?.sortOrder?.fields?[key] as? Int{
                                        self?.productsArray[index] = response
                                        self?.shimmer.removeFromSuperview()
                                        self?.tableView.reloadData()
                                        self?.refreshViewControl?.endRefreshing()
                                    }
                                }
                            }
                        })
                    }
                }
            default:
                print("default")
            }
        }
        DispatchQueue.main.async {
            self.shimmer.removeFromSuperview()
            self.tableView.reloadData()
            self.refreshViewControl?.endRefreshing()
        }
    }
}
