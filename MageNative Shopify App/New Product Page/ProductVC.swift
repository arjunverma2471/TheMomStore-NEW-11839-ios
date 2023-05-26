//
//  ProductVC.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 12/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import SwiftUI
import RxSwift
import BottomPopup

protocol SelectedProductDelegate {
    func getSelectedProduct(value: ProductViewModel!)
}

class ProductVC : BaseViewController,SelectedProductDelegate {
    var selectedProduct: ProductViewModel!
    // ----------------------------------
    //  MARK: - Properties -
    //
    var productId:String?
    var isProductLoading = false
    var product : ProductViewModel!{
        didSet{
            sellingPlanCheckForTabView()
        }
    }
    var similarProducts: Array<ProductViewModel>?
    var descriptionHeight :CGFloat! = 0.0
    var descriptionLoading = false
    var showDescription = false
    var shopifyRecommendedProducts: Array<ProductViewModel>?
    var layoutHeight = [String: CGFloat]()
    // Shopify Review and Rating
    var productRatingBadgeData = [String:String]()
    var productReviews : productRatingData?
    //JudgeMe Rating Review
    var productJudgeMeId = String()
    var productExternalId = String()
    var judgeMeRatingCount=String()
    var aliReviews: Alireviews?
    var shopId = ""
    var productJudgeMeReviews : judgeMeRatingAndReview?
    var variantManager = VariantSelectionManager.shared
    var selectedVariantID : String!
    var sellingPlanId = ""
    var arLocalPath = ""
    var showSizeChart = false
    var isBackStockDataLoaded = false
    var disposeBag = DisposeBag()
    //Fast Simon Properties
    var fastSimonAPIHandler: FastSimonAPIHandler?
    var reviewsAPIHandler : ReviewsAPIHandler?
    var avgReviewIORating : Double?
    var reviewsIOreview : [ReviewIOModel]? {
        didSet {
            self.showReviewsIOReview()
        }
    }
    var colorsArray = [String]()
    var ratingData = [[String:Any]]()
    var goToBag = false
    var selectedVariant : VariantViewModel? = nil {
        didSet {
            self.reloadTabView()
        }
    }
    
    var stampedReviewDetailModel: StampedReviewDetailModel?
    var growaveViewModel = GrowaveReviewsViewModel()
    var stampedReviews = ProductGrowaveReview()
    let feraViewModel = FeraViewModel()
    var feraProductReview = [FeraProductReviewsData]()
    // ----------------------------------
    //  MARK: - Views -
    //
    
    fileprivate lazy var scrollView : UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    
    public lazy var mainStack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 5
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    // ----------------------------------
    //  MARK: - Custom Views -
    //
    
    var tabView = ProductPageTabView()
    var headerView = ProductHeaderView()
    var titleView = ProductTitleView()
    var descriptionView = ProductDescriptionView()
    var recommendedProductView = ProductRecommendedView()
    var shopifyReviews = ProductReviewsCombineView()
    var subscriptionView = SubscriptionProductView()
    var judgeMeReviws = ProductReviewsCombineView()
    var aliReview = ProductReviewsCombineView()
    var reviewsIOreviews = ProductReviewsCombineView()
    var qtyView = ProductCartQuantityView()
    var buyNowQtyView = ProductCartQuantityBuyNowView()
    var variantButton : UIButton!
    var backStockView = ProductBackInStockView()
    var bagButton : BadgeButton!
    var btn_selectVariant : UIButton!
    var fastSimonUpsellProductView = FSUpSellCrossSellProductView()
    var similarProductView = ProductRecommendedView()
    var fastSimonLookAlikeProductView = ProductRecommendedView()
    var productChatGPTview = ProductChatGPTView()
    
    
    var cartbutton : BadgeButton!
    
