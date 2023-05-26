//
//  orderPlacedViewController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 07/04/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import UIKit

class orderPlacedViewController: UIViewController {

  @IBOutlet weak var continueShopping: UIButton!
  
    @IBOutlet weak var orderTxt: UILabel!
    @IBOutlet weak var thankTxt: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        thankTxt.text = "Thank You".localized
        orderTxt.text = "Your Order has been placed successfully".localized
        continueShopping.setTitle("Continue Shopping".localized, for: .normal)
        continueShopping.addTarget(self, action: #selector(continueShoppingClicked(_:)), for: .touchUpInside)
        thankTxt.font = mageFont.regularFont(size: 15.0)
        orderTxt.font = mageFont.regularFont(size: 15.0)
        continueShopping.titleLabel?.font = mageFont.regularFont(size: 15.0)
        // Do any additional setup after loading the view.
    }
    
  
  @objc func continueShoppingClicked(_ sender:UIButton) {
    DBManager.shared.clearCartData()  
    self.setupTabbarCount()
    self.dismiss(animated: true, completion: nil)
    
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
