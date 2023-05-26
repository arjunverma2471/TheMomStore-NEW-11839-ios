//
//  FilterTableCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 14/08/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FilterTableCell: UITableViewCell {

    @IBOutlet weak var imgBtn: UIButton!
    
    @IBOutlet weak var textLbl: UILabel!
    var value = false
    var disposeBag = DisposeBag()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
      //  imgBtn.setImage(UIImage(named: "unchecked"), for: .normal)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