    func isVisible(view: UIView) -> Bool {
        func isVisible(view: UIView, inView: UIView?) -> Bool {
            guard let inView = inView else { return true }
            let viewFrame = inView.convert(view.bounds, from: view)
            if viewFrame.intersects(inView.bounds) {
                return isVisible(view: view, inView: inView.superview)
            }
            return false
        }
        return isVisible(view: view, inView: view.superview)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.getData()
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 13
        //self.navigationItem.rightBarButtonItems?.insert(space, at: 2)
        let sharebutton = UIButton()
        sharebutton.frame=CGRect(x: 0, y: 0, width: 15, height: 15)
        sharebutton.setImage(UIImage(named: "share"), for: .normal)
        sharebutton.imageView?.contentMode = .scaleAspectFit;
        sharebutton.addTarget(self, action: #selector(shareThisProduct), for: .touchUpInside)
        self.navigationItem.rightBarButtonItems?.insert(space, at: 0)
        cartbutton = BadgeButton(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        cartbutton.setImage(UIImage(named: "bag"), for: .normal)
        cartbutton.imageView?.contentMode = .scaleAspectFit;
        cartbutton.addTarget(self, action: #selector(redirectToCart), for: .touchUpInside)
        //self.navigationItem.rightBarButtonItems?.remove(at: 0)
        self.navigationItem.rightBarButtonItems?.insert(UIBarButtonItem(customView: cartbutton), at: 0)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        WebViewCookies().clearCookies()
        VariantSelectionManager.shared.delegate = self
        self.updateCartCount()
        customAppSettings.sharedInstance.hideTabbarOnProduct = true
        self.tabBarController?.tabBar.tabsVisiblty()
        self.goToBag = false
        self.updateCartText()
//        if self.selectedVariant != nil {
//            self.reloadTabView()
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        customAppSettings.sharedInstance.hideTabbarOnProduct = false
        self.tabBarController?.tabBar.tabsVisiblty()
    }
    
    func updateCartCount() {
        //bagButton.badge = CartManager.shared.cartCount == 0 ? nil : CartManager.shared.cartCount.description
        print("CART COUNT====>", CartManager.shared.cartCount.description)
        cartbutton.badge = CartManager.shared.cartCount == 0 ? nil : CartManager.shared.cartCount.description
    }
    
    fileprivate func sellingPlanCheckForTabView() {
        if product.requiresSellingPlan{
            tabView.anchor(left: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.trailingAnchor, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 0)
            tabView.isHidden = true
        }else{
            tabView.anchor(left: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.trailingAnchor, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 62)
            tabView.isHidden = false
        }
    }
    
    func initView() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor(light: .secondarySystemBackground,dark: UIColor.black)
        } else {
            // Fallback on earlier versions
            view.backgroundColor = .white
        }
        view.addSubview(scrollView)
        scrollView.addSubview(mainStack)
        view.addSubview(tabView)
        
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, bottom: tabView.topAnchor, right: view.trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        mainStack.anchor(top: scrollView.topAnchor, left: view.leadingAnchor, bottom: scrollView.bottomAnchor, right: view.trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        //        sellingPlanCheckForTabView()
        
        self.setupTabView()
    }
    
    func getData() {
        VariantSelectionManager.shared.clearUserSelectedVariants()
        if isProductLoading {
            self.getProductData()
        }
        else {
            self.validateForSelectedVariant()
            AnalyticsFirebaseData.shared.firebaseProductEvent(product: self.product)
            self.perform()
        }
    }
    
    func perform() {
        if customAppSettings.sharedInstance.aiProductRecomendaton {
            self.getSimilarProducts(similarProductId: self.product.id.components(separatedBy: "/").last! )
        }
        
        if customAppSettings.sharedInstance.shopifyRecommendedProducts {
            self.getShopifyRecommendedProducts()
        }
        
        
        if customAppSettings.sharedInstance.isFastSimonSearchEnabled{
            DBManager.shared.addToRecently(product: self.product, variant: self.product.variants.items.first!)
            self.fastSimonAPIHandler = FastSimonAPIHandler()
            self.getFastSimonUpSellCrossSellProducts()
            self.getLookAlikeProducts()
        }
        
        if customAppSettings.sharedInstance.inAppRatingReview {
            self.fetchProductRatingAndReview(productId: self.product.id)
        }
        if customAppSettings.sharedInstance.inAppRatingReviewJudgeMe {
            self.fetchJudgeMeProductDetails()
        }
        if customAppSettings.sharedInstance.aliReview {
            //                self.getAliReviewsStatus()
        }
        if customAppSettings.sharedInstance.kiwiSizeChart {
            let _ = self.fetchKiwiSizeData(checkForSizeChart: true)
        }
        if customAppSettings.sharedInstance.isFeraReviewsEnabled {
            self.fetchFeraRatings()
        }
        if customAppSettings.sharedInstance.isGrowaveReviewsIntegration {
            self.fetchGrowaveRatings()
        }
        
        if customAppSettings.sharedInstance.reviewsIO {
            self.reviewsAPIHandler = ReviewsAPIHandler()
            self.reviewsAPIHandler?.getProductAverageRating(model: self.product) { ratng in
                self.avgReviewIORating = ratng
                self.reviewsAPIHandler?.getAllReviewsForProduct(model: self.product) { reviews in
                    self.reviewsIOreview = reviews
                }
            }
        }
        
        if customAppSettings.sharedInstance.chatgpt &&  self.product.summary.htmlToString != ""{
            self.getDataThroughChatGPT()
        }
     
        self.renderProductPage()
        self.checkCustomSettings()
    }
    
    
    func setupTabView() {
        //tabView.cardView()
        tabView.buyNowButton.setTitleColor(UIColor(light: .darkGray, dark: .black), for: .normal)
        tabView.wishlistButton.addTarget(self, action: #selector(addProductToWishlist(_:)), for: .touchUpInside)
        tabView.buyNowButton.titleLabel?.font = mageFont.mediumFont(size: 16.0)
        tabView.cartButton.titleLabel?.font = mageFont.mediumFont(size: 16.0)
        tabView.cartButton.addTarget(self, action: #selector(addProductToBag(_:)), for: .touchUpInside)
        tabView.buyNowButton.addTarget(self, action: #selector(buyNowProduct), for: .touchUpInside)
        tabView.buyNowButton.layer.borderWidth = 1.0
        tabView.buyNowButton.layer.borderColor = UIColor(light: .darkGray.withAlphaComponent(0.5),dark: .black).cgColor
    }
    
    
    @objc func buyNowProduct(){
        print("-VE====>",self.selectedVariant?.availableQuantity.hasPrefix("-"))
        self.validateForSelectedVariant()
        if let selectedVariant = self.selectedVariant{
            if Int(selectedVariant.availableQuantity) ?? 0 <= 0  &&  !selectedVariant.availableForSale{
//                self.view.makeToast("Product is Currently out of stock.".localized, duration: 1.5, position: .center)
            }
            else {
                SweetAlert().showAlert("Confirmation!".localized, subTitle: "Want to apply discount code".localized, style: AlertStyle.warning, buttonTitle:"No".localized, buttonColor:UIColor(hexString: "#cd7b72") , otherButtonTitle:  "Yes".localized, otherButtonColor:UIColor(hexString: "#29b456")) { (isOtherButton) -> Void in
                    if isOtherButton == true {
                        print("Cancel Button  Pressed")
                        self.buyNowClicked()
                    }
                    else {
                        self.bagButtonClicked()
                    }
                }
                //          buyNowQtyView.tag = 456654
                //          self.view.addSubview(buyNowQtyView)
                //          buyNowQtyView.selectedVariant = selectedVariant
                //          buyNowQtyView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
                //          buyNowQtyView.closeButton.addTarget(self, action: #selector(closeViewBuyNow(_:)), for: .touchUpInside)
                //          buyNowQtyView.buyNow.addTarget(self, action: #selector(buyNowClicked(_:)), for: .touchUpInside)
            }
        }else{
            let productvc = QuickAddToCartVC()
            productvc.isFromProductPage = true
            productvc.popupDelegate = self
            productvc.parentVC = self
            productvc.delegate = self;
            productvc.id = self.product.id
            let count = product.model?.options.count ?? 0
            if count > 2 {
                productvc.height += CGFloat(100 * (count-2))
            }
            self.present(productvc, animated: true, completion: nil)
        }
    }
    
    func buyNowClicked() {
        
        self.validateForSelectedVariant()
        
        if let selectedVariant = self.selectedVariant{
            
            if !selectedVariant.currentlyNotInStock {
                if Int(selectedVariant.availableQuantity) ?? 0 <= 0 &&  !selectedVariant.availableForSale{
                    self.view.makeToast("Product is Currently out of stock.".localized, duration: 1.5, position: .center)
                    return;
                }
            }
            
            var selectedQty = ""
            if self.buyNowQtyView.customQuantity != "" {
                selectedQty = buyNowQtyView.customQuantity
            }
            else {
                //                selectedQty = self.buyNowQtyView.selectedQuantity
                selectedQty = "1"
            }
            let cartDetail = CartDetail()
            cartDetail.id  = self.product.id
            cartDetail.qty = Int(selectedQty) ?? 1
            cartDetail.variant = WishlistManager.shared.getVariant(selectedVariant)
            
            Client.shared.createCheckout(with: [cartDetail]) { checkout,error ,errorIfCheckoutIsNil  in
                if let checkout = checkout {
                    self.openWebCheckout(checkout)
                }
            }
        }else{
            self.view.makeToast("Select Variant First!")
        }
    }
    
    func updateCartText() {
        let selectedVariantText = String(VariantSelectionManager.shared.getCurrentVariant(product).dropLast(3))
        
        if let selectedVariant = selectedVariant {
            
            if VariantSelectionManager.shared.isVariantUnavailable.contains(selectedVariantText){
                tabView.cartButton.setTitle("Unavailable".localized, for: .normal)
                tabView.cartButton.setTitleColor(.red, for: .normal)
            tabView.cartButton.isUserInteractionEnabled=false
                tabView.buyNowButton.isUserInteractionEnabled=false
                tabView.cartButton.backgroundColor = UIColor(light: UIColor.lightGray.withAlphaComponent(0.5), dark: UIColor.lightGray.withAlphaComponent(0.5))
            tabView.buyNowButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
                
            }else if !selectedVariant.currentlyNotInStock {
            }else if !selectedVariant.currentlyNotInStock {
                if selectedVariant.availableQuantity != "" {
                    //|| self.selectedVariant.availableQuantity.hasPrefix("-")
                    if Int(selectedVariant.availableQuantity) ?? 0 <= 0  &&  !selectedVariant.availableForSale{
                        tabView.cartButton.setTitle("Out Of Stock".localized, for: .normal)
                        tabView.cartButton.isUserInteractionEnabled=false
                        tabView.cartButton.setTitleColor(.red, for: .normal)
                        tabView.cartButton.backgroundColor = UIColor(light: UIColor.lightGray.withAlphaComponent(0.5), dark: UIColor.lightGray.withAlphaComponent(0.5))
                        tabView.buyNowButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
                     
                        
                    }
                    else {
                        tabView.cartButton.setTitle("Add To Bag".localized, for: .normal)
                        tabView.cartButton.isUserInteractionEnabled=true
                        tabView.cartButton.backgroundColor = UIColor.AppTheme()
                        tabView.buyNowButton.backgroundColor = UIColor.white
                        tabView.buyNowButton.isUserInteractionEnabled=true
                        tabView.cartButton.setTitleColor(UIColor.textColor(), for: .normal)
                        tabView.buyNowButton.backgroundColor = UIColor.white
                    }
                }
                else {
                    tabView.cartButton.setTitle("Add To Bag".localized, for: .normal)
                    tabView.cartButton.isUserInteractionEnabled=true
                    tabView.buyNowButton.isUserInteractionEnabled=true
                    tabView.cartButton.backgroundColor = UIColor.AppTheme()
                    tabView.buyNowButton.backgroundColor = UIColor.white
                    tabView.cartButton.setTitleColor(UIColor.textColor(), for: .normal)
                    tabView.buyNowButton.backgroundColor = UIColor.white
                    //tabView.buyNowButton.makeBorder(width: 1.0, color: UIColor.AppTheme(), radius: 0)
                }
            }else{
                tabView.cartButton.setTitle("Add To Bag".localized, for: .normal)
                tabView.cartButton.isUserInteractionEnabled=true
                tabView.buyNowButton.isUserInteractionEnabled=true
                tabView.cartButton.backgroundColor =  UIColor.AppTheme()
                tabView.buyNowButton.backgroundColor = UIColor.white
                tabView.cartButton.setTitleColor(UIColor.textColor(), for: .normal)
            }
        }
    }
    
    func reloadTabView() {
        
        let selectedVariantText = String(VariantSelectionManager.shared.getCurrentVariant(product).dropLast(3))
        self.goToBag = false
        //        if selectedVariant == nil {
        //          self.selectedVariant = self.product.variants.items.first
        //        }
        if let selectedVariant = self.selectedVariant{
            
            if product.sellingPlansGroups.items.count > 0 {
                subscriptionView.selectedVariant=selectedVariant
                subscriptionView.selectedPlanIndex = -1
                subscriptionView.selectedIndex = 0
                subscriptionView.sellingGroupCollectionView.reloadData()
                subscriptionView.sellingPlanCollectionView.reloadData()
                self.sellingPlanId=""
            }
            
            //
            print("---------->",self.selectedVariant?.availableQuantity)
            
            
            //            titleView.availableQty.text = "\(selectedVariant.availableQuantity) " + "Available Quantity".localized
            
            
            //
            let product = CartProduct(product: self.product, variant: WishlistManager.shared.getVariant(selectedVariant))
            if WishlistManager.shared.isProductVariantinWishlist(product: product) {
                tabView.wishlistButton.setImage(UIImage(named: "heartFilled"), for: .normal)
                
            }
            else {
                tabView.wishlistButton.setImage(UIImage(named: "heartEmpty"), for: .normal)
            }
            
            if VariantSelectionManager.shared.isVariantUnavailable.contains(selectedVariantText){
                tabView.cartButton.setTitle("Unavailable".localized, for: .normal)
                tabView.cartButton.setTitleColor(.red, for: .normal)
            tabView.cartButton.isUserInteractionEnabled=false
                tabView.buyNowButton.isUserInteractionEnabled=false
                tabView.cartButton.backgroundColor = UIColor(light: UIColor.lightGray.withAlphaComponent(0.5), dark: UIColor.lightGray.withAlphaComponent(0.5))
            tabView.buyNowButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            }
            
            
            else if !selectedVariant.currentlyNotInStock {
                if selectedVariant.availableQuantity != "" {
                    //|| self.selectedVariant.availableQuantity.hasPrefix("-")
                    if selectedVariant.availableQuantity == "0"  &&  !selectedVariant.availableForSale{
                        tabView.cartButton.setTitle("Out Of Stock".localized, for: .normal)
                        tabView.cartButton.setTitleColor(.red, for: .normal)
                    tabView.cartButton.isUserInteractionEnabled=false
                        tabView.buyNowButton.isUserInteractionEnabled=false
                        tabView.cartButton.backgroundColor = UIColor(light: UIColor.lightGray.withAlphaComponent(0.5), dark: UIColor.lightGray.withAlphaComponent(0.5))
                    tabView.buyNowButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
                    
                }
                else {
                    tabView.cartButton.setTitle("Add To Bag".localized, for: .normal)
                    tabView.cartButton.isUserInteractionEnabled=true
                    tabView.buyNowButton.isUserInteractionEnabled=true
                    tabView.cartButton.backgroundColor = UIColor.AppTheme()
                    tabView.buyNowButton.backgroundColor = UIColor.white
                    tabView.cartButton.setTitleColor(.textColor(), for: .normal)
                }
            }
                else {
                    tabView.cartButton.setTitle("Add To Bag".localized, for: .normal)
                    tabView.cartButton.isUserInteractionEnabled=true
                    tabView.buyNowButton.isUserInteractionEnabled=true
                    tabView.cartButton.backgroundColor = UIColor.AppTheme()
                    tabView.buyNowButton.backgroundColor = UIColor.white
                    tabView.cartButton.setTitleColor(.textColor(), for: .normal)
                    //tabView.buyNowButton.makeBorder(width: 1.0, color: UIColor.AppTheme(), radius: 0)
                }
            }else{
                tabView.cartButton.setTitle("Add To Bag".localized, for: .normal)
                tabView.cartButton.isUserInteractionEnabled=true
                tabView.buyNowButton.isUserInteractionEnabled=true
                tabView.cartButton.backgroundColor =  UIColor.AppTheme()
                tabView.buyNowButton.backgroundColor = UIColor.white
                tabView.cartButton.setTitleColor(.textColor(), for: .normal)
            }
            
//            tabView.buyNowButton.makeBorder(width: 1.0, color: UIColor.lightGray, radius: 5)
            if customAppSettings.sharedInstance.outOfStocklabel {
                if !selectedVariant.currentlyNotInStock {
                    
                    if selectedVariant.availableQuantity != "" {
                        if selectedVariant.availableQuantity == "0" && !selectedVariant.availableForSale{
                            //                                          headerView.outOfStockLabel.isHidden = false
                            //                                          headerView.imageCollection.alpha = 0.4
                        }
                        else {
                            //                                          headerView.outOfStockLabel.isHidden = true
                            //                                          headerView.imageCollection.alpha = 1.0
                        }
                    }
                    else {
                        //                                      headerView.outOfStockLabel.isHidden = true
                        //                                      headerView.imageCollection.alpha = 1.0
                        
                    }
                }
                else {
                    //                           headerView.outOfStockLabel.isHidden = true
                    //                           headerView.imageCollection.alpha = 1.0
                }
            }
            else {
                headerView.outOfStockLabel.isHidden = true
                headerView.imageCollection.alpha = 1.0
            }
            if let media = headerView.productMedia, let selectedImage = selectedVariant.image{
                let url = media.map{$0.imageUrl}
                if(!url.contains(selectedImage.description) && !headerView.imagesArray.contains(selectedImage.description)){
                    headerView.imagesArray.append(selectedImage.description)
                    headerView.imageCollection.reloadData()
                    let indexPath = IndexPath(row: headerView.productMediaData.count+headerView.imagesArray.count-1, section: 0)
                    headerView.imageCollection.isPagingEnabled = false;
                    headerView.imageCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                    headerView.imageCollection.isPagingEnabled = true;
                    
                }
                else{
                    var indexPath = IndexPath(row: 0, section: 0)
                    if(headerView.imagesArray.contains(selectedImage.description)){
                        
                        if let index = headerView.imagesArray.firstIndex(of: selectedImage.description){
                            indexPath = IndexPath(row: headerView.productMediaData.count+index, section: 0)
                        }
                    }
                    else{
                        guard let index =  headerView.productMedia?.firstIndex(where: {
                            $0.imageUrl == selectedVariant.image?.description
                        }) else{return}
                        indexPath = IndexPath(row: index, section: 0)
                    }
                    headerView.imageCollection.reloadData()
                    headerView.imageCollection.isPagingEnabled = false;
                    headerView.imageCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                    headerView.imageCollection.isPagingEnabled = true;
                    
                }
            }
            
            titleView.productPrice.attributedText = self.calculatePrice()
            if variantButton != nil {
                var str = String()
                selectedVariant.selectedOptions.forEach { data in
                    str += "    \(data.name): \(data.value)\n"
                }
                variantButton.setTitle(str, for: .normal)
                variantButton.isHidden = false
                variantButton.heightAnchor.constraint(equalToConstant: CGFloat(selectedVariant.selectedOptions.count  * 30)).isActive = true
            }
            if customAppSettings.sharedInstance.backInStockIntegration {
                self.checkStockIntegration()
            }
            
        }else{
            if VariantSelectionManager.shared.isVariantUnavailable.contains(selectedVariantText){
                tabView.cartButton.setTitle("Unavailable".localized, for: .normal)
                tabView.cartButton.setTitleColor(.red, for: .normal)
            tabView.cartButton.isUserInteractionEnabled=false
                tabView.buyNowButton.isUserInteractionEnabled=false
                tabView.cartButton.backgroundColor = UIColor(light: UIColor.lightGray.withAlphaComponent(0.5), dark: UIColor.lightGray.withAlphaComponent(0.5))
            tabView.buyNowButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            }else{
                self.view.makeToast("Select Variant First!")
            }
            
        }
    }
    
    func calculatePrice() -> NSMutableAttributedString {
        let price = NSMutableAttributedString()
        var priceString = NSMutableAttributedString()
        
        if selectedVariant == nil {
            self.selectedVariant = self.product.variants.items.first
        }
        
        priceString =  NSMutableAttributedString(string: Currency.stringFrom(selectedVariant!.price))
        if let comparePrice = selectedVariant?.compareAtPrice {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string:Currency.stringFrom(comparePrice))
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            priceString.addAttribute(NSAttributedString.Key.foregroundColor,value: UIColor.AppTheme(), range: NSMakeRange(0, priceString.length))
            
            price.append(priceString)
            price.append(NSMutableAttributedString(string : "  "))
            price.append(attributeString)
            
            let minusPrice = ((selectedVariant?.compareAtPrice ?? 0.0) - (selectedVariant?.price ?? 0.0))
            let percentage = ((minusPrice/(selectedVariant?.compareAtPrice ?? 0.0))*100)
            let val = String(format: "%.0f", Double(truncating : percentage as? NSNumber ?? 0))
            let offerString: NSMutableAttributedString =  NSMutableAttributedString(string: "(\(val)% "+"OFF".localized+")")
            offerString.addAttribute(NSAttributedString.Key.foregroundColor,value: UIColor.systemGreen, range: NSMakeRange(0, offerString.length))
            price.append(NSMutableAttributedString(string : "  "))
            price.append(offerString)
        }
        else {
            priceString.addAttribute(NSAttributedString.Key.foregroundColor,value: UIColor.AppTheme(), range: NSMakeRange(0, priceString.length))
            price.append(priceString)
        }
        return price
    }
    
    @objc func addProductToWishlist(_ sender: UIButton) {
        
        if let selectedVariant = self.selectedVariant {
            if customAppSettings.sharedInstance.isGrowaveWishlist && Client.shared.isAppLogin() {
                let vc = WishlistBoardsView()
                vc.product = self.product
                if #available(iOS 15.0, *) {
                    if let sheet = vc.sheetPresentationController {
                        sheet.detents = [.medium()]
                        sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                        sheet.preferredCornerRadius = 0
                    }
                }
                self.present(vc, animated: true)
            }
            else {
                let product = CartProduct(product: self.product, variant: WishlistManager.shared.getVariant(selectedVariant))
                           if WishlistManager.shared.isProductVariantinWishlist(product: product) {
                               WishlistManager.shared.removeFromWishList(product)
                               //TOAST REMOVED DUE TO ANIMATION
                            //   let msg =  self.product.title + " removed from wishlist.".localized
                           //self.view.showmsg(msg: msg)
                               sender.setImage(UIImage(named: "heartEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
                               
                           }
                           else {
                               WishlistManager.shared.addToWishList(product)
                               //TOAST REMOVED DUE TO ANIMATION
                          /*     if product.variant.title == "Default Title" {
                                   let msg = "You have added ".localized + self.product.title + " to your wishlist.".localized
                                   self.view.showmsg(msg: msg)
                               }
                               else {
                                   let msg = "You have added ".localized + product.variant.title + " of product ".localized + self.product.title + " to your wishlist.".localized
                                   self.view.showmsg(msg: msg)
                               }  */
               //
                             sender.setImage(UIImage(named: "heartFilled"), for: .normal)
                               sender.animateRippleEffect(animationCount: 1)
                           }
                           self.setupTabbarCount()
            }
            
        }else{
            let productvc = QuickAddToCartVC()
            productvc.isFromProductPage = true
            productvc.popupDelegate = self
            productvc.parentVC = self
            productvc.delegate = self;
            productvc.parentView = self;
            productvc.id = self.product.id
            let count = product.model?.options.count ?? 0
            if count > 2 {
                productvc.height += CGFloat(100 * (count-2))
            }
            self.present(productvc, animated: true, completion: nil)
        }
    }
    
    func validateForSelectedVariant(){
        let edgeCount = self.product.model?.variants.edges.count ?? 0
        if self.selectedVariant == nil{
            if self.product.variants.items.first?.selectedOptions.first?.name == "Title" || self.product.variants.items.first?.selectedOptions.first?.value == "Default Title" || edgeCount <= 1{
                self.selectedVariant = self.product.variants.items.first
            }
        }
    }
    
    
    @objc func addProductToCart(_ sender : UIButton) {
        validateForSelectedVariant()
        if let selectedVariant = self.selectedVariant{
            qtyView.tag = 123321
            self.view.addSubview(qtyView)
            qtyView.selectedVariant = selectedVariant
            if selectedVariant.currentlyNotInStock {
                if Int(selectedVariant.availableQuantity) ?? 0 <= 0 && selectedVariant.availableForSale{
                    qtyView.outOfStockCheck = true
                }
            }
            else{
                qtyView.outOfStockCheck = false
            }
            qtyView.reloadData()
            qtyView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
            qtyView.closeButton.addTarget(self, action: #selector(closeView(_:)), for: .touchUpInside)
            qtyView.addToBag.addTarget(self, action: #selector(addProductToBag(_:)), for: .touchUpInside)
            //  qtyView.mainHeading.text = "Select Quantity - ( \(self.selectedVariant.availableQuantity) Available Quantity)"
        }else{
            self.view.makeToast("Select Variant First!")
        }
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
    
    @objc func redirectToCart() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let data = DBManager.shared.cartProducts?.filter{$0.sellingPlanId != ""}
        if data?.count ?? 0 > 0 {
            let vc : NewCartViewController = storyboard.instantiateViewController()
            self.navigationController?.pushViewController(vc, animated: true)
           
        }
        else {
            let viewController:CartViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @objc func bagButtonClicked() {
       
        let selectedQty = "1"
        //condition
        print("selected qty===>",selectedQty)
        guard let selectedVariant = selectedVariant else {return}
        print("available qty==>",selectedVariant.availableQuantity)
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
            let item = CartProduct(product: product, variant: WishlistManager.shared.getVariant(selectedVariant), quantity: intQty)
            CartManager.shared.addToCart(item)
            self.view.showmsg(msg: product.title + " Added to cart".localized)
            Analytics.logEvent(AnalyticsEventAddToCart, parameters: [AnalyticsParameterItemID: "id-\(product.id)",
                                                                   AnalyticsParameterItemName: product.title,
                                                                      AnalyticsParameterPrice: product.price])
            let params : [AppEvents.ParameterName:Any] = [AppEvents.ParameterName.content : CartManager.shared.cartSubtotal,AppEvents.ParameterName.contentID : Client.shared.getCurrencyCode() ?? "",AppEvents.ParameterName.contentType:CartManager.shared.cartSubtotal]
            AppEvents.shared.logEvent(.addedToCart, valueToSum: Double(self.product.price) ?? 0.0, parameters:params )
            self.setupTabbarCount()
            
            self.redirectToCart()
        }
        //        self.view.viewWithTag(123321)?.removeFromSuperview()
        self.updateCartCount()
    }
}


// ----------------------------------
//  MARK: - Delegation -
//

extension ProductVC : productHeaderDelegate {
    
    @objc func productImageClicked(position:Int,image: String = "") {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let productViewController:ProductImageViewController = storyboard.instantiateViewController()
        if(image != ""){
            productViewController.staticImage = image//[product.images.items[position]]
        }
        else{
            
            productViewController.images = product.images.items//[product.images.items[position]]
            productViewController.selectedImage = position
            
        }
        productViewController.modalPresentationStyle = .overFullScreen
        self.present(productViewController, animated: false, completion: nil)
        
    }
    @objc func productVideoClicked(url:URL) {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            player.play()
        }
        
    }
    
    @objc func closeView(_ sender : UIButton) {
        if let view = self.view.viewWithTag(123321) {
            view.removeFromSuperview()
        }
    }
    
    
    @objc func addProductToBag(_ sender : UIButton) {
        
        self.validateForSelectedVariant()
        
        if let selectedVariant  = self.selectedVariant{
            if goToBag {
                self.redirectToCart()
                return;
            }
            if self.selectedVariant != nil {
                if !selectedVariant.currentlyNotInStock {
                    if Int(selectedVariant.availableQuantity) ?? 0 <= 0  && !selectedVariant.availableForSale{
                        self.view.makeToast("Product is Currently out of stock.".localized, duration: 1.5, position: .center)
                        return;
                    }
                }
            }
            let selectedQty = "1"
          /*  if self.qtyView.customQuantity != "" {  //DISABLING QUANTITY SELECTOR
                selectedQty = qtyView.customQuantity
            }
            else {
                selectedQty = self.qtyView.selectedQuantity
            }  */
            //condition
            print("selected qty===>",selectedQty)
            print("available qty==>",selectedVariant.availableQuantity)
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
              let item = CartProduct(product: product, variant: WishlistManager.shared.getVariant(selectedVariant), quantity: intQty)
              CartManager.shared.addToCart(item)
           //   self.view.showmsg(msg: product.title + " Added to cart".localized)
              Analytics.logEvent(AnalyticsEventAddToCart, parameters: [AnalyticsParameterItemID: "id-\(product.id)",
                                 AnalyticsParameterItemName: product.title,
                                 AnalyticsParameterPrice: product.price])
                let params : [AppEvents.ParameterName:Any] = [AppEvents.ParameterName.content : CartManager.shared.cartSubtotal,AppEvents.ParameterName.contentID : Client.shared.getCurrencyCode() ?? "",AppEvents.ParameterName.contentType:CartManager.shared.cartSubtotal]
                        AppEvents.shared.logEvent(.addedToCart, valueToSum: Double(self.product.price) ?? 0.0, parameters:params )
              self.setupTabbarCount()
                self.goToBag = true
                sender.setNewTitlewithAnimation()
                
            }
         //   self.view.viewWithTag(123321)?.removeFromSuperview()
            self.updateCartCount()
        }else{
            let productvc = QuickAddToCartVC()
            productvc.isFromProductPage = true
            productvc.popupDelegate = self
            productvc.parentVC = self
            productvc.delegate = self;
            productvc.parentView = self;
            productvc.id = self.product.id
            let count = product.model?.options.count ?? 0
            if count > 2 {
                productvc.height += CGFloat(100 * (count-2))
            }
            self.present(productvc, animated: true, completion: nil)
        }
    }
    
    
    @objc func closeViewBuyNow(_ sender : UIButton) {
        if let view = self.view.viewWithTag(456654) {
            view.removeFromSuperview()
        }
    }
    
    @objc func buyNowClicked(_ sender : UIButton) {
        self.validateForSelectedVariant()
        if let selectedVariant = self.selectedVariant{
            
            if !selectedVariant.currentlyNotInStock {
                if Int(selectedVariant.availableQuantity) ?? 0 <= 0 &&  !selectedVariant.availableForSale{
                    self.view.makeToast("Product is Currently out of stock.".localized, duration: 1.5, position: .center)
                    return;
                }
            }
            
            var selectedQty = ""
            if self.buyNowQtyView.customQuantity != "" {
                selectedQty = buyNowQtyView.customQuantity
            }
            else {
                selectedQty = self.buyNowQtyView.selectedQuantity
            }
            let cartDetail = CartDetail()
            cartDetail.id  = self.product.id
            cartDetail.qty = Int(selectedQty) ?? 1
            cartDetail.variant = WishlistManager.shared.getVariant(selectedVariant)
            
            SweetAlert().showAlert("Confirmation!".localized, subTitle: "Want to apply discount code".localized, style: AlertStyle.warning, buttonTitle:"No".localized, buttonColor:UIColor(hexString: "#cd7b72") , otherButtonTitle:  "Yes".localized, otherButtonColor:UIColor(hexString: "#29b456")) { (isOtherButton) -> Void in
                if isOtherButton == true {
                    Client.shared.createCheckout(with: [cartDetail]) { checkout,error,errorIfCheckoutIsNil   in
                      if let checkout = checkout {
                        self.openWebCheckout(checkout)
                      }
                    }
                }
                else {
                    let vc = GetNavigation.shared.getCartController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
            
            
        }else{
            self.view.makeToast("Select Variant First!")
        }
    }
}

extension ProductVC : VariantSelectionMadeDelegate {
    func variantSelectionMadeDelegate() {
        let selectVariant = VariantSelectionManager.shared.getCurrentVariant(product).dropLast(3)
        print(selectVariant)
        let optionCount = self.product.model?.options.count ?? 0
        for node in self.product.variants.items{
            var variantName = ""
            for items in node.selectedOptions{
                variantName += items.value
                variantName += " / "
            }
            let title = variantName.dropLast(3)
            if selectVariant == title {
                self.selectedVariant = node
                print("Variant Quantity==",(self.selectedVariant?.availableQuantity))
                //              titleView.availableQty.text = "\(avlquantity ?? "") " + "Available Quantity".localized
                return;
            }
        }
        
        if VariantSelectionManager.shared.userSelectedVariants.keys.count == optionCount{
            VariantSelectionManager.shared.isVariantUnavailable.append(String(selectVariant))
            self.reloadTabView()
        }
    }
}

extension ProductVC : subscriptionDelegate {
    func subscriptionSelected(sellingPlan: ProductSellingPlanModel) {
        self.sellingPlanId = sellingPlan.id
        
        let percent = sellingPlan.adjustmentPercentage
        
        if percent != 0 {
            subscriptionView.offerLabel.text = "Available Discount".localized + " \(percent)%"
        }else if sellingPlan.adjustmentAmount != 0.0 {
            subscriptionView.offerLabel.text = "Available Discount".localized + " \(Currency.stringFrom(sellingPlan.adjustmentAmount))"
        }
        else {
            subscriptionView.offerLabel.text = ""
        }
    }
}

extension ProductVC:productClicked{
  func productCellClicked(product: ProductViewModel, sender: Any) {
    let productViewController=ProductVC()
    productViewController.product = product
    self.navigationController?.pushViewController(productViewController, animated: true)
  }
}


extension UIStackView {
    func insertArrangedSubview(_ view: UIView, belowArrangedSubview subview: UIView) {
        arrangedSubviews.enumerated().forEach {
            if $0.1 == subview {
                insertArrangedSubview(view, at: $0.0 + 1)
            }
        }
    }
    
    func insertArrangedSubview(_ view: UIView, aboveArrangedSubview subview: UIView) {
        arrangedSubviews.enumerated().forEach {
            if $0.1 == subview {
                insertArrangedSubview(view, at: $0.0)
            }
        }
    }
}

extension ProductVC{
    func openWebCheckout(_ checkout: CheckoutViewModel){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: WebViewController.className) as! WebViewController
        vc.checkoutId = checkout.id
        let subTotal    = Double(truncating: (CartManager.shared.cartSubtotal) as NSNumber)
        vc.cartSubTotal = subTotal
        if(!Client.shared.isAppLogin()){
            vc.isLoginRequired=true
            vc.url=checkout.webURL
            print(checkout.webURL)
            vc.ischeckout=true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let tokenArray = Client.shared.getToken() as! [String:Any]
            let tokenValue = tokenArray["token"] as! String
            
            Client.shared.checkoutCustomerAssociateV2(checkoutId: checkout.checkId, token: tokenValue) { [weak self](check, error) in
                vc.isLoginRequired=true
                vc.url=check?.webURL
                vc.ischeckout=true
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        Client.shared.fetchCompletedOrder(checkout.id, completion: {
            response  in
            
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["magenative_cart_notification_center"])
        })
    }
}

extension ProductVC: BottomPopupDelegate,UpdateBadge{
    func updateCart() {
        print("CART COUNT====>", CartManager.shared.cartCount.description)
        cartbutton.badge = CartManager.shared.cartCount == 0 ? nil : CartManager.shared.cartCount.description
    }
    
    func bottomPopupDidDismiss(){
        self.perform()
    }
}


extension ProductVC {
    func getDataThroughChatGPT() {
        let url = "https://api.openai.com/v1/completions"
        let productDescription = self.product.description?.replacingOccurrences(of: "\'", with: "") ?? ""
        let parameters : [String:Any] = [
            "model" : "text-davinci-003",
            "prompt" : productDescription,
            "temperature" : 0.7,
            "max_tokens" : 64,
            "top_p" : 1.0,
            "frequency_penalty" : 0.0,
            "presence_penalty" : 0.0
        ]
        
        let postData = self.convertAnyDicTostring(str: parameters)
        guard let urlRequest = url.getURL() else {return}
        var request = URLRequest(url: urlRequest)
        request.httpMethod="POST"
        request.httpBody = postData.data(using: String.Encoding.utf8)
        let token = "Bearer " + Client.chatGPTtoken
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task=URLSession.shared.dataTask(with: request, completionHandler: {data,response,error in
          DispatchQueue.main.sync
          {
            do {
              guard let data = data else {return;}
              guard let json = try? JSON(data:data) else {return;}
              print(json)
                print(json["choices"][0]["text"].stringValue)
                let dataToShow = json["choices"][0]["text"].stringValue
                if dataToShow != "" {
                    self.descriptionView.chatGptView.isHidden = false
                    self.descriptionView.dataToShow = dataToShow
                }
             //   mainStack.addArrangedSubview(productChatGPTview)
            }
          }
        })
        task.resume()
    }
}
