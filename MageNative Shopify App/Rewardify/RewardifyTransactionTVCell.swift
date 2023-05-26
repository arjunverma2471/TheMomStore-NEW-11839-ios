//
//  RewardifyTransactionTVCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 22/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class RewardifyTransactionTVCell: UITableViewCell {

  @IBOutlet weak var id: UILabel!
  @IBOutlet weak var amount: UILabel!
  @IBOutlet weak var openBalance: UILabel!
  @IBOutlet weak var type: UILabel!
  @IBOutlet weak var effectiveDate: UILabel!
  @IBOutlet weak var expiryDate: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  
  var transaction: RewardifyTransactionModel?{
    didSet{
      if let transaction = transaction {
        
        let symbol = Currencies.currency(for: transaction.amountCurrency!)!.shortestSymbol
        let a = transaction.id?.description
        id.text = a ?? "N/A"
        var amountText = transaction.amount ?? "N/A"
        if amountText.contains("-"){
          amountText.insert(contentsOf:symbol,  at: amountText.index(amountText.startIndex, offsetBy: 1))
          
        }else{
          amountText.insert(contentsOf: symbol, at: amountText.startIndex)
        }
        amount.text = amountText
        
        var openBalanceText = transaction.customerOpenBalance ?? "N/A"
        openBalanceText.insert(contentsOf: symbol, at: openBalanceText.startIndex)
        openBalance.text = openBalanceText
        
        type.text = transaction.transactionType
        effectiveDate.text = transaction.effectiveAt ?? "N/A"
        expiryDate.text = transaction.expiresAt ?? "N/A"
      }
    }
  }
}

