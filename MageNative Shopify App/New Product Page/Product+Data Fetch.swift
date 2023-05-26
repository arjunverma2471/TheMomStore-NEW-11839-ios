//
//  Product+Data Fetch.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 12/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
extension ProductVC {
    
    func getProductData() {
        guard let productId = productId else {return}
        Client.shared.fetchSingleProduct(of: productId){
            response,error   in
            if let response = response {
                self.product = response
                //        self.selectedVariant = self.product.variants.items.first
                self.product.variants.items.map { variant in
                    if variant.id == self.selectedVariantID {
                        self.selectedVariant = variant
                    }
                }
                self.validateForSelectedVariant()
                self.perform()
                AnalyticsFirebaseData.shared.firebaseProductEvent(product: self.product)
                let params : [AppEvents.ParameterName:Any] = [AppEvents.ParameterName.content : self.product.title]
                AppEvents.shared.logEvent(.viewedContent, valueToSum: NumberFormatter().number(from: self.product.price)?.doubleValue ?? 0.0, parameters: params)
            }
            else {
                //self.showErrorAlert(error: error?.localizedDescription)
            }
        }
    }
    
    func getShopifyRecommendedProducts() {
        let productId = self.product.id
        Client.shared.fetchRecommendedProducts(ids: GraphQL.ID(rawValue: productId),completion: { (response, error) in
            if let response = response {
                if response.count > 0 {
                    self.shopifyRecommendedProducts = response
                    self.mainStack.addArrangedSubview(self.recommendedProductView)
//                    self.mainStack.insertArrangedSubview(self.recommendedProductView, belowArrangedSubview: self.descriptionView)
                    self.recommendedProductView.delegate = self
                    self.recommendedProductView.recommendedProducts = self.shopifyRecommendedProducts ?? []
                    self.recommendedProductView.heightAnchor.constraint(equalToConstant: 345).isActive = true
                }
            }
        })
    }
    
    func getFastSimonUpSellCrossSellProducts(){
          let pid = self.product.id.components(separatedBy: "/").last ?? ""
          fastSimonAPIHandler?.getUpsellCrossSellProducts(pid: pid, completion: { upsellCrossSellProducts in
              let products = upsellCrossSellProducts?.widget_responses.first?.products
              if products?.count ?? 0 > 0 {
                  var ids = [GraphQL.ID]()
                  for itms in products! {
                      let str = "gid://shopify/Product/\(itms.id)"
                      let graphId = GraphQL.ID(rawValue: str)
                      ids.append(graphId)
                  }
                  Client.shared.fetchMultiProducts(ids: ids) { response, error in
                      if let response = response {
                          print(response.count)
                          self.mainStack.insertArrangedSubview(self.fastSimonUpsellProductView, belowArrangedSubview: self.mainStack.arrangedSubviews.last ?? self.descriptionView)
                          self.fastSimonUpsellProductView.delegate = self
                          self.fastSimonUpsellProductView.titleLabel.text = "Upsell Products".localized
                          self.fastSimonUpsellProductView.recommendedProducts = response
                          self.fastSimonUpsellProductView.heightAnchor.constraint(equalToConstant: 350).isActive = true
                      }
                  }
              }
        })
      }
    
