//
//  CouponListController.swift
//  MageNative Shopify App
//
//  Created by Yash Pratap Singh sisodia on 24/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import UIKit

class CouponListController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
   
  
    
    @IBOutlet weak var mainTableView: UITableView!
    var coupons: [CouponData]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Coupons"
        setupView()
        // Do any additional setup after loading the view.
    }
    
    @objc func tapCopyCoupon(_ sender: UIButton){
        self.view.makeToast("Copied")
        if let discounts = self.coupons {
            UserDefaults.standard.set(discounts[sender.tag].discount?.title, forKey: "coupon")
            UIPasteboard.general.string = discounts[sender.tag].discount?.title
        }
       
    }
    
    func setupView() {
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.separatorStyle = .none
        self.mainTableView.register(UINib(nibName: "DiscountCouponCell", bundle: nil), forCellReuseIdentifier: "DiscountCouponCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coupons?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell   = tableView.dequeueReusableCell(withIdentifier: "DiscountCouponCell", for: indexPath) as! DiscountCouponCell
        if let coupon = self.coupons {
            cell.viewAllButton.isHidden = true
            if let discount = coupon[indexPath.row].discount {
                cell.configure(discount: discount)
                cell.viewAllButton.isHidden = true
                cell.viewAllLbl.isHidden = true
                cell.viewALLView.isHidden = true
            }
            cell.copyButton.tag = indexPath.row
            cell.copyButton.addTarget(self, action: #selector(tapCopyCoupon), for: .touchUpInside)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

}
