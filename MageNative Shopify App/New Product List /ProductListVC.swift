//
//  ProductListVC.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 10/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import MobileBuySDK
import AudioToolbox

class ProductListVC : BaseViewController, ProductAddProtocol {
    
    func productAdded() {
      self.setupTabbarCount()
        self.updateCartCount()
    }

    // ----------------------------------
    //  MARK: - Properties -
    //
    
    var collection : CollectionViewModel!
    fileprivate var products: PageableArray<ProductListViewModel>!
    var isFromSearch=false
    var currentSortKey = ""
    var collect:collection?
    var isfromHome = false
    var fetchAllProduct = false
    var searchText:String?
    var productSortKey:MobileBuySDK.Storefront.ProductCollectionSortKeys = MobileBuySDK.Storefront.ProductCollectionSortKeys.created
    var productreverseKey:Bool = true
    var searchSortKey:MobileBuySDK.Storefront.ProductSortKeys? = nil
    var filterFloatingButton : UIButton!
    var selectedFilter = [String]()
    var selectedBCFilterArrayAPI = [String:[String]]()
    var selectedFilterData : SelectedFilterModel?
    var selectedPrice = [String:String]()
    var priceSelected = [Double]()
    var handle = BehaviorSubject(value: "")
    var filteredArray = [MobileBuySDK.Storefront.ProductFilter]()
    var isFilter = false;
    var filterData = [String:[String]]()
    var disposeBag = DisposeBag()
    var isGridView = true
    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
    var secondaryColor = UIColor(light: Client.navigationThemeData?.icon_color ?? .black, dark: UIColor.provideColor(type: .productListVC).itemTitleColor)
    var selectedFilterCount = [String:Int]()
    
    var subMenuData = [MenuObject]()
    var selectedIndex = 0
    private var shimmer = customShimmerView(cellsArray: [productListingShimmerTC.reuseID], productListCount: 20)
    var bagButton : BadgeButton!
    var bcFilterStr = ""
    var cartbutton : BadgeButton!
    var filterProducts=Array<ProductViewModel>()
    var boostCommerceAPIHandler: BoostCommerceAPIHandler?
    var filterPage = 1
    // ----------------------------------
    //  MARK: - Views -
    //
    var titleBtn = UIButton()
    var pageTitle : String = String(){
        didSet{
            self.headerTitleSetup()
        }
    }
    
    var imageSize = CGSize(width: 1, height: 1)

