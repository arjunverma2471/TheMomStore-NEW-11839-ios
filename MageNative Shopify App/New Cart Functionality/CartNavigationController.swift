//
//  CartNavigationController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 23/04/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class CartNavigationController: BaseNavigation {

    override func viewDidLoad() {
        super.viewDidLoad()
       // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let data = DBManager.shared.cartProducts?.filter{$0.sellingPlanId != ""}
        if data?.count ?? 0 > 0 {
            let vc : NewCartViewController = storyboard.instantiateViewController()
            self.setViewControllers([vc], animated: true)
        }
        else {
            let vc : CartViewController = storyboard.instantiateViewController()
            self.setViewControllers([vc], animated: true)
        }
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
