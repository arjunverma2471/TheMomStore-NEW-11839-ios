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

import Foundation
import SafariServices
extension CartViewController:SFSafariViewControllerDelegate {
  func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
    print(URL.absoluteString)
    
  }
  
  func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    if cartManager.cartCount == 0 {
      if customAppSettings.sharedInstance.showTabbar{
        self.tabBarController?.selectedIndex = 0
      }else{
        self.navigationController?.popToRootViewController(animated: true)
      }
    }
  }
  
  func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
    
  }
  
  func setOrderRequest(orderData:[String:Any]){
    guard let url = (AppSetUp.baseUrl+"index.php/shopifymobile/shopifyapi/setorder?mid="+Client.merchantID).getURL() else {return}
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    self.view.addLoader()
    
    AF.request(request).responseData(completionHandler: {
      response in
      self.view.stopLoader()
      switch response.result {
      case .success:
        if let data = response.data {
          do {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            print(json)
          }catch let err {
            print(err.localizedDescription)
          }
        }
      case .failure:
        guard let error = response.error?.localizedDescription else {return}
        print(error)
      }
    })
  }  
}
