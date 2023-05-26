//
//  AllReviewsViewController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 20/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
class AllReviewsViewController : UIViewController , UITableViewDataSource , UITableViewDelegate {
    
    var isFromShopifyRating=false
    
    var ratingData = [[String:String]]()
    var productname = String()
    var productId = String()
    var page = 1
    var loadMoreData = true
    var shopId = ""
    var productJudgeMeId=String()
    var isFromReviewsIO = false
    var product : ProductViewModel!
    
    lazy var tableView : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(AllReviewTableCell.self, forCellReuseIdentifier: AllReviewTableCell.className)
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    lazy var scrollView : UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    lazy var stackView : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var mainHeading : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.mediumFont(size: 14.0)
        label.text = "Customer Review".localized
        return label
    }()
    
    var imagesArray = [[[String:String]]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        if isFromShopifyRating {
            self.fetchReviewData(productId: productId, page: "\(1)")
        }else if(shopId != ""){
            getAliReviews(page: 1)
        }
        else if isFromReviewsIO{
            reviewsIOdata(page: 1)
        }
        else {
            fetchJudgeMeReviewData(page:"\(1)")
        }
    }
    
    func initView() {
        view.backgroundColor = .white
        self.view.addSubview(mainHeading)
        self.view.addSubview(tableView)
        
        mainHeading.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16, height: 45)
        tableView.anchor(top: mainHeading.bottomAnchor, left: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)

        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ratingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllReviewTableCell.className, for: indexPath) as! AllReviewTableCell
        if(productJudgeMeId != ""){
            cell.configureData(ratingData: self.ratingData[indexPath.row], pictures: imagesArray[indexPath.row])
        }
        else if isFromReviewsIO {
            cell.configureData(ratingData: self.ratingData[indexPath.row], pictures: nil)
        }
        else{
            cell.configureData(ratingData: self.ratingData[indexPath.row], pictures: nil)
        }
        cell.parent = self;
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maximumOffset - currentOffset) <= 40 {
            if self.loadMoreData {
                self.page += 1
                if isFromShopifyRating {
                    self.fetchReviewData(productId: productId, page: "\(self.page)")
                }
                else if(shopId != ""){
                    getAliReviews(page: self.page)
                }
                else if isFromReviewsIO {
                    reviewsIOdata(page: self.page)
                }
                else {
                    self.fetchJudgeMeReviewData(page: "\(self.page)")
                }
            }
        }
    }
    
    
    func fetchReviewData(productId:String,page:String) {
        let id = productId.components(separatedBy: "/").last ?? ""
        let url =
            "https://shopifymobileapp.cedcommerce.com/index.php/shopifymobile/productreviewapi/product?mid=\(Client.merchantID)&product_id=\(id)&page=\(page)&tt=\(Date().timeIntervalSince1970)"
        self.view.addLoader()
        guard let urlRequest = url.getURL() else {return}
        var request = URLRequest(url: urlRequest)
        request.httpMethod="GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task=URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil && data != nil else
            {
                self.view.stopLoader()
                return;
            }
            // check for http errors
            if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode/100 != 2
            {
                DispatchQueue.main.async {
                    self.view.stopLoader()
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                }
                return;
            }
            DispatchQueue.main.async{
                do {
                    self.view.stopLoader()
                    guard let data = data else {return}
                    guard let json = try? JSON(data: data) else {return}
                    print(json)
                    
                    if json["success"].stringValue == "true" {
                        if json["data"]["reviews"].arrayValue.count > 0 {
                            for values in json["data"]["reviews"].arrayValue {
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
                        else {
                            self.loadMoreData=false
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
        task.resume()
    }
    
    
    func fetchJudgeMeReviewData(page:String) {
        let url =
        "https://judge.me/api/v1/reviews?api_token=\(Client.judgemeApikey)&shop_domain=\(Client.shopUrl)&per_page=10&page=\(page)&product_id=\(self.productJudgeMeId)"
        self.view.addLoader()
        guard let urlRequest = url.getURL() else {return}
        var request = URLRequest(url: urlRequest)
        request.httpMethod="GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task=URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil && data != nil else
            {
                self.view.stopLoader()
                return;
            }
            
            // check for http errors
            if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode/100 != 2
            {
                DispatchQueue.main.async {
                    self.view.stopLoader()
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                }
                return;
            }
            DispatchQueue.main.async{
                do {
                    self.view.stopLoader()
                    guard let data = data else {return}
                    guard let json = try? JSON(data: data) else {return}
                    print(json)
                    if json["reviews"].arrayValue.count > 0 {
                        for values in json["reviews"].arrayValue {
                            if(values["curated"].stringValue == "ok" && values["hidden"].stringValue == "false"){
                                let review_title = values["title"].stringValue
                                let reviewer_name = values["reviewer"]["name"].stringValue
                                let rating = values["rating"].stringValue
                                let review_date = values["created_at"].stringValue
                                let content = values["body"].stringValue
                                let id = values["id"].stringValue
                                
                                self.ratingData.append(["review_title":review_title,"reviewer_name":reviewer_name,"rating":rating,"review_date":review_date,"id":id,"content":content])
                                var imageStr = [[String:String]]()
                                for index in values["pictures"].arrayValue{
                                    if(index["hidden"].stringValue == "false"){
                                        imageStr.append(["small":index["urls"]["small"].stringValue,"original":index["urls"]["original"].stringValue])
                                    }
                                }
                                self.imagesArray.append(imageStr)
                            }
                            
                        }
                    }
                    else {
                        self.loadMoreData=false
                    }
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
    }
    
    func getAliReviews(page: Int){
        let url =
            "https://alireviews.fireapps.io/comment/get_review?shop_id=\(shopId)&product_id=\(productId)&currentPage=\(page)"
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
                    guard let json = try? JSON(data:data) else {return;}
                    print(json)
                    
                    //self.aliReviews = try decoder.decode(Alireviews.self, from: data)
                    
                    print(json)
                    if(json["status"].stringValue == "true"){
                        if json["data"]["data"].arrayValue.count > 0 {
                            for values in json["data"]["data"].arrayValue {
                                let review_title = ""
                                let reviewer_name = values["author"].stringValue
                                let rating = values["star"].stringValue
                                let review_date = values["created_at"].stringValue
                                let content = values["content"].stringValue
                                let id = values["product_id"].stringValue
                                
                                self.ratingData.append(["review_title":review_title,"reviewer_name":reviewer_name,"rating":rating,"review_date":review_date,"id":id,"content":content])
                            }
                        }
                        self.tableView.reloadData()
                    }
                    
                    
                }
                
                self.tableView.reloadData()
                
            }
        })
        task.resume()
    }
    
    
    
    func reviewsIOdata(page:Int) {
        var skuStr = ""
        for items in product.variants.items {
            skuStr+=(items.sku ?? "")+";"
        }
        
        SharedNetworking.shared.sendRequestUpdated(api: "https://api.reviews.io/reviews?store=\(Client.shopUrl)&sku=\(skuStr)&type=product_review&page=\(page)",type:.GET) { (result) in
            switch result{
            case .success(let data):
              do{
                let json                     = try JSON(data: data)
                print("allReviewIO==",json)
                  if json["reviews"].arrayValue.count > 0 {
                      for values in json["reviews"].arrayValue {
                          let review_title = ""
                          let reviewer_name = values["author"]["name"].stringValue
                          let rating = values["rating"].stringValue
                          let review_date = values["date_created"].stringValue
                          let content = values["title"].stringValue
                
                          
                          self.ratingData.append(["review_title":review_title,"reviewer_name":reviewer_name,"rating":rating,"review_date":review_date,"content":content])
                      }
                  }
                  else {
                      self.loadMoreData=false
                  }
                  self.tableView.reloadData()
                
               
              }catch let error {
                print(error)
                 
                
              }
            case .failure(let error):
                print(error)
                
               
            }
          }
        
    }
    
    
}
