//
//  CartPickupCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 12/10/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import UIKit

class CartPickupCell: UITableViewCell {

    @IBOutlet weak var shippingBtn: UIButton!
    @IBOutlet weak var pickupBtn: UIButton!
    @IBOutlet weak var deliveryBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData() {
        deliveryBtn.setTitle("Local Delivery".localized, for: .normal)
        deliveryBtn.ButtonTextDown(spacing: 10)
        deliveryBtn.tintColor = UIColor(light: .black, dark: .white)
        deliveryBtn.btnView()
        pickupBtn.setTitle("Store Pickup".localized, for: .normal)
        pickupBtn.ButtonTextDown(spacing: 10)
        pickupBtn.btnView()
        shippingBtn.setTitle("Shipping".localized, for: .normal)
        shippingBtn.ButtonTextDown(spacing: 10)
        shippingBtn.tintColor = UIColor(light: .black, dark: .white)
        pickupBtn.tintColor = UIColor(light: .black, dark: .white)
        shippingBtn.btnView()
        deliveryBtn.titleLabel?.font = mageFont.mediumFont(size: 15.0)
        pickupBtn.titleLabel?.font = mageFont.mediumFont(size: 15.0)
        shippingBtn.titleLabel?.font = mageFont.mediumFont(size: 15.0)
    }

}
