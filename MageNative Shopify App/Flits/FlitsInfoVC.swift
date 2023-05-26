//
//  FlitsInfoVC.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 25/07/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FlitsInfoVC: UIViewController {
  
  enum FlitsInfoResults{
    case isEarned
    case  isSpend
  }
  
  let disposeBag = DisposeBag()
  
  var flitsInfoManager : FlitsProfileManager?
  var activeCase       = FlitsInfoResults.isEarned {
    didSet{
      if activeCase == .isEarned{
        howToEarn.setTitleColor(UIColor.textColor(), for: .normal)
        howToEarn.backgroundColor = UIColor.AppTheme()
        howToSpend.setTitleColor(UIColor.AppTheme(), for: .normal)
        howToSpend.backgroundColor = UIColor.textColor()
      }else{
        howToSpend.setTitleColor(UIColor.textColor(), for: .normal)
        howToSpend.backgroundColor = UIColor.AppTheme()
        howToEarn.setTitleColor(UIColor.AppTheme(), for: .normal)
        howToEarn.backgroundColor = UIColor.textColor()
      }
    }
  }
  
  
  
  lazy var howToEarn:UIButton = {
    let button = UIButton(type: .system)
    button.backgroundColor = UIColor.textColor()
    button.setTitle("How to Earn", for: .normal)
    button.setTitleColor(UIColor.AppTheme(), for: .normal)
    button.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 13)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.rx.tap.subscribe { [weak self] (onTap) in
      button.setTitleColor(UIColor.textColor(), for: .normal)
      self?.activeCase = FlitsInfoResults.isEarned
      self?.detailTable.reloadData()
    }.disposed(by: disposeBag)
    return button
  }()
  
  lazy var howToSpend:UIButton = {
    let button = UIButton(type: .system)
    button.backgroundColor = UIColor.textColor()
    button.setTitle("How to Spend", for: .normal)
    button.setTitleColor(UIColor.AppTheme(), for: .normal)
    button.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 13)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.rx.tap.subscribe { [weak self] (onTap) in
      self?.activeCase = FlitsInfoResults.isSpend
      self?.detailTable.reloadData()
    }.disposed(by: disposeBag)
    return button
  }()
  
  
  lazy var stackViewCustom: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .horizontal
    stack.distribution = .fillEqually
    stack.spacing = 10
    return stack
  }()
  
  lazy var detailTable: UITableView = {
      let table = UITableView()
      table.backgroundColor = .clear
      table.separatorStyle = .none
      table.translatesAutoresizingMaskIntoConstraints = false
    let nib = UINib(nibName: FlitsInfoTVCell.className, bundle: nil)
    table.register(nib, forCellReuseIdentifier: FlitsInfoTVCell.className)
      table.delegate = self
      table.dataSource = self
      return table
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    fetchData()
  }
  
  func fetchData(){
    self.view.addLoader()
    flitsInfoManager = FlitsProfileManager()
    flitsInfoManager?.getRules(completion: { [weak self] feed in
      self?.view.stopLoader()
      guard feed != nil else {return}
      self?.detailTable.reloadData()
    })
  }
  
  func setupView(){
    self.activeCase = FlitsInfoResults.isEarned
      self.title = "Manage Credits".localized
      self.view.backgroundColor = UIColor(light: .white,dark: UIColor.black)
    self.view.addSubview(stackViewCustom)
    stackViewCustom.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
    stackViewCustom.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
    stackViewCustom.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    stackViewCustom.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    stackViewCustom.addArrangedSubview(howToEarn)
    stackViewCustom.addArrangedSubview(howToSpend)
    
    self.view.addSubview(detailTable)
    detailTable.topAnchor.constraint(equalTo: stackViewCustom.bottomAnchor, constant: 10).isActive = true
    detailTable.leadingAnchor.constraint(equalTo: stackViewCustom.leadingAnchor).isActive = true
    detailTable.trailingAnchor.constraint(equalTo: stackViewCustom.trailingAnchor).isActive = true
    detailTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    
  }
}

extension FlitsInfoVC: UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch activeCase {
    case .isEarned:
      return flitsInfoManager?.flitsEarnedInfo?.count ?? 0
    case .isSpend:
      return flitsInfoManager?.flitsSpendinfo?.count ?? 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FlitsInfoTVCell.className, for: indexPath) as! FlitsInfoTVCell
    switch activeCase {
    case .isEarned:
      let feed = flitsInfoManager?.flitsEarnedInfo?[indexPath.row]
      cell.infoData = feed
    case .isSpend:
      let feed = flitsInfoManager?.flitsSpendinfo?[indexPath.row]
      cell.infoData = feed
    }
    return cell
  }
}

extension FlitsInfoVC: UITableViewDelegate{
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}
