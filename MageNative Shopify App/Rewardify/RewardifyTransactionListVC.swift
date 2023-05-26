//
//  RewardifyTransactionListVC.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 21/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class RewardifyTransactionListVC: UIViewController {
  
  var rewardifyTransactionVM  : RewardifyTransactionVM?
  let dashboardView           = RewardifyDashboardView()
  let discountCardView        = RewardifyDiscountCard()
    var discountCode = String()
  
  lazy var discountCardViewHeightAnchor = discountCardView.heightAnchor.constraint(equalToConstant: 10)
  
  lazy var generateDiscountCodeButton:UIButton = {
    let button = UIButton()
    button.backgroundColor = UIColor.AppTheme()
    button.setTitle("Generate Discount Code", for: .normal)
    button.setTitleColor(UIColor.textColor(), for: .normal)
    button.titleLabel?.font = mageFont.mediumFont(size: 15)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.cornerRadius = 5
    button.addTarget(self, action: #selector(promptForAnswer), for: .touchUpInside)
    return button
  }()
  
  lazy var showDiscountCodeButton:UIButton = {
    let button = UIButton()
    button.backgroundColor = UIColor.AppTheme()
    button.setTitle("Show All Discount Code", for: .normal)
    button.setTitleColor(UIColor.textColor(), for: .normal)
    button.titleLabel?.font = mageFont.mediumFont(size: 15)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.cornerRadius = 5
    button.addTarget(self, action: #selector(goToShowAllDiscountCode), for: .touchUpInside)
    return button
  }()
  
  lazy var transactionTable: UITableView = {
    let table = UITableView()
    table.backgroundColor = .clear
    table.translatesAutoresizingMaskIntoConstraints = false
    let nib = UINib(nibName: RewardifyTransactionTVCell.className, bundle: nil)
    table.register(nib, forCellReuseIdentifier: RewardifyTransactionTVCell.className)
    table.delegate = self
    table.dataSource = self
    return table
  }()
  
  lazy var stackViewCustom: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.distribution = .fillEqually
    stack.spacing = 10
    return stack
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadTransactions()
    setupViews()
  }
  
  @objc func see(_ sender: UIButton){
    print("Hello")
  }
  
  func loadTransactions(){
    self.view.addLoader()
    rewardifyTransactionVM = RewardifyTransactionVM()
    rewardifyTransactionVM?.delegate = self
  }
  
  func feedDashboard(){
    let currency     = rewardifyTransactionVM?.rewardifyAccountModel?.currency ?? ""
    var totalAmount  = rewardifyTransactionVM?.rewardifyAccountModel?.amount ?? "N/A"
    var totalSpend   = rewardifyTransactionVM?.rewardifyAccountModel?.customer?.totalSpent ?? "N/A"
    
    dashboardView.totalAmountVal.text = rewardifyTransactionVM?.getWithCurrency(currency, &totalAmount)
    dashboardView.totalSpendVal.text  = rewardifyTransactionVM?.getWithCurrency(currency, &totalSpend)
  }
  
  func feedDiscountCard(){
    var curr = rewardifyTransactionVM?.rewardifyDiscount?.currency ?? "N/A"
    var amount = rewardifyTransactionVM?.rewardifyDiscount?.amount ?? "N/A"
    curr = curr == "US" ? "USD" : curr
    discountCardView.discountCodeLabel.text = rewardifyTransactionVM?.rewardifyDiscount?.code ?? ""
      self.discountCode = rewardifyTransactionVM?.rewardifyDiscount?.code ?? ""
    
    if let amountWithCurr = rewardifyTransactionVM?.getWithCurrency(curr, &amount){
      discountCardView.discountAmount.text = "Discount Code generated for amount \(amountWithCurr)"
    }
    discountCardView.copyButton.addTarget(self, action: #selector(copyText(_:)), for: .touchUpInside)
  }
  
  @objc func copyText(_ sender: UIButton){
      UIPasteboard.general.string = self.discountCode
      self.view.showmsg(msg: "Copied!")
    
  }
  
  func setupViews(){
    self.title = "Rewardify Dashboard"
    self.view.backgroundColor = .white
    discountCardView.isHidden = true
    dashboardView.translatesAutoresizingMaskIntoConstraints = false
    discountCardView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(dashboardView)
    dashboardView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
    dashboardView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
    dashboardView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
    dashboardView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    
    self.view.addSubview(stackViewCustom)
    stackViewCustom.topAnchor.constraint(equalTo: dashboardView.bottomAnchor, constant: 20).isActive = true
    stackViewCustom.leadingAnchor.constraint(equalTo: dashboardView.leadingAnchor).isActive = true
    stackViewCustom.trailingAnchor.constraint(equalTo: dashboardView.trailingAnchor).isActive = true
    stackViewCustom.heightAnchor.constraint(equalToConstant: 90).isActive = true
    stackViewCustom.addArrangedSubview(showDiscountCodeButton)
    stackViewCustom.addArrangedSubview(generateDiscountCodeButton)
    
    self.view.addSubview(discountCardView)
    discountCardView.topAnchor.constraint(equalTo: stackViewCustom.bottomAnchor, constant: 10).isActive = true
    discountCardView.leadingAnchor.constraint(equalTo: dashboardView.leadingAnchor).isActive = true
    discountCardView.trailingAnchor.constraint(equalTo: dashboardView.trailingAnchor).isActive = true
    discountCardViewHeightAnchor.isActive = true
    
    self.view.addSubview(transactionTable)
    transactionTable.topAnchor.constraint(equalTo: discountCardView.bottomAnchor).isActive = true
    transactionTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    transactionTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    transactionTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
  }

  @objc func goToShowAllDiscountCode(){
      let vc = RewardifyActiveDiscountList()
      vc.modalPresentationStyle = .fullScreen
    self.navigationController?.present(vc, animated: true, completion: nil)
  }
  
  @objc func promptForAnswer() {
    let ac = UIAlertController(title: "Generate Discount Code", message: nil, preferredStyle: .alert)
    ac.addTextField { textField in
      textField.placeholder  = "Enter Amount"
      textField.keyboardType = .numberPad
    }
    
    ac.addTextField { textField in
      textField.placeholder = "Enter Memo"
    }
    
    let submitAction = UIAlertAction(title: "Submit".localized, style: .default) { [unowned ac] _ in
      let amount  = ac.textFields![0].text
      let memo    = ac.textFields![1].text
      
      guard let amount = amount else {return ac.dismiss(animated: true) {
        return
      }}
      
      guard let amountInt = Double(amount) else {return ac.dismiss(animated: true) {
        return
      }}
      
      guard let totalAmount = self.rewardifyTransactionVM?.rewardifyAccountModel?.amount else {return ac.dismiss(animated: true) {
        return
      }}
      
      guard let totalAmountInt = Double(totalAmount) else {return ac.dismiss(animated: true) {
        return
      }}
      
      guard amountInt < totalAmountInt else {return ac.dismiss(animated: true) {
        self.view.showmsg(msg: "Entered amount should be less than total amount")
        return
      }}
      self.callCode(amount: amount, memo: memo ?? "")
      
    }
    
    ac.addAction(UIAlertAction(title: "Cancel".localized, style: .default, handler: { action in
      ac.dismiss(animated: true, completion: nil)
    }))
    
    ac.addAction(submitAction)
    present(ac, animated: true)
  }
  
  func callCode(amount:String,memo:String = ""){
    rewardifyTransactionVM?.generateDiscountCode(amount: amount, memo: memo,completion: { [weak self] result in
      if result{
        self?.feedDiscountCard()
        UIView.animate(withDuration: 0.4) { [weak self] in
          self?.discountCardView.isHidden = false
          self?.discountCardViewHeightAnchor.constant = 84
          self?.view.layoutIfNeeded()
          self?.loadTransactions()
        }
      }
    })
  }
}

extension RewardifyTransactionListVC: UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rewardifyTransactionVM?.rewardifyTransactionModel?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Transaction Details"
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: RewardifyTransactionTVCell.className, for: indexPath) as! RewardifyTransactionTVCell
    cell.transaction = rewardifyTransactionVM?.rewardifyTransactionModel?[indexPath.row]
    return cell
  }
}

extension RewardifyTransactionListVC: UITableViewDelegate{
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 200
  }
}

extension RewardifyTransactionListVC: ReceivedRewardifyTransactions{
  func receivedTransactions() {
    self.view.stopLoader()
    feedDashboard()
    transactionTable.reloadData()
  }
}
