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
import RxCocoa
import RxSwift
class AccountViewController: BaseViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var shopDetails:ShopViewModel?
  var customerId = ""
  var email = ""
  var accountOptions = [[String]]()

  var images =  [[String]]()
  var fromPasswordUpdate: Bool = false
  var disposeBag = DisposeBag()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
      self.view.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .accountVc).backGroundColor)
    //var options       = ["Profile".localized,"Address Book".localized,"My Orders".localized,"Delete Your Account".localized]
    //var customImages  = ["profileN","addressN","orderN","delete_accountN"]
      var options       = ["Orders".localized,"My Wishlist".localized,"My Address".localized,"Delete Your Account".localized]
      var customImages  = ["orderN","wishlistN","addressN","delete_accountN"]
    
    if customAppSettings.sharedInstance.rewardify && customAppSettings.sharedInstance.flitsIntegration{
      options.append("My Credits".localized)
      options.append("Rewardify".localized)
      customImages.append("creditN")
      customImages.append("orderN")
    }else{
      if customAppSettings.sharedInstance.flitsIntegration{
        options.append("My Credits".localized)
        customImages.append("creditN")
      }
      
      if customAppSettings.sharedInstance.rewardify{
        options.append("Rewardify".localized)
        customImages.append("orderN")
      }
    }
    
    accountOptions = [options,["Sign out".localized]]
    images = [customImages,["logoutN"]]
    
  
      Client.shared.fetchShop(completion: {
      response in
      self.shopDetails = response
      self.tableView.reloadData()
    })
  }
  
  func setupTable(){
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
//      self.setUpNavigationTheme()
      
         
    //JS
    self.tabBarController?.tabBar.tabsVisiblty()
    //END
    setupTable()
    if !fromPasswordUpdate {
      setUPTableHeader()
    }
  }
  
  func setUPTableHeader(){
    let cell = tableView.dequeueReusableCell(withIdentifier: AccountProfileCell.className) as! AccountProfileCell
      cell.displayName.font = mageFont.regularFont(size: 14.0)
      cell.displayName.textColor = UIColor(light: UIColor(hexString: "#383838"),dark: UIColor.provideColor(type: .accountVc).textColor)
        cell.loginViaMailLabel.textColor = UIColor(light: UIColor(hexString: "#383838"),dark: UIColor.provideColor(type: .accountVc).textColor)
      cell.loginViaMailLabel.font = mageFont.regularFont(size: 12)//UIFont(name: "Sora-Light", size: 12)
    self.view.addLoader()
    Client.shared.fetchCustomerDetails(completeion: {
      response,error in
      if let response = response {
        self.view.stopLoader()
        self.customerId = response.customerId ?? ""
          self.email = response.email ?? ""
          cell.loginViaMailLabel.text = ""
        if let displayName = response.displayName?.capitalized{
          cell.displayName.text = displayName
          
            //cell.loginViaMailLabel.text = "Login via Email id".localized
            
        
        }
          
          
        var name = ""
        if let firstName = response.firstName?.first?.description{
          name += firstName
        }
        if let lastName = response.lastName?.first?.description{
          name += lastName
        }
        //  cell.imageView?.backgroundColor = UIColor.AppTheme()
        cell.nameInitials.text =  name.uppercased()
        cell.nameInitials.font = mageFont.boldFont(size: 22.0)
        self.tableView.tableHeaderView = cell
      }else {
          self.view.stopLoader()
        self.showErrorAlert(error: error?.localizedDescription)
      }
    })
      cell.profileButton.rx.tap.bind{
          let editProfileView:EditUserViewController = self.storyboard!.instantiateViewController()
         
          editProfileView.parentVC = self
          self.navigationController?.pushViewController(editProfileView, animated: true)
      }.disposed(by: disposeBag)
    //cell.backgroundColor = UIColor.lightGray
    self.tableView.tableHeaderView = cell
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

extension AccountViewController:UITableViewDelegate{
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
  
//  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//    switch section {
//    case 0:
//      return "    "+"My Account".localized
//    default:
//      return nil
//
//    }
//  }
//
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case 0:
      let title = self.accountOptions[indexPath.section][indexPath.row]
      if title == "Orders".localized{
        let orderViewControl:OrdersViewController = self.storyboard!.instantiateViewController()
          orderViewControl.email = self.email
        self.navigationController?.pushViewController(orderViewControl, animated: true)
      }
      else if title ==  "My Address".localized {
        let addressViewControl:AddressesViewController = self.storyboard!.instantiateViewController()
        self.navigationController?.pushViewController(addressViewControl, animated: true)
      }
      else if title == "My Credits".localized{
          let vc = FlitsCreditVC()
        self.navigationController?.pushViewController(vc, animated: true)
      }
      else if title ==  "Profile".localized {
        let editProfileView:EditUserViewController = self.storyboard!.instantiateViewController()
       
        editProfileView.parentVC = self
        self.navigationController?.pushViewController(editProfileView, animated: true)
      }else if title == "Rewardify" {
          let vc = RewardifyTransactionListVC()
        self.navigationController?.pushViewController(vc, animated: true)
      }
        else if title == "My Wishlist".localized{
            let viewController:WishlistViewController = self.storyboard!.instantiateViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else{
            self.showDeleteAlert()
        }
      /*case 1:
       let name = self.accountOptions[indexPath.section][indexPath.row]
       self.gotoWebPages(page: name)*/
    case 1:
        let title = self.accountOptions[indexPath.section][indexPath.row]
        if(title == "Sign out".localized){
            let alert = UIAlertController(title: "", message: "Are you sure you want to log out?".localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No".localized, style: .default, handler: { action in
              // completion(nil)
            }))
            alert.addAction(UIAlertAction(title: "Yes".localized, style: .cancel, handler: {  action in
                self.doLogOut()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        
     // self.doLogOut()
    default:
      print("Hello")
    }
  }
  
  func showDeleteAlert() {
    let alert = UIAlertController(title: "", message: "Are you sure you want to delete your account?".localized, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "No".localized, style: .default, handler: { action in
      // completion(nil)
    }))
    alert.addAction(UIAlertAction(title: "Yes".localized, style: .cancel, handler: {  action in
      self.deleteCustomerAccount()
    }))
    self.present(alert, animated: true, completion: nil)
  }
  
  func deleteCustomerAccount() {
    //  self.customerId = self.customerId.base64decode()
    let id = self.customerId.components(separatedBy: "/").last ?? ""
    guard let url = "https://shopifymobileapp.cedcommerce.com/shopifymobile/shopifyapi/deletecustomer?mid=\(Client.merchantID)&cid=\(id)".getURL() else {return}
    print(url)
    var request = URLRequest(url: url)
    request.httpMethod="GET"
    AF.request(request).responseData(completionHandler: {
      response in
      switch response.result {
      case .success:
        do {
          guard let json = try? JSON(data: response.data!) else{return;}
          print(json)
          self.showErrorAlert(error:  json["message"].stringValue)
          if Client.shared.doLogOut(){
            if customAppSettings.sharedInstance.showTabbar{
              self.tabBarController?.selectedIndex = 0
            }else{
              self.navigationController?.popToRootViewController(animated: true)
            }
          }
        }
      case .failure:
        print("failed")
      }
    })
  }
}

extension AccountViewController:UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return accountOptions[section].count
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return accountOptions.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: AccountTableViewCell.className) as! AccountTableViewCell
    cell.title.text = accountOptions[indexPath.section][indexPath.row]
      if(accountOptions[indexPath.section][indexPath.row]=="Sign out".localized){
          cell.bottomView.isHidden = false
      }
      else{
          cell.bottomView.isHidden = true;
      }
    //cell.accountImage.image = UIImage(named: images[indexPath.section][indexPath.row])
      cell.imageView?.tintColor = AppConfigure.shared.checkThemeColor()
      cell.imageView?.image = UIImage(named: images[indexPath.section][indexPath.row])
    return cell
  }
}

extension AccountViewController{
  func gotoWebPages(page:String){
    let viewController:WebViewController = storyboard!.instantiateViewController()
    viewController.title = page
    switch page {
    case "Privacy Policy".localized:
      viewController.url = shopDetails?.privacyPolicyUrl
    case "Return Policy".localized:
      print("sdsd")
      viewController.url = shopDetails?.refundPolicyUrl
    case "Terms of services".localized:
      viewController.url = shopDetails?.termsOfService
      print("sdsd")
    default:
      let contactus:ContactUsViewController = self.storyboard!.instantiateViewController()
      contactus.title = "Contact Us".localized
      self.navigationController?.pushViewController(contactus, animated: true)
      return
    }
    self.navigationController?.pushViewController(viewController, animated: true)
  }
  
  func doLogOut(){
    if Client.shared.doLogOut() {
        NotificationCenter.default.post(name: NSNotification.Name("loadDrawerAgain"), object: nil)
      if customAppSettings.sharedInstance.showTabbar{
        self.tabBarController?.selectedIndex = 0
      }else{
        self.navigationController?.popToRootViewController(animated: true)
      }
    }
  }
}
