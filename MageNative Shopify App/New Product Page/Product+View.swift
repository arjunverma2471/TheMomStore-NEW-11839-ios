//
//  Product+View.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 12/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
extension ProductVC {
    
    // ----------------------------------
    //  MARK: - Render Product Page  -
    //

    
     func variantViewSetup() {
        //        if selectedVariant.selectedOptions.first?.name != "Title" && selectedVariant.selectedOptions.first?.value != "Default Title"{
        let count = self.product.model?.options.count ?? 0
        
        if count > 2{
            variantButton = UIButton()
            btn_selectVariant = UIButton()
            variantButton.translatesAutoresizingMaskIntoConstraints = false
            btn_selectVariant.translatesAutoresizingMaskIntoConstraints = false
            variantButton.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .productVC).backGroundColor)
            variantButton.titleLabel?.numberOfLines = 0
            variantButton.titleLabel?.font = mageFont.regularFont(size: 14.0)
            btn_selectVariant.titleLabel?.font = mageFont.mediumFont(size: 14.0)
            var str = String()
            selectedVariant?.selectedOptions.forEach { data in
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
            variantButton.isHidden = false
            if str.isEmpty{
                variantButton.isHidden = true
            }
            mainStack.addArrangedSubview(btn_selectVariant)
            
            btn_selectVariant.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            btn_selectVariant.addTarget(self, action: #selector(showVariantVC(_:)), for: .touchUpInside)
        }
        else {
            if let edgeCount = self.product.model?.variants.edges.count {
                if edgeCount > 1 { // Linked to variant combination count
                    if let option = self.product.model?.options{
                        for items in option {
                            let view = ProductVariationView()
                            view.selectedVariant = self.selectedVariant
                            view.option = items
                            view.setupView()
                            mainStack.addArrangedSubview(view)
                            view.heightAnchor.constraint(equalToConstant: 100).isActive = true
                        }
                    }
                }
            }
        }
    }
    
