//
//  RewardifyDiscountDetailTVCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 27/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RewardifyDiscountDetailTVCell: UITableViewCell {
  
  private(set) var disposeBag    = DisposeBag()
  
  @IBOutlet weak var discountAmount: UILabel!
  @IBOutlet weak var discountCode: UILabel!
  @IBOutlet weak var copyDiscount: UIButton!
  @IBOutlet weak var revertDiscount: UIButton!
  
  
  override func prepareForReuse(){
      super.prepareForReuse()
      disposeBag = DisposeBag() // because life cicle of every cell ends on prepare for reuse
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    copyDiscount.backgroundColor    = UIColor.AppTheme()
    copyDiscount.layer.cornerRadius = 5
    copyDiscount.titleLabel?.font   = mageFont.mediumFont(size: 15)
    copyDiscount.setTitleColor(UIColor.textColor(), for: .normal)

    revertDiscount.backgroundColor    = UIColor.AppTheme()
    revertDiscount.layer.cornerRadius = 5
    revertDiscount.titleLabel?.font   = mageFont.mediumFont(size: 15)
    revertDiscount.setTitleColor(UIColor.textColor(), for: .normal)
    discountCode.font                 = mageFont.mediumFont(size: 13)
    discountAmount.font               = mageFont.mediumFont(size: 13)
    
  }
  
  var discountListingModel: DiscountListingModel?{
    didSet{
      let curr = discountListingModel?.currency ?? "N/A"
      var amount = discountListingModel?.amount ?? "N/A"
      
      let amountWithCurr = getWithCurrencyDetail(curr, &amount)
      discountAmount.text = "Discount code genearted for \(amountWithCurr)"
      discountCode.text   = discountListingModel?.code
      
      copyDiscount.rx.tap.subscribe { [weak self] (onTap) in
        UIPasteboard.general.string = self?.discountListingModel?.code
      }.disposed(by: disposeBag)
    }
  }
  
  func getWithCurrencyDetail(_ currency: String,_ amount: inout String)->String{

    let symbol = Currencies.currency(for: currency)!.shortestSymbol
    amount.insert(contentsOf: symbol, at: amount.startIndex)
    return amount
  }
}

