/**
 * CedCommerce
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the End User License Agreement (EULA)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://cedcommerce.com/license-agreement.txt
 *
 * @category  Ced
 * @package   MageNative
 * @author    CedCommerce Core Team <connect@cedcommerce.com >
 * @copyright Copyright CEDCOMMERCE (http://cedcommerce.com/)
 * @license      http://cedcommerce.com/license-agreement.txt
 */

import UIKit
import MobileBuySDK

class AddAddressViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var address1: UITextField!
    @IBOutlet weak var address2: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var zip: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var saveAddress: UIButton!
    
    @IBOutlet weak var selectCountry: UIButton!
    @IBOutlet weak var selectState: UIButton!
    var editAddress : AddressesViewModel!
    var isFromEditAddress = false
    var isFromCart = false
    var checkoutID = GraphQL.ID(rawValue: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.titlePadding = 10
            selectCountry.configuration = config
            selectState.configuration = config
        } else {
            // Fallback on earlier versions
        }
        
        self.navigationItem.title = "ADD ADDRESS".localized
        saveAddress.addTarget(self, action: #selector(self.saveAddress(_:)), for: .touchUpInside)
        selectCountry.addTarget(self, action: #selector(self.showCountry(_:)), for: .touchUpInside)
        selectState.addTarget(self, action: #selector(self.showStates(_:)), for: .touchUpInside)
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
        saveAddress.setTitle("Save Address".localized, for: .normal)
        fname.font = mageFont.regularFont(size: 14.0)
        lname.font = mageFont.regularFont(size: 14.0)
        address1.font = mageFont.regularFont(size: 14.0)
        address2.font = mageFont.regularFont(size: 14.0)
        selectState.titleLabel?.font = mageFont.regularFont(size: 14.0)
        selectCountry.titleLabel?.font = mageFont.regularFont(size: 14.0)
        city.font = mageFont.regularFont(size: 14.0)
        zip.font = mageFont.regularFont(size: 14.0)
        phone.font = mageFont.regularFont(size: 14.0)
        saveAddress.titleLabel?.font = mageFont.mediumFont(size: 15.0)
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
        if isFromEditAddress {
            self.navigationItem.title = "EDIT ADDRESS".localized
            fname.text = editAddress.firstName
            lname.text = editAddress.lastName
            address1.text = editAddress.address1
            address2.text = editAddress.address2
            city.text = editAddress.city
            zip.text = editAddress.zip
            phone.text = editAddress.phone
            selectCountry.setTitle(editAddress.country, for: .normal)
            selectState.setTitle(editAddress.province, for: .normal)
        }
        if isFromCart {
            email.isHidden = false
        }
        else {
            email.isHidden = true
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        FloatingButton.shared.controller = self
//        FloatingButton.shared.renderFloatingButton()
    }
    
    func addBorders(_ sender: UIButton)
    {
        sender.layer.borderWidth = 0.5
        sender.layer.borderColor = UIColor.lightGray.cgColor
    }
   
    @objc func showCountry(_ sender:UIButton){
        self.view.endEditing(true)
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
        self.view.endEditing(true)
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
            self.showErrorAlert(error: "All fields are required!.".localized)
            return
        }
      
      if !phone.isValidPhone(){
        self.showErrorAlert(error: "Invalid phone number.".localized)
        return
      }
      
        if isFromCart {
            if email.text == "" {
                self.showErrorAlert(error: "Email can't be empty.".localized)
                return;
            }
        }
        
        let addressFields = ["firstName":fname,"lastName":lname,"address1":address1,"address2":address2,"city":city,"zip":zip,"country":country,"province":state,"phone":phone]
        print(addressFields)
        do {
         
            self.view.addLoader()
            if isFromCart {
                Client.shared.customerAddShippingAddress(address: addressFields, checkoutID: checkoutID) { response, error in
                    self.view.stopLoader()
                    if let response = response {
                        if response.availableShippingRate?.count ?? 0 > 0 {
                            let vc = ShippingMethodViewController()
                            vc.availableShippingRate = response.availableShippingRate ?? []
                            vc.checkoutId = response.checkId
                            vc.email = self.email.text ?? ""
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        else {
                            self.view.showmsg(msg: "Kindly try with a different address".localized)
                            return;
                        }
                    }
                }
                return;
            }
        
            
            if isFromEditAddress {
                Client.shared.customerUpdateAddress(address: addressFields, addressId: editAddress.id!, completeion: {[unowned self]
                    response ,error in
                    self.view.stopLoader()
                    if response != nil {
                        self.navigationController?.popViewController(animated: true)
                        return
                    }else{
                        self.showErrorAlert(errors: error)
                    }
                })
            }
            else {
                Client.shared.customerAddAddress(address: addressFields, completeion: {[unowned self]
                    response ,error in
                    self.view.stopLoader()
                    if let response = response {
                        if response.name != nil {
                            self.navigationController?.popViewController(animated: true)
                            return
                        }
                    }else {
                        //self.showErrorAlert(errors: error)
                    }
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

