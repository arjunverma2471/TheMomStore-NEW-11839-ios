//
//  SearchNavigation.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 29/04/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class SearchNavigation: BaseNavigation {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([GetNavigation.shared.getSearchController()], animated: true)
        // Do any additional setup after loading the view.
    }
}
