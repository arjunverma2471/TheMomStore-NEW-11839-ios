//
//  RewardifyCartTVCelll.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 27/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RewardifyCartTVCelll: UITableViewCell {
  
  @IBOutlet weak var showDiscountCode: UIButton!
  
  var parent                     :UIViewController?
  private(set) var disposeBag    = DisposeBag()
  
  override func prepareForReuse(){
    super.prepareForReuse()
    disposeBag = DisposeBag() // because life cicle of every cell ends on prepare for reuse
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    showDiscountCode.backgroundColor    = UIColor.AppTheme()
    showDiscountCode.layer.cornerRadius = 5
    showDiscountCode.titleLabel?.font   = mageFont.mediumFont(size: 15)
    showDiscountCode.setTitleColor(UIColor.textColor(), for: .normal)
    
  }
  
  func setupView(){
    showDiscountCode.rx.tap.subscribe({ [weak self] (onTap) in
      print("Hello")
        let vc = RewardifyActiveDiscountList()
        vc.modalPresentationStyle = .fullScreen
        self?.parent?.navigationController?.present(vc, animated: true, completion: nil)
    //self?.parent?.navigationController?.present(RewardifyActiveDiscountList(), animated: true, completion: nil)
    }).disposed(by: disposeBag)
  }
}
