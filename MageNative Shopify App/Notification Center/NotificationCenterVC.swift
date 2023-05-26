//
//  NotificationCenterVC.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 02/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
class NotificationCenterVC : UIViewController {
    
    
    private lazy var mainTable : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        let nib = UINib(nibName: NotificationCenterTVCell.className, bundle: nil)
        table.register(nib, forCellReuseIdentifier: "NotificationCenterTVCell")
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    var notifHandler : NotificationNetworking?
    var notificationsData: [NotificationSendModel]?
    var page = 1;
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setView()
        notifHandler = NotificationNetworking()
        self.view.addLoader()
        self.page = 1;
        self.notificationsData = []
        self.loadData()
       
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    func loadData() {
        notifHandler?.getNotificationCenterData(page: page){ [weak self] json in
            guard let json = json else {return}
            if json["success"].stringValue == "true" && json["data"]["send"].arrayValue.count > 0{
                if self?.page == 1 {
                    let dataArr = json["data"]["send"].arrayValue.filter{ $0["notification_data"].stringValue != "" }
                    self?.notificationsData = dataArr.map{NotificationSendModel(json: $0)}
                }
                else {
                    let dataArr = json["data"]["send"].arrayValue.filter{ $0["notification_data"].stringValue != "" }
                    self?.notificationsData?.append(contentsOf: dataArr.map{NotificationSendModel(json: $0)})
                }
                DispatchQueue.main.async {
                    self?.view.stopLoader()
                    self?.mainTable.reloadData()
                    if self?.isViewLoaded ?? false && (self?.view.window != nil) && json["data"]["send"].arrayValue.count != 0 {
                        print("✅ViewController is visible")
                        self?.loadMoreData()
                    }
                }
            }
            else if json["success"].stringValue == "false"{
                self?.notificationsData = []
                DispatchQueue.main.async {
                    self?.view.stopLoader()
                    self?.mainTable.emptyDataSetSource = self
                    self?.mainTable.emptyDataSetDelegate = self
                    self?.mainTable.reloadEmptyDataSet()
                }
            }
            
        }
    }
    
    func loadMoreData() {
        page += 1;
        loadData()
    }
    
    
    
    
    func setView() {
        view.backgroundColor = .white
        view.addSubview(mainTable)
        mainTable.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    
    
}
extension NotificationCenterVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsData?.count ?? 0 > 0 ? notificationsData?.count ?? 0 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCenterTVCell", for: indexPath) as! NotificationCenterTVCell
        cell.selectionStyle = .none
        cell.setData(data: notificationsData?[indexPath.row])
        cell.updateInterface = {
            
            for (index,_) in (self.notificationsData ?? []).enumerated() where indexPath.row != index{
                self.notificationsData?[index].isExpanded = false
            }
            
            if self.notificationsData?[indexPath.row].isExpanded == true {
                self.notificationsData?[indexPath.row].isExpanded = false
            }
            else {
                self.notificationsData?[indexPath.row].isExpanded = true
            }
            
            
            tableView.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = notificationsData?[indexPath.row] {
            if let dat = data.notification_data?.convertToDictionary() {
                let link_type = dat["link_type"] as? String ?? ""
                let link_value = dat["link_id"] as? String ?? ""
                switch link_type {
                case "collection" :
                    let coll = collection(id: link_value, title: link_type)
                    let vc = ProductListVC()
                    vc.isfromHome = true
                    vc.collect = coll
                    self.navigationController?.pushViewController(vc, animated: false)
                case "product":
                    let viewController=ProductVC()
                    let str="gid://shopify/Product/"+(link_value)
                    viewController.productId = str
                    viewController.isProductLoading = true
                    self.navigationController?.pushViewController(viewController, animated: false)
                    UIView.transition(from: self.view, to: viewController.view, duration: 0.85, options: [UIView.AnimationOptions.transitionCrossDissolve])
                case "web_address" :
                    let story = UIStoryboard(name: "Main", bundle: nil)
                    let vc : WebViewController = story.instantiateViewController()
                    vc.url = link_value.getURL()
                    self.navigationController?.pushViewController(vc, animated: false)
                default :
                    print("default")
                }
                
            }
        }
    }
    
    
}


extension NotificationCenterVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return notificationsData?.count == 0
    }
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        let custom = EmptyView()
        custom.delegate = self;
        custom.configure(imageName: "emptyCart", title: EmptyData.notificationTitle.localized, subtitle: "")
        return custom;
    }
    
}
