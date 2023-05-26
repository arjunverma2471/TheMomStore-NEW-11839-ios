//
//  QuickAddToCartVC.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 07/09/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit
import BottomPopup
import RxSwift

class QuickAddToCartVC: BottomPopupViewController {

    var delegate: UpdateBadge?
    var height: CGFloat = 420
    // MARK: - BottomPopupAttributesDelegate Variables
    override var popupHeight: CGFloat { height}
    var productId:String?
    var product: ProductViewModel!
    var id = ""
    var parentView : UIViewController?
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false;
        scroll.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .quickAddToCart).backGroundColor)
        return scroll;
    }()
    
    public lazy var mainStack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .quickAddToCart).backGroundColor)
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.setTitle("    "+"Add To Bag".localized, for: .normal)
        button.setImage(UIImage(named: "bag")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.titleLabel?.font = mageFont.regularFont(size: 16)
        button.tintColor = .textColor()
        button.layer.cornerRadius = 5
        button.backgroundColor = .AppTheme()
        button.setTitleColor(UIColor.textColor(), for: .normal)
        return button;
    }()
    
    private lazy var buyNowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.setTitle("Buy Now".localized, for: .normal)
//        button.setImage(UIImage(named: "bag")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = UIColor.init(hexString: "#F55353")
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        button.titleLabel?.font = mageFont.regularFont(size: 16)
        button.tintColor = .lightGray
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.setTitleColor(UIColor.lightGray, for: .normal)
        return button;
    }()
    
    private lazy var wishlistButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.setImage(UIImage(named: "heartEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 5
        button.tintColor = UIColor.gray//init(hexString: "#F55353")
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor(light: UIColor.lightGray.withAlphaComponent(0.5),dark: .white).cgColor
        button.addTarget(self, action: #selector(addProductToWishlist(_:)), for: .touchUpInside)
        return button;
    }()
    
    public lazy var bottomStack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .quickAddToCart).backGroundColor)
        stack.spacing = 8
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        return stack
    }()
    
    var variantButton : UIButton!
    var btn_selectVariant : UIButton!
    var titleView = ProductImageTitlePriceView()
    var variantManager = VariantSelectionManager.shared
    
    // ProductPageHandlers
    var isFromProductPage = false
    var parentVC: ProductVC?
    
    var selectedVariant : VariantViewModel!{
        didSet {
            self.reloadTabView()
        }
    }
    var goToBag = false
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .quickAddToCart).backGroundColor)
        initView()
        // Do any additional setup after loading the view.
    }
    
    private func initView(){
        view.backgroundColor = UIColor(light: UIColor(hexString: "#FFFFFF"),dark: UIColor.provideColor(type: .quickAddToCart).backGroundColor)
        view.addSubview(scrollView)
        
        scrollView.addSubview(mainStack)
        
        view.addSubview(bottomStack)
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, bottom: bottomStack.topAnchor, right: view.trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        mainStack.anchor(top: scrollView.topAnchor, left: view.leadingAnchor, bottom: scrollView.bottomAnchor, right: view.trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        bottomStack.anchor(left: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.trailingAnchor, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, height: 47)
        
        if isFromProductPage{
            bottomStack.addArrangedSubview(wishlistButton)
            wishlistButton.widthAnchor.constraint(equalToConstant: 53).isActive = true
            bottomStack.addArrangedSubview(addButton)
            bottomStack.addArrangedSubview(buyNowButton)
            buyNowButton.addTarget(self, action: #selector(dismissFromBuyNow), for: .touchUpInside)
        }else{
            bottomStack.addArrangedSubview(addButton)
        }
        
        addButton.addTarget(self, action: #selector(addProductToBag), for: .touchUpInside)
        loadData()
    }
    
    
    @objc func dismissFromBuyNow(){
        self.dismiss(animated: true){
            self.parentVC?.buyNowProduct()
        }
    }
    

    @objc func addProductToWishlist(_ sender: UIButton) {
        
        if let selectedVariant = self.selectedVariant {
            
            let product = CartProduct(product: self.product, variant: WishlistManager.shared.getVariant(selectedVariant))
            if WishlistManager.shared.isProductVariantinWishlist(product: product) {
                WishlistManager.shared.removeFromWishList(product)
             /*   let msg =  self.product.title + " removed from wishlist.".localized
                self.view.showmsg(msg: msg)  */ //TOAST REMOVED DUE TO ANIMATION
                sender.setImage(UIImage(named: "heartEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
                
            }
            else {
                WishlistManager.shared.addToWishList(product)
              /*  if product.variant.title == "Default Title" {
                    let msg = "You have added ".localized + self.product.title + " to your wishlist.".localized
                    self.view.showmsg(msg: msg)
                }
                else {
                    let msg = "You have added ".localized + product.variant.title + " of product ".localized + self.product.title + " to your wishlist.".localized
                    self.view.showmsg(msg: msg)
                } */  //TOAST REMOVED DUE TO ANIMATION
              sender.setImage(UIImage(named: "heartFilled"), for: .normal)
              sender.animateRippleEffect(animationCount: 1)
            }
            self.setupTabbarCount()
        }else{
            self.view.makeToast("Select Variant First!")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        VariantSelectionManager.shared.clearUserSelectedVariants()
        VariantSelectionManager.shared.delegate = self
    }
    
    func loadViewData(){
        mainStack.addArrangedSubview(titleView)
        titleView.product = self.product
        titleView.setupView()
        titleView.heightAnchor.constraint(equalToConstant: 100).isActive = true;
        titleView.crossButton.rx.tap.bind{
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)
        let variant = product.variants.items.first
        if variant?.selectedOptions.first?.name != "Title" || variant?.selectedOptions.first?.value != "Default Title"{
            let count = self.product.model?.options.count ?? 0
            
            if count > 4{
                variantButton = UIButton()
                btn_selectVariant = UIButton()
                variantButton.translatesAutoresizingMaskIntoConstraints = false
                btn_selectVariant.translatesAutoresizingMaskIntoConstraints = false
                variantButton.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .productVC).backGroundColor)
                variantButton.titleLabel?.numberOfLines = 0
                variantButton.titleLabel?.font = mageFont.regularFont(size: 14.0)
                btn_selectVariant.titleLabel?.font = mageFont.mediumFont(size: 14.0)
                var str = String()
                variant?.selectedOptions.forEach { data in
                  str += "    \(data.name): \(data.value)\n"
                }
                variantButton.setTitle(str, for: .normal)
                variantButton.sizeToFit()
                variantButton.setTitleColor(UIColor(light: .black,dark: UIColor.provideColor(type: .productVC).textColor), for: .normal)
                if Client.locale == "ar" {
                    variantButton.contentHorizontalAlignment = .right
                }
                else {
                    variantButton.contentHorizontalAlignment = .left
                }
                variantButton.addTarget(self, action: #selector(showVariantVC(_:)), for: .touchUpInside)
                
                btn_selectVariant.setTitle("Select Variant".localized, for: .normal)
                btn_selectVariant.setImage(#imageLiteral(resourceName:"rightArrow"), for: .normal)
                btn_selectVariant.semanticContentAttribute = .forceRightToLeft
                btn_selectVariant.titleLabel?.textAlignment = .right
                btn_selectVariant.setTitleColor(UIColor(light: .black,dark: UIColor.provideColor(type: .productVC).textColor), for: .normal)
                btn_selectVariant.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .productVC).backGroundColor)
                mainStack.addArrangedSubview(variantButton)
                mainStack.addArrangedSubview(btn_selectVariant)
                
                variantButton.heightAnchor.constraint(equalToConstant: variantButton.frame.height + 5).isActive = true
                btn_selectVariant.heightAnchor.constraint(equalToConstant: 40).isActive = true
                
                btn_selectVariant.addTarget(self, action: #selector(showVariantVC(_:)), for: .touchUpInside)
            }
            else {
                if let option = self.product.model?.options{
                    for items in option {
                        let view = ProductVariationView()
                        let variant = product.variants.items.first
                        //view.selectedVariant = variant
                        view.option = items
                        view.setupView()
                        mainStack.addArrangedSubview(view)
                        view.heightAnchor.constraint(equalToConstant: 100).isActive = true
                        }
                    }
                }
            }
        //mainStack.addArrangedSubview(addButton)
        //addButton.heightAnchor.constraint(equalToConstant: 25).isActive = true;
    }
    
    @objc func showVariantVC(_ sender : UIButton) {
        let vc = VariantVC()
        vc.product         = self.product
        vc.selectedVariant = self.selectedVariant
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    
    func loadData(){
      //self.id = id
      Client.shared.fetchSingleProduct(of: id){[weak self]
        response,error   in
        if let response = response {
          self?.product = response
          let variants = response.variants.items
          //self?.selectedVariant = variants.first
          self?.loadViewData()
          //response.variants.items.
        }else {
          //self.showErrorAlert(error: error?.localizedDescription)
        }
      }
    }
    
    func reloadTabView() {
        
        let selectedVariantText = String(VariantSelectionManager.shared.getCurrentVariant(product).dropLast(3))
        print("see==",VariantSelectionManager.shared.getCurrentVariant(product).dropLast(3))
        
        if selectedVariant == nil {
          self.selectedVariant = self.product.variants.items.first
            
        }
        self.goToBag = false
//        if product.sellingPlansGroups.items.count > 0 {
//            subscriptionView.selectedVariant=selectedVariant
//            subscriptionView.selectedPlanIndex = -1
//            subscriptionView.selectedIndex = 0
//            subscriptionView.sellingGroupCollectionView.reloadData()
//            subscriptionView.sellingPlanCollectionView.reloadData()
//            self.sellingPlanId=""
//        }
        
        //
        //print("---------->",self.selectedVariant.availableQuantity)
        //titleView.availableQty.text = "\(self.selectedVariant.availableQuantity) " + "Available Quantity".localized
        //
        
        let product = CartProduct(product: self.product, variant: WishlistManager.shared.getVariant(selectedVariant))
        if WishlistManager.shared.isProductVariantinWishlist(product: product) {
            wishlistButton.setImage(UIImage(named: "heartFilled"), for: .normal)
        }
        else {
            wishlistButton.setImage(UIImage(named: "heartEmpty"), for: .normal)//
        }
        
        
        
        if VariantSelectionManager.shared.isVariantUnavailable.contains(selectedVariantText){
            
            addButton.setTitle("    "+"Unavailable".localized, for: .normal)
            addButton.setImage(UIImage(named: "bag")?.withRenderingMode(.alwaysTemplate), for: .normal)
            addButton.tintColor = UIColor(hexString: "#F43939")
            addButton.isUserInteractionEnabled=false
            addButton.backgroundColor = UIColor(hexString: "#F0F0F0")
            addButton.setTitleColor(UIColor(hexString: "#F43939"), for: .normal)
            buyNowButton.backgroundColor = UIColor.textColor().withAlphaComponent(0.5)
            
        }else if !self.selectedVariant.currentlyNotInStock {
            if self.selectedVariant.availableQuantity != "" {
                //|| self.selectedVariant.availableQuantity.hasPrefix("-")
                if Int(self.selectedVariant.availableQuantity) ?? 0 <= 0  &&  !self.selectedVariant.availableForSale{
                    addButton.setTitle("    "+"Out Of Stock".localized, for: .normal)
                    addButton.setImage(UIImage(named: "bag")?.withRenderingMode(.alwaysTemplate), for: .normal)
                    addButton.tintColor = UIColor(hexString: "#F43939")
                    addButton.isUserInteractionEnabled=false
                    addButton.backgroundColor = UIColor(hexString: "#F0F0F0")
                    addButton.setTitleColor(UIColor(hexString: "#F43939"), for: .normal)
                    buyNowButton.backgroundColor = UIColor.textColor().withAlphaComponent(0.5)
                    
                }
                else {
                    addButton.setTitle("    "+"Add To Bag".localized, for: .normal)
                    addButton.setImage(UIImage(named: "bag")?.withRenderingMode(.alwaysTemplate), for: .normal)
                    addButton.isUserInteractionEnabled=true
                    addButton.backgroundColor = UIColor.AppTheme()
                    addButton.tintColor = .textColor()
                    addButton.setTitleColor(.textColor(), for: .normal)
                    buyNowButton.backgroundColor = UIColor.textColor()
                }
        }
            else {
                addButton.setTitle("    "+"Add To Bag".localized, for: .normal)
                addButton.setImage(UIImage(named: "bag")?.withRenderingMode(.alwaysTemplate), for: .normal)
                addButton.isUserInteractionEnabled=true
                addButton.tintColor = .textColor()
                addButton.backgroundColor = UIColor.AppTheme()
                addButton.setTitleColor(.textColor(), for: .normal)
                buyNowButton.backgroundColor = UIColor.textColor()
            }
        }else{
            addButton.setTitle("    "+"Add To Bag".localized, for: .normal)
            addButton.setImage(UIImage(named: "bag")?.withRenderingMode(.alwaysTemplate), for: .normal)
            addButton.isUserInteractionEnabled=true
            addButton.backgroundColor = UIColor.AppTheme()
            addButton.tintColor = .textColor()
            addButton.setTitleColor(.textColor(), for: .normal)
            buyNowButton.backgroundColor = UIColor.textColor()
        }
        
    
//        if customAppSettings.sharedInstance.outOfStocklabel {
//                   if !self.selectedVariant.currentlyNotInStock {
//                              if self.selectedVariant.availableQuantity != "" {
//                                  if self.selectedVariant.availableQuantity == "0" || self.selectedVariant.availableQuantity.hasPrefix("-"){
//                                      headerView.outOfStockLabel.isHidden = false
//                                      headerView.imageCollection.alpha = 0.4
//                                  }
//                                  else {
//                                      headerView.outOfStockLabel.isHidden = true
//                                      headerView.imageCollection.alpha = 1.0
//                                  }
//                          }
//                              else {
//                                  headerView.outOfStockLabel.isHidden = true
//                                  headerView.imageCollection.alpha = 1.0
//
//                              }
//                          }
//                   else {
//                       headerView.outOfStockLabel.isHidden = true
//                       headerView.imageCollection.alpha = 1.0
//                   }
//               }
//               else {
//                   headerView.outOfStockLabel.isHidden = true
//                   headerView.imageCollection.alpha = 1.0
//               }
        
        
        if let image = selectedVariant.image{
            titleView.productImage.setImageFrom(image)
        }
        
        titleView.productPrice.attributedText = self.calculatePrice()
        if variantButton != nil {
            var str = String()
            selectedVariant.selectedOptions.forEach { data in
              str += "    \(data.name): \(data.value)\n"
            }
            variantButton.setTitle(str, for: .normal)
        }
    }
    
    func calculatePrice() -> NSMutableAttributedString {
        let price = NSMutableAttributedString()
        var priceString = NSMutableAttributedString()
        
        priceString =  NSMutableAttributedString(string: Currency.stringFrom(selectedVariant.price))
        if let comparePrice = selectedVariant.compareAtPrice {
          let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string:Currency.stringFrom(comparePrice))
          attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            attributeString.addAttribute(NSAttributedString.Key.foregroundColor,value: UIColor(hexString: "#6B6B6B"), range: NSMakeRange(0, attributeString.length))
            priceString.addAttribute(NSAttributedString.Key.foregroundColor,value: UIColor(light: .black,dark: UIColor.provideColor(type: .quickAddToCart).textColor), range: NSMakeRange(0, priceString.length))
          
          price.append(priceString)
          price.append(NSMutableAttributedString(string : "  "))
          price.append(attributeString)
          
          let minusPrice = ((selectedVariant.compareAtPrice ?? 0.0) - (selectedVariant.price ))
          let percentage = ((minusPrice/(selectedVariant.compareAtPrice ?? 0.0))*100)
          let val = String(format: "%.0f", Double(truncating : percentage as? NSNumber ?? 0))
            let offerString: NSMutableAttributedString =  NSMutableAttributedString(string: "(\(val)% "+"OFF".localized+")")
          offerString.addAttribute(NSAttributedString.Key.foregroundColor,value: UIColor.systemGreen, range: NSMakeRange(0, offerString.length))
          price.append(NSMutableAttributedString(string : "  "))
          price.append(offerString)
        }
        else {
            priceString.addAttribute(NSAttributedString.Key.foregroundColor,value: UIColor(light: UIColor(hexString: "#6B6B6B"),dark: UIColor.provideColor(type: .quickAddToCart).textColor), range: NSMakeRange(0, priceString.length))
          price.append(priceString)
        }
        return price
    }
    
    @objc func addProductToBag(_ sender : UIButton) {
        if self.selectedVariant == nil {
            self.view.makeToast("Select Variant First !".localized, duration: 1.5, position: .bottom)//self.selectedVariant = self.product.variants.items.first
            return;
        }
        if self.selectedVariant != nil {
            if goToBag {
                let story = UIStoryboard(name: "Main", bundle: nil)
                let data = DBManager.shared.cartProducts?.filter{$0.sellingPlanId != ""}
                if data?.count ?? 0 > 0 {
                    let vc : NewCartViewController = story.instantiateViewController()
                    self.parentView?.navigationController?.pushViewController(vc, animated: true)
                    self.dismiss(animated: false)
                    return;
                }
                else {
                    let vc : CartViewController = story.instantiateViewController()
                    self.parentView?.navigationController?.pushViewController(vc, animated: true)
                    self.dismiss(animated: false)
                    return;
                }
            }
          if !self.selectedVariant.currentlyNotInStock {
              if (Int(self.selectedVariant.availableQuantity) == 0  &&  !self.selectedVariant.availableForSale) {
              self.view.makeToast("Product is Currently out of stock.".localized, duration: 1.5, position: .center)
              return;
            }
          }
        }
        let selectedQty = "1"
//        if self.qtyView.customQuantity != "" {
//            selectedQty = qtyView.customQuantity
//        }
//        else {
//            selectedQty = self.qtyView.selectedQuantity
//        }
        //condition
        print("selected qty===>",selectedQty)
        print("available qty==>",self.selectedVariant.availableQuantity)
        guard let userSelectedQty = Int(selectedQty), var availableQuantity = Int(self.selectedVariant.availableQuantity) else {
                print("Some value is nil")
                return
            }
        if(self.selectedVariant.availableForSale && userSelectedQty > availableQuantity){
            availableQuantity = 1
        }
        var addProduct=true
        if DBManager.shared.cartProducts?.count ?? 0 > 0 {
          for CartDetail in DBManager.shared.cartProducts! {
            let variantId = CartDetail.variant.id
            if self.selectedVariant.id == variantId {
              if !self.selectedVariant.currentlyNotInStock {
                if (Int(self.selectedVariant.availableQuantity) ?? 0) > 0 {
                  if CartDetail.qty > (Int(self.selectedVariant.availableQuantity) ?? 0) {
                    self.view.makeToast("You have already added the maximum available quantities for this Variant".localized, duration: 2.5, position: .center)
                    addProduct=false
                    break;
                  }
                  else if CartDetail.qty + (Int(selectedQty) ?? 0) > (Int(self.selectedVariant.availableQuantity) ?? 0) {
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
        //  self.view.showmsg(msg: product.title + " Added to cart".localized)
          Analytics.logEvent(AnalyticsEventAddToCart, parameters: [AnalyticsParameterItemID: "id-\(product.id)",
                             AnalyticsParameterItemName: product.title,
                             AnalyticsParameterPrice: product.price])
            let params : [AppEvents.ParameterName:Any] = [AppEvents.ParameterName.content : CartManager.shared.cartSubtotal,AppEvents.ParameterName.contentID : Client.shared.getCurrencyCode() ?? "",AppEvents.ParameterName.contentType:CartManager.shared.cartSubtotal]
                    AppEvents.shared.logEvent(.addedToCart, valueToSum: Double(self.product.price) ?? 0.0, parameters:params )
            self.delegate?.updateCart()
          self.setupTabbarCount()
            self.goToBag = true
            sender.setNewTitlewithAnimation()
        }
      //  self.dismiss(animated: true)
        //self.view.viewWithTag(123321)?.removeFromSuperview()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
extension QuickAddToCartVC : VariantSelectionMadeDelegate {
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
            self.parentVC?.selectedVariant = selectedVariant
//            print("Variant Quantity==",(self.selectedVariant.availableQuantity))
//              titleView.availableQty.text = "\(self.selectedVariant.availableQuantity) " + "Available Quantity".localized
                return;
            }
        }
        
        if VariantSelectionManager.shared.userSelectedVariants.keys.count == optionCount{
            VariantSelectionManager.shared.isVariantUnavailable.append(String(selectVariant))
            self.parentVC?.reloadTabView()
            self.reloadTabView()
        }
       
        
    }
}

protocol UpdateBadge{
    func updateCart()
}
