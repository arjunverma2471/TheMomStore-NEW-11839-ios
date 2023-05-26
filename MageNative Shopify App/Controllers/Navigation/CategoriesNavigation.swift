//
//  CategoriesNavigation.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 12/09/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
class CategoriesNavigation: BaseNavigation {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([GetNavigation.shared.getCategoriesController()], animated: true)
        // Do any additional setup after loading the view.
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
