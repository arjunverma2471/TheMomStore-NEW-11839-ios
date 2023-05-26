//
//  QuickAddButton.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 27/01/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import Foundation
class QuickAddButton: UIButton {
    
    var controller: UIViewController
    var id: String
    var product: ProductViewModel!
    
    required init(controller: UIViewController, id: String) {
        self.controller = controller
        self.id = id
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func openVariantsPage( sender: UIButton){
        
        Client.shared.fetchSingleProduct(of: id){[weak self]
            response,error   in
            if let response = response {
                self?.controller.view.stopLoader()
                self?.product = response
            }else {
                //self.showErrorAlert(error: error?.localizedDescription)
            }
        }
    }
    
}
