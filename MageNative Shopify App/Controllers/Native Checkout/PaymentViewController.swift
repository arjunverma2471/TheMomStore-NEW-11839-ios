//
//  PaymentViewController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 29/04/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
import MobileBuySDK
class PaymentViewController : UIViewController {
    
    var checkout : CheckoutViewModel!
    var shippingRate : ShippingRateViewModel!
    let paymentView = PaymentCardView()
    var email = ""
    private lazy var topHeading : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ADD CREDIT/DEBIT CARD".localized
        label.font = mageFont.boldFont(size: 15.0)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var scrollView : UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var stackView : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        stack.distribution = .fill
        stack.axis = .vertical
        return stack
    }()

    
    private lazy var continueButton : Button = {
        let button = Button()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CONTINUE".localized, for: .normal)
        button.titleLabel?.font = mageFont.mediumFont(size: 15.0)
        button.addTarget(self, action: #selector(continuePayment(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    func initView() {
        view.backgroundColor = .white
        self.view.addSubview(scrollView)
        self.view.addSubview(topHeading)
        self.scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topHeading.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topHeading.topAnchor.constraint(equalTo: view.topAnchor),
            topHeading.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topHeading.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topHeading.heightAnchor.constraint(equalToConstant: 45),
            stackView.topAnchor.constraint(equalTo: topHeading.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -8),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            
        ])
        self.addSubviews()
    }
    
    
    func addSubviews() {
       
        paymentView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(paymentView)
        paymentView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        stackView.addArrangedSubview(continueButton)
        continueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func continuePayment(_ sender : UIButton) {
        
        if paymentView.firstName.text == "" {
            self.view.showmsg(msg: "Please enter first name".localized)
            return
        }
        if paymentView.cardNumber.text == "" {
            self.view.showmsg(msg: "Please enter card number".localized)
            return;
        }
        if paymentView.month.text == "" {
            self.view.showmsg(msg: "Please enter expiry month".localized)
            return;
        }
        if paymentView.year.text == "" {
            self.view.showmsg(msg: "Please enter expiry year".localized)
            return;
        }
        if paymentView.cvvNumber.text == "" {
            self.view.showmsg(msg: "Please enter CVV number".localized)
            return;
        }
        let details = [
            "firstName":paymentView.firstName.text ?? "",
            "middleName":"",
            "lastName":paymentView.lastName.text ?? "",
            "cardNumber":paymentView.cardNumber.text ?? "",
            "expiryMonth":paymentView.month.text ?? "",
            "expiryYear":paymentView.year.text ?? "",
            "cvv":paymentView.cvvNumber.text ?? ""
            
        ]
        self.view.addLoader()
        Client.shared.getPaymentToken(cardDetails: details , checkout : checkout, shippingRate: shippingRate, email : self.email) { response, error in
            if let error=error, error.count > 0 {
                self.view.stopLoader()
                self.showErrorAlert(errors: error)
            }
            else if let response = response {
                self.view.stopLoader()
                Client.shared.fetchCompletedOrder(response.id) { respo in
                    self.view.stopLoader()
                    let order = respo
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let orderViewControl:OrderDetailsViewController = storyboard.instantiateViewController()
                    orderViewControl.paymentOrder = order
                    orderViewControl.isfromNativeCheckout = true
                    self.navigationController?.pushViewController(orderViewControl, animated: true)
                    CartManager.shared.deleteAll()
                    
                }
            }
        }
    }
    
}