    func getLookAlikeProducts() {
            let prodId = self.product.id.components(separatedBy: "/").last ?? ""
            fastSimonAPIHandler?.getLookALikeProducts(pid: prodId) { json in
                if json?.arrayValue.count ?? 0 > 0 {
                    var ids = [GraphQL.ID]()
                    for items in (json?.arrayValue)! {
                        let str = "gid://shopify/Product/\(items["id"].stringValue)"
                        let graphId = GraphQL.ID(rawValue: str)
                        ids.append(graphId)
                    }
                    Client.shared.fetchMultiProducts(ids: ids) { response, error in
                        if let response = response {
                            print(response.count)
                            self.mainStack.insertArrangedSubview(self.fastSimonLookAlikeProductView, belowArrangedSubview: self.mainStack.arrangedSubviews.last ?? self.descriptionView)
                            self.fastSimonLookAlikeProductView.delegate = self
                            self.fastSimonLookAlikeProductView.titleLabel.text = "Look-a-likes".localized
                            self.fastSimonLookAlikeProductView.recommendedProducts = response
                            self.fastSimonLookAlikeProductView.heightAnchor.constraint(equalToConstant: 350).isActive = true
                        }
                    }
                }
            }
        }
      
    
    func getSimilarProducts(similarProductId: String) {
        Client.shared.fetchRecommendedProducts(query: [ "queries": [["id": "query1","max_recommendations": 10,"recommendation_type": "similar_products", "product_ids":[similarProductId]]]]) { (json, error) in
            if let json = json{
                if let status = json["status"] as? String{
                    if(status.lowercased() == "ok"){
                        if let query1 = json["query1"] as? [String:Any]{
                            if let products = query1["products"] as? [[String:Any]]{
                                var ids = [GraphQL.ID]()
                                for index in products{
                                    let str="gid://shopify/Product/\(index["product_id"]!)"
                                    let graphId = GraphQL.ID(rawValue: str)
                                    ids.append(graphId)
                                }
                                Client.shared.fetchMultiProducts(ids: ids, completion: { (response, error) in
                                    if let response = response {
                                        self.similarProducts = response
                                        self.mainStack.addArrangedSubview(self.similarProductView)
//                                        self.mainStack.insertArrangedSubview(self.similarProductView, belowArrangedSubview: self.descriptionView)
                                        self.similarProductView.titleLabel.text = "Similar Products".localized
                                        self.similarProductView.delegate = self
                                        self.similarProductView.recommendedProducts = self.similarProducts ?? []
                                        self.similarProductView.heightAnchor.constraint(equalToConstant: 345).isActive = true
                                    }else {
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
    }

    func fetchProductRatingAndReview(productId:String) {
        let id = productId.components(separatedBy: "/").last ?? ""
        let url = "https://shopifymobileapp.cedcommerce.com/index.php/shopifymobile/productreviewapi/badges?mid=\(Client.merchantID)&product_id=\(id))"
        guard let urlRequest = url.getURL() else {return}
        var request = URLRequest(url: urlRequest)
        request.httpMethod="GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task=URLSession.shared.dataTask(with: request, completionHandler: {data,response,error in
            DispatchQueue.main.sync
            {
                do {
                    guard let data = data else {return;}
                    guard let json = try? JSON(data:data) else {return;}
                    print(json)
                    if json["success"].stringValue == "true" {
                        let totalRating = json["data"][id]["total-rating"].stringValue
                        let totalReviews = json["data"][id]["total-reviews"].stringValue
                        self.productRatingBadgeData["totalReview"] = totalReviews
                        self.productRatingBadgeData["totalRating"] = totalRating
                        self.fetchReviewData(productId: self.product.id, page: "1")
                    }
                }
            }
        })
        task.resume()
    }
    
    func fetchKiwiSizeData(checkForSizeChart:Bool) -> URL {
        
        var url = "https://app.kiwisizing.com/size?shop=\(Client.shopUrl)"
        let id = self.product.id.components(separatedBy: "/").last ?? ""
        url += "&source=magenative&product=\(id)"
        var tags = String()
        for tag in product.tag {
            tags += "\(tag),"
        }
        
        if(tags.last == ",") {
            
            tags = String(tags.prefix(upTo: tags.index(before: tags.endIndex)));
        }
        url += "&tags=\(tags.allowedString())"
        url += "&vendor=\(product.vendor.allowedString())"
        
        var str = ""
        if let collec = self.product.model?.collections.edges {
            for collectionId in collec {
                let id = collectionId.node.id.rawValue
                str += "\(id),"
            }
            if(str.last == ","){
                str = String(str.prefix(upTo: str.index(before: str.endIndex)));
            }
        }
        url += "&collections=\(str.allowedString())"
        guard let urlRequest = url.getURL() else { return URL(string: "")!}
        print(urlRequest)
        if !checkForSizeChart {
            return urlRequest
        }
        var request = URLRequest(url: urlRequest)
        request.httpMethod="GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task=URLSession.shared.dataTask(with: request, completionHandler: {data,response,error in
            DispatchQueue.main.sync
            {
                do {
                    guard let data = data else {return}
                    let response = NSString (data: data, encoding: String.Encoding.utf8.rawValue)
                    if response == "" {
                        print("No Size Chart")
                        self.showSizeChart=false
                    }
                    else {
                        self.showSizeChart=true
                    }
//                    self.renderProductPage()
                    if self.showSizeChart {
                        self.headerView.sizeChart.isHidden = false
                    }
                    else {
                        self.headerView.sizeChart.isHidden = true
                    }
                }
            }
        })
        task.resume()
        return URL(string: Client.shopUrl)!
    }
    
    
    func fetchReviewData(productId:String,page:String) {
        let id = productId.components(separatedBy: "/").last ?? ""
        let url =
        "https://shopifymobileapp.cedcommerce.com/index.php/shopifymobile/productreviewapi/product?mid=\(Client.merchantID)&product_id=\(id)&page=\(page)&tt=\(Date().timeIntervalSince1970)"
        
        guard let urlRequest = url.getURL() else {return}
        var request = URLRequest(url: urlRequest)
        request.httpMethod="GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task=URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil && data != nil else
            {
                return;
            }
            
            // check for http errors
            if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode/100 != 2
            {
                DispatchQueue.main.async {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                }
                return;
            }
            DispatchQueue.main.async{
             //   do {
                    
                    guard let data = data else {return}
                    guard let json = try? JSON(data: data) else {return}
                    print(json)
                    if json["success"].stringValue == "true" {
                        let decoder = JSONDecoder()
                        do {
                            self.productReviews = try decoder.decode(productRatingData.self, from: data)
                        }
                        catch{}
                        self.mainStack.insertArrangedSubview(self.shopifyReviews, belowArrangedSubview: self.descriptionView)
                        //   self.mainStack.insertArrangedSubview(self.shopifyReviews, at: 5)
                        self.shopifyReviews.productRatingBadgeData = self.productRatingBadgeData
                        self.shopifyReviews.setupView(productReviews: self.productReviews)
                        self.shopifyReviews.viewAll.addTarget(self, action: #selector(self.viewAll(_:)), for: .touchUpInside)
                        self.shopifyReviews.writeReview.addTarget(self, action: #selector(self.writeReview(_:)), for: .touchUpInside)
                    }
//                }
//                catch{
//
//                }
                
            }
        }
        task.resume()
    }
    
    
    func fetchJudgeMeProductDetails() {
        let url = "https://judge.me/api/v1/products/id=\(self.product.handle)?api_token=\(Client.judgemeApikey)&shop_domain=\(Client.shopUrl)&handle=\(self.product.handle)"
        guard let urlRequest = url.getURL() else {return}
        var request = URLRequest(url: urlRequest)
        request.httpMethod="GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task=URLSession.shared.dataTask(with: request, completionHandler: {data,response,error in
            DispatchQueue.main.sync
            {
                do {
                    guard let data = data else {return;}
                    guard let json = try? JSON(data:data) else {return;}
                    self.productJudgeMeId = json["product"]["id"].stringValue
                    self.productExternalId = json["product"]["external_id"].stringValue
                    self.fetchJudgeMeProductReviewCount(productId: self.productJudgeMeId)
                    self.fetchJudgeMeReviewData()
//                    self.getJudgeMeReviewData()
                }
            }
        })
        task.resume()
    }
    
    func fetchJudgeMeProductReviewCount(productId:String) {
        let url =
        "https://judge.me/api/v1/reviews/count/?api_token=\(Client.judgemeApikey)&shop_domain=\(Client.shopUrl)&product_id=\(productId)"
        guard let urlRequest = url.getURL() else {return}
        var request = URLRequest(url: urlRequest)
        request.httpMethod="GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task=URLSession.shared.dataTask(with: request, completionHandler: {data,response,error in
            DispatchQueue.main.sync
            {
                do {
                    guard let data = data else {return;}
                    guard let json = try? JSON(data:data) else {return;}
                    if json["count"].stringValue != "" {
                        self.judgeMeRatingCount=json["count"].stringValue
                    }
                }
            }
        })
        task.resume()
    }
    
    func getJudgeMeReviewData() {
        let url = "https://judge.me/api/v1/widgets/product_review?api_token=\(Client.judgemeApikey)&shop_domain=\(Client.shopUrl)&per_page=10&page=1&handle=\(self.product.handle)&external_id=\(productExternalId)&id=\(productJudgeMeId)"
        
        guard let urlRequest = url.getURL() else {return}
        var request = URLRequest(url: urlRequest)
        request.httpMethod="GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task=URLSession.shared.dataTask(with: request, completionHandler: {data,response,error in
            DispatchQueue.main.sync
            {
                do {
                    guard let data = data else {return;}
                    guard let json = try? JSON(data:data) else {return}
                    print(json)
                    
                }
                catch{}
            }
        })
        task.resume()
    }
    
