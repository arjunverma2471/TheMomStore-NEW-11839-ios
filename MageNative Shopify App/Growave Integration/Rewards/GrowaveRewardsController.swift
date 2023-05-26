//
//  GrowaveRewardsController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 27/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
class GrowaveRewardsController : UIViewController {
    
    lazy var bottomView = GrowaveRewardsBottomView()
    
    lazy var topLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Join our community and start earning sweet discounts!".localized
        label.font = mageFont.regularFont(size: 12.0)
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    
    lazy var createAccountButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create a Store Account".localized, for: .normal)
        button.backgroundColor = UIColor.AppTheme()
        button.setTitleColor(.white, for: .normal)
        button.setupFont(fontType: .Regular, fontSize: 13.0)
        button.addTarget(self, action: #selector(redirectToRegister(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var loginButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login".localized, for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(.AppTheme(), for: .normal)
        button.layer.borderColor = UIColor.AppTheme().cgColor
        button.layer.borderWidth = 1.5
        button.setupFont(fontType: .Regular, fontSize: 13.0)
        button.addTarget(self, action: #selector(loginTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    func setUpView() {
        view.backgroundColor = .white
        view.addSubview(topLabel)
        view.addSubview(createAccountButton)
        view.addSubview(loginButton)
       // view.addSubview(bottomView)
        
        topLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leadingAnchor, right: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12, height: 50)
        
      //  bottomView.anchor(left: view.safeAreaLayoutGuide.leadingAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.trailingAnchor, paddingLeft: 12, paddingBottom: 8, paddingRight: 12, height: 72)
        
        createAccountButton.anchor(left: view.safeAreaLayoutGuide.leadingAnchor, right: view.safeAreaLayoutGuide.trailingAnchor, paddingLeft: 12, paddingRight: 12, height: 40)
        
        createAccountButton.center(inView: view)
        
        loginButton.anchor(top: createAccountButton.bottomAnchor, left: view.safeAreaLayoutGuide.leadingAnchor, right: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12, height: 40)
        
     //   self.setupTabView()
        
    }
    
    
    func setupTabView() {
        bottomView.loginButton.setTitle("LOG IN".localized, for: .normal)
        bottomView.learnButton.setTitle("LEARN MORE".localized, for: .normal)
        
        bottomView.loginButton.setupFont(fontType: .Regular)
        bottomView.learnButton.setupFont(fontType: .Regular)
        
        bottomView.loginButton.setTitleColor(.AppTheme(), for: .normal)
        bottomView.learnButton.setTitleColor(.AppTheme(), for: .normal)
        
        bottomView.loginImage.tintColor = .AppTheme()
        bottomView.learnImage.tintColor = .AppTheme()
        
        bottomView.loginButton.addTarget(self, action: #selector(loginTapped(_:)), for: .touchUpInside)
        
        
        
    }
    
    @objc func loginTapped(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: false) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
             let loginNavigation = storyboard.instantiateViewController(withIdentifier:"NewLoginNavigation")
                loginNavigation.modalPresentationStyle = .fullScreen
                self.present(loginNavigation, animated: true, completion: nil)
            
        }
        
    }
    
    @objc func redirectToRegister(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: false) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginNavigation = storyboard.instantiateViewController(withIdentifier:"NewLoginNavigation")
            loginNavigation.modalPresentationStyle = .fullScreen
            self.present(loginNavigation, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    
}
