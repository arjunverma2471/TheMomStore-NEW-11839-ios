//
//  ShippingMethodViewController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 29/04/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
import MobileBuySDK
class ShippingMethodViewController : UIViewController {
    
    private lazy var topHeading : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "SHIPPING RATES".localized
        label.font = mageFont.boldFont(size: 15.0)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var tableView : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(ShippingMethodTableCell.self, forCellReuseIdentifier: ShippingMethodTableCell.className)
        tv.dataSource = self;
        tv.delegate = self;
        return tv;
        
    }()
    
    private lazy var continueButton : Button = {
        let button = Button()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CONTINUE".localized, for: .normal)
        button.titleLabel?.font = mageFont.mediumFont(size: 15.0)
        button.addTarget(self, action: #selector(continueButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    var availableShippingRate = [ShippingRateViewModel]()
    var checkoutId : GraphQL.ID!
    var selectedMethod = 0
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        tableView.reloadData()
    }
    
    func setupView() {
        view.backgroundColor = .white
        self.view.addSubview(topHeading)
        self.view.addSubview(tableView)
        self.view.addSubview(continueButton)
        NSLayoutConstraint.activate([
            topHeading.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            topHeading.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            topHeading.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            topHeading.heightAnchor.constraint(equalToConstant: 45),
            continueButton.leadingAnchor.constraint(equalTo: topHeading.leadingAnchor),
            continueButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            continueButton.trailingAnchor.constraint(equalTo: self.topHeading.trailingAnchor),
            continueButton.heightAnchor.constraint(equalToConstant: 45),
            tableView.leadingAnchor.constraint(equalTo: topHeading.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: self.topHeading.bottomAnchor, constant: -4),
            tableView.trailingAnchor.constraint(equalTo: topHeading.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.continueButton.topAnchor, constant: 0)
        ])
    }
    
    @objc func continueButtonPressed(_ sender : UIButton) {
        self.view.addLoader()
        let handle = availableShippingRate[selectedMethod].handle
        Client.shared.checkoutShippingLineUpdate(checkoutID: checkoutId, shippingRAteHandle: handle) { response, error in
            self.view.stopLoader()
            if let _ = response {
                
                let vc = PaymentViewController()
                vc.checkout = response
                vc.shippingRate = self.availableShippingRate[self.selectedMethod]
                vc.email = self.email
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}


extension ShippingMethodViewController : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableShippingRate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShippingMethodTableCell.className, for: indexPath) as! ShippingMethodTableCell
        cell.initView()
        cell.setupData(model: self.availableShippingRate[indexPath.row])
        if selectedMethod == indexPath.row {
            cell.radioImageView.image = UIImage(named: "radio_checked")
        }
        else {
            cell.radioImageView.image = UIImage(named: "radio_unchecked")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.selectedMethod = indexPath.row
    self.tableView.reloadData()
  }
}