    func fetchJudgeMeReviewData() {
        let url =
        "https://judge.me/api/v1/reviews?api_token=\(Client.judgemeApikey)&shop_domain=\(Client.shopUrl)&per_page=10&page=1&product_id=\(self.productJudgeMeId)"
        guard let urlRequest = url.getURL() else {return}
        var request = URLRequest(url: urlRequest)
        request.httpMethod="GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task=URLSession.shared.dataTask(with: request, completionHandler: {data,response,error in
            DispatchQueue.main.sync
            {
                do {
                    guard let data = data else {return;}
                    let json = try! JSON(data: data)
                    print(json)
                    if json["success"].stringValue == "true" {
                        if json["data"]["reviews"].arrayValue.count > 0 {
                            for values in json["data"]["reviews"].arrayValue {
                                if values["curated"].stringValue == "ok" && values["hidden"].stringValue == "false" {
                                    
                                    let review_title = values["review_title"].stringValue
                                    let reviewer_name = values["reviewer_name"].stringValue
                                    let rating = values["rating"].stringValue
                                    let review_date = values["review_date"].stringValue
                                    let content = values["content"].stringValue
                                    let id = values["id"].stringValue
                                    let outof = values["outof"].stringValue
                                    
                                    self.ratingData.append(["review_title":review_title,"reviewer_name":reviewer_name,"rating":rating,"review_date":review_date,"id":id,"outof":outof,"content":content])
                                }
                            }
                        }
                    }
                    let decoder = JSONDecoder()
                    self.productJudgeMeReviews = try decoder.decode(judgeMeRatingAndReview.self, from: data)
                    self.mainStack.insertArrangedSubview(self.judgeMeReviws, belowArrangedSubview: self.descriptionView)
                    self.judgeMeReviws.judgeMeRatingCount = self.judgeMeRatingCount
                    self.judgeMeReviws.setupJudgeMeReviewData(reviewData: self.productJudgeMeReviews!)
                    self.judgeMeReviws.viewAll.addTarget(self, action: #selector(self.viewJudgeMeReviews(_:)), for: .touchUpInside)
                    self.judgeMeReviws.writeReview.addTarget(self, action: #selector(self.writeJudgeMeReview(_:)), for: .touchUpInside)
                    
                }
                catch{}
            }
        })
        task.resume()
    }
    
