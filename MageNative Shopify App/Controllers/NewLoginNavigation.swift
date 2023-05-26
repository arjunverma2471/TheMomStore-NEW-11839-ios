//
//  NewLoginNavigation.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 16/05/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation

class NewLoginNavigation: UINavigationController {
    
    var webViewVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : NewLoginVC = storyboard.instantiateViewController()
        vc.webViewVC = webViewVC
        self.setViewControllers([vc], animated: true)
    }
}