    fileprivate lazy var productsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 5, bottom: 5 , right: 5)
        collectionView.collectionViewLayout = layout
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false;
        if #available(iOS 13.0, *) {
            collectionView.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .productListVC).collectionViewBackgroundColor)
        } else {
            collectionView.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .productListVC).collectionViewBackgroundColor)
            // Fallback on earlier versions
        }
        collectionView.register(ProductGridCollectionCell.self, forCellWithReuseIdentifier: ProductGridCollectionCell.className)
        return collectionView
    }()
    
    private lazy var subCollectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5 , right: 5)
        layout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = layout
        collectionView.translatesAutoresizingMaskIntoConstraints = false;
        collectionView.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .productListVC).collectionViewBackgroundColor)
        collectionView.register(ProductVariationViewCell.self, forCellWithReuseIdentifier: ProductVariationViewCell.className)
        return collectionView
    }()
    
    var bottomTabView = ProductListTabView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.productsCollectionView.reloadData()
        self.updateCartCount()
        if(Client.locale == "ar"){
            bottomTabView.listButton.contentHorizontalAlignment = .right
            bottomTabView.gridButton.contentHorizontalAlignment = .left
        }else{
                bottomTabView.listButton.contentHorizontalAlignment = .left
                bottomTabView.gridButton.contentHorizontalAlignment = .right
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        AnalyticsFirebaseData.shared.firebaseCategoryEvent(category: self.pageTitle)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
     
        print("here from home==>",isfromHome)
        self.setUpView()
        self.setupCollectionView()
        if(collection != nil){
            handle.onNext(collection.handle)
        }
        
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 13
        cartbutton = BadgeButton(frame: CGRect(x: 0, y: 0, width: 20, height: 15))
        cartbutton.setImage(UIImage(named: "bag"), for: .normal)
        
        cartbutton.imageView?.contentMode = .scaleAspectFit;
        cartbutton.addTarget(self, action: #selector(bagButtonClicked(_:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItems?.remove(at: 0)
        self.navigationController?.navigationBar.tintColor = Client.navigationThemeData?.icon_color

        //self.navigationItem.rightBarButtonItems?.insert(space, at: 0)
        self.navigationItem.rightBarButtonItems?.insert(UIBarButtonItem(customView: cartbutton), at: 0)
        self.loadProducts(sortKey: self.productSortKey,reverse:self.productreverseKey)
    }
    
    
    func headerTitleSetup(){
        let titleWidth = (self.pageTitle.localized as NSString).size(withAttributes: [NSAttributedString.Key.font: mageFont.mediumFont(size: 15)]).width
        let title           = UILabel(frame: CGRect(x: 0, y: 0, width: titleWidth, height: 30))
        title.font          = mageFont.mediumFont(size: 15)
        title.text          = self.pageTitle.localized
        title.textColor     =  UIColor(light: Client.navigationThemeData?.icon_color ?? .white, dark: .white)
        if self.navigationItem.leftBarButtonItems?.count ?? 0 < 2{
            self.navigationItem.leftBarButtonItems?.append(UIBarButtonItem(customView: title))
        }
    }
    
    
    func updateCartCount() {
        print("CART COUNT====>", CartManager.shared.cartCount.description)
        cartbutton.badge = CartManager.shared.cartCount == 0 ? nil : CartManager.shared.cartCount.description
    }
    
    func setupCollectionView(){
      self.productsCollectionView.delegate   = self
      self.productsCollectionView.dataSource = self
      self.productsCollectionView.emptyDataSetSource   = self
      self.productsCollectionView.emptyDataSetDelegate = self
        self.productsCollectionView.reloadData()
        if subMenuData.count > 0 {
            self.subCollectionView.isHidden = false
            self.subCollectionView.dataSource = self
            self.subCollectionView.delegate = self
            self.subCollectionView.reloadData()
            self.subCollectionView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        }
        else {
            self.subCollectionView.isHidden = true
            self.subCollectionView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
    }
    
    func setUpView() {
        view.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .productListVC).backGroundColor)
        view.addSubview(productsCollectionView)
        view.addSubview(subCollectionView)
        view.addSubview(bottomTabView)
        //bottomTabView.backgroundColor = .AppTheme()
        //ShowShimmer
        shimmer.frame = self.view.bounds
        view.addSubview(shimmer)
        view.bringSubviewToFront(shimmer)
        bottomTabView.translatesAutoresizingMaskIntoConstraints = false
        bottomTabView.layer.masksToBounds = false
        bottomTabView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bottomTabView.layer.shadowColor = UIColor.black.cgColor
        bottomTabView.layer.shadowOpacity = 0.3
        self.setupTabView()
        NSLayoutConstraint.activate([
            bottomTabView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bottomTabView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            bottomTabView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            bottomTabView.heightAnchor.constraint(equalToConstant: 60),
            productsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            productsCollectionView.topAnchor.constraint(equalTo: subCollectionView.bottomAnchor, constant: 8),
            productsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            productsCollectionView.bottomAnchor.constraint(equalTo: bottomTabView.topAnchor, constant: -4),
            subCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            subCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            subCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
           // subCollectionView.heightAnchor.constraint(equalToConstant: 60)
        ])
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
    
    func setupTabView() {
        if isGridView {
            bottomTabView.gridButton.tintColor = self.checkTabColor()
            bottomTabView.listButton.tintColor = self.checkTabColor()
        }
        else {
            bottomTabView.listButton.tintColor = self.checkTabColor()
            bottomTabView.gridButton.tintColor = self.checkTabColor()
        }
        bottomTabView.filterButton.tintColor = self.checkTabColor()
        bottomTabView.sortButton.tintColor = self.checkTabColor()
        bottomTabView.filterButton.setTitleColor(self.checkTabColor(), for: .normal)
        bottomTabView.sortButton.setTitleColor(self.checkTabColor(), for: .normal)
                                          
        bottomTabView.sortButton.titleLabel?.font = mageFont.regularFont(size: 12)//UIFont(name: "Sora-Light", size: 12.0)
        bottomTabView.filterButton.titleLabel?.font = mageFont.regularFont(size: 12)//UIFont(name: "Sora-Light", size: 12.0)
        bottomTabView.gridButton.addTarget(self, action: #selector(changeToGrid(_:)), for: .touchUpInside)
        bottomTabView.listButton.addTarget(self, action: #selector(changeToList(_:)), for: .touchUpInside)
        bottomTabView.sortButton.addTarget(self, action: #selector(sortProducts(_:)), for: .touchUpInside)
        bottomTabView.filterButton.addTarget(self, action: #selector(navigateToFilter(_:)), for: .touchUpInside)
        
        self.bottomTabView.sortButton.setTitle("Sort".localized, for: .normal)
        self.bottomTabView.filterButton.setTitle("Filter".localized, for: .normal)
       
    }
    
    // ----------------------------------
    //  MARK: - Fetching -
    //
    func loadProducts(sortKey:MobileBuySDK.Storefront.ProductCollectionSortKeys? = MobileBuySDK.Storefront.ProductCollectionSortKeys.created,searchsortKey: MobileBuySDK.Storefront.ProductSortKeys? = nil,cursor: String? = nil,reverse:Bool? = true){
      if isfromHome{
        if fetchAllProduct {
          DispatchQueue.global(qos: .background).async {
              Client.shared.fetchShopAllProducts(after: cursor, with: searchsortKey, reverse: reverse, completion: {
              response in
              self.view.stopLoader()
              
            if let product = response
            {
              print("---cursor--\(cursor ?? "")")
              if cursor != nil {
                self.products.appendPage(from: product)
              }
              else {
                self.products = product
              }
                self.getHeight()
              DispatchQueue.main.async {
                  self.shimmer.removeFromSuperview()
                self.productsCollectionView.reloadData()
                // Making request for more data
                if self.isViewLoaded && (self.view.window != nil) {
                  print("✅ViewController is visible")
                  self.loadMoreData()
                }
              }
            }
          })
          }
        }
        else {
          DispatchQueue.global(qos: .background).async {
            Client.shared.fetchProducts(coll: self.collect,sortKey:sortKey,reverse: reverse,after:cursor, completion: {
              products,url,error,pageHandler   in
                DispatchQueue.main.async {
                    self.view.stopLoader()
                }
           
            self.productsCollectionView.reloadEmptyDataSet()
            if let products = products{
              if cursor != nil {
                self.products.appendPage(from: products)
              }
              else {
                self.products = products
              }
                self.getHeight()
                self.handle.onNext(pageHandler?["handle"] ?? "")
                //self.handle = handle!
              DispatchQueue.main.async {
                  self.pageTitle = pageHandler?["title"] ?? ""
                  self.navigationController?.navigationBar.setNeedsLayout()
                  self.shimmer.removeFromSuperview()
                self.productsCollectionView.reloadData()
                // Making request for more data
                // If viewcontroller is visible and stopping if view controller is disappeared
                if self.isViewLoaded && (self.view.window != nil) {
                  print("✅ViewController is visible")
                  self.loadMoreData()
                }
              }
            }else {
              //self.showErrorAlert(error: error?.localizedDescription)
            }
          })
          }
        }
      }else if  isFromSearch{
        guard let searchText = searchText else {return}
        DispatchQueue.global(qos: .background).async {
          Client.shared.searchProductsForQuery(for: searchText,after:cursor, with: self.searchSortKey, reverse: self.productreverseKey, completion: {
            response,error   in
          self.view.stopLoader()
            
          if let response = response {
            print("--cursors--\(cursor ?? "")")
            if cursor != nil {
              print(response)
              self.products.appendPage(from: response)
            }
            else {
              self.products = response
            }
              self.getHeight()
           
            DispatchQueue.main.async {
                self.shimmer.removeFromSuperview()
              self.productsCollectionView.reloadData()
              // Making request for more data
              if self.isViewLoaded && (self.view.window != nil) {
                print("✅ViewController is visible")
                self.loadMoreData()
              }
            }
          }else {
            //self.showErrorAlert(error: error?.localizedDescription)
          }
        })}}else  {
          DispatchQueue.global(qos: .background).async {
            Client.shared.fetchProducts(in: self.collection,sortKey:sortKey,reverse: reverse,after:cursor, completion: {
              products,_,error,pageHandler   in
            self.view.stopLoader()
            if let products = products{
              print("---cursor--\(cursor ?? "")")
              if cursor != nil {
                //print("title--"+products.items[0].title)
                self.products.appendPage(from: products)
              }else {
                self.products = products
              }
                self.getHeight()
                self.handle.onNext(pageHandler?["handle"] ?? "")
                
              DispatchQueue.main.async {
                  self.pageTitle = pageHandler?["title"] ?? ""
                  self.navigationController?.navigationBar.setNeedsLayout()
                  self.shimmer.removeFromSuperview()
                self.productsCollectionView.reloadData()
                // Making request for more data
                if self.isViewLoaded && (self.view.window != nil) {
                  print("✅ViewController is visible")
                  self.loadMoreData()
                }
              }
            }else {
              //self.showErrorAlert(error: error?.localizedDescription)
            }
          })}
        }
    }
    
    
    func loadMoreData(){
      if(isFilter){
        loadFilteredProduct(sortKey: self.productSortKey,searchsortKey: self.searchSortKey, cursor: self.products.items.last?.cursor,reverse:self.productreverseKey)
        return;
      }
      if self.products.hasNextPage {
        self.loadProducts(sortKey: self.productSortKey,searchsortKey: self.searchSortKey, cursor: self.products.items.last?.cursor,reverse:self.productreverseKey)
      }
    }
    
   
    // ----------------------------------
    //  MARK: - Shopify Filters -
    //
                                                  
                                                  
                                                  
                                                 
    func renderFilterFloatingButton(shopifyFilters: Bool) {
        filterFloatingButton = UIButton()
        filterFloatingButton.translatesAutoresizingMaskIntoConstraints = false
        filterFloatingButton.backgroundColor = UIColor.AppTheme()
        filterFloatingButton.setImage(UIImage(named: "filterImg"), for: .normal)
        filterFloatingButton.tintColor = UIColor.textColor()
        filterFloatingButton.layer.cornerRadius = 30.0
        
        filterFloatingButton.addTarget(self, action: #selector(navigateToFilter(_:)), for: .touchUpInside)
        
        self.view.addSubview(filterFloatingButton)
        filterFloatingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        filterFloatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        filterFloatingButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        filterFloatingButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
}


extension ProductListVC: FilterClicked{
    func applyFilter(selectedPrice: [Double], filter: [String], filterCount: [String : Int]) {
        print(selectedPrice)
        self.selectedFilter = filter
        self.priceSelected = selectedPrice
        self.selectedFilterCount=filterCount
        filteredArray = [MobileBuySDK.Storefront.ProductFilter]()
        if(!selectedPrice.isEmpty || !filter.isEmpty){
            isFilter = true
            for index in filter{
                let filters = MobileBuySDK.Storefront.ProductFilter.create()
                if let input = index.toJSON() as? [String:AnyObject]{
                    for(key,val) in input{
                        switch key{
                        case "productType":
                            if let value = val as? String{
                                filters.productType = .value(value)
                            }
                        case "available":
                            if let value = val as? Bool{
                                filters.available = .value(value)
                            }
                        case "productVendor":
                            if let value = val as? String{
                                filters.productVendor = .value(value)
                            }
                        case "variantOption":
                            if let value = val as? [String:String]{
                                
                                filters.variantOption = .value(MobileBuySDK.Storefront.VariantOptionFilter(name: value["name"]!, value: value["value"]!))
                            }
                        case "productMetafield":
                            if let value = val as? [String:String]{
                                filters.productMetafield = .value(MobileBuySDK.Storefront.MetafieldFilter(namespace: value["namespace"]!, key: value["key"]!, value: value["value"]!))
                            }
                        default:
                            
                            print("default")
                        }
                    }
                }
                filteredArray.append(filters)
            }
            if(!selectedPrice.isEmpty){
                let filt = MobileBuySDK.Storefront.ProductFilter.create()
                
                filt.price = .value(MobileBuySDK.Storefront.PriceRangeFilter.create(min: .value(selectedPrice.first ?? 0.0), max: .value(selectedPrice.last ?? 0.0)))
                filteredArray.append(filt)
            }
        }
        else{
            isFilter = false;
        }
        loadFilteredProduct()
    }
    
    
    func loadFilteredProduct(sortKey:MobileBuySDK.Storefront.ProductCollectionSortKeys? = nil,searchsortKey: MobileBuySDK.Storefront.ProductSortKeys? = nil,cursor: String? = nil,reverse:Bool? = nil){
        if cursor == nil {
            self.view.addLoader()
        }
        DispatchQueue.global(qos: .background).async {
            do {
                var handle = try! self.handle.value()
                if handle == "" {
                    if let handl = self.products.items.first?.collections.items.first?.handle {
                        handle = handl
                    }
                }
                Client.shared.fetchFilteredProducts(handle: handle,sortKey:sortKey,reverse: reverse,after:cursor, filter: self.filteredArray, completion: {
                    products,url,error,handle in
                    
                    if cursor == nil {
                        self.view.stopLoader()
                    }
                    
                    self.productsCollectionView.reloadEmptyDataSet()
                    if let products = products{
                        if cursor != nil {
                            self.products.appendPage(from: products)
                        }
                        else {
                            self.products = products
                        }
                        self.getHeight()
                        self.handle.onNext(handle ?? "")
                        DispatchQueue.main.async {
                            self.shimmer.removeFromSuperview()
                            self.productsCollectionView.reloadData()
                            // Making request for more data
                            if self.isViewLoaded && (self.view.window != nil) && cursor != nil {
                                print("✅ViewController is visible")
                                self.loadMoreData()
                            }
                        }
                    }else {
                        self.showErrorAlert(error: error?.localizedDescription)
                    }
                })
            }
        }
    }
    
     //MARK: Boostcommerce Filter
    func applyBoostCommerceFilterFromAPI(selectedPrice: [String : String], filter: [String:[String]],selectedFilter: SelectedFilterModel?) {
        self.selectedFilterData = selectedFilter
          self.selectedPrice = selectedPrice
         self.selectedBCFilterArrayAPI = filter
         if(!selectedPrice.isEmpty || !filter.isEmpty){
             isFilter = true
             self.filterPage = 1
             self.products.items.removeAll()
             self.filterProducts.removeAll()
             self.fetchFilterData(filterData: filter)
         }
         else {
             isFilter = false
             self.filterProducts.removeAll()
             self.productsCollectionView.reloadData()
             loadProducts()
         }
     }
    //MARK: BoostCommerce Filter Data fetch
   func fetchFilterData(filterData : [String:Any],sortData:String="best-selling") {
       print(filterData)
       var postString = filterData
       var staticData = [String:String]()
       self.view.addFullLoader()
       if self.collect?.id ?? "" != "" {
           staticData["collection_scope"] = self.collect?.id ?? ""
       }
       else {
           let collId = collection.id.components(separatedBy: "/").last ?? ""
           staticData["collection_scope"] = collId//collection.id
       }
       staticData["page"] = "\(self.filterPage)"
       if sortData != ""{
           staticData["sort"] = sortData
       }
       if(!selectedPrice.isEmpty){
           postString["pf_p_price"]="\(selectedPrice["min"] ?? ""):\(selectedPrice["max"] ?? "")"
       }
       print(postString)
       boostCommerceAPIHandler = BoostCommerceAPIHandler()
       boostCommerceAPIHandler?.getInstantFilterResults(postString,staticData: staticData, completion: { [weak self] feed in
         self?.view.stopLoader()
         guard let feed = feed else {return}
           print(feed)
           //if feed.products.count > 0 {
               var ids = [GraphQL.ID]()
               for itms in feed.products {
                   let str     = "gid://shopify/Product/\(itms.id ?? 0)"
                   let graphId = GraphQL.ID(rawValue: str)
                   ids.append(graphId)
               }
               
               if ids.count == 0 {
                   self?.view.removeFullLoader()

                   //self?.view.showmsg(msg: "No products found!")
                   return
                  // self?.productsCollectionView.reloadEmptyDataSet()
               }
               else {
                   Client.shared.fetchMultiProducts(ids: ids, completion: { [weak self] (response, error) in
                       
                       if response != nil {
                           self?.view.removeFullLoader()
                           if self?.filterPage == 1 {
                               self?.filterProducts = response!
                           }else{
                               self?.filterProducts += response!
                           }
                           self?.getBCFilterProdHeight()
                           self?.productsCollectionView.dataSource=self
                           self?.productsCollectionView.reloadData()
                           

                       }
                   })
               }
           //}
       })
       
   }
    
    func getBCFilterProdHeight(){
        //DispatchQueue.global(qos: .userInitiated).async {
            if(self.imageSize == CGSize(width: 1, height: 1)){
                if(self.filterProducts.count>0){
                    if let url = self.filterProducts.first?.images.items.first?.url, let size = ImageSize.shared.sizeOfImageAt(url: url){////first?.model?.node.viewModel.images.items.first?.url
                        self.imageSize=size
                        DispatchQueue.main.async {
                            self.productsCollectionView.dataSource = self
                            self.productsCollectionView.delegate = self
                            self.productsCollectionView.reloadData()
                        }
                        
                    }

                }
            }
            
        //}
    }
}


extension ProductListVC : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == subCollectionView {
            return subMenuData.count
        }
        else {
            if customAppSettings.sharedInstance.boostCommerceFilterEnabled && isFilter {
                return filterProducts.count > 0 ? filterProducts.count : 0
            }else{
                return products?.items.count ?? 0 > 0 ? products?.items.count ?? 0 : 0
            }
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == subCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductVariationViewCell.className, for: indexPath) as! ProductVariationViewCell
            selectedIndex == indexPath.row ? cell.textLabel.selectedItem() : cell.textLabel.unselectedItem()
            cell.textLabel.text = subMenuData[indexPath.item].name
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductGridCollectionCell.className, for: indexPath) as! ProductGridCollectionCell
            if customAppSettings.sharedInstance.boostCommerceFilterEnabled && isFilter {
                let product = self.filterProducts[indexPath.item]
                cell.setupView(model:product)
            }else{
                let product = self.products.items[indexPath.item]
                cell.setupView(model: (product.model?.node.viewModel)!)
            }
            cell.isGridView = isGridView
            cell.delegate = self
            cell.shareButton.tag = indexPath.item
            cell.shareButton.addTarget(self, action: #selector(shareProduct(_:)), for: .touchUpInside)
            cell.addToCartButton.tag = indexPath.item
            cell.addToCartButton.addTarget(self, action: #selector(addToCartPressed(_:)), for: .touchUpInside)
            return cell
        }
    }
    

    
   
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (customAppSettings.sharedInstance.boostCommerceFilterEnabled &&
            self.isFilter == true){
            if (filterProducts.count - 1) == indexPath.item{
                self.filterPage += 1
                self.fetchFilterData(filterData: self.selectedBCFilterArrayAPI)
            }
        }else{
          /*  if self.products != nil{
                if self.products.hasNextPage {
                    if (self.products.items.count-1)==indexPath.item{
                        self.view.addLoader()
                    }
                }
            } */
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == subCollectionView {
            return CGSize(width: 150, height: 45)
        }
        else {
            if isGridView {
                if UIDevice.current.model.lowercased() == "ipad".lowercased(){
                    let height = customAppSettings.sharedInstance.inAppAddToCart ? 185.0 : 150.0
                  return collectionView.calculateCellSizeOld(numberOfColumns: 6,of: 185.0)
                }
                
                let height = customAppSettings.sharedInstance.inAppAddToCart ? 180.0 : 145.0
              return collectionView.calculateCellSizeOld(numberOfColumns: 2,of: height,addSpacing: 5)
            }else {
                let height = UIScreen.main.bounds.height
                return CGSize(width: self.productsCollectionView.frame.width, height: (height*0.75))
            }
//            if isGridView {
//                if UIDevice.current.model.lowercased() == "ipad".lowercased(){
//                    var collectionSize = collectionView.calculateCellSize(numberOfColumns: 4, imagesize: imageSize)
//                    if(customAppSettings.sharedInstance.inAppAddToCart){
//                        collectionSize.height += 92
//                    }
//                    else{
//                        collectionSize.height += 57
//                    }
//                    return collectionSize
//                }
//                var collectionSize = collectionView.calculateCellSize(numberOfColumns: 2, imagesize: imageSize)
//                if(customAppSettings.sharedInstance.inAppAddToCart){
//                    collectionSize.height += 92
//                }
//                else{
//                    collectionSize.height += 57
//                }
//                return collectionSize
//            }
//            else {
//                var collectionSize = CGSize(width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.width-10*(imageSize.height/imageSize.width))
//                if(customAppSettings.sharedInstance.inAppAddToCart){
//                    collectionSize.height += 92
//                }
//                else{
//                    collectionSize.height += 57
//                }
//                return collectionSize
////                let height = UIScreen.main.bounds.height
////                return CGSize(width: self.productsCollectionView.frame.width, height: (height*0.75))
//            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == subCollectionView {
            return 5
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == subCollectionView {
            selectedIndex = indexPath.item
            collectionView.reloadData()
            let data = subMenuData[indexPath.item]
            let collectionId = returnString(strToModify: data.id)
            let coll = The_Mom_Store.collection(id: collectionId, title: data.name)
            let viewControl = ProductListVC() 
            viewControl.isfromHome = true
            viewControl.collect = coll
//            viewControl.title   = coll.title
            if data.children.count > 0 {
                viewControl.subMenuData = data.children
            }
            self.navigationController?.pushViewController(viewControl, animated: true)
        }
        else {
            productsCollectionView.isUserInteractionEnabled = false
            if customAppSettings.sharedInstance.boostCommerceFilterEnabled && isFilter {
                let product         = self.filterProducts[indexPath.row]
                let productViewController = ProductVC()
                productViewController.product = product
                self.navigationController?.pushToViewController(productViewController, completion: {
                    self.productsCollectionView.isUserInteractionEnabled = true
                })
            }
            else {
                
                let product         = self.products.items[indexPath.row]
                let productViewController = ProductVC()
                productViewController.product = product.model?.node.viewModel
                self.navigationController?.pushToViewController(productViewController, completion: {
                    self.productsCollectionView.isUserInteractionEnabled = true
                })
            }
        }
    }
  
    func getHeight(){
        DispatchQueue.global(qos: .userInitiated).async {
            if(self.imageSize == CGSize(width: 1, height: 1)){
                if(self.products.items.count>0){
                    if let url = self.products.items.first?.model?.node.viewModel.images.items.first?.url, let size = ImageSize.shared.sizeOfImageAt(url: url){
                        self.imageSize=size
                        DispatchQueue.main.async {
                            self.productsCollectionView.dataSource = self
                            self.productsCollectionView.delegate = self
                            self.productsCollectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
}

extension ProductListVC:wishListProductDelegate
{
    
  func addToWishListProduct(_ cell: ProductGridCollectionCell, didAddToWishList sender: UIButton) {
    guard let indexPath = self.productsCollectionView.indexPath(for: cell) else {return}
      if customAppSettings.sharedInstance.isGrowaveWishlist && Client.shared.isAppLogin(){
          let product = self.products.items[indexPath.row]
          guard let productModel = product.model?.node.viewModel else {
            return
          }
          let wishProduct = CartProduct.init(product: productModel, variant: WishlistManager.shared.getVariant(product.variants.items.first!))
          if WishlistManager.shared.isProductVariantinWishlist(product: wishProduct) {
              guard let productID = product.id.components(separatedBy: "/").last else {return}
              deleteGrowaveWishlistItem(productId: productID, wishProduct: wishProduct, indexPath: indexPath)
          }
          else {
              let vc = WishlistBoardsView()
              vc.product = productModel
              vc.delegate = self
              vc.indexPath = indexPath
              if #available(iOS 15.0, *) {
                  if let sheet = vc.sheetPresentationController {
                      sheet.detents = [.medium()]
                      sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                      sheet.preferredCornerRadius = 0
                  }
              }
              self.present(vc, animated: true)
          }
        }
      else if (customAppSettings.sharedInstance.boostCommerceFilterEnabled && self.isFilter == true){
          let product = self.filterProducts[indexPath.row]
          guard let productModel = product.model?.viewModel else {return}
          let wishProduct = CartProduct.init(product:productModel , variant: WishlistManager.shared.getVariant(product.variants.items.first!))
          
          if WishlistManager.shared.isProductVariantinWishlist(product: wishProduct){
              WishlistManager.shared.removeFromWishList(wishProduct)
              let msg =  "Item removed from wishlist.".localized
          self.view.showmsg(msg: msg)
          sender.setImage(UIImage(named: "wishlist-image"), for: .normal)
          }
          else {
              let msg =  "Item added to wishlist.".localized
              self.view.showmsg(msg: msg)
          WishlistManager.shared.addToWishList(wishProduct)
          sender.setImage(UIImage(named: "wishlist-filledImage"), for: .normal)
         
          sender.animateRippleEffect(animationCount: 1)
          }
      }else{
          let product = self.products.items[indexPath.row]
          guard let productModel = product.model?.node.viewModel else {
              return
          }
          let wishProduct = CartProduct.init(product: productModel, variant: WishlistManager.shared.getVariant(product.variants.items.first!))
          if WishlistManager.shared.isProductVariantinWishlist(product: wishProduct){
              WishlistManager.shared.removeFromWishList(wishProduct)
//              let msg =  "Item removed from wishlist.".localized
//              self.view.showmsg(msg: msg)
              sender.setImage(UIImage(named: "wishlist-image"), for: .normal)
          }
          else {
//              let msg =  "Item added to wishlist.".localized
//              self.view.showmsg(msg: msg)
              WishlistManager.shared.addToWishList(wishProduct)
              sender.setImage(UIImage(named: "wishlist-filledImage"), for: .normal)
              sender.animateRippleEffect(animationCount: 1)
          }

      }
    self.setupTabbarCount()
   // self.productsCollectionView.reloadItems(at: [indexPath])
  }
}

extension ProductListVC:DZNEmptyDataSetSource{
//  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
//    return NSAttributedString(string: EmptyData.listEmptyTitle)
//  }
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        let custom = EmptyView()
        custom.delegate = self;
        custom.configure(imageName: "emptySearch", title: EmptyData.listingTitle, subtitle: EmptyData.listingDescription)
        return custom;
    }
    
}

extension ProductListVC:DZNEmptyDataSetDelegate{
  func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
    return products?.items.count == 0
  }
}

extension ProductListVC {
    
    // ----------------------------------
    //  MARK: - TARGET FUNCTIONS
    //
    
    @objc func changeToGrid(_ sender : UIButton) {
        isGridView = true;
        
        bottomTabView.gridButton.setImage(UIImage(named: "grid-fill"), for: .normal)
        bottomTabView.listButton.setImage(UIImage(named: "stroke-empty"),for: .normal)
        //        bottomTabView.gridButton.tintColor = UIColor.textColor()
        //        bottomTabView.listButton.tintColor = UIColor.textColor()
        self.productsCollectionView.reloadData()
    }
    
    @objc func changeToList(_ sender : UIButton) {
        isGridView = false;
        
        bottomTabView.gridButton.setImage(UIImage(named: "grid-empty"), for: .normal)
        bottomTabView.listButton.setImage(UIImage(named: "stroke-fill"),for: .normal)
        
        //        bottomTabView.gridButton.tintColor = UIColor.textColor()
        //        bottomTabView.listButton.tintColor = UIColor.textColor()
        self.productsCollectionView.reloadData()
    }
    
    @objc func navigateToFilter(_ sender: UIButton){
        if customAppSettings.sharedInstance.boostCommerceFilterEnabled {
            let vc = BoostCommerceFilterVC()
            vc.delegate = self
            vc.selectedFilterModel = selectedFilterData
            vc.selectedprice = selectedPrice
            vc.selectedFilterArrayAPI = selectedBCFilterArrayAPI
            if collect?.id ?? "" != "" {
                vc.collectionId = collect?.id ?? ""
            }
            else {
                let collectionId = collection.id.components(separatedBy: "/").last ?? ""
                vc.collectionId = collectionId//collection.id
            }
            self.navigationController?.pushViewController(vc, animated: true)
           
        }
        else {
            let vc = ProductFilterViewController()
            do {
                // vc.handleString = try! handle.value()
                let handleValue = try! handle.value()
                print("COLLECTION HANDLE-->\(handleValue)")
                if handleValue != "" {
                    vc.handleString = try! handle.value()
                }
                else {
                    if let handle = self.products.items.first?.collections.items.first?.handle {
                        vc.handleString = handle
                    }
                    
                }
            }
            
            //vc.handleString = handle.value()
            vc.delegate = self
            vc.selectedFilterArray = selectedFilter
            vc.priceSelected = priceSelected
           // vc.selectedprice = selectedPrice
            vc.selectFilterCount = selectedFilterCount
            //vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
           
        }
        
        
        
    }
    
    
    
    @objc func shareProduct(_ sender : UIButton) {
        let product = self.products.items[sender.tag]
        if let productModel = product.model?.node.viewModel {
            let url = URL(string: "\(productModel.onlineStoreUrl?.absoluteString ?? "")?pid=\(productModel.id)")!
            let vc = UIActivityViewController(activityItems: [url as Any], applicationActivities: nil);
            if(UIDevice().model.lowercased() == "ipad".lowercased()){
                vc.popoverPresentationController?.sourceView = sender
            }
            self.present(vc, animated: true, completion: nil);
        }
    }
    
    
    @objc func addToCartPressed(_ sender : UIButton) {
        if (customAppSettings.sharedInstance.boostCommerceFilterEnabled && self.isFilter){
            if(self.filterProducts[sender.tag].variants.items.count==1  /*&& self.filterProducts[sender.tag].variants.items.first?.selectedOptions.count ?? 0 == 1*/){
                var selectedVariant: VariantViewModel!
                selectedVariant = self.filterProducts[sender.tag].variants.items.first
                if selectedVariant != nil {
                    if !selectedVariant.currentlyNotInStock {
                        if (Int(selectedVariant.availableQuantity) == 0 &&  !selectedVariant.availableForSale) {
                            self.view.makeToast("Product is Currently out of stock.".localized, duration: 1.5, position: .center)
                            return;
                        }
                    }
                }
                
                let selectedQty = "1"
                guard let userSelectedQty = Int(selectedQty), var availableQuantity = Int(selectedVariant.availableQuantity) else {
                    print("Some value is nil")
                    return
                }
                if(selectedVariant.availableForSale && userSelectedQty > availableQuantity){
                    availableQuantity = 1
                }
                /*if (selectedVariant.availableForSale && userSelectedQty > availableQuantity) {
                 self.view.makeToast("Can not add more than available quantity".localized, duration: 1.5, position: .center)
                 return;
                 }*/
                //
                var addProduct=true
                if DBManager.shared.cartProducts?.count ?? 0 > 0 {
                    for CartDetail in DBManager.shared.cartProducts! {
                        let variantId = CartDetail.variant.id
                        if selectedVariant.id == variantId {
                            if !selectedVariant.currentlyNotInStock {
                                if (Int(selectedVariant.availableQuantity) ?? 0) > 0 {
                                    if CartDetail.qty > (Int(selectedVariant.availableQuantity) ?? 0) {
                                        self.view.makeToast("You have already added the maximum available quantities for this Variant".localized, duration: 2.5, position: .center)
                                        addProduct=false
                                        break;
                                    }
                                    else if CartDetail.qty + (Int(selectedQty) ?? 0) > (Int(selectedVariant.availableQuantity) ?? 0) {
                                        self.view.makeToast("You have already added the maximum available quantities for this Variant".localized, duration: 2.5, position: .center)
                                        addProduct=false
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
                let intQty = (selectedQty as NSString).integerValue
                if addProduct {
                    let item = CartProduct(product: self.filterProducts[sender.tag], variant: WishlistManager.shared.getVariant((self.filterProducts[sender.tag].variants.items.first)!), quantity: intQty)
                    CartManager.shared.addToCart(item)
                    self.view.showmsg(msg: (self.filterProducts[sender.tag].title) + " Added to cart".localized)
                    let product=self.filterProducts[sender.tag]
                    Analytics.logEvent(AnalyticsEventAddToCart, parameters: [AnalyticsParameterItemID: "id-\(product.id)",
                                                                           AnalyticsParameterItemName: product.title,
                                                                              AnalyticsParameterPrice: product.price])
                    let params : [AppEvents.ParameterName:Any] = [AppEvents.ParameterName.content : CartManager.shared.cartSubtotal,AppEvents.ParameterName.contentID : Client.shared.getCurrencyCode() ?? "",AppEvents.ParameterName.contentType:CartManager.shared.cartSubtotal]
                    AppEvents.shared.logEvent(.addedToCart, valueToSum: Double(product.price) ?? 0.0, parameters:params )
                    self.setupTabbarCount()
                }
            }
            else{
                let productvc = QuickAddToCartVC()
                productvc.delegate = self;
                productvc.parentView = self
                let product = self.filterProducts[sender.tag]
                productvc.id = product.id
                let count = product.model?.options.count ?? 0
                if count > 2 {
                    productvc.height += CGFloat(100 * (count-2))
                }
                self.present(productvc, animated: true, completion: nil)
            }
        }else{
            if(self.products.items[sender.tag].variants.items.count==1  /*&& self.products.items[sender.tag].variants.items.first?.selectedOptions.count ?? 0 == 1*/){
                var selectedVariant: VariantViewModel!
                selectedVariant = self.products.items[sender.tag].variants.items.first
                if selectedVariant != nil {
                    if !selectedVariant.currentlyNotInStock {
                        if (Int(selectedVariant.availableQuantity) == 0 &&  !selectedVariant.availableForSale) {
                            self.view.makeToast("Product is Currently out of stock.".localized, duration: 1.5, position: .center)
                            return;
                        }
                    }
                }
                
                let selectedQty = "1"
                guard let userSelectedQty = Int(selectedQty), var availableQuantity = Int(selectedVariant.availableQuantity) else {
                    print("Some value is nil")
                    return
                }
                if(selectedVariant.availableForSale && userSelectedQty > availableQuantity){
                    availableQuantity = 1
                }
                /*if (selectedVariant.availableForSale && userSelectedQty > availableQuantity) {
                 self.view.makeToast("Can not add more than available quantity".localized, duration: 1.5, position: .center)
                 return;
                 }*/
                //
                var addProduct=true
                if DBManager.shared.cartProducts?.count ?? 0 > 0 {
                    for CartDetail in DBManager.shared.cartProducts! {
                        let variantId = CartDetail.variant.id
                        if selectedVariant.id == variantId {
                            if !selectedVariant.currentlyNotInStock {
                                if (Int(selectedVariant.availableQuantity) ?? 0) > 0 {
                                    if CartDetail.qty > (Int(selectedVariant.availableQuantity) ?? 0) {
                                        self.view.makeToast("You have already added the maximum available quantities for this Variant".localized, duration: 2.5, position: .center)
                                        addProduct=false
                                        break;
                                    }
                                    else if CartDetail.qty + (Int(selectedQty) ?? 0) > (Int(selectedVariant.availableQuantity) ?? 0) {
                                        self.view.makeToast("You have already added the maximum available quantities for this Variant".localized, duration: 2.5, position: .center)
                                        addProduct=false
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
                let intQty = (selectedQty as NSString).integerValue
                if addProduct {
                    let item = CartProduct(product: self.products.items[sender.tag].model?.node.viewModel, variant: WishlistManager.shared.getVariant(selectedVariant), quantity: intQty)
                    CartManager.shared.addToCart(item)
                    self.view.showmsg(msg: (self.products.items[sender.tag].model?.node.viewModel.title ?? "") + " Added to cart".localized)
                    let product=self.products.items[sender.tag].model?.node.viewModel
                    Analytics.logEvent(AnalyticsEventAddToCart, parameters: [AnalyticsParameterItemID: "id-\(product?.id ?? "")",
                                                                           AnalyticsParameterItemName: product?.title ?? "",
                                                                              AnalyticsParameterPrice: product?.price ?? ""])
                    let params : [AppEvents.ParameterName:Any] = [AppEvents.ParameterName.content : CartManager.shared.cartSubtotal,AppEvents.ParameterName.contentID : Client.shared.getCurrencyCode() ?? "",AppEvents.ParameterName.contentType:CartManager.shared.cartSubtotal]
                    AppEvents.shared.logEvent(.addedToCart, valueToSum: Double(product!.price) ?? 0.0, parameters:params )
                    self.setupTabbarCount()
                }
            }
            else{
                let productvc = QuickAddToCartVC()
                productvc.delegate = self;
                productvc.parentView = self
                let product = self.products.items[sender.tag]
                productvc.id = product.id
                let count = product.model?.node.options.count ?? 0
                if count > 2 {
                    productvc.height += CGFloat(100 * (count-2))
                }
                self.present(productvc, animated: true, completion: nil)
            }
        }
        //        if self.products.items[sender.tag].sellingPlansGroups.items.count > 0 {
        //            let product         = self.products.items[sender.tag]
        //            let productViewController=ProductVC()//:ProductViewController = self.storyboard!.instantiateViewController()
        //            productViewController.product = product.model?.node.viewModel
        //            self.navigationController?.pushViewController(productViewController, animated: true)
        //        }
        //        else{
        //
        //
        //
        //        }
        //        else {
        //            if(self.products.items[sender.tag].variants.items.first?.title == "Default Title"){
        //              if self.products.items[sender.tag].variants.items.first?.currentlyNotInStock ?? false{
        //                let variantt = WishlistManager.shared.getVariant((self.products.items[sender.tag].variants.items.first)!)
        //                let product = self.products.items[sender.tag]
        //                  let item = CartProduct(product: (product.model?.node.viewModel)!, variant: variantt, quantity: 1)
        //                  CartManager.shared.addToCart(item)
        //                  self.quickAddClicked(productId: self.products.items[sender.tag].id , title: self.products.items[sender.tag].title ,error: false)
        //
        //              }
        //              else {
        //                if(!(self.products.items[sender.tag].variants.items.first?.availableForSale ?? false)){
        //                  self.quickAddClicked(productId: self.products.items[sender.tag].id , title: self.products.items[sender.tag].title ,error: true)
        //                }
        //                else
        //                {
        //                  let variantt = WishlistManager.shared.getVariant((self.products.items[sender.tag].variants.items.first)!)
        //                  let product = self.products.items[sender.tag]
        //                  let item = CartProduct(product: (product.model?.node.viewModel)!, variant: variantt, quantity: 1)
        //                  CartManager.shared.addToCart(item)
        //                  self.quickAddClicked(productId: self.products.items[sender.tag].id , title: self.products.items[sender.tag].title ,error: false)
        //                }
        //              }
        //            }
        //            else
        //            {
        //              self.quickAddClicked(productId: self.products.items[sender.tag].id ,title: "",error: false)
        //            }
        //        }
        self.updateCartCount()
    }
    
    
    
    func quickAddClicked(productId: String,title: String,error: Bool) {
        if(title == ""){
            let vc = AddToCartVC()
            vc.id = productId
            self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: vc)
            vc.modalPresentationStyle = .custom
            vc.delegate = self;
            vc.isFromWishlist=false
            vc.transitioningDelegate = self.halfModalTransitioningDelegate
            self.present(vc, animated: true, completion: nil)
        }
        else{
            if(error){
                self.view.makeToast(title+" not available.".localized, duration: 2.0, position: .center)
            }
            else{
                self.view.makeToast(title+" added to cart.".localized, duration: 2.0, position: .center)
                self.setupTabbarCount()
            }
        }
        self.updateCartCount()
    }
    
    @objc func searchButtonClicked(_ sender : UIButton) {
        if customAppSettings.sharedInstance.algoliaIntegration {
            let vc = AlgoliaSearchViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let vc = NewSearchVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    @objc func bagButtonClicked(_ sender : UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let data = DBManager.shared.cartProducts?.filter{$0.sellingPlanId != ""}
        if data?.count ?? 0 > 0 {
            let vc : NewCartViewController = storyboard.instantiateViewController()
            self.navigationController?.pushViewController(vc, animated: true)
          
        }
        else {
            let viewController:CartViewController = storyboard.instantiateViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
            
        }
    }
    
    
    @objc func sortProducts(_ sender : UIButton) {
        let sortKeys = ["Featured".localized,"Best Selling".localized,"A to Z".localized,"Z to A".localized,"Price: Low to High".localized,"Price: High to Low".localized,"History: New to Old".localized,"History: Old to New".localized]
        
        let sortVC = BottomSortVC()
        let index  = sortKeys.firstIndex(of: currentSortKey)
        sortVC.selectedSortValue = index
        sortVC.sortDelegate = self
        sortVC.sortKeys = sortKeys
        self.present(sortVC, animated: true, completion: nil)
        return
        
//        let alertController=UIAlertController(title: "", message: "Select Option.".localized, preferredStyle: .alert)
//
//        for item in sortKeys{
//            if (self.currentSortKey == item){
//                alertController.addAction(UIAlertAction(title: item, style: .destructive, handler: nil))
//            }else{
//                let action = UIAlertAction(title: item, style: .default, handler: {  Void in
//                    switch item{
//                    case "Featured".localized:
//                        if(self.isFromSearch){
//                            self.searchSortKey = MobileBuySDK.Storefront.ProductSortKeys.relevance
//                        }else{
//                            self.productSortKey = MobileBuySDK.Storefront.ProductCollectionSortKeys.manual
//                        }
//                        self.productreverseKey = false;
//                    case "Best Selling".localized:
//                        if(self.isFromSearch){
//                            self.searchSortKey = MobileBuySDK.Storefront.ProductSortKeys.bestSelling
//                        }else{
//                            self.productSortKey = MobileBuySDK.Storefront.ProductCollectionSortKeys.bestSelling
//                        }
//                        self.productreverseKey = false;
//
//                    case "Price: High to Low".localized:
//                        if(self.isFromSearch){
//                            self.searchSortKey = MobileBuySDK.Storefront.ProductSortKeys.price
//                        }else{
//                            self.productSortKey = MobileBuySDK.Storefront.ProductCollectionSortKeys.price
//                        }
//                        self.productreverseKey = true;
//                    case "Price: Low to High".localized:
//                        if(self.isFromSearch){
//                            self.searchSortKey = MobileBuySDK.Storefront.ProductSortKeys.price
//                        }else{
//                            self.productSortKey = MobileBuySDK.Storefront.ProductCollectionSortKeys.price
//                        }
//                        self.productreverseKey = false;
//                    case "A to Z".localized:
//                        if(self.isFromSearch){
//                            self.searchSortKey = MobileBuySDK.Storefront.ProductSortKeys.title
//                        }else{
//                            self.productSortKey = MobileBuySDK.Storefront.ProductCollectionSortKeys.title
//                        }
//                        self.productreverseKey = false;
//                    case "Z to A".localized:
//                        if(self.isFromSearch){
//                            self.searchSortKey = MobileBuySDK.Storefront.ProductSortKeys.title
//                        }else{
//                            self.productSortKey = MobileBuySDK.Storefront.ProductCollectionSortKeys.title
//                        }
//                        self.productreverseKey = true;
//                    case "History: New to Old".localized:
//                        if(self.isFromSearch){
//                            self.searchSortKey = MobileBuySDK.Storefront.ProductSortKeys.createdAt
//                        }else{
//                            self.productSortKey = MobileBuySDK.Storefront.ProductCollectionSortKeys.created
//                        }
//                        self.productreverseKey = true;
//                    case "History: Old to New".localized:
//                        if(self.isFromSearch){
//                            self.searchSortKey = MobileBuySDK.Storefront.ProductSortKeys.createdAt
//                        }else{
//                            self.productSortKey = MobileBuySDK.Storefront.ProductCollectionSortKeys.created
//                        }
//                        self.productreverseKey = false;
//                    default:
//                        print("")
//                    }
//
//                    if (self.isFromSearch){
//                        if(self.isFilter){
//                            self.loadFilteredProduct(searchsortKey: self.searchSortKey,reverse:self.productreverseKey)
//                        }
//                        else{
//                            self.loadProducts(searchsortKey: self.searchSortKey,reverse:self.productreverseKey)
//                        }
//                        self.currentSortKey = item
//                    }else{
//                        if(self.isFilter){
//                            self.loadFilteredProduct(sortKey: self.productSortKey,reverse:self.productreverseKey)
//                        }
//                        else{
//                            self.loadProducts(sortKey: self.productSortKey,reverse:self.productreverseKey)
//                        }
//                        self.currentSortKey = item
//                    }
//                })
//
//              alertController.addAction(action)
//            }
//        }
//
//        let cancelAction = UIAlertAction(title:"Cancel".localized, style: .cancel, handler: nil)
//        alertController.addAction(cancelAction)
//        if UIDevice.current.model.lowercased() == "ipad".lowercased(){
//          alertController.popoverPresentationController?.sourceView = sender
//        }
//        self.present(alertController, animated: true, completion: nil)
      }
    
   
    
}


extension ProductListVC: SortingSelected{
    func sortingSelected(sortValue: String) {
        let item = sortValue
        var bcSortStr = ""
        switch item{
        case "Featured".localized:
            if (customAppSettings.sharedInstance.boostCommerceFilterEnabled && self.isFilter == true){
                bcSortStr = "relevance"
            }else{
               // if(self.isFromSearch){
                    self.searchSortKey = MobileBuySDK.Storefront.ProductSortKeys.relevance
              //  }else{
                    self.productSortKey = MobileBuySDK.Storefront.ProductCollectionSortKeys.manual
              //  }
                self.productreverseKey = false;
            }
        case "Best Selling".localized:
            if (customAppSettings.sharedInstance.boostCommerceFilterEnabled && self.isFilter == true){
                bcSortStr = "best-selling"
            }else{
               // if(self.isFromSearch){
                    self.searchSortKey = MobileBuySDK.Storefront.ProductSortKeys.bestSelling
              //  }else{
                    self.productSortKey = MobileBuySDK.Storefront.ProductCollectionSortKeys.bestSelling
              //  }
                self.productreverseKey = false;
            }
        case "Price: High to Low".localized:
            if (customAppSettings.sharedInstance.boostCommerceFilterEnabled && self.isFilter == true){
                bcSortStr = "price-descending"
            }else{
              //  if(self.isFromSearch){
                    self.searchSortKey = MobileBuySDK.Storefront.ProductSortKeys.price
              //  }else{
                    self.productSortKey = MobileBuySDK.Storefront.ProductCollectionSortKeys.price
            //    }
                self.productreverseKey = true;
            }
        case "Price: Low to High".localized:
            if (customAppSettings.sharedInstance.boostCommerceFilterEnabled && self.isFilter == true){
                bcSortStr = "price-ascending"
            }else{
            //    if(self.isFromSearch){
                    self.searchSortKey = MobileBuySDK.Storefront.ProductSortKeys.price
              //  }else{
                    self.productSortKey = MobileBuySDK.Storefront.ProductCollectionSortKeys.price
              //  }
                self.productreverseKey = false;
            }
        case "A to Z".localized:
            if (customAppSettings.sharedInstance.boostCommerceFilterEnabled && self.isFilter == true){
                bcSortStr = "title-ascending"
            }else{
              //  if(self.isFromSearch){
                    self.searchSortKey = MobileBuySDK.Storefront.ProductSortKeys.title
              //  }else{
                    self.productSortKey = MobileBuySDK.Storefront.ProductCollectionSortKeys.title
              //  }
                self.productreverseKey = false;
            }
        case "Z to A".localized:
            if (customAppSettings.sharedInstance.boostCommerceFilterEnabled && self.isFilter == true){
                bcSortStr = "title-descending"
            }else{
             //   if(self.isFromSearch){
                    self.searchSortKey = MobileBuySDK.Storefront.ProductSortKeys.title
            //    }else{
                    self.productSortKey = MobileBuySDK.Storefront.ProductCollectionSortKeys.title
              //  }
            }
            self.productreverseKey = true;
        case "History: New to Old".localized:
            if (customAppSettings.sharedInstance.boostCommerceFilterEnabled && self.isFilter == true){
                bcSortStr = "created-ascending"
            }else{
             //   if(self.isFromSearch){
                    self.searchSortKey = MobileBuySDK.Storefront.ProductSortKeys.createdAt
             //   }else{
                    self.productSortKey = MobileBuySDK.Storefront.ProductCollectionSortKeys.created
             //   }
                self.productreverseKey = true;
            }
        case "History: Old to New".localized:
            if (customAppSettings.sharedInstance.boostCommerceFilterEnabled && self.isFilter == true){
                bcSortStr = "created-descending"
            }else{
              //  if(self.isFromSearch){
                    self.searchSortKey = MobileBuySDK.Storefront.ProductSortKeys.createdAt
             //   }else{
                    self.productSortKey = MobileBuySDK.Storefront.ProductCollectionSortKeys.created
             //   }
                self.productreverseKey = false;
            }
        default:
            print("")
        }
        if (self.isFromSearch){
            if(self.isFilter){
                self.loadFilteredProduct(searchsortKey: self.searchSortKey,reverse:self.productreverseKey)
            }
            else{
                self.loadProducts(searchsortKey: self.searchSortKey,reverse:self.productreverseKey)
            }
            self.currentSortKey = item
        }else if self.fetchAllProduct {
            if self.isFilter {
                self.loadFilteredProduct(sortKey: self.productSortKey,reverse:self.productreverseKey)
            }
            else {
                self.loadProducts(searchsortKey: self.searchSortKey, reverse: self.productreverseKey)
            }
            self.currentSortKey = item
        }
        else{
            if(self.isFilter){
                if (customAppSettings.sharedInstance.boostCommerceFilterEnabled){
                    self.filterPage = 1
                    self.filterProducts.removeAll()
                    self.fetchFilterData(filterData: self.selectedBCFilterArrayAPI,sortData: bcSortStr)
                }else{
                    self.loadFilteredProduct(sortKey: self.productSortKey,reverse:self.productreverseKey)
                }
            }
            else{
                self.loadProducts(sortKey: self.productSortKey,reverse:self.productreverseKey)
            }
            self.currentSortKey = item
        }
    }
}

extension ProductListVC: UpdateBadge{
    func updateCart(){
        self.updateCartCount()
    }
}
extension ProductListVC: ReloadWishlistItem {
    func reloadWishlistItem(productID: String, indexPath: IndexPath) {
        DispatchQueue.main.async {[weak self] in
            self?.productsCollectionView.reloadItems(at: [indexPath])
        }
    }
    
    func deleteGrowaveWishlistItem(productId: String, wishProduct: CartProduct, indexPath: IndexPath) {
        let growaveWishlistViewModel = GrowaveWishlistViewModel()
        growaveWishlistViewModel.deleteGrowaveItem(product_id: productId) {[weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    WishlistManager.shared.removeFromWishList(wishProduct)
                    self?.productsCollectionView.reloadItems(at: [indexPath])
                    self?.setupTabbarCount()
                    let msg =  "Item removed from wishlist.".localized
                    self?.view.showmsg(msg: msg)
                }
            case .failed(let err):
                self?.showErrMessage(msg: err, index: indexPath)
            }
        }
    }
    
    
    private func showErrMessage(msg: String, index: IndexPath) {
        DispatchQueue.main.async {[weak self] in
            self?.view.showmsg(msg: msg)
        }
    }
}
