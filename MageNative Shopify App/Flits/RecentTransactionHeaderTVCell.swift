//
//  RecentTransactionHeaderTVCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 10/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class RecentTransactionHeaderTVCell: UITableViewCell {

    @IBOutlet weak var qrdrLabel: UILabel!
    @IBOutlet weak var recentTransactions: UILabel!
    @IBOutlet weak var containerView: UIView!
  override func awakeFromNib() {
        super.awakeFromNib()
    containerView.layer.borderColor = UIColor.darkGray.cgColor
    containerView.layer.borderWidth = 1
      qrdrLabel.text = "CR/DR\nCreditReason\nDate".localized
      recentTransactions.text = "Recent Transactions".localized
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

// This syntax reflects changes made to the Swift language as of Aug. '16
extension UIView {
    
    // Example use: myView.addBorder(toSide: .Left, withColor: UIColor.redColor().CGColor, andThickness: 1.0)
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }
        
        layer.addSublayer(border)
    }
}
