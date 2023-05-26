//
//  writeReviewViewController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 16/03/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import UIKit
import Cosmos


protocol ReloadReviewsData {
  func reloadRatingAndReviews()
}

class writeReviewViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let growaveViewModel = GrowaveReviewsViewModel()
    @IBOutlet weak var tableView: UITableView!
    var product : ProductViewModel?
    let feraViewModel = FeraViewModel()
    var isFromJudgeMe = false
    var judgeMeId = String()
    var customerId: String = ""
    var productId = String()
    var delegate:ReloadReviewsData?
    var selectedTitle = ""
    var isFromReviewsIO = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.dataSource=self
        self.tableView.delegate=self
        self.tableView.rowHeight = 50.0
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.reloadData()
    }
    
    //  @IBAction func closeView(_ sender: Any) {
    //    self.dismiss(animated: true, completion: nil)
    //  }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "writeReviewTableCell", for: indexPath) as? writeReviewTableCell
        if(isFromJudgeMe){
            cell?.titleTextLabel.font = mageFont.regularFont(size: 15.0)
            cell?.titleButton.titleLabel?.font = mageFont.regularFont(size: 14.0)
            cell?.titleButton.addTarget(self, action: #selector(titleButtonClicked(_:)), for: .touchUpInside)
            cell?.titleButton.layer.borderWidth = 1.0
            cell?.titleButton.layer.borderColor = UIColor.lightGray.cgColor
        }
        else{
            cell?.titleTextLabel.isHidden = true;
            cell?.titleButton.isHidden = true;
            
        }
        
        cell?.writeTeviewTxt.text = "Write A Review".localized
        cell?.fillDetailsTxt.text = "Please Fill your Details".localized
        cell?.selectRatingTxt.text = "Please Select Rating".localized
        cell?.txtLabel.text = "Please let us know your thoughts".localized
        cell?.writeTeviewTxt.font = mageFont.regularFont(size: 15.0)
        cell?.fillDetailsTxt.font = mageFont.regularFont(size: 15.0)
        cell?.selectRatingTxt.font = mageFont.regularFont(size: 15.0)
        cell?.txtLabel.font = mageFont.regularFont(size: 15.0)
        cell?.addImageBtn.setTitle("Add Images".localized, for: .normal)
        cell?.submiteBtn.setTitle("Submit Review".localized, for: .normal)
        cell?.addImageBtn.titleLabel?.font = mageFont.mediumFont(size: 15.0)
        cell?.submiteBtn.titleLabel?.font = mageFont.mediumFont(size: 15.0)
        
        cell?.reviewText.layer.borderWidth = 1.0
        cell?.reviewText.layer.borderColor = UIColor.lightGray.cgColor
        cell?.reviewText.layer.cornerRadius = 8.0
        cell?.submiteBtn.backgroundColor = UIColor.AppTheme()
        cell?.submiteBtn.setTitleColor(UIColor.textColor(), for: .normal)
        cell?.ratineView.settings.starSize = 35.0
        //   cell?.ratineView.settings.emptyBorderColor = UIColor.AppTheme()
        cell?.ratineView.settings.emptyBorderWidth = 1.0
        
        //    cell?.ratineView.settings.filledColor = UIColor.AppTheme()
        //    cell?.ratineView.settings.filledBorderColor = UIColor.AppTheme()
        cell?.ratineView.settings.filledBorderWidth = 1.0
        
        cell?.ratineView.settings.totalStars = 5
        cell?.ratineView.settings.fillMode = .half
        cell?.ratineView.rating = 0.0
        
        cell?.submiteBtn.addTarget(self, action: #selector(submitReview(_:)), for: .touchUpInside)
        
        if isFromJudgeMe == false {
            cell?.addImageBtn.isHidden=true
            cell?.addImageHeight.constant = 0.0
        }
        else {
            cell?.addImageBtn.isHidden=true
            cell?.addImageHeight.constant = 0.0
        }
        return cell!
    }
    
    
    @objc func titleButtonClicked(_ sender: UIButton){
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! writeReviewTableCell
        let dropDown = DropDown()
        var dataSource = [String]()
        dataSource = ["John Smith","John S.","J.S.", "Anonymous"]
        dropDown.dataSource = dataSource
        dropDown.selectionAction = {[unowned self](index, item) in
            sender.setTitle(item, for: UIControl.State());
            switch item{
            case "John S.":
                selectedTitle = "last_initial"
                break;
            case "J.S.":
                selectedTitle = "all_initials"
                break;
            case "Anonymous":
                selectedTitle = "anonymous"
                break;
            default:
                selectedTitle = ""
            }
            
        }
        
        dropDown.anchorView =  cell.titleButton
        dropDown.bottomOffset = CGPoint(x: 0, y:sender.bounds.height)
        // dropDown.semanticContentAttribute = Client.locale == "ar" ? .forceRightToLeft : .forceLeftToRight
        if dropDown.isHidden {
            dropDown.setAlignment(dropDown);
            let _ = dropDown.show();
        } else {
            dropDown.hide();
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func submitReview(_ sender:UIButton) {
        var url = String()
        var str = [String:String]()
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? writeReviewTableCell {
            if cell.name.text == "" || cell.email.text == "" || cell.reviewText.text == "" || cell.title.text == "" {
                self.view.makeToast("Please fill all the details", duration: 1.5, position: .center)
                return;
            }
            
            if !(cell.email.text?.isValidEmail() ?? true) {
                self.view.makeToast("Please Enter a valid Email-Id", duration: 1.5, position: .center)
                return
            }
           
            if customAppSettings.sharedInstance.isFeraReviewsEnabled {
                self.view.addLoader()
                let id = self.product?.id.components(separatedBy: "/").last ?? ""
                let name = cell.name.text ?? ""
                let email = cell.email.text ?? ""
                let heading = cell.title.text ?? ""
                let body = cell.reviewText.text ?? ""
                let rating = Int(cell.ratineView.rating)
                postFeraReview(name: name, email: email, rating: "\(rating)", heading: heading, reviewBody: body, external_product_id: id)
            }
            else if customAppSettings.sharedInstance.isGrowaveReviewsIntegration {
                self.view.addLoader()
                let id = self.product?.id.components(separatedBy: "/").last ?? ""
                let name = cell.name.text ?? ""
                let email = cell.email.text ?? ""
                let heading = cell.title.text ?? ""
                let body = cell.reviewText.text ?? ""
                let rating = Int(cell.ratineView.rating)
                postGrowaveReview(name: name, email: email, rating: rating, heading: heading, reviewBody: body, external_product_id: id)
            }
            
            else if isFromReviewsIO {
                
                url = "https://api.reviews.io/product/review/new"
                str = ["store":"\(Client.shopUrl)","rating":"\(cell.ratineView.rating)","name":"\(cell.name.text ?? "" )","email":"\(cell.email.text ?? "")","title":"\(cell.title.text ?? "")","review":"\(cell.reviewText.text ?? "")","sku":product?.variants.items.first?.sku ?? "","apikey":Client.reviewsIOApiKey]
            }
            else {
                
                if self.isFromJudgeMe == false {
                    let id = self.productId.components(separatedBy: "/").last ?? ""
                    url =
                    "https://shopifymobileapp.cedcommerce.com/index.php/shopifymobile/productreviewapi/create?mid=\(Client.merchantID)&review[rating]=\(cell.ratineView.rating)&product_id=\(id)&review[author]=\(cell.name.text ?? "")&review[email]=\(cell.email.text ?? "")&review[title]=\(cell.title.text ?? "")&review[body]=\(cell.reviewText.text!)"
                    
                }
                else {
                    
                    url = "https://judge.me/api/v1/reviews"
                    
                    str = ["shop_domain":"\(Client.shopUrl)","rating":"\(cell.ratineView.rating)","name":"\(cell.name.text ?? "" )","email":"\(cell.email.text ?? "")","title":"\(cell.title.text ?? "")","body":"\(cell.reviewText.text ?? "")","id":"\(self.judgeMeId)","platform":"shopify","reviewer_name_format":"\(selectedTitle)"]
                    
                    print(str)
                }
            }
                self.view.addLoader()
                guard let urlRequest = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?.getURL() else {return}
                print(urlRequest)
                print(str)
                var request = URLRequest(url: urlRequest)
                
                if self.isFromJudgeMe == true || self.isFromReviewsIO == true{
                    request.httpMethod = "POST"
                    let encoder = JSONEncoder()
                    if let jsonData = try? encoder.encode(str) {
                        if let parameters = String(data: jsonData, encoding: .utf8) {
                            let postData = parameters.data(using: .utf8)
                            request.httpBody=postData
                        }
                    }
                }
                else {
                    request.httpMethod="GET"
                }
                
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let task=URLSession.shared.dataTask(with: request) { (data, response, error) in
                    guard error == nil && data != nil else
                    {
                        //print(error)
                        //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
                        return;
                    }
                    
                    
                    DispatchQueue.main.async{
                        self.view.stopLoader()
                        do {
                            guard let data = data else {return}
                            guard let json = try? JSON(data: data) else {return}
                            print(json)
                            if self.isFromJudgeMe == false {
                                if json["success"].stringValue == "true" {
                                    self.view.makeToast("Thankyou for sharing your valueable feedback with us.".localized, duration: 2.0, position: .center)
                                }
                            }
                            else {
                                self.view.makeToast(json["message"].stringValue, duration: 1.0, position: .center)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                self.delegate?.reloadRatingAndReviews()
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }
                task.resume()
        }
    }
}

extension writeReviewViewController {
    func postFeraReview(name: String, email: String, rating: String, heading: String, reviewBody: String, external_product_id: String) {
        feraViewModel.feraPostReviewRequest(name: name, email: email, rating: rating, heading: heading, reviewBody: reviewBody, external_product_id: external_product_id) {[weak self] result in
            switch result {
            case .success:
                self?.showSuccessMessage()
            case .failed(let err):
                DispatchQueue.main.async {
                    self?.view.hideLoader()
                    self?.view.showmsg(msg: err)
                }
            }
        }
    }
    
    func postGrowaveReview(name: String, email: String, rating: Int, heading: String, reviewBody: String, external_product_id: String) {
        growaveViewModel.growavePostReview(email: email, name: name, product_id: external_product_id, title: heading, body: reviewBody, rate: rating) {[weak self] result in
            switch result {
            case .success:
                self?.showSuccessMessage()
            case .failed(let err):
                DispatchQueue.main.async {
                    self?.view.hideLoader()
                    self?.view.showmsg(msg: err)
                }
            }
        }
    }
    
    
    private func showSuccessMessage() {
        DispatchQueue.main.async {[weak self] in
            self?.view.hideLoader()
            self?.view.makeToast("Thankyou for sharing your valueable feedback with us.".localized, duration: 5.0, position: .center)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.delegate?.reloadRatingAndReviews()
            self.navigationController?.popViewController(animated: true)
        }
    }
}


