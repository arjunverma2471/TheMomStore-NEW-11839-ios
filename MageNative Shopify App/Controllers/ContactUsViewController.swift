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

class ContactUsViewController: UIViewController {
    
    
    @IBOutlet weak var phoneIcon: UIImageView!
    @IBOutlet weak var emailIcon: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var cardViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewForCard: UIView!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var addressLine1: UILabel!
    @IBOutlet weak var otherAddress: UILabel!
    @IBOutlet weak var addressLine2: UILabel!
    @IBOutlet weak var addressLine2Height: NSLayoutConstraint!
    @IBOutlet weak var phone: UIButton!
    @IBOutlet weak var email: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneIcon.isHidden=true
        emailIcon.isHidden=true
        let url=URL(string: AppSetUp.baseUrl+"index.php/shopifymobile/shopifyapi/getshop?mid="+Client.merchantID)
        var urlreq=URLRequest(url: url!)
        
        urlreq.httpMethod="GET"
        urlreq.cachePolicy = .returnCacheDataElseLoad
        urlreq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        self.view.addLoader()
        let task=URLSession.shared.dataTask(with: urlreq, completionHandler: {data,response,error in
            
            if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode/100 != 2
            {
                
                DispatchQueue.main.sync
                    {
                        self.view.stopLoader()
                        
                        print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        
                        print("response = \(String(describing: response))")
                }
                return;
            }
            
            // code to fetch values from response :: start
            
            guard error == nil && data != nil else
            {
                DispatchQueue.main.sync
                    {
                        self.view.stopLoader()
                        
                        print("error=\(String(describing: error))")
                        if error?.localizedDescription=="The Internet connection appears to be offline."{
                            
                            
                        }
                }
                return ;
            }
            DispatchQueue.main.sync
                {
                    
                    self.view.stopLoader()
                    do {
                        let json=try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                   
                        let check=json?["success"] as! Bool
                        if check==true
                        {
                            if let jsonData=json?["data"] as? [String:Any]
                            {
                                self.phoneIcon.isHidden=false
                                self.emailIcon.isHidden=false
                                self.ownerName.text = jsonData["shop_owner"] as? String
                                if let address1=jsonData["address1"] as? String{
                                    self.addressLine1.text=address1
                                }
                                else{
                                    
                                }
                                if let address2=jsonData["sddress2"] as? String{
                                    self.addressLine2.text=address2
                                    self.addressLine2Height.constant=40
                                }
                                else{
                                    //                                    self.addressLine2Height.constant=0
                                    //                                    self.cardViewHeight.constant-=40
                                    
                                }
                                var other=""
                                if let city=jsonData["city"] as? String{
                                    other+=city+", "
                                }
                                if let province=jsonData["province"] as? String{
                                    other+=province+", "
                                }
                                if let country_name=jsonData["country_name"] as? String{
                                    other+=country_name+" -"
                                }
                                if let zip=jsonData["zip"] as? String{
                                    other+=zip
                                }
                                self.otherAddress.text=other
                                
                                if let phoneNumber=jsonData["phone"] as? String
                                {
                                    self.phone.addTarget(self, action: #selector(self.phoneButtonClicked(_:)), for: .touchUpInside)
                                    self.phone.setTitle(phoneNumber, for: .normal)
                                }
                                if let email=jsonData["email"] as? String
                                {
                                    self.email.addTarget(self, action: #selector(self.emailButtonClicked(_:)), for: .touchUpInside)
                                    self.email.setTitle(email, for: .normal)
                                }
                                
                            }
                            
                            
                        }
                        
                        
                    }catch{
                        
                    }
            }
        })
        task.resume()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc  func phoneButtonClicked(_ sender: UIButton){
        let url=URL(string: "tel:"+sender.currentTitle!)
        if #available(iOS 10.0, *) {
            
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            print("9")
            UIApplication.shared.open(url!)
        }
    }
    
    @objc  func emailButtonClicked(_ sender: UIButton){
        let url=URL(string: "mailto:"+sender.currentTitle!)
        if #available(iOS 10.0, *) {
            
            
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            
            UIApplication.shared.open(url!)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
