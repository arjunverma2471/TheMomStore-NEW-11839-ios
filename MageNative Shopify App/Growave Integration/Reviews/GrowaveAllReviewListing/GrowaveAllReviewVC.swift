//
//  StampedAllReviewVC.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 16/09/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class GrowaveAllReviewVC: UIViewController {
    let feraReviewViewModel = FeraViewModel()
    let growaveViewModel = GrowaveReviewsViewModel()
    var productId = String()
    var stampedReviewDetailModel: StampedReviewDetailModel?{
        didSet{
            tableView.reloadData()
        }
    }
    
    lazy var tableView : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        
        let nib = UINib(nibName: GrowaveReviewCell.className, bundle: nil)
        table.register(nib, forCellReuseIdentifier: GrowaveReviewCell.className)
        
        
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupView()
        fetchReviews()
        // Do any additional setup after loading the view.
    }
    
    private func fetchReviews() {
        if customAppSettings.sharedInstance.isFeraReviewsEnabled {
            fetchFeraReviews()
        }
        else if customAppSettings.sharedInstance.isGrowaveReviewsIntegration {
            fetchGrowaveAllReviews()
        }
        else {
            fetchStampedReviewData()
        }
    }
    
    func fetchStampedReviewData(){
        self.view.addLoader()
        let id = productId.components(separatedBy: "/").last ?? ""
        let url = "https://stamped.io/api/widget/reviews?productId=\(id)&storeUrl=\(Client.shopUrl)&apiKey=\(StampedConstant().apiPublicKey)"
        SharedNetworking.shared.sendRequestUpdated(api: url, type: .GET) { [unowned self] (result) in
            self.view.stopLoader()
            switch result{
            case .success(let data):
                do{
                    let decoder = JSONDecoder()
                    self.stampedReviewDetailModel       = try decoder.decode(StampedReviewDetailModel.self, from: data)
                    print("fetchStampedReviewData===",self.stampedReviewDetailModel?.data?.count)
                    
                }catch let error {
                    print(error)
                    //          completion(nil)
                }
            case .failure(let error):
                print(error)
                //        completion(nil)
            }
        }
    }
    
    func fetchFeraReviews() {
        guard let productID = productId.components(separatedBy: "/").last else {return}
        feraReviewViewModel.fetchFeraProductReviews(product_id: productID) {[weak self] result in
            switch result {
            case .success:
                self?.reloadTable()
            case .failed(let err):
                print("failed with err \(err)")
            }
        }
    }
    
    func fetchGrowaveAllReviews() {
        let productID = productId.components(separatedBy: "/").last ?? ""
        growaveViewModel.fetchAllReviews(product_id: productID) {[weak self] result in
            switch result {
            case .success:
                self?.reloadTable()
            case .failed(let err):
                print("Fetch all reviews err is \(err)")
            }
        }
    }
    
    private func reloadTable() {
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
        }
    }
    
    
    func setupView(){
        self.view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
}

extension GrowaveAllReviewVC: UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if customAppSettings.sharedInstance.isFeraReviewsEnabled {
            return feraReviewViewModel.reviewsList.count
        }
        else if customAppSettings.sharedInstance.isGrowaveReviewsIntegration {
            return growaveViewModel.allReview.count
        }
        else {
            return stampedReviewDetailModel?.data?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GrowaveReviewCell.className, for: indexPath) as! GrowaveReviewCell
        if customAppSettings.sharedInstance.isFeraReviewsEnabled {
            cell.feraReviewData = feraReviewViewModel.reviewsList[indexPath.item]
        }
        else if customAppSettings.sharedInstance.isGrowaveReviewsIntegration {
            cell.growaveReviewData = growaveViewModel.allReview[indexPath.item]
        }
        else {
            cell.reviewData = stampedReviewDetailModel?.data?[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
