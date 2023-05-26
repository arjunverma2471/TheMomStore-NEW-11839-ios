//
//  SearchViewController.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 17/03/20.
//  Copyright © 2020 MageNative. All rights reserved.
//

import UIKit
import MLKit
import ChatSDK
import MessagingSDK

class SearchViewController: BaseViewController,ProductAddProtocol, wishListProductDelegate{
  
    func addToWishListProduct(_ cell: ProductGridCollectionCell, didAddToWishList sender: UIButton) {
        var wishProduct : CartProduct?
        guard let indexPath = self.productsCollectionView.indexPath(for: cell) else {return}
        if (customAppSettings.sharedInstance.isFastSimonSearchEnabled && fastSimonProduct?.count ?? 0 > 0) || (customAppSettings.sharedInstance.boostCommerceEnabled && fastSimonProduct?.count ?? 0 > 0) {
            if let product = fastSimonProduct?[indexPath.row] {
                wishProduct = CartProduct(product: product, variant:WishlistManager.shared.getVariant(product.variants.items.first!))
            }
        }
        if products != nil {
            let product = self.products.items[indexPath.row]
            guard let productModel = product.model?.node.viewModel else {
              return
            }
            wishProduct = CartProduct.init(product: productModel, variant: WishlistManager.shared.getVariant(product.variants.items.first!))
        }
        
          guard let wishProduct = wishProduct else {return}
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
        self.setupTabbarCount()
    }
    
  func productAdded() {
    self.setupTabbarCount()
  }
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var productsCollectionView: UICollectionView!
  
    fileprivate var collections: PageableArray<CollectionViewModel>!
  fileprivate var products: PageableArray<ProductListViewModel>!
  var recentSearchItems = [String]()
  var datasourceArray = [String]()
    
  var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
  
