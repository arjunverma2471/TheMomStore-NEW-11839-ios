//
//  GrowaveBoardWishlistViewController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 25/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import UIKit

class GrowaveBoardWishlistViewController: UIViewController, UpdateBadge {
    var cartbutton : BadgeButton!
    var boardID: String = ""
    var growaveWishlistViewModel = GrowaveWishlistViewModel()
    var products: Array<ProductViewModel>?
    var imageSize = CGSize(width: 1, height: 1)
    fileprivate let itemsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        if #available(iOS 13.0, *) {
            collection.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .productListVC).collectionViewBackgroundColor)
        } else {
            collection.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .productListVC).collectionViewBackgroundColor)
            // Fallback on earlier versions
        }
        collection.showsVerticalScrollIndicator = false
        collection.register(GrowaveWishlistProductCell.self, forCellWithReuseIdentifier: GrowaveWishlistProductCell.className)
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        fetchGrowaveItems()
        view.showLoader()
        view.backgroundColor = .viewBackgroundColor()
        setupNavigationBar()
        itemsCollectionLayout()
        setupDelegates()
    }
    
    private func setupNavigationBar() {
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 13
        cartbutton = BadgeButton(frame: CGRect(x: 0, y: 0, width: 20, height: 15))
        cartbutton.setImage(UIImage(named: "bag"), for: .normal)
        
        cartbutton.imageView?.contentMode = .scaleAspectFit;
        cartbutton.addTarget(self, action: #selector(goToCartViewController(_:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItems?.remove(at: 0)
        self.navigationController?.navigationBar.tintColor = Client.navigationThemeData?.icon_color
        //self.navigationItem.rightBarButtonItems?.insert(space, at: 0)
        self.navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartbutton)
    }
    
    private func itemsCollectionLayout() {
        view.addSubview(itemsCollectionView)
        itemsCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.trailingAnchor, paddingTop: 10, paddingBottom: 20)
    }
    
    private func setupDelegates() {
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        itemsCollectionView.emptyDataSetSource = self
        itemsCollectionView.emptyDataSetDelegate = self
    }
    
}
extension GrowaveBoardWishlistViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return growaveWishlistViewModel.wishlistItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GrowaveWishlistProductCell.className, for: indexPath) as! GrowaveWishlistProductCell
        if let product = self.products?[indexPath.item] {
            cell.isGridView = true
            cell.setupView(model: product)
            cell.addToCartButton.tag = indexPath.item
            cell.addToBag = {[weak self] in
                self?.addToBag(cell.addToCartButton)
            }
            
            cell.removeProduct =  {[weak self] in
                let alert = UIAlertController(title: "", message: "Are you sure you want to remove this item from wishlist?".localized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Remove".localized, style: .destructive, handler: { action in
                    guard let productModel = product.model?.viewModel else {return}
                    let wishProduct = CartProduct.init(product: productModel, variant: WishlistManager.shared.getVariant(product.variants.items.first!))
                    guard let productID = product.id.components(separatedBy: "/").last else {return}
                    self?.deleteGrowaveWishlistItem(productId: productID, wishProduct: wishProduct, indexPath: indexPath)
                }))
                alert.addAction(UIAlertAction(title: "Cancel".localized, style: .default))
                self?.present(alert, animated: true)
                
            }
            
            cell.moveToDifferentBoard = {[weak self] in
                self?.moveToBoard(indexPath: indexPath)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = self.products?[indexPath.row]
        let productViewController = ProductVC()
        productViewController.product = product?.model?.viewModel
        self.navigationController?.pushViewController(productViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.model.lowercased() == "ipad".lowercased(){
            return collectionView.calculateCellSize(numberOfColumns: 4,of: 150.0)
        }
        return collectionView.calculateCellSize(numberOfColumns: 2,of: 120)
    }
}

extension GrowaveBoardWishlistViewController: DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "No Item in Wishlist".localized)
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return  growaveWishlistViewModel.wishlistItems.count == 0
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "")
    }
}



extension GrowaveBoardWishlistViewController {
    func fetchGrowaveItems() {
        growaveWishlistViewModel.fetchWishlistItems(boardId: boardID) {[weak self] result in
            switch result {
            case .success:
                self?.reloadCollection()
                self?.fetchMultipleProducts(ids: self?.growaveWishlistViewModel.wishlistItems ?? [GraphQL.ID]())
            case .failed(let err):
                print("The err is \(err)")
                self?.reloadCollection()
            }
        }
    }
    
