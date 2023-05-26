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

class AddressesViewController: BaseViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var addresses : PageableArray<AddressesViewModel>!
    
  var email = String()
  var checkoutID = GraphQL.ID(rawValue: "")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addLoader()
    loadAddresses()
    setUPTableHeader()
      self.navigationItem.title = "ADDRESS BOOK".localized
  }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // Check if the user switched to dark mode
        if #available(iOS 13.0, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
           
            tableView.reloadData()
        }
    }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
//      FloatingButton.shared.controller = self
//      FloatingButton.shared.renderFloatingButton()
    self.loadAddresses()
  }
  
  func loadAddresses(){
   
    Client.shared.fetchCustomerAddresses(completion: {
      response,error  in
      self.view.stopLoader()
      if let response = response {
        self.addresses = response
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.emptyDataSetSource = self
        self.tableView.reloadData()
      }else {
        //self.showErrorAlert(error: error?.localizedDescription)
      }
    })
  }
    
  func setUpTable(){}
  
  func setUPTableHeader(){
    let cell = tableView.dequeueReusableCell(withIdentifier: "addNewAddress")
    if let addAddress = cell?.viewWithTag(785) as? UIButton {
        addAddress.setTitle("+ ADD NEW ADDRESS".localized, for: .normal)
        addAddress.titleLabel?.font = mageFont.mediumFont(size: 15.0)
      addAddress.addTarget(self, action: #selector(self.gotoAddAddress), for: .touchUpInside)
    }
    
    self.tableView.tableHeaderView = cell
  }
  
  @objc func gotoAddAddress(){
    let addressView:AddAddressViewController = self.storyboard!.instantiateViewController()
    self.navigationController?.pushViewController(addressView, animated: true)
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

extension AddressesViewController:UITableViewDataSource
{
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: AddressListViewCell.className)  as! AddressListViewCell
    let address = addresses.items[indexPath.row]
      cell.setupView()
      cell.configureFrom(address)
      cell.deleteButton.setTitle("Delete".localized, for: .normal)
      cell.editButton.setTitle("Edit".localized, for: .normal)
      cell.deleteButton.titleLabel?.font = mageFont.mediumFont(size: 15.0)
      cell.editButton.titleLabel?.font = mageFont.mediumFont(size: 15.0)
      cell.deleteButton.tag = indexPath.row
      cell.deleteButton.addTarget(self, action: #selector(deleteAddress(_:)), for: .touchUpInside)
      cell.editButton.tag = indexPath.row
      cell.editButton.addTarget(self, action: #selector(editAddress(_:)), for: .touchUpInside)
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return addresses?.items.count ?? 0
  }
    @objc func editAddress(_ sender : UIButton) {
        let addressView:AddAddressViewController = self.storyboard!.instantiateViewController()
        addressView.editAddress = addresses.items[sender.tag]
        addressView.isFromEditAddress = true
        self.navigationController?.pushViewController(addressView, animated: true)
    }
    
    
    @objc func deleteAddress(_ sender : UIButton) {
       
        let alert = UIAlertController(title: "Alert".localized, message: "Are you sure you want to delete address?".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No".localized, style: .default, handler: { action in
            // completion(nil)
        }))
        alert.addAction(UIAlertAction(title: "OK".localized, style: .cancel, handler: {  action in
            Client.shared.customerDeleteAddress(address: self.addresses.items[sender.tag], completeion: {
                id,error,netError  in
                if id != nil {
                  self.loadAddresses()
                }
              })
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension AddressesViewController:UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
}

extension  AddressesViewController:DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        let custom = EmptyView()
        custom.delegate = self;
        custom.configure(imageName: "emptyAddress", title: EmptyData.listEmptyTitle, subtitle: EmptyData.addressEmptyTitle)
        return custom;
    }
  
  func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
    return addresses?.items.count == 0
  }
}
