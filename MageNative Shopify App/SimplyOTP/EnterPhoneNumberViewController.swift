//
//  EnterPhoneNumberViewController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 30/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import UIKit

class EnterPhoneNumberViewController: UIViewController {
    let simplyOTPViewModel = SimplyOTPViewModel()
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "header")?.withRenderingMode(.alwaysOriginal)
        return imageView
    }()
    
    fileprivate let pinTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.textColor = UIColor.AppTheme()
        textField.layer.borderWidth = 1
        textField.textAlignment = .center
        textField.clipsToBounds = true
        textField.isUserInteractionEnabled = false
        textField.text = "+91 "
        textField.font = mageFont.mediumFont(size: 16)
        return textField
    }()
    
    fileprivate let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor(light: UIColor(hexString: "#050505", alpha: 1),dark: UIColor.provideColor(type: .newLoginVC).textColor).cgColor
        textField.textColor = UIColor.AppTheme()
        textField.layer.borderWidth = 2
        textField.textAlignment = .left
        textField.clipsToBounds = true
        textField.placeholder = "Enter Phone Number".localized
        textField.font = mageFont.mediumFont(size: 16)
        textField.keyboardType = .numberPad
        textField.setLeftPaddingPoints(15)
        textField.setRightPaddingPoints(15)
        return textField
    }()
    
    fileprivate lazy var getOTPButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .AppTheme()
        button.cardView()
        button.setTitle("SEND OTP".localized, for: .normal)
        button.titleLabel?.font = mageFont.mediumFont(size: 14)
        button.tintColor = .white
        button.addTarget(self, action: #selector(getOTPTapped), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var signInLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(light: UIColor(hexString: "#050505", alpha: 1),dark: UIColor.provideColor(type: .newLoginVC).textColor)
        label.font = mageFont.boldFont(size: 16)
        label.textAlignment = .left
        label.text = "Sign In".localized
        return label
    }()
    
    fileprivate lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(light: UIColor(hexString: "#050505", alpha: 1),dark: UIColor.provideColor(type: .newLoginVC).textColor)
        label.font = mageFont.regularFont(size: 14)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Please enter your phone number below to start using app".localized
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()                              
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = .viewBackgroundColor()
        imageViewLayout()
        signInLabelLayout()
        infoLabelLayout()
        pinTextFieldLayout()
        phoneTextFieldLayout()
        otpButtonLayout()
    }
    
    private func imageViewLayout() {
        view.addSubview(imageView)
        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, paddingTop: 30, paddingLeft: ((view.frame.size.width / 2) - 70), width: 140, height: 140)
    }
    
    private func pinTextFieldLayout() {
        view.addSubview(pinTextField)
        pinTextField.anchor(top: infoLabel.bottomAnchor, left: view.leadingAnchor, paddingTop: 30, paddingLeft: 20, width: 60, height: 50)
    }
    
    private func phoneTextFieldLayout() {
        phoneTextField.delegate = self
        view.addSubview(phoneTextField)
        phoneTextField.anchor(top: infoLabel.bottomAnchor, left: pinTextField.trailingAnchor, right: view.trailingAnchor, paddingTop: 30, paddingLeft: 5, paddingRight: 20,  height: 50)
    }
    
    private func otpButtonLayout() {
        view.addSubview(getOTPButton)
        getOTPButton.anchor(top: phoneTextField.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: 20, height: 50)
    }
    
    private func signInLabelLayout() {
        view.addSubview(signInLabel)
        signInLabel.anchor(top: imageView.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingTop: 5, paddingLeft: 20, paddingRight: 20, height: 20)
    }
    
    private func infoLabelLayout() {
        view.addSubview(infoLabel)
        infoLabel.anchor(top: signInLabel.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingTop: 8, paddingLeft: 20, paddingRight: 20, height: 50)
    }
    
    
    @objc func getOTPTapped() {
        sendOTPRequest()
        
    }
    
}

extension EnterPhoneNumberViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 15
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        
        return newString.count <= maxLength
    }
}


extension EnterPhoneNumberViewController {
    private func sendOTPRequest() {
        guard let phoneNumber = phoneTextField.text else {return}
        if phoneNumber.isEmpty {
            showErrorMessage(message: "Please enter a phone number".localized )
        }
        else {
            simplyOTPViewModel.sendOTPRequest(phoneNumber: phoneNumber, shop_name: Client.shopUrl, action: "sendOTP") {[weak self] result in
                switch result {
                case .success:
                    self?.navigate(phoneNumber: "+91\(phoneNumber)")
                case .failed(let err):
                    self?.showErrorMessage(message: err)
                }
            }
        }
        
    }
    
    private func showErrorMessage(message: String) {
        DispatchQueue.main.async {[weak self] in
            self?.view.hideLoader()
            self?.view.showmsg(msg: message)
        }
    }
    
    private func navigate(phoneNumber: String) {
        DispatchQueue.main.async {[weak self] in
            let vc = EnterOTPViewController()
            vc.phoneNumber = phoneNumber
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}




extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
