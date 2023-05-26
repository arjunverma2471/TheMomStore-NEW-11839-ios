//
//  Navigation+Extension.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 29/04/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class GetNavigation{
    private init(){}
    static let shared = GetNavigation()
    func getSearchController()->UIViewController{
        
      
        if(!customAppSettings.sharedInstance.algoliaIntegration){
            //let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: SearchViewController.className) as! SearchViewController
            return NewSearchVC();
        }
        else{
            return AlgoliaSearchViewController()
            
        }
    }
    
    func getCategoriesController()->UIViewController{
        let vc = CategoryListVC()
        return vc;
    }
    
    func getGrowWishlistController()->UIViewController{
        let vc = GrowaveBoardsViewController()
        return vc
    }
    
    func getCartController()->UIViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let data = DBManager.shared.cartProducts?.filter{$0.sellingPlanId != ""}
        if data?.count ?? 0 > 0 {
            let vc : NewCartViewController = storyboard.instantiateViewController()
            return vc
        }
        else {
            let viewController:CartViewController = storyboard.instantiateViewController()
             return viewController
        }
    }
}
