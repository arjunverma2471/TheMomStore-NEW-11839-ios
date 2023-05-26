//
//  NetworkErrorVC.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 02/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class NetworkErrorVC: UIViewController {

  lazy var containerView:UIView = {
    let v = UIView()
    v.backgroundColor = DynamicColor.systemBackground
    v.translatesAutoresizingMaskIntoConstraints = false
    return v
  }()
  
  lazy var noInternetImage:UIImageView = {
    let v = UIImageView()
    v.translatesAutoresizingMaskIntoConstraints = false
    v.image = UIImage(named: "nointernet")
    return v
  }()
  
  lazy var noConnectionLabel:UILabel = {
    let v = UILabel()
    v.translatesAutoresizingMaskIntoConstraints = false
    v.textAlignment = .center
    v.text = "No Internet Connection"
    v.textAlignment = .center
    v.font = mageFont.boldFont(size: 16)
    return v
  }()
  
  lazy var noConnectionSubLabel:UILabel = {
    let v = UILabel()
    v.translatesAutoresizingMaskIntoConstraints = false
    v.textAlignment = .center
    v.text = """
            Slow or no internet connection
            Please check
            """
    v.numberOfLines = 0
    v.font = mageFont.regularFont(size: 14)
    v.textAlignment = .center
    v.textColor =  UIColor(hexString: "#6B6B6B")
    return v
  }()
  
  lazy var retryButton:UIButton = {
      let button = UIButton(type: .system)
      button.setTitle("Retry", for: .normal)
      button.setTitleColor(.white, for: .normal)
      button.titleLabel?.font = mageFont.regularFont(size: 14)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.backgroundColor = UIColor.AppTheme()
      button.isHidden = true
      return button
  }()

    override func viewDidLoad() {
      super.viewDidLoad()
      self.view.backgroundColor = .white
      self.title                = "NetworkErrorVC"
      setupView()
    }
  
  func setupView(){
    self.view.addSubview(containerView)
    containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    
    self.containerView.addSubview(noInternetImage)
    noInternetImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -150).isActive = true
    noInternetImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
    noInternetImage.heightAnchor.constraint(equalToConstant: 175).isActive  = true
    noInternetImage.widthAnchor.constraint(equalToConstant: 175).isActive   = true
    
    self.containerView.addSubview(noConnectionLabel)
    noConnectionLabel.topAnchor.constraint(equalTo: noInternetImage.bottomAnchor, constant: 40).isActive = true
    noConnectionLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
    noConnectionLabel.heightAnchor.constraint(equalToConstant: 30).isActive  = true
    noConnectionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive   = true
    noConnectionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
    
    self.containerView.addSubview(noConnectionSubLabel)
    noConnectionSubLabel.topAnchor.constraint(equalTo: noConnectionLabel.bottomAnchor, constant: 5).isActive = true
    noConnectionSubLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
    noConnectionSubLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive   = true
    noConnectionSubLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
    
    self.containerView.addSubview(retryButton)
    retryButton.topAnchor.constraint(equalTo: noConnectionSubLabel.bottomAnchor, constant: 15).isActive = true
    retryButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
    retryButton.heightAnchor.constraint(equalToConstant: 48).isActive  = true
    retryButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive   = true
    retryButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
  }
}
