//
//  FlitsCreditVC.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 09/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class FlitsCreditVC: UIViewController {
  
  lazy var creditTable: UITableView = {
    let table = UITableView()
    table.backgroundColor = .clear
    table.separatorStyle  = .none
    
    table.translatesAutoresizingMaskIntoConstraints = false
    let nib = UINib(nibName: CreditDetailTVCell.className, bundle: nil)
    table.register(nib, forCellReuseIdentifier: CreditDetailTVCell.className)
    
    let nib1 = UINib(nibName: RecentTransactionHeaderTVCell.className, bundle: nil)
    table.register(nib1, forCellReuseIdentifier: RecentTransactionHeaderTVCell.className)
    
    let nib2 = UINib(nibName: RecentTransactionDetailTVCell.className, bundle: nil)
    table.register(nib2, forCellReuseIdentifier: RecentTransactionDetailTVCell.className)
    
    table.delegate = self
    table.dataSource = self
    return table
  }()
  
  lazy var manageCredits:UIButton = {
    let button = UIButton(type: .system)
    button.backgroundColor = UIColor.AppTheme()
      button.setTitle("Manage Credits".localized, for: .normal)
    button.setTitleColor(UIColor.textColor(), for: .normal)
    button.titleLabel?.font = mageFont.mediumFont(size: 15)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(goToManageCredits), for: .touchUpInside)
    return button
  }()
  
  var flitsCreditViewModel : FlitsCreditViewModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addLoader()
    flitsCreditViewModel = FlitsCreditViewModel()
    flitsCreditViewModel?.delegate = self
    setupViews()
  }
  
  @objc func goToManageCredits(sender: UIButton){
    self.navigationController?.pushViewController(FlitsInfoVC(), animated: true)
  }
  
  func setupViews(){
      self.title = "My Credits".localized
      self.view.backgroundColor = UIColor(light: .white,dark: UIColor.black)
    self.view.addSubview(manageCredits)
    manageCredits.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
//    manageCredits.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    manageCredits.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
    manageCredits.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8).isActive = true
    manageCredits.heightAnchor.constraint(equalToConstant: 40).isActive = true
    self.view.addSubview(creditTable)
    creditTable.topAnchor.constraint(equalTo: self.manageCredits.bottomAnchor, constant:8).isActive = true
    creditTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    creditTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    creditTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
  }
}

extension FlitsCreditVC: UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section{
    case 0:   return flitsCreditViewModel?.flitsCreditTypes.count ?? 0
    case 1:   return (flitsCreditViewModel?.creditLogCount ?? 0) + 1
    default:  return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: CreditDetailTVCell.className, for: indexPath) as! CreditDetailTVCell
      if let type = flitsCreditViewModel?.flitsCreditTypes[indexPath.row]{
      cell.creditType.text  = type
      cell.creditValue.text = flitsCreditViewModel?.creditDetail[type]
        return cell
      }else{
        return UITableViewCell()
      }
    case 1:
      switch indexPath.row {
      case 0:
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentTransactionHeaderTVCell.className, for: indexPath)
        return cell
      default:
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentTransactionDetailTVCell.className, for: indexPath) as! RecentTransactionDetailTVCell
        let data = flitsCreditViewModel?.flitsCreditModel?.customer?.creditLog?[indexPath.row - 1]
        cell.creditLog = data
        return cell
      }
    default: return UITableViewCell()
    }
  }
}

extension FlitsCreditVC: UITableViewDelegate{
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section{
    case 1:
      switch indexPath.row {
      case 0:   return
      default:  return print(indexPath.section,indexPath.row)
      }
    default: return
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section{
    case 1:
      switch indexPath.row{
      case 0:  return 150
      default: return 135
      }
    default:
      return 150
    }
  }
}

extension FlitsCreditVC: StoreCreditReceived{
  func storeCreditReceived() {
    self.view.stopLoader()
    self.creditTable.reloadData()
  }
}

