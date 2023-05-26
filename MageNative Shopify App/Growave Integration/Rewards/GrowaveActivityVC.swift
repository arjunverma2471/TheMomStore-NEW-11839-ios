//
//  GrowaveActivityVC.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 30/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
class GrowaveActivityVC : UIViewController {
    
    private lazy var headingLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.boldFont(size: 14.0)
        label.text = "Points History".localized
        label.textAlignment = .center
        return label
    }()
    
    private lazy var mainTable : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        let nib = UINib(nibName: GrowaveActivityTableCell.className, bundle: nil)
        table.register(nib, forCellReuseIdentifier: GrowaveActivityTableCell.className)
        table.delegate = self
        table.dataSource = self
        table.emptyDataSetSource = self
        table.emptyDataSetDelegate = self
        return table
    }()
    
    //MARK: - GROWAVE TOKEN
    private let growaveToken = GrowaveTokenHandler()
    var activityModel = [GrowavePointActivityModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getPointsData()
        self.setupView()
    }
    
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(headingLabel)
        view.addSubview(mainTable)
        headingLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leadingAnchor, right: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8, height: 45)
        
        mainTable.anchor(top: headingLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leadingAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 8, paddingLeft: 8,paddingBottom: 8, paddingRight: 8)
    }
    
    func getPointsData() {
        self.view.addLoader()
        if let userID = UserDefaults.standard.value(forKey: "growaveUserId") as? String {
            growaveToken.generateTokenGrowave { token in
                NetworkHandler.shared.sendRequestUpdated(api: "https://api.growave.io/api/reward/users-activities&user_id=\(userID)",type: .GET, token: token ?? "") { (result) in
                    self.view.stopLoader()
                    switch result{
                    case .success(let data):
                      do{
                        let json                     = try JSON(data: data)
                        print("growaveSpendingRules==",json)
                          self.activityModel = json["data"].arrayValue.map({GrowavePointActivityModel(json: $0)})
                          print(self.activityModel.count)
                          self.mainTable.reloadData()
                      }catch let error {
                        print(error)
                          
                      
                      }
                    case .failure(let error):
                      print(error)
                      
                    }
                  }
            }
        }
    }
    
}


extension GrowaveActivityVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GrowaveActivityTableCell", for: indexPath) as! GrowaveActivityTableCell
        cell.setData(model: activityModel[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
    
}


extension GrowaveActivityVC:DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
      return NSAttributedString(string: "No points history".localized)
  }
  
  func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
    return activityModel.count == 0
  }
  
  func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    return NSAttributedString(string: "")
  }
}
