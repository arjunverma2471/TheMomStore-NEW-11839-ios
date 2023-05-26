//
//  MenuLoginView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 15/12/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation

class MenuLoginView:UIView{
    
    private lazy var avtarImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 25
        image.contentMode = .scaleAspectFit
        
        image.clipsToBounds = true;
        return image;
    }()
    
    private lazy var avtarInitails: UILabel = {
        let lbl = UILabel()
        lbl.layer.cornerRadius = 25
        lbl.backgroundColor = .lightGray
        lbl.font = mageFont.setFont(fontWeight: "bold", fontStyle: "normal", fontSize: 20)
        lbl.textColor  = .white
        lbl.clipsToBounds = true;
        lbl.textAlignment = .center
        return lbl;
    }()
    
    private lazy var profileName: UILabel = {
        let name = UILabel()
        name.font = mageFont.setFont(fontWeight: "regular", fontStyle: "normal", fontSize: 14)
        name.textColor = UIColor(light: UIColor(hexString: "#383838"),dark: UIColor.provideColor(type: .SideMenuController).textColor)
        return name;
    }()
    
    private lazy var msgLabel: UILabel = {
        let msg = UILabel()
        msg.font = mageFont.setFont(fontWeight: "light", fontStyle: "normal", fontSize: 12)
        msg.textColor = UIColor(light: UIColor(hexString: "#383838"),dark: UIColor.provideColor(type: .SideMenuController).textColor)
        return msg
    }()
    lazy var titleView: UIView = {
        let view = UIView()
        view.addSubview(profileName)
        profileName.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, right: view.trailingAnchor)
        view.addSubview(msgLabel)
        msgLabel.anchor(top: profileName.bottomAnchor, left: view.leadingAnchor, bottom:view.safeAreaLayoutGuide.bottomAnchor,right: view.trailingAnchor, paddingTop: 4)
        return view
    }()
    private lazy var rightArrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "rightArrow"), for: .normal);
        button.imageView?.contentMode = .scaleAspectFit;
        return button;
    } ()
    lazy var tapBtnView: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        return btn
    }()
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    func setView(){
        addSubview(avtarImage)
        avtarImage.anchor(left: leadingAnchor,paddingLeft: 12,width: 50,height: 50)
        avtarImage.centerY(inView: self)
        addSubview(avtarInitails)
        avtarInitails.anchor(left: leadingAnchor,paddingLeft: 12,width: 50,height: 50)
        avtarInitails.centerY(inView: self)
        addSubview(rightArrowButton)
        rightArrowButton.anchor(right: trailingAnchor,paddingRight: 12,width: 25,height: 25)
        rightArrowButton.centerY(inView: self)
        addSubview(titleView)
        titleView.centerY(inView: self)
        titleView.anchor(left: avtarInitails.trailingAnchor,right: rightArrowButton.leadingAnchor,paddingLeft: 12,paddingRight: 50)
        addSubview(tapBtnView)
        tapBtnView.anchor(top: safeAreaLayoutGuide.topAnchor,left: leadingAnchor,bottom: safeAreaLayoutGuide.bottomAnchor,right: trailingAnchor)
    }
    
    func setup(menu: MenuObject){
       
//        msgLabel.text = "Sign in via email"
        //mageShopLogin
        print("v=========>",Client.shared.isAppLogin())
        if Client.shared.isAppLogin(){
            Client.shared.fetchCustomerDetails(completeion: {
                response,error in
                if let response = response {
                    //let name = response.displayName!
                    self.profileName.text = response.displayName!
                    self.avtarImage.isHidden = true
                    self.avtarInitails.isHidden = false
                    let fullName = response.displayName!
                    var name = ""
                    if let firstName = fullName.components(separatedBy: " ").first?.first{
                        name += firstName.description
                    }
                    if let lastName = fullName.components(separatedBy: " ").last?.first{
                        name += lastName.description
                    }
                    
                    self.avtarInitails.text = name.uppercased()
                    self.msgLabel.text = "Save, Shop and View Orders".localized
                }
            })
        }
      /*  if Client.shared.isAppLogin(){
            profileName.text = menu.name
            avtarImage.isHidden = true
            avtarInitails.isHidden = false
            let fullName = menu.name
            var name = ""
            if let firstName = fullName.components(separatedBy: " ").first?.first{
                name += firstName.description
            }
            if let lastName = fullName.components(separatedBy: " ").last?.first{
                name += lastName.description
            }
            
            avtarInitails.text = name.uppercased()
            msgLabel.text = "Save, Shop and View Orders".localized
        }*/
        else{
            avtarImage.image = UIImage(named: "profile")
            avtarImage.isHidden = false
            avtarInitails.isHidden = true
            profileName.text = "Sign In".localized
            msgLabel.text = "Save, Shop and View Orders".localized
            
        }
    }
}
