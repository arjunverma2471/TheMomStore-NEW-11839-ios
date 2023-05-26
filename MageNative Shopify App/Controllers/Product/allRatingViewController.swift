//
//  allRatingViewController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 20/03/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import UIKit

class allRatingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var ratingData = [[String:String]]()
    var productname = String()
    var productId = String()
    var page = 1
    var loadMoreData = true
    var shopId = ""
    var isFromShopifyRating=true
    var productJudgeMeId=String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.topLabel.text = productname
        self.topLabel.font = mageFont.mediumFont(size: 15.0)
        if isFromShopifyRating {
            self.fetchReviewData(productId: productId, page: "\(1)")
        }else if(shopId != ""){
            getAliReviews(page: 1)
        }
        else {
            fetchJudgeMeReviewData(page:"\(1)")
        }
        self.tableView.dataSource=self
        self.tableView.delegate=self
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
                else {
                    self.fetchJudgeMeReviewData(page: "\(self.page)")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ratingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allRatingTableCell", for: indexPath) as? allRatingTableCell
        cell?.configureData(ratingData: self.ratingData[indexPath.row])
        cell?.cardView()
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
                            let review_title = values["title"].stringValue
                            let reviewer_name = values["reviewer"]["name"].stringValue
                            let rating = values["rating"].stringValue
                            let review_date = values["created_at"].stringValue
                            let content = values["body"].stringValue
                            let id = values["id"].stringValue
                            
                            self.ratingData.append(["review_title":review_title,"reviewer_name":reviewer_name,"rating":rating,"review_date":review_date,"id":id,"content":content])
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
            "https://alireviews.fireapps.io/comment/get_review?shop_id=\(shopId)&product_id=\(productId )&currentPage=\(page)"
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
}
