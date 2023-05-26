//
//  NativeAddressListing.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 13/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class NativeAddressListing: UIViewController {
  
  var nativeAddressViewModel: NativeAddressViewModel?
  var email                 = String()
  var checkoutID            = GraphQL.ID(rawValue: "")
  
  lazy var tableView: UITableView = {
    let table = UITableView()
    table.backgroundColor = .clear
    table.separatorStyle = .none
    table.translatesAutoresizingMaskIntoConstraints = false
    let nib = UINib(nibName: NativeAddressListTVCell.className, bundle: nil)
    table.register(nib, forCellReuseIdentifier: NativeAddressListTVCell.className)
    let nib1 = UINib(nibName: NativeAddAddressTVCelll.className, bundle: nil)
    table.register(nib1, forCellReuseIdentifier: NativeAddAddressTVCelll.className)
    table.delegate = self
    table.dataSource = self
    return table
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initiateSetup()
    setupView()
  }
  
  func initiateSetup(){
    nativeAddressViewModel = NativeAddressViewModel()
    nativeAddressViewModel?.delegate = self
    if Client.shared.isAppLogin(){
      nativeAddressViewModel?.loadAddresses()
    }
  }
  
  func setupView(){
    self.title = "Select Address"
    self.view.backgroundColor = DynamicColor.systemBackground
    self.view.addSubview(tableView)
    tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
    tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
    tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
    tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
    
  }
}


extension NativeAddressListing: UITableViewDataSource,UITableViewDelegate{
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section{
    case 0  : return nativeAddressViewModel?.addresses?.items.count ?? 0 > 0 ? 1 : 0
    case 1  : return 1
    default : return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section{
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: NativeAddressListTVCell.className, for:indexPath) as! NativeAddressListTVCell
      cell.parent = self
      cell.emailReceived = email
      cell.checkoutID = checkoutID
      cell.setupView()
      cell.addresses = self.nativeAddressViewModel?.addresses
      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: NativeAddAddressTVCelll.className, for:indexPath) as! NativeAddAddressTVCelll
      cell.emailReceived = email
      cell.checkoutID = checkoutID
      cell.parent = self
      return cell
    default: return UITableViewCell()
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section{
    case 0: return 150
    case 1: return 550
    default: return 0
    }
  }
}

extension NativeAddressListing: AddressUpdatesDelegate{
  func addressUpdate() {
    tableView.reloadData()
  }
}