    func renderProductPage() {
        mainStack.arrangedSubviews.forEach{ $0.removeFromSuperview()}
        mainStack.addArrangedSubview(headerView)
        headerView.productMedia = self.product.media?.items
        headerView.delegate = self
        headerView.shareButton.addTarget(self, action: #selector(shareThisProduct(_:)), for: .touchUpInside)
        headerView.rotateButton.addTarget(self, action: #selector(rotateThisProduct(_:)), for: .touchUpInside)
//        headerView.wishlistButton.addTarget(self, action: #selector(addProductToWishlist(_:)), for: .touchUpInside)
        
        headerView.arButton.addTarget(self, action: #selector(arButtonClicked(_:)), for: .touchUpInside)
//        if(customAppSettings.sharedInstance.lipShadeTryon && colorsArray.count>0){
//            headerView.virtualButton.rx.tap.bind{
//                let vc = UIStoryboard(name: "VirtualTryon", bundle: nil).instantiateViewController(withIdentifier: "LipShadeViewController") as! LipShadeViewController//LipShadeViewController()
//                vc.modalPresentationStyle = .fullScreen
//                vc.colorsArray = self.colorsArray
//                self.present(vc, animated: true, completion: nil)
//            }.disposed(by: disposeBag)
//        }
        
        if showSizeChart {
            headerView.sizeChart.isHidden = false
        }
        else {
            headerView.sizeChart.isHidden = true
        }
        headerView.sizeChart.addTarget(self, action: #selector(showSizeChart(_:)), for: .touchUpInside)
        
        
        mainStack.addArrangedSubview(titleView)
        titleView.product = self.product
        titleView.setupView()
//        titleView.similarProductsButton.addTarget(self, action: #selector(showSimilarProducts(_:)), for: .touchUpInside)
//        if customAppSettings.sharedInstance.aiProductRecomendaton {
//            titleView.similarProductsButton.isHidden = false
//        }
//        else {
//            titleView.similarProductsButton.isHidden = true
//        }
//        titleView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        headerView.virtualButton.isHidden = true
        
        if self.product.variants.items.first?.selectedOptions.first?.name != "Title" || self.product.variants.items.first?.selectedOptions.first?.value != "Default Title"{
            if let edgeCount = self.product.model?.variants.edges.count {
                if edgeCount > 1 {
                    variantViewSetup()
                }
            }
        }
        
        if customAppSettings.sharedInstance.backInStockIntegration {
            self.mainStack.addArrangedSubview(backStockView)
            backStockView.notifyButton.addTarget(self, action: #selector(notifyForThisProduct(_:)), for: .touchUpInside)
            if selectedVariant == nil{
                self.backStockView.isHidden = true
            }
        }
        
        mainStack.addArrangedSubview(descriptionView)
        if self.product.summary.htmlToString != ""{
            descriptionView.product = self.product
            descriptionView.setupView()
            descriptionView.parent = self
            descriptionView.productHeading.addTarget(self, action: #selector(showDescription(_:)), for: .touchUpInside)
        }else{
            descriptionView.isHidden = true
        }
        
        if product.sellingPlansGroups.items.count > 0 {
            mainStack.addArrangedSubview(subscriptionView)
            subscriptionView.product = self.product
            subscriptionView.delegate = self
            subscriptionView.parent = self
            subscriptionView.selectedVariant = selectedVariant
            subscriptionView.subscribeBtn.addTarget(self, action: #selector(subscribeToProduct(_:)), for: .touchUpInside)
        }
    }
    
    func checkStockIntegration() {
        
        if let selectedVariant = self.selectedVariant{
            if !selectedVariant.currentlyNotInStock {
                if selectedVariant.availableQuantity == "0" {
                    self.backStockView.isHidden = false
    //
                }
                else {
                    self.backStockView.isHidden = true
                }
            }
            else {
                self.backStockView.isHidden = true
            }
        }
    }
    
    
    
    // ----------------------------------
    //  MARK: - Check Custom Settings
    //
    
    func checkCustomSettings() {
        
        if customAppSettings.sharedInstance.productShare {
            headerView.shareButton.isHidden = false
        }
        else {
            headerView.shareButton.isHidden = true
            
        }
        
        if let type = (self.product.media?.items.filter({$0.type == .model3d})) {
            if type.count > 0 {
                headerView.rotateButton.isHidden = false
                headerView.arButton.isHidden = false
            }
            else {
                headerView.rotateButton.isHidden = true
                headerView.arButton.isHidden = true
            }
        }
        if customAppSettings.sharedInstance.inAppWishlist {
//            tabView.wishlistButtonWidth.constant = 45
            tabView.wishlistButton.isHidden = false
//            headerView.wishlistButton.isHidden = false
        }
        else {
//            tabView.wishlistButtonWidth.constant = 0
            tabView.wishlistButton.isHidden = true
//          headerView.wishlistButton.isHidden = true
        }
    }
    
    
    
    // ----------------------------------
    //  MARK: - Target Functions -
    //

    
    
    
    @objc func shareThisProduct(_ sender : UIButton) {
        let url = URL(string: "\(self.product.onlineStoreUrl?.absoluteString ?? "")?pid=\(self.product.id)")!
        let vc = UIActivityViewController(activityItems: [url as Any], applicationActivities: nil);
        if(UIDevice().model.lowercased() == "ipad".lowercased())
        {
          vc.popoverPresentationController?.sourceView = sender as UIView
        }
        self.present(vc, animated: true, completion: nil);
    }
    
    
    @objc func showSimilarProducts(_ sender : UIButton) {
        let vc = SimilarProductView()
        vc.similarProducts = self.similarProducts
//        vc.modalPresentationStyle = .pageSheet
//        if #available(iOS 15.0, *) {
//            if let sheet = vc.sheetPresentationController {
//                sheet.detents = [.medium()]
//                sheet.largestUndimmedDetentIdentifier = .medium
//                        sheet.prefersScrollingExpandsWhenScrolledToEdge = false
//                        sheet.prefersEdgeAttachedInCompactHeight = true
//                        sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
//            }
//        } else {
//            // Fallback on earlier versions
//        }
        //vc.popupDelegate = self;
        vc.delegate = self
        self.present(vc, animated: true)
    }
    func getSelectedProduct(value: ProductViewModel!) {
        selectedProduct = value
        //print(selectedProduct)
        
        let productViewController=ProductVC()
        productViewController.product = selectedProduct
        self.navigationController?.pushViewController(productViewController, animated: true)
    }
    
    @objc func showSizeChart(_ sender : UIButton) {
        let contentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sizeChartPopUpController") as? sizeChartPopUpController
        let popupVC = PopupViewController(contentController: contentVC!, popupWidth: self.view.frame.width-20, popupHeight: self.view.frame.height-200)
        popupVC.backgroundAlpha = 0.3
        popupVC.backgroundColor = .black
        popupVC.canTapOutsideToDismiss = true
        popupVC.cornerRadius = 10
        popupVC.shadowEnabled = true
        let url = self.fetchKiwiSizeData(checkForSizeChart: false)
        let request = URLRequest(url: url)
        contentVC?.sizeChartView.load(request)
        self.present(popupVC, animated: true)
    }
                                                 
                                                 
       @objc func showDescription(_ sender : UIButton) {
           self.showDescription.toggle()
           self.renderProductPage()
        }
    
    @objc func subscribeToProduct(_ sender : UIButton) {
        if let selectedVariant = self.selectedVariant{
            if sellingPlanId == "" {
                self.view.showmsg(msg: "Please select an option to continue".localized)
                return;
            }
            let item = CartProduct(product: product, variant: WishlistManager.shared.getVariant(selectedVariant), quantity: 1, sellingPlanId: self.sellingPlanId)
            CartManager.shared.addToCart(item)
            self.view.showmsg(msg: product.title + " Added to cart".localized)
            self.setupTabbarCount()
        }else{
            self.view.makeToast("Select Variant First!")
        }
    }
    
    @objc func rotateThisProduct(_ sender : UIButton) {
        if let imageData = self.product.media?.items.filter({$0.type == .model3d}) {
            if imageData.count > 0 {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc : Scene3DViewController = storyboard.instantiateViewController()
                vc.product=imageData.first!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @objc func showVariantVC(_ sender : UIButton) {
        let vc = VariantVC()
        vc.product         = self.product
        vc.selectedVariant = self.selectedVariant
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @objc func arButtonClicked(_ sender: UIButton)
    {
      if let arMediaData = self.product.media?.items.filter({$0.type == .model3d}) {
        if arMediaData.count > 0 {
          if arMediaData.count == 1 {
            self.fetchArModel(arMediaData[0])
          }
          else {
              let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let contentViewController :ARPopupViewController = storyboard.instantiateViewController()
            contentViewController.arModelData = arMediaData
            let popupVC = PopupViewController(contentController: contentViewController, popupWidth: self.view.frame.width-20, popupHeight: 250)
            
            popupVC.backgroundAlpha = 0.3
            popupVC.backgroundColor = .black
            popupVC.canTapOutsideToDismiss = true
            popupVC.cornerRadius = 10
            popupVC.shadowEnabled = true
            present(popupVC, animated: true)
          }
        }
      }
    }

    @objc func notifyForThisProduct(_ sender : UIButton) {
        guard let email = backStockView.textField.text else {return}
        
        if email.isEmpty {
            self.showErrorAlert(error: "Email is empty".localized)
            return
        }
        
        if !email.isValidEmail() {
          self.showErrorAlert(error: "Email is not Valid.".localized)
          return
        }
        
        guard let pId = self.product.id.components(separatedBy: "/").last else {return}
        
        var vId = String()
        if self.selectedVariant != nil{
            vId = self.selectedVariant!.id.components(separatedBy: "/").last ?? ""
        }
        
        
        
        let url = "http://shopifymobileapp.cedcommerce.com/index.php/shopifymobile/alertmerestockalertsapi/alertsubscriptionforemail?email=\(email)&shop=\(Client.shopUrl)&product=\(pId)&variant=\(vId)"
        Networking.shared.sendRequestUpdated(api: url, type: .POST, includePureURLString: true) { (result) in
            switch result {
            case .success(let data):
                do {
                    let json = try JSON(data: data)
                    print(json)
                    if json["success"].stringValue == "true" {
                        self.isBackStockDataLoaded = true
                        self.backStockView.resultLabel.text = "We'll notify you once this product gets in stock.".localized
                        self.backStockView.resultLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
                        self.showAlert(error: "We'll notify you once this product gets in stock.".localized)
                    }
                    else {
                        self.isBackStockDataLoaded = false
                        self.backStockView.resultLabel.text = ""
                        self.backStockView.resultLabel.heightAnchor.constraint(equalToConstant: 0).isActive = true
                    }
                }
                catch let error {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}


//MARK: - REVIEWS IO
extension ProductVC {
    
    func showReviewsIOReview() {
        self.mainStack.insertArrangedSubview(reviewsIOreviews, belowArrangedSubview: self.mainStack.arrangedSubviews.last ?? self.descriptionView)
        reviewsIOreviews.setReviewsIOReview(data:reviewsIOreview ?? [], averageRatings: avgReviewIORating ?? 0.0)
        reviewsIOreviews.viewAll.addTarget(self, action: #selector(showAllReviewsIO(_:)), for: .touchUpInside)
        reviewsIOreviews.writeReview.addTarget(self, action: #selector(writeReviewsIOreview(_:)), for: .touchUpInside)
    }
    
    
    @objc func showAllReviewsIO(_ sender : UIButton) {
        let vc = AllReviewsViewController()
        vc.isFromReviewsIO = true
        vc.product = self.product
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func writeReviewsIOreview(_ sender : UIButton) {
        let contentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "writeReviewViewController") as? writeReviewViewController
        contentVC?.delegate=self
        contentVC?.isFromJudgeMe=false
        contentVC?.isFromReviewsIO = true
        contentVC?.product = self.product
        self.navigationController?.pushViewController(contentVC!, animated: true)
    }
}