    func getAliReviewsStatus(){
        let url =
        "https://alireviews.fireapps.io/api/shops/\(Client.shopUrl)"
        guard let urlRequest = url.getURL() else {return}
        var request = URLRequest(url: urlRequest)
        request.httpMethod="GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task=URLSession.shared.dataTask(with: request, completionHandler: {data,response,error in
            DispatchQueue.main.sync
            {
                do {
                    guard let data = data else {return;}
                    guard let json = try? JSON(data:data) else {return;}
                    if(json["status"].stringValue == "true"){
                        self.shopId = json["result"]["shop_id"].stringValue
                        self.getAliReviews()
                    }
                }
                //catch{}
                
            }
        })
        task.resume()
    }
    
    func getAliReviews(){
        let id = productId?.components(separatedBy: "/").last ?? ""
        let url =
        "https://alireviews.fireapps.io/comment/get_review?shop_id=\(shopId)&product_id=\(id)"
        print(url)
        guard let urlRequest = url.getURL() else {return}
        var request = URLRequest(url: urlRequest)
        request.httpMethod="GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task=URLSession.shared.dataTask(with: request, completionHandler: {data,response,error in
            DispatchQueue.main.sync
            {
                do {
                    guard let data = data else {return;}
                    //     guard let json = try? JSON(data:data) else {return;}
                    let decoder = JSONDecoder()
                    self.aliReviews = try decoder.decode(Alireviews.self, from: data)
                    
                    self.mainStack.insertArrangedSubview(self.aliReview, belowArrangedSubview: self.descriptionView)
                    self.aliReview.setAliReview(reviewData: self.aliReviews!)
                    self.aliReview.viewAll.addTarget(self, action: #selector(self.viewAliReviews(_:)), for: .touchUpInside)
                    self.aliReview.writeReview.addTarget(self, action: #selector(self.writeAliReview(_:)), for: .touchUpInside)
                    
                }
                catch{}
                
                
            }
        })
        task.resume()
    }
    
    
    @objc func viewAll(_ sender : UIButton) {
        let vc = AllReviewsViewController()
        vc.isFromShopifyRating = true
        vc.productname = self.product.title
        vc.productId = self.product.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func viewJudgeMeReviews(_ sender : UIButton) {
        let vc = AllReviewsViewController()
        vc.isFromShopifyRating = false
        vc.productJudgeMeId = self.productJudgeMeId
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func viewAliReviews(_ sender : UIButton) {
        let vc = AllReviewsViewController()
        vc.isFromShopifyRating = false
        vc.productJudgeMeId = ""
        vc.shopId=self.shopId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func writeJudgeMeReview(_ sender : UIButton) {
        let contentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "writeReviewViewController") as? writeReviewViewController
        contentVC?.delegate=self
        contentVC?.isFromJudgeMe=true
        contentVC?.judgeMeId = self.productExternalId
        self.navigationController?.pushViewController(contentVC!, animated: true)
    }
    
    @objc func writeAliReview(_ sender : UIButton) {
        
    }
    
    @objc func writeReview(_ sendr : UIButton) {
        let contentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "writeReviewViewController") as? writeReviewViewController
        contentVC?.delegate=self
        contentVC?.isFromJudgeMe=false
        contentVC?.productId = self.product.id
        self.navigationController?.pushViewController(contentVC!, animated: true)
    }
    
    
}
extension ProductVC : ReloadReviewsData {
    func reloadRatingAndReviews() {
        // MARK: *** Shopify Rating And Reviews
        if customAppSettings.sharedInstance.inAppRatingReview {
            self.fetchProductRatingAndReview(productId: self.product.id )
           // self.fetchReviewData(productId: self.product.id, page: "1")
        }
        
        //MARK: - REVIEWS IO
        if customAppSettings.sharedInstance.reviewsIO {
            reviewsAPIHandler = ReviewsAPIHandler()
            reviewsAPIHandler?.getProductAverageRating(model: self.product) { ratng in
                self.avgReviewIORating = ratng
                self.reviewsAPIHandler?.getAllReviewsForProduct(model: self.product) { reviews in
                    self.reviewsIOreview = reviews
                }
            }
        }
        
        if customAppSettings.sharedInstance.isFeraReviewsEnabled {
            fetchFeraReviews()
            stampedReviews.setupFeraReviewView(reviews: feraViewModel.reviewsList, ratings: feraViewModel.productRating, ratingsCount: feraViewModel.productRatingCount)
        }
        
        if customAppSettings.sharedInstance.isGrowaveReviewsIntegration {
            fetchGrowaveRatings()
        }
        
        // MARK: *** Shopify JUDGE ME Rating And Reviews
        /*if customAppSettings.sharedInstance.inAppRatingReviewJudgeMe {
         self.fetchJudgeMeProductDetails()
         }*/
    }
}

