//
//  RewardifyActiveDiscountList.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 27/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RewardifyActiveDiscountList: UIViewController {
  
  var rewardifyActiveDiscountVM       : RewardifyActiveDiscountVM?
  var disposeBag                      = DisposeBag()
    
    lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "close"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.tintColor = UIColor(light: .black,dark: UIColor.provideColor(type: .SideMenuController).white)
        btn.addTarget(self, action: #selector(closeBtnTapped), for: .touchUpInside)
        return btn
    }()
    private lazy var navigationBottomLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false;
        line.backgroundColor = UIColor(hexString: "#D1D1D1")
        return line;
    }()
    lazy var headerView: UIView = {
        let view = UIView()
        view.addSubview(closeBtn)
        closeBtn.anchor(right: view.trailingAnchor, paddingRight: 8, width: 35, height: 35)
        closeBtn.centerY(inView: view)
        view.addSubview(navigationBottomLine)
        navigationBottomLine.anchor(left: view.leadingAnchor, bottom: view.bottomAnchor, right: view.trailingAnchor, paddingBottom: 2, height: 0.5)
        return view
    }()
  
  private lazy var discountTable: UITableView = {
    let table = UITableView()
    table.backgroundColor = .clear
    table.translatesAutoresizingMaskIntoConstraints = false
    let nib = UINib(nibName: RewardifyDiscountDetailTVCell.className, bundle: nil)
    table.register(nib, forCellReuseIdentifier: RewardifyDiscountDetailTVCell.className)
    table.delegate = self
    table.dataSource = self
    table.emptyDataSetSource = self
    table.emptyDataSetDelegate = self
    return table
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    loadActiveDiscount()
  }
  
  func loadActiveDiscount(){
    rewardifyActiveDiscountVM = RewardifyActiveDiscountVM()
    rewardifyActiveDiscountVM?.delegate = self
    self.view.addLoader()
  }
  
  func setupViews(){
    self.title = "Active Discount Codes"
    self.view.backgroundColor = .white
      self.view.addSubview(headerView)
    self.view.addSubview(discountTable)
      headerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingTop: 12, paddingLeft: 4,paddingRight: 10, height: 40)
    discountTable.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0).isActive = true
    discountTable.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    discountTable.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    discountTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
  }
    
    @objc func closeBtnTapped() {
        self.dismiss(animated: false)
    }
}

extension RewardifyActiveDiscountList:UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rewardifyActiveDiscountVM?.discountListingModel?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: RewardifyDiscountDetailTVCell.className, for: indexPath) as! RewardifyDiscountDetailTVCell
    let feed = rewardifyActiveDiscountVM?.discountListingModel?[indexPath.row]
    cell.discountListingModel = feed
    
    cell.revertDiscount.rx.tap.subscribe{ [weak self] (onTap) in
      self?.view.addLoader()
      self?.rewardifyActiveDiscountVM?.revertDiscount(discountID: feed?.shopifyId, completion: { [weak self] result in
        self?.view.stopLoader()
        if result{
          self?.loadActiveDiscount()
        }else{
          print("Not able to revert discount code")
        }
      })
    }.disposed(by: disposeBag)
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Active Discount codes \n Use them in checkout"
  }
}

extension RewardifyActiveDiscountList: UITableViewDelegate{
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 160
  }
}

extension RewardifyActiveDiscountList: ReceivedActiveDiscounts{
  func receivedActiveDiscounts() {
    self.view.stopLoader()
      self.discountTable.reloadData()
  }
}

extension RewardifyActiveDiscountList:DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    return NSAttributedString(string: "No discount code found")
  }
  
  func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
    return self.rewardifyActiveDiscountVM?.discountListingModel?.count == 0
  }
  
  func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    return NSAttributedString(string: "")
  }
}
