//
//  ProductListCollectionCell.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 08/02/20.
//  Copyright © 2020 MageNative. All rights reserved.
//

import UIKit

class ProductListCollectionCell: UICollectionViewCell {
    
    // @IBOutlet weak var addToWishList: UIButton!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productPrice: UILabel!  
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var outOfStockImage: UIImageView!
  
    lazy var outOfStockLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Out of Stock".localized
        label.textAlignment = .center
        label.font = mageFont.mediumFont(size: 12.0)
        label.backgroundColor = UIColor(hexString: "#F55353").withAlphaComponent(0.7)
        label.textColor = UIColor.white
        label.layer.maskedCorners = Client.locale == "ar" ? [.layerMinXMinYCorner] : [.layerMaxXMinYCorner]
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.numberOfLines = 2
        return label
    }()
    
    var priceFont = mageFont.regularFont(size: 15.0)
    var specialPriceFont = mageFont.lightFont(size: 15.0)
    var itemNameFont = mageFont.regularFont(size: 15.0)
    var priceColor = UIColor.white;
    var specialPriceColor = UIColor.red;
    var itemTitleColor = UIColor.gray;
    var specialPriceHide = false;
    var delegate:wishListDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        let screenWidth = self.frame.width
        productImage.backgroundColor = .randomAlpha
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //addToWishList.addTarget(self, action: #selector(self.addItemToWishList(_:)), for: .touchUpInside)
        productPrice.numberOfLines = 0
    }
    
    func setupView(_ model:ProductViewModel){
        addSubview(outOfStockLabel)
        outOfStockLabel.anchor(left: productImage.leadingAnchor, bottom: productImage.bottomAnchor, paddingLeft: 0, paddingBottom: 0, width: (productImage.frame.width), height: 45)
        productName?.text = model.title
        productName?.font = itemNameFont
        productName?.textColor = itemTitleColor
        productPrice?.attributedText =  self.calCulatePrice(model)
        productImage?.setImageFrom(model.images.items.first?.url)
        self.outOfStockImage.isHidden = true
        if model.availableForSale {
            self.outOfStockLabel.isHidden=true
        }
        else {
            self.outOfStockLabel.isHidden=false
        }
    }
    
    @objc func addItemToWishList(_ sender:UIButton){
        //self.delegate?.addToWishListProduct(self, didAddToWishList: sender)
    }
    
    func calCulatePrice(_ model:ProductViewModel) -> NSMutableAttributedString?{
        let price = NSMutableAttributedString()
        let attr1 = [NSAttributedString.Key.foregroundColor:specialPriceColor,NSAttributedString.Key.font:priceFont]
        
        if model.compareAtPrice != "false" && specialPriceHide == false{
            let attribute1 = NSAttributedString(string:  model.price, attributes: attr1  as [NSAttributedString.Key : Any])
            
            let attr = [NSAttributedString.Key.strikethroughStyle:1,NSAttributedString.Key.font: specialPriceFont,NSAttributedString.Key.foregroundColor:priceColor] as [NSAttributedString.Key : Any]
            
            let attribute = NSAttributedString(string:  model.compareAtPrice, attributes: attr)
            price.append(attribute)
            price.append(NSAttributedString(string: " "))
            price.append(attribute1)
            return price
        }
        else {
            let attr = [NSAttributedString.Key.foregroundColor:priceColor,NSAttributedString.Key.font:priceFont]
            let attribute = NSAttributedString(string:  model.price, attributes: attr  as [NSAttributedString.Key : Any])
            price.append(attribute)
            return price
        }
    }
}
