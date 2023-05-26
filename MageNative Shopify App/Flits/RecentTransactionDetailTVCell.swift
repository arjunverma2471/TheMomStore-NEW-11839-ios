//
//  RecentTransactionDetailTVCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 10/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//


import UIKit

class RecentTransactionDetailTVCell: UITableViewCell {
  
  @IBOutlet weak var creditImage: UIImageView!
  @IBOutlet weak var crdr: UILabel!
  @IBOutlet weak var creditReason: UILabel!
  @IBOutlet weak var containerView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.selectionStyle = .none
  }
  
  var creditLog: CreditLog? {
    didSet{
      let symbol = Currencies.currency(for: Client.shared.getCurrencyCode()!)!.shortestSymbol
      print("SEE==",symbol)
      if let crdr = creditLog?.credits{
        var text = (crdr/100).description
        if creditLog?.credits ?? Double() < 0 {
          creditImage.image = UIImage(named: "creditMinus")
          text.insert(contentsOf:symbol,  at: text.index(text.startIndex, offsetBy: 1))
        }else{
          text.insert(contentsOf:symbol, at: text.startIndex)
          creditImage.image = UIImage(named: "credit")
        }
        self.crdr.text = text
      }
      creditReason.text =
      """
      \(creditLog?.comment ?? "")
      \(creditLog?.createdAt ?? "")
      """
    }
  }
}