    func fetchMultipleProducts(ids: [GraphQL.ID]) {
        Client.shared.fetchMultiProducts(ids: ids, completion: {[weak self] (response, error) in
            if let response = response {
                self?.products = response
                self?.reloadCollection()
            }
        })
    }
    
    func reloadCollection() {
        DispatchQueue.main.async {[weak self] in
            self?.view.hideLoader()
            self?.itemsCollectionView.reloadData()
        }
    }
}
extension GrowaveBoardWishlistViewController {
    func updateCart() {
        self.updateCartCount()
        self.reloadCollection()
    }
    
    func addToBag(_ sender : UIButton) {
        if self.products?[sender.tag].sellingPlansGroups.items.count ?? 0 > 0 {
            let product         = self.products?[sender.tag]
            let productViewController = ProductVC()
            productViewController.product = product?.model?.viewModel
            self.navigationController?.pushViewController(productViewController, animated: true)
            return
        }
        
        print("Clicked add")
        
        if(self.products?[sender.tag].variants.items.count == 1  && self.products?[sender.tag].variants.items.first?.selectedOptions.count ?? 0 == 1){
            
            var selectedVariant: VariantViewModel!
            selectedVariant = self.products?[sender.tag].variants.items.first
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
                let item = CartProduct(product: self.products?[sender.tag].model?.viewModel, variant: WishlistManager.shared.getVariant(selectedVariant), quantity: intQty)
                CartManager.shared.addToCart(item)
                self.view.showmsg(msg: (self.products?[sender.tag].model?.viewModel.title ?? "") + " Added to cart".localized)
                let product = self.products?[sender.tag].model?.viewModel
                Analytics.logEvent(AnalyticsEventAddToCart, parameters: [AnalyticsParameterItemID: "id-\(product?.id ?? "")",
                                                                       AnalyticsParameterItemName: product?.title ?? "",
                                                                          AnalyticsParameterPrice: product?.price ?? ""])
                let params : [AppEvents.ParameterName:Any] = [AppEvents.ParameterName.content : CartManager.shared.cartSubtotal,AppEvents.ParameterName.contentID : Client.shared.getCurrencyCode() ?? "",AppEvents.ParameterName.contentType:CartManager.shared.cartSubtotal]
                AppEvents.shared.logEvent(.addedToCart, valueToSum: Double(product!.price) ?? 0.0, parameters:params )
                self.fetchGrowaveItems()
                self.setupTabbarCount()
                self.reloadCollection()
            }
        }
        else{
            let productvc = QuickAddToCartVC()
            productvc.delegate = self;
            productvc.parentView = self
            let product = self.products?[sender.tag]
            productvc.id = product?.id ?? ""
            let count = product?.model?.options.count ?? 0
            if count > 2 {
                productvc.height += CGFloat(100 * (count-2))
            }
            self.present(productvc, animated: true, completion: nil)
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
//        if let product = self.products?[sender.tag], let productModel = product.model?.viewModel, let productID = product.id.components(separatedBy: "/").last {
//            let wishProduct = CartProduct.init(product: productModel, variant: WishlistManager.shared.getVariant(product.variants.items.first!))
//            deleteGrowaveWishlistItem(productId: productID, wishProduct: wishProduct, indexPath: IndexPath(row: sender.tag, section: 0))
//        }
    }
    
    
    func updateCartCount() {
        print("CART COUNT====>", CartManager.shared.cartCount.description)
        cartbutton.badge = CartManager.shared.cartCount == 0 ? nil : CartManager.shared.cartCount.description
    }
    
    @objc func goToCartViewController(_ sender : UIButton) {
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
    
    
    func deleteGrowaveWishlistItem(productId: String, wishProduct: CartProduct, indexPath: IndexPath) {
        growaveWishlistViewModel.deleteGrowaveItem(product_id: productId) {[weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    WishlistManager.shared.removeFromWishList(wishProduct)
                    self?.setupTabbarCount()
                    self?.fetchGrowaveItems()
                    let msg =  "Item removed from wishlist.".localized
                    self?.view.showmsg(msg: msg)
                }
            case .failed(let err):
                print("DEBUG: \(err)")
            }
        }
    }
}
extension GrowaveBoardWishlistViewController: ItemMoveToBoard {
    func itemMoveToBoard() {
        fetchGrowaveItems()
    }
    
    func moveToBoard(indexPath: IndexPath) {
        let vc = WishlistBoardsView()
        vc.product = self.products?[indexPath.item]
        vc.indexPath = indexPath
        vc.boardID = boardID
        vc.itemMoveToBoardDelegate = self
        vc.isFromChangeBoard = true
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
