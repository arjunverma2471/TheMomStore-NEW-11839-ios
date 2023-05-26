//
//  VariantVCTVCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 13/04/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class VariantVCTVCell: UITableViewCell {

  @IBOutlet weak var variantTitle: UILabel!
  @IBOutlet weak var variantItemCollectionView: UICollectionView!
  
  
    @IBOutlet weak var variantDropDownBtn: UIButton!
    
  var selectedVariant: VariantViewModel!
  
  var item: MobileBuySDK.Storefront.ProductOption? {
    didSet{
      variantTitle.text = item?.name
      variantItemCollectionView.reloadData()
        variantDropDownBtn.setTitle(item?.values.first, for: .normal)
    }
  }
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    variantItemCollectionView.delegate = self
    variantItemCollectionView.dataSource = self
    let nib2 = UINib(nibName: VariantItemCVCell.className, bundle: nil)
    variantItemCollectionView.register(nib2, forCellWithReuseIdentifier: VariantItemCVCell.className)
      //New Code
      if customAppSettings.sharedInstance.isDropDownVariant{
          variantItemCollectionView.isHidden = true
          variantDropDownBtn.isHidden = false
      }
      else{
          variantItemCollectionView.isHidden = false
          variantDropDownBtn.isHidden = true
      }
      variantDropDownBtn.layer.cornerRadius = 2
      variantDropDownBtn.layer.borderColor = UIColor.black.cgColor
      variantDropDownBtn.layer.borderWidth = 0.2
      variantDropDownBtn.setTitleColor(.black, for: .normal)
      variantDropDownBtn.addTarget(self, action: #selector(show_Variants(_:)), for: .touchUpInside)
      //
    }
    
    @objc func show_Variants(_ sender : UIButton) {
        let dropDown = DropDown(anchorView: sender)
        var dataSource = [String]()
        dataSource = item?.values ?? []
        dropDown.dataSource = dataSource
        dropDown.selectionAction = {[unowned self](index, value) in
            sender.setTitle(value, for: UIControl.State());
            self.variantDropDownBtn.titleLabel?.text = value
            guard let itemVal = item?.values[index], let itemName = item?.name else {return}
            let dict = [itemName:itemVal]
            VariantSelectionManager.shared.setUserSelectedVariants(dict)
        }
        
        dropDown.bottomOffset = CGPoint(x: 0, y:sender.bounds.height)
        if dropDown.isHidden {
            dropDown.setAlignment(dropDown);
            let _ = dropDown.show();
        } else {
            dropDown.hide();
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

extension VariantVCTVCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return item?.values.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VariantItemCVCell.className, for: indexPath) as! VariantItemCVCell
    cell.setupView()
    let itemName        = item?.values[indexPath.row]
    cell.itemLabel.text = itemName
    VariantSelectionManager.shared.userSelectedVariants[item!.name] == item?.values[indexPath.row] ? cell.itemLabel.selectedItem() : cell.itemLabel.unselectedItem()
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //    return CGSize(width: (collectionView.frame.width/4 - 10), height: 30)
    let itemName        = item?.values[indexPath.row]
//    let btnSize = (itemName as! NSString).size(withAttributes: [NSAttributedString.Key.font:mageFont.regularFont(size: 15.0)])
//    return CGSize(width: btnSize.width + 100, height: 30)
    return CGSize(width: (collectionView.frame.width/4 - 10), height: 30)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let itemVal = item?.values[indexPath.row], let itemName = item?.name else {return}
    let dict = [itemName:itemVal]
    VariantSelectionManager.shared.setUserSelectedVariants(dict)
    collectionView.reloadData()
  }
}


extension String {
  func seperate()->[String]{
    let trimmed    = self.components(separatedBy: "/").map { val in
      val.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    return trimmed
  }
}