  //Fast Simon Properties
  var fastSimonAPIHandler: FastSimonAPIHandler?
  var fastSimonProducts  : [Item]?
    var productreverseKey:Bool? = nil
    var searchSortKey:MobileBuySDK.Storefront.ProductSortKeys? = nil
    var fastSimonProduct : Array<ProductViewModel>?
  //Boost Commerce Properties
  var boostCommerceAPIHandler: BoostCommerceAPIHandler?
  var boostCommerceProducts  : [Product]?
  var imageSize = CGSize(width: 1, height: 1)
    var searchText = ""
    lazy var sortButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.clipsToBounds = true;
        button.layer.cornerRadius = 25
        button.setImage(UIImage(named: "sort"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        if(UIColor.AppTheme() == .white){
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 0.5
        }
        else{
            button.backgroundColor = .AppTheme()
            button.tintColor = .textColor()
            
        }
        button.setTitle("", for: .normal)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.navigationItem.title = ""
        self.headerTitleSetup()
        productsCollectionView.delegate = self;
        productsCollectionView.dataSource = self;
        productsCollectionView.keyboardDismissMode = .onDrag
        productsCollectionView.register(ProductGridCollectionCell.self, forCellWithReuseIdentifier: ProductGridCollectionCell.className)
      //  searchBar.delegate = self;
        
        //self.navigationItem.rightBarButtonItems = []
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        // Do any additional setup after loading the view.
        checkFastSimonIntegration()
        checkForBoostCommerceIntegration()
        view.addSubview(sortButton)
        NSLayoutConstraint.activate([
            sortButton.heightAnchor.constraint(equalToConstant: 50),
            sortButton.widthAnchor.constraint(equalToConstant: 50),
            sortButton.bottomAnchor.constraint(equalTo: productsCollectionView.bottomAnchor, constant: -20),
            sortButton.trailingAnchor.constraint(equalTo: productsCollectionView.trailingAnchor, constant: -20)
        ])
        sortButton.addTarget(self, action: #selector(sortProducts(_:)), for: .touchUpInside)
        
        if searchText != ""{
            searchProduct()
        }
    }
    
    func headerTitleSetup(){
        let titleWidth = (searchText.localized as NSString).size(withAttributes: [NSAttributedString.Key.font: mageFont.mediumFont(size: 15)]).width
        let title           = UILabel(frame: CGRect(x: 0, y: 0, width: titleWidth, height: 30))
        title.font          = mageFont.mediumFont(size: 15)
        title.text          = searchText.localized
        title.textColor     = Client.navigationThemeData?.icon_color
        self.navigationItem.leftBarButtonItems?.append(UIBarButtonItem(customView: title))
        
    }
    
  
  func checkFastSimonIntegration(){
    if customAppSettings.sharedInstance.isFastSimonSearchEnabled{
      productsCollectionView.register(FastSimonCVCell.self, forCellWithReuseIdentifier: FastSimonCVCell.className)
      fastSimonAPIHandler = FastSimonAPIHandler()
        sortButton.isHidden = true
    }
  }
  
  
  func checkForBoostCommerceIntegration(){
    if customAppSettings.sharedInstance.boostCommerceEnabled{
      productsCollectionView.register(FastSimonCVCell.self, forCellWithReuseIdentifier: FastSimonCVCell.className)
      boostCommerceAPIHandler = BoostCommerceAPIHandler()
        sortButton.isHidden = true;
    }
  }
  
  
  func loadBoostCommerceProducts(searchText: String){
    if searchText == ""{
      self.boostCommerceProducts?.removeAll()
      self.productsCollectionView.reloadData()
    }else{
      guard let searchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
      self.view.addLoader()
      let params = ["q":searchText]
      boostCommerceAPIHandler?.getInstantSearchResults(params, completion: { [weak self] feed in
        self?.view.stopLoader()
        guard let feed = feed else {return}
          if feed.products?.count ?? 0 > 0 {
              var ids = [GraphQL.ID]()
              for item in feed.products! {
                  if let id = item.id {
                      let str = "gid://shopify/Product/\(id)"
                      let graphId = GraphQL.ID(rawValue: str)
                      ids.append(graphId)
                  }
                  
              }
              Client.shared.fetchMultiProducts(ids: ids) { response, error in
                  if let response = response {
                      self?.fastSimonProduct?.removeAll()
                      self?.fastSimonProduct = response
                      self?.productsCollectionView.reloadData()
                      
                  }
              }
          }
      })
    }
  }
  
  func loadFastSimonProducts(searchText: String){
    
    if searchText == "" {
      self.fastSimonProduct?.removeAll()
      self.productsCollectionView.reloadData()
    }else{
      guard let searchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
      self.view.addLoader()
      fastSimonAPIHandler?.getAutoCompleteProducts(searchText) { [weak self] feed in
        self?.view.stopLoader()
        guard let feed = feed else {return}
          if feed.items?.count ?? 0 > 0 {
              var ids = [GraphQL.ID]()
              for item in feed.items! {
                  if let id = item.id {
                      let str = "gid://shopify/Product/\(id)"
                      let graphId = GraphQL.ID(rawValue: str)
                      ids.append(graphId)
                  }
                  
              }
              Client.shared.fetchMultiProducts(ids: ids) { response, error in
                  if let response = response {
                      self?.fastSimonProduct?.removeAll()
                      self?.fastSimonProduct = response
                      self?.productsCollectionView.reloadData()
                      
                  }
              }
          }
      }
    }
  }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      // JS
        self.tabBarController?.tabBar.isHidden = true
     self.tabBarController?.tabBar.tabsVisiblty()
        
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        //loadCategories()
    }
  
  override func viewWillDisappear(_ animated: Bool){
    super.viewWillDisappear(animated)
      self.tabBarController?.tabBar.isHidden = false
      self.tabBarController?.tabBar.tabsVisiblty()
  }
  func loadCategories(){
    self.view.addLoader()
    Client.shared.fetchCollections(maxImageWidth: 300, maxImageHeight: 300, completion: {
      result,error  in
      self.view.stopLoader()
      if let results = result {
        self.collections = results
        self.productsCollectionView.reloadData()
      }else {
        //self.showErrorAlert(error: error?.localizedDescription)
      }
    })
  }
  
  @objc func barcodeScannerClicked(_ sender: UIButton){
    let viewController:ScanViewController = self.storyboard!.instantiateViewController()
    viewController.barcodeScannerCheck = true;
    viewController.delegate = self;
    self.navigationController?.pushViewController(viewController, animated: true)
  }
  
  
  @objc func addToCartPressed(_ sender:UIButton) {
      
      if (customAppSettings.sharedInstance.isFastSimonSearchEnabled && fastSimonProduct?.count ?? 0 > 0) || (customAppSettings.sharedInstance.boostCommerceEnabled && fastSimonProduct?.count ?? 0 > 0){
          self.addFastSimonProductToCart(sender: sender)
          return;
      }
      
      
      if self.products.items[sender.tag].sellingPlansGroups.items.count > 0 {
          let product         = self.products.items[sender.tag]
          let productViewController = ProductVC()
          productViewController.product = product.model?.node.viewModel
          self.navigationController?.pushViewController(productViewController, animated: true)
          return
      }
      
      if(self.products.items[sender.tag].variants.items.count>1){
          let productvc = QuickAddToCartVC()
          let product = self.products.items[sender.tag]
          productvc.id = product.id
          productvc.parentView = self
          let count = product.model?.node.options.count ?? 0
          if count > 2 {
              productvc.height += CGFloat(100 * (count-2))
          }
          self.present(productvc, animated: true, completion: nil)
      }
      else{
          var selectedVariant: VariantViewModel!
          if self.products.items[sender.tag].variants.items.first?.selectedOptions.first?.name == "Title" || self.products.items[sender.tag].variants.items.first?.selectedOptions.first?.value == "Default Title"{
              selectedVariant = self.products.items[sender.tag].variants.items.first
              //return;
          }
          if selectedVariant != nil {
            if !selectedVariant.currentlyNotInStock {
            if Int(selectedVariant.availableQuantity) == 0 {
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
  }
    
    @objc func sortProducts(_ sender : UIButton) {
        let alertController=UIAlertController(title: "", message: "Select Option.".localized, preferredStyle: .alert)
        let sortKeys = ["Popularity".localized,"Price: High to Low".localized,"Price: Low to High".localized,"Name: A to Z".localized,"Name: Z to A".localized]
        for item in sortKeys{
          let action = UIAlertAction(title: item, style: .default, handler: {  Void in
              if item == "Popularity".localized{
                self.searchSortKey = MobileBuySDK.Storefront.ProductSortKeys.bestSelling
                self.productreverseKey = false;
              }
              else if item == "Price: High to Low".localized{
                
                self.searchSortKey = MobileBuySDK.Storefront.ProductSortKeys.price
                self.productreverseKey = true;
              }
              else if item == "Price: Low to High".localized{
                self.searchSortKey = MobileBuySDK.Storefront.ProductSortKeys.price
                self.productreverseKey = false;
                
              }else if item == "Name: A to Z".localized{
                self.searchSortKey = MobileBuySDK.Storefront.ProductSortKeys.title
                self.productreverseKey = false;
                
              }else if item == "Name: Z to A".localized{
                self.searchSortKey = MobileBuySDK.Storefront.ProductSortKeys.title
                self.productreverseKey = true;
                
              }else{}
             // if(self.searchBar.text != ""){
                  self.loadProducts(searchText: self.searchText, sortKey: self.searchSortKey, reverse: self.productreverseKey)//self.searchBar.text!
             //}
              
            
          })
          alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title:"Cancel".localized, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        if UIDevice.current.model.lowercased() == "ipad".lowercased(){
          alertController.popoverPresentationController?.sourceView = sender
        }
        self.present(alertController, animated: true, completion: nil)
      }
}

extension SearchViewController:UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if (customAppSettings.sharedInstance.isFastSimonSearchEnabled && fastSimonProduct?.count ?? 0 > 0) || (customAppSettings.sharedInstance.boostCommerceEnabled && fastSimonProduct?.count ?? 0 > 0){
      return fastSimonProduct?.count ?? 0
    }
    
    if let products = products{
      if(products.items.count > 0){
        return products.items.count
      }
    }

    return collections?.items.count ?? 0
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if (customAppSettings.sharedInstance.isFastSimonSearchEnabled && fastSimonProduct?.count ?? 0 > 0) || (customAppSettings.sharedInstance.boostCommerceEnabled && fastSimonProduct?.count ?? 0 > 0){
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductGridCollectionCell.className, for: indexPath) as! ProductGridCollectionCell
        cell.isGridView = true
        if let product = fastSimonProduct?[indexPath.row] {
            cell.setupView(model: product)
        }
        
        cell.delegate = self
        cell.addToCartButton.tag = indexPath.item
        cell.addToCartButton.addTarget(self, action: #selector(addToCartPressed(_:)), for: .touchUpInside)
      return cell
    }
    
    if let products = products
    {
      if(products.items.count > 0){
     
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductGridCollectionCell.className, for: indexPath) as! ProductGridCollectionCell
          let product = self.products.items[indexPath.item]
          cell.isGridView = true
          cell.setupView(model: (product.model?.node.viewModel)!)
          cell.delegate = self
          cell.addToCartButton.tag = indexPath.item
          cell.addToCartButton.addTarget(self, action: #selector(addToCartPressed(_:)), for: .touchUpInside)
          return cell
      }
    }
      
    
    let cell       = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionCell.className, for: indexPath) as! CategoryCollectionCell
    let collection = self.collections.items[indexPath.row]
    cell.configureFrom(collection)
    return cell
  }
}

extension SearchViewController:wishListDelegate
{
  func addToWishListProduct(_ cell: ProductCollectionViewCell, didAddToWishList sender: Any) {
    guard let indexPath = self.productsCollectionView.indexPath(for: cell) else {return}
    let product = self.products.items[indexPath.row]
    guard let productModel = product.model?.node.viewModel else {
      return
    }
    let wishProduct = CartProduct.init(product: productModel, variant: WishlistManager.shared.getVariant(product.variants.items.first!))

      if WishlistManager.shared.isProductVariantinWishlist(product: wishProduct){
          WishlistManager.shared.removeFromWishList(wishProduct)
      }
      else {
          WishlistManager.shared.addToWishList(wishProduct)
      }
    self.setupTabbarCount()
    self.productsCollectionView.reloadItems(at: [indexPath])
  }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    if (customAppSettings.sharedInstance.isFastSimonSearchEnabled && fastSimonProduct?.count ?? 0 > 0) || (customAppSettings.sharedInstance.boostCommerceEnabled && boostCommerceProducts?.count ?? 0 > 0){
        if(fastSimonProduct?.count ?? 0 > 0){
            if UIDevice.current.model.lowercased() == "ipad".lowercased(){
                var collectionSize = collectionView.calculateCellSize(numberOfColumns: 4, imagesize: imageSize)
                if(customAppSettings.sharedInstance.inAppAddToCart){
                    collectionSize.height += 95
                }
                else{
                    collectionSize.height += 50
                }
                return collectionSize
            }
            var collectionSize = collectionView.calculateCellSize(numberOfColumns: 2, imagesize: imageSize)
            if(customAppSettings.sharedInstance.inAppAddToCart){
                collectionSize.height += 95
            }
            else{
                collectionSize.height += 50
            }
            return collectionSize
        }
    }
    
    
    if let products = products{
      if(products.items.count > 0){
          if UIDevice.current.model.lowercased() == "ipad".lowercased(){
              var collectionSize = collectionView.calculateCellSize(numberOfColumns: 4, imagesize: imageSize)
              if(customAppSettings.sharedInstance.inAppAddToCart){
                  collectionSize.height += 95
              }
              else{
                  collectionSize.height += 50
              }
              return collectionSize
          }
          var collectionSize = collectionView.calculateCellSize(numberOfColumns: 2, imagesize: imageSize)
          if(customAppSettings.sharedInstance.inAppAddToCart){
              collectionSize.height += 95
          }
          else{
              collectionSize.height += 50
          }
          return collectionSize
      }
    }
    //Collection Cell Size
      //return CGSize(width: UIScreen.main.bounds.width - 10, height: 3/7*self.view.frame.width)
      
      if UIDevice.current.model.lowercased() == "ipad".lowercased(){
          return CGSize(width: collectionView.frame.width/4 - 10, height: 220)
      }
      return CGSize(width: collectionView.frame.width/2 - 10, height: 220)
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension SearchViewController:UISearchBarDelegate,UISearchDisplayDelegate{
//  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//    NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchProduct), object: nil)
//    self.perform(#selector(searchProduct), with: nil, afterDelay: 1.65)
//  }

  
  func scrollCollections(){
    if let _ = collections {
      if self.collections.hasNextPage {
        self.fetchCollections(after: self.collections.items.last?.cursor)
      }
    }
  }
  
  func loadMoreData(){
    if let products = products{
      if(products.items.count > 0){
        if self.products.hasNextPage {
            //if let searchText = searchBar.text{
              self.loadProducts(searchText: searchText,cursor: self.products.items.last?.cursor, sortKey: searchSortKey, reverse: productreverseKey)
         // }
        }
      }
      else{
        self.scrollCollections()
      }
    }
    else{
      self.scrollCollections()
    }
  }

  
  // ----------------------------------
  //  MARK: - Fetching -
  //
  fileprivate func fetchCollections(after cursor: String? = nil) {
    let width  = productsCollectionView.bounds.width
    let height = Int32(width * 0.8)
    self.view.addLoader()
    DispatchQueue.global(qos: .background).async {
      Client.shared.fetchCollections(after: cursor, maxImageWidth: height, maxImageHeight: height) { collections,error  in
          DispatchQueue.main.async {
              self.view.stopLoader()
          }
      
        if let collections = collections {
          self.collections.appendPage(from: collections)
        }else {
          //self.showErrorAlert(error: error?.localizedDescription)
        }
        DispatchQueue.main.async {
          self.productsCollectionView.reloadData()
          if self.isViewLoaded && (self.view.window != nil) {
            self.loadMoreData()
          }
        }
      }
    }
  }
  
  func loadProducts(searchText:String, cursor: String? = nil,sortKey:MobileBuySDK.Storefront.ProductSortKeys? = nil,reverse:Bool?=nil){
//    searchBar.resignFirstResponder()
    if(searchText != ""){
//      if cursor == nil {
//        self.view.addLoader()
//      }
      DispatchQueue.global(qos: .background).async {
          Client.shared.searchProductsForQuery(for: searchText,after:cursor, with: sortKey, reverse: reverse, completion: {
        response,error   in
//        if cursor == nil {
//          self.view.stopLoader()
//        }
        if let response = response {
          print("--cursors--\(cursor ?? "")")
          if cursor != nil {
            print(response)
            if self.products != nil {
              self.products.appendPage(from: response)
            }
          }
          else {
            self.products = response
            self.products.items=[]
            for item in response.items {
              self.products.items.append(item)
            }
            if(self.products.items.count == 0){
                self.view.makeToast("No Products Found In Collection".localized, duration: 2.0, position: .center);
              return;
            }
          }
            self.getHeight()
          DispatchQueue.main.async {
            self.productsCollectionView.reloadData()
            // Making request for more data
            if self.isViewLoaded && (self.view.window != nil) {
              self.loadMoreData()
            }
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
      }
      self.productsCollectionView.reloadData()
    }
    
  }
  
    func searchProduct(){
    //if let searchText = searchBar.text{
        imageSize = CGSize(width: 1, height: 1)
      if customAppSettings.sharedInstance.isFastSimonSearchEnabled{
        loadFastSimonProducts(searchText:searchText)
      }else if customAppSettings.sharedInstance.boostCommerceEnabled {
        loadBoostCommerceProducts(searchText: searchText)
      }else{
        loadProducts(searchText:searchText)
      }
  //  }
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    self.navigationController?.navigationBar.isHidden = false
      self.navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    if let _ = searchBar.text {
      searchBar.resignFirstResponder()
    }
  }
}

extension SearchViewController: BarcodeProtocol{
  func searchBarcode(text: String) {
    if(text == ""){
        self.view.makeToast("No Products Found In Collection".localized, duration: 2.0, position: .center);
      return;
    }
    loadProducts(searchText:text)
  }
}

extension SearchViewController: UICollectionViewDelegate{
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if (customAppSettings.sharedInstance.isFastSimonSearchEnabled && fastSimonProduct?.count ?? 0 > 0) || (customAppSettings.sharedInstance.boostCommerceEnabled && fastSimonProduct?.count ?? 0 > 0){
        let productViewController=ProductVC()
        if let product = self.fastSimonProduct?[indexPath.row] {
            productViewController.product = product
        }
        self.navigationController?.pushViewController(productViewController, animated: true)
        
      
    }else if let products = products{
      if(products.items.count > 0){
        let product         = self.products.items[indexPath.row]
        let productViewController=ProductVC()//:ProductViewController = self.storyboard!.instantiateViewController()
        productViewController.product = product.model?.node.viewModel
        self.navigationController?.pushViewController(productViewController, animated: true)
      }
      else{
        navigateToProductListing(indexPath: indexPath)
      }
    }
    else{
      navigateToProductListing(indexPath: indexPath)
    }
  }
  
  
  func navigateToProductListing(indexPath: IndexPath){
      
      if let collections = self.collections{
          let collection = collections.items[indexPath.row]
        let productListingController=ProductListVC()//:ProductListViewController = self.storyboard!.instantiateViewController()
        productListingController.collection = collection
        productListingController.title = collection.title
        self.navigationController?.pushViewController(productListingController, animated: true)
      }
  }
    func moveToProductListing(title: String, collection: CollectionViewController){
       // let collection         = self.collections.items[indexPath.row]
        let productListingController=ProductListVC()//:ProductListViewController = self.storyboard!.instantiateViewController()
      //  productListingController.collection = collection
        productListingController.title = collection.title
        self.navigationController?.pushViewController(productListingController, animated: true)

    }
}

extension SearchViewController {
    func addFastSimonProductToCart(sender:UIButton) {
        if let product = fastSimonProduct?[sender.tag] {
            if product.sellingPlansGroups.items.count > 0 {
                let productViewController = ProductVC()
                productViewController.product = product
                self.navigationController?.pushViewController(productViewController, animated: true)
                return
            }
            
            if product.variants.items.count > 1 {
                let productvc = QuickAddToCartVC()
                productvc.id = product.id
                productvc.parentView = self
                let count = product.model?.options.count ?? 0
                if count > 2 {
                    productvc.height += CGFloat(100 * (count-2))
                }
                self.present(productvc, animated: true, completion: nil)
            }
            else {
                var selectedVariant: VariantViewModel?
                if product.variants.items.first?.selectedOptions.first?.name == "Title" || product.variants.items.first?.selectedOptions.first?.value == "Default Title"{
                    selectedVariant = product.variants.items.first
                }
                guard let selectedVariant = selectedVariant else{return}
                if !selectedVariant.currentlyNotInStock {
                if Int(selectedVariant.availableQuantity) == 0 {
                    self.view.makeToast("Product is Currently out of stock.".localized, duration: 1.5, position: .center)
                    return;
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
            }
        }
    
}

extension UISearchBar {

    // Due to searchTextField property who available iOS 13 only, extend this property for iOS 13 previous version compatibility
    var compatibleSearchTextField: UITextField {
        guard #available(iOS 13.0, *) else { return legacySearchField }
        return self.searchTextField
    }

    private var legacySearchField: UITextField {
        if let textField = self.subviews.first?.subviews.last as? UITextField {
            // Xcode 11 previous environment
            return textField
        } else if let textField = self.value(forKey: "searchField") as? UITextField {
            // Xcode 11 run in iOS 13 previous devices
            return textField
        } else {
            // exception condition or error handler in here
            return UITextField()
        }
    }
}
