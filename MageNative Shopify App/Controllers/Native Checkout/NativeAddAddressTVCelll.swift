//
//  NativeAddAddressTVCelll.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 13/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class NativeAddAddressTVCelll: UITableViewCell {
  
  var parent: UIViewController?
  var checkoutID = GraphQL.ID(rawValue: "")
  var emailReceived = String()
  
  @IBOutlet weak var fname: UITextField!
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var lname: UITextField!
  @IBOutlet weak var address1: UITextField!
  @IBOutlet weak var address2: UITextField!
  @IBOutlet weak var phone: UITextField!
  @IBOutlet weak var zip: UITextField!
  @IBOutlet weak var city: UITextField!
  @IBOutlet weak var selectCountry: UIButton!
  @IBOutlet weak var saveAddress: UIButton!
  @IBOutlet weak var selectState: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.selectionStyle = .none
    selectCountry.addTarget(self, action: #selector(self.showCountry(_:)), for: .touchUpInside)
    selectState.addTarget(self, action: #selector(self.showStates(_:)), for: .touchUpInside)
    saveAddress.addTarget(self, action: #selector(self.saveAddress(_:)), for: .touchUpInside)
    addBorders(selectCountry)
    addBorders(selectState)
    
    fname.placeholder = "First Name".localized
    lname.placeholder = "Last Name".localized
    address1.placeholder = "Address Line 1".localized
    address2.placeholder = "Address Line 2".localized
    selectCountry.setTitle("Select Country".localized, for: .normal)
    selectState.setTitle("Select State".localized, for: .normal)
    city.placeholder = "City".localized
    zip.placeholder = "Zip".localized
    phone.placeholder = "Phone".localized
    saveAddress.setTitle("Proceed".localized, for: .normal)
    
    fname.font = mageFont.regularFont(size: 14.0)
    lname.font = mageFont.regularFont(size: 14.0)
    address1.font = mageFont.regularFont(size: 14.0)
    address2.font = mageFont.regularFont(size: 14.0)
    selectState.titleLabel?.font = mageFont.regularFont(size: 14.0)
    selectCountry.titleLabel?.font = mageFont.regularFont(size: 14.0)
    city.font = mageFont.regularFont(size: 14.0)
    zip.font = mageFont.regularFont(size: 14.0)
    phone.font = mageFont.regularFont(size: 14.0)
    saveAddress.titleLabel?.font = mageFont.mediumFont(size: 14.0)
    saveAddress.backgroundColor = UIColor.AppTheme()
    saveAddress.setTitleColor(UIColor.textColor(), for: .normal)
    saveAddress.layer.cornerRadius = 5
    
    if Client.locale == "ar" {
      fname.textAlignment = .right
      lname.textAlignment = .right
      address1.textAlignment = .right
      address2.textAlignment = .right
      selectCountry.contentHorizontalAlignment = .right
      selectState.contentHorizontalAlignment = .right
      city.textAlignment = .right
      zip.textAlignment = .right
      phone.textAlignment = .right
      email.textAlignment = .right
    }
    else {
      fname.textAlignment = .left
      lname.textAlignment = .left
      address1.textAlignment = .left
      address2.textAlignment = .left
      selectCountry.contentHorizontalAlignment = .left
      selectState.contentHorizontalAlignment = .left
      city.textAlignment = .left
      zip.textAlignment = .left
      phone.textAlignment = .left
      email.textAlignment = .left
    }
    
    email.isHidden = Client.shared.isAppLogin()
  }
  
  func addBorders(_ sender: UIButton)
  {
    sender.layer.borderWidth = 0.5
    sender.layer.borderColor = UIColor.lightGray.cgColor
  }
  
  
  @objc func showCountry(_ sender:UIButton){
    
    let dropDown = DropDown(anchorView: sender)
    dropDown.dataSource = Country.shared.countries!
    dropDown.selectionAction = {[unowned self](index, item) in
      sender.setTitle(item, for: UIControl.State());
      Country.shared.stateWithCountry(with: item)
      self.selectState.setTitle("Select State".localized, for: .normal)
    }
    
    dropDown.bottomOffset = CGPoint(x: 0, y:sender.bounds.height)
    if dropDown.isHidden {
        dropDown.setAlignment(dropDown);
      let _ = dropDown.show();
    } else {
      dropDown.hide();
    }
  }
  
  @objc func showStates(_ sender:UIButton){
    guard let states = Country.shared.currentStates else {
      
      return }
    let dropDown = DropDown(anchorView: sender)
    dropDown.dataSource = states as! [String]
    dropDown.selectionAction = {(index, item) in
      sender.setTitle(item, for: UIControl.State());
      
    }
    dropDown.bottomOffset = CGPoint(x: 0, y:sender.bounds.height)
    if dropDown.isHidden {
        dropDown.setAlignment(dropDown);
      let _ = dropDown.show();
    } else {
      dropDown.hide();
    }
  }
  
  @objc func saveAddress(_ sender:UIButton){
    guard let fname         = fname.text else {return}
    guard let lname         = lname.text else {return}
    guard let address1      = address1.text else {return}
    guard let address2      = address2.text else {return}
    guard let city          = city.text else {return}
    guard let zip           = zip.text else {return}
    guard let country       = selectCountry.titleLabel?.text  else {return}
    guard let state         = selectState.titleLabel?.text else {return}
    guard let phone         = phone.text else {return}
    
    if fname == "" || lname == "" || address1 == "" || address2 == "" || city == "" || zip  == "" || country == "Select Country".localized || state == "Select State".localized || phone == "" {
      self.parent?.showErrorAlert(error: "All fields are required!.".localized)
      return
    }
    
    if !phone.isValidPhone(){
      self.parent?.showErrorAlert(error: "Invalid phone number.".localized)
      return
    }
    
    if !Client.shared.isAppLogin(){
      if email.text == "" {
        self.parent?.showErrorAlert(error: "Email can't be empty.".localized)
        return;
      }
    }
    
    let addressFields = ["firstName":fname,"lastName":lname,"address1":address1,"address2":address2,"city":city,"zip":zip,"country":country,"province":state,"phone":phone]
    print(addressFields)
    do {
      
      self.parent?.view.addLoader()
      
      Client.shared.customerAddShippingAddress(address: addressFields, checkoutID: checkoutID) { response, error in
        self.parent?.view.stopLoader()
        if let response = response {
          if response.availableShippingRate?.count ?? 0 > 0 {
            print("AvailaibleShippingRate==",response.availableShippingRate)
            let vc = ShippingMethodViewController()
            vc.availableShippingRate = response.availableShippingRate ?? []
            vc.checkoutId = response.checkId
            if Client.shared.isAppLogin(){
              vc.email = self.emailReceived
            }else{
              vc.email = self.email.text ?? ""
            }
            self.parent?.navigationController?.pushViewController(vc, animated: true)
          }
          else {
            self.parent?.view.showmsg(msg: "Kindly try with a different address".localized)
            return;
          }
        }
      }
    }
  }
}
