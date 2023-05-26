//
//  LoginNavigation.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 03/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
class LoginNavigation : UINavigationController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func getController() {
        if Client.shared.isAppLogin() {
            
        }
        else {
            
        }
    }
    
    
}