extension ProductVC {
    func fetchGrowaveAllReviews() {
        let productID = product.id.components(separatedBy: "/").last ?? ""
        growaveViewModel.fetchAllReviews(product_id: productID) {[weak self] result in
            switch result {
            case .success:
                self?.addTargets()
            case .failed(let err):
                print("Fetch all reviews err is \(err)")
            }
        }
    }
      
    func fetchGrowaveRatings() {
        let productID = product.id.components(separatedBy: "/").last ?? ""
        growaveViewModel.growaveProductScoreRequest(product_ids: productID, completion: {[weak self] result in
            switch result {
            case .success:
                self?.fetchGrowaveAllReviews()
            case .failed(let err):
                print("Fetch all reviews err is \(err)")
            }
        })
    }
    
    private func addTargets() {
        DispatchQueue.main.async {
            if customAppSettings.sharedInstance.isFeraReviewsEnabled {
                self.stampedReviews.setupFeraReviewView(reviews: self.feraViewModel.reviewsList, ratings: self.feraViewModel.productRating, ratingsCount: self.feraViewModel.productRatingCount)
                self.mainStack.insertArrangedSubview(self.stampedReviews, belowArrangedSubview: self.descriptionView)
                self.stampedReviews.loadallReview.addTarget(self, action: #selector(self.gotToGrowaveReviewListing(_:)), for: .touchUpInside)
                self.stampedReviews.writeReview.addTarget(self, action: #selector(self.gotToGrowaveWriteReview(_:)), for: .touchUpInside)
            }
            else if customAppSettings.sharedInstance.isGrowaveReviewsIntegration {
                self.stampedReviews.setupGrowaveReviewView(reviews: self.growaveViewModel.allReview, ratings: self.growaveViewModel.productRating, ratingsCount: self.growaveViewModel.productRatingCount)
                self.mainStack.insertArrangedSubview(self.stampedReviews, belowArrangedSubview: self.descriptionView)
                self.stampedReviews.loadallReview.addTarget(self, action: #selector(self.gotToGrowaveReviewListing(_:)), for: .touchUpInside)
                self.stampedReviews.writeReview.addTarget(self, action: #selector(self.gotToGrowaveWriteReview(_:)), for: .touchUpInside)
            }
            else {
                self.stampedReviews.stampedReviewDetailModel = self.stampedReviewDetailModel
                self.mainStack.insertArrangedSubview(self.stampedReviews, belowArrangedSubview: self.descriptionView)
                self.stampedReviews.loadallReview.addTarget(self, action: #selector(self.gotToGrowaveReviewListing(_:)), for: .touchUpInside)
                self.stampedReviews.writeReview.addTarget(self, action: #selector(self.gotToGrowaveWriteReview(_:)), for: .touchUpInside)
            }
        }
    }
    
    
    private func fetchCustomerDetails() -> String {
        var customerID = ""
        Client.shared.fetchCustomerDetails(completeion: {
            response,error in
            if let response = response, let id = response.customerId {
                customerID = id.components(separatedBy: "/").last ?? ""
            }else {
                self.showErrorAlert(error: error?.localizedDescription)
            }
        })
        return customerID
    }
}

extension ProductVC {
    @objc func gotToGrowaveReviewListing(_ sender: UIButton){
        let vc  = GrowaveAllReviewVC()
        vc.productId = self.product.id
        //    vc.stampedReviewDetailModel = stampedReviewDetailModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func gotToGrowaveWriteReview(_ sender: UIButton){
        let contentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "writeReviewViewController") as? writeReviewViewController
        contentVC?.product = self.product
        contentVC?.delegate = self
        self.navigationController?.pushViewController(contentVC!, animated: true)
    }
}

extension ProductVC {
    func fetchFeraRatings() {
        guard let productID = product.id.components(separatedBy: "/").last else {return}
        feraViewModel.feraProductScoreRequest(product_id: productID) { result in
            switch result {
            case .success:
                self.fetchFeraReviews()
            case .failed(let err):
                print("DEBUG: Faild with err \(err)")
            }
        }
    }
    
    func fetchFeraReviews() {
        guard let productID = product.id.components(separatedBy: "/").last else {return}
        feraViewModel.fetchFeraProductReviews(product_id: productID) { result in
            switch result {
            case .success:
                self.addTargets()
            case .failed(let err):
                print("failed with err \(err)")
            }
        }
    }
}

extension ProductVC {
    func loginTapped() {
        self.navigationController?.popViewController(animated: false) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginNavigation = storyboard.instantiateViewController(withIdentifier:"NewLoginNavigation")
            loginNavigation.modalPresentationStyle = .fullScreen
            self.present(loginNavigation, animated: true, completion: nil)
            
        }
        
    }
}
