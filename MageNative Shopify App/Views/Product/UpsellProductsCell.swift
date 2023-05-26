//
//  UpsellProductsCell.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 29/03/20.
//  Copyright © 2020 MageNative. All rights reserved.
//
/*
import UIKit

protocol UpsellProductsHeightUpdate {
  func upsellHeightUpdate(products: Array<ProductViewModel>)
}

class UpsellProductsCell: UITableViewCell {
  
  @IBOutlet weak var addToCartButton: UIButton!
  @IBOutlet weak var totalPriceLabel: UILabel!
  @IBOutlet weak var headingLabel: UILabel!
  @IBOutlet weak var upsellCollectionView: UICollectionView!
  
  var delegate: UpsellProductsHeightUpdate?
  fileprivate var products: Array<ProductViewModel>?
  var parent = ProductViewController()
  var recommendedName = "upsell"
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func configure(products: Array<ProductViewModel>?)
  {
    self.products = products
    self.delegate?.upsellHeightUpdate(products: products!)
    upsellCollectionView.delegate = self;
    upsellCollectionView.dataSource = self;
    upsellCollectionView.reloadData()
    setPrice()
    addToCartButton.addTarget(self, action: #selector(groupedAddToCart(_:)), for: .touchUpInside)
  }
  
  @objc func groupedAddToCart(_ sender: UIButton){
    for (_,value) in parent.selectedProductsForUpsell{
      if let product = value["product"] as? ProductViewModel, let _ = value["selected"] as? VariantViewModel{
        let item = CartProduct(product: product, variant: WishlistManager.shared.getVariant(product.variants.items.first!), quantity: 1)
        CartManager.shared.addToCart(item)
        self.parent.setupTabbarCount()
      }
    }
    self.parent.view.showmsg(msg: " Added to cart".localized)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
extension UpsellProductsCell: UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return products?.count ?? 0;
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpsellProductCollectionCell.className, for: indexPath) as! UpsellProductCollectionCell

      let priceFont = mageFont.regularFont(size: 15.0)
    //let specialPriceFont = UIFont(name: "Helvetica", size: mageFont.regularsize)
    let priceColor = UIColor.gray;
    //let specialPriceColor = UIColor.red;
    let price = NSMutableAttributedString()
    //let attr1 = [NSAttributedString.Key.foregroundColor:specialPriceColor,NSAttributedString.Key.font:specialPriceFont!]
    cell.product = products?[indexPath.row]
    cell.configure()
    for index in cell.variationStack.arrangedSubviews{
      index.removeFromSuperview()
    }
    if let imgUrl = cell.product?.images.items[0].url{
      cell.productImageView.setImageFrom(imgUrl)
    }
    cell.productNameLabel.text = cell.product?.title
      cell.productNameLabel.font = mageFont.regularFont(size: 15.0)
    if let variantSelect = parent.upsellSelectedVariants?[indexPath.row]{
      cell.selectedVariant = variantSelect
        let attr = [NSAttributedString.Key.foregroundColor:priceColor,NSAttributedString.Key.font:priceFont]
      let attribute = NSAttributedString(string:  Currency.stringFrom(variantSelect.price), attributes: attr  as [NSAttributedString.Key : Any])
      price.append(attribute)
      cell.priceLabel.attributedText = price;
      if(cell.selectedVariant.selectedOptions.count > 0){
        if cell.selectedVariant.selectedOptions.first?.name == "Title" && cell.selectedVariant.selectedOptions.first?.value == "Default Title"{
        }
        else
        {
          let variationButtonView = VariationButtonView()
          variationButtonView.translatesAutoresizingMaskIntoConstraints = false
          let heightConstrain = NSLayoutConstraint(item: variationButtonView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 30)
          variationButtonView.addConstraint(heightConstrain)
          variationButtonView.variationButton.setTitle(cell.selectedVariant.title, for: .normal)
          variationButtonView.variationButton.tag = indexPath.row + 5555;
            variationButtonView.variationButton.titleLabel?.font = mageFont.regularFont(size: 15.0)
          variationButtonView.variationButton.addTarget(self, action: #selector(variationButtonClicked(_:)), for: .touchUpInside)
          cell.variationStack.addArrangedSubview(variationButtonView)
        }
      }
    }
    return cell;
  }
  
  @objc func variationButtonClicked(_ sender: UIButton){
    if let collectioncell = sender.superview?.superview?.superview?.superview?.superview as? UpsellProductCollectionCell{
      let tag = sender.tag - 5555;
      let index = products?[tag]
      var variant = index?.variants
      variant?.items = []
      
      let items = index?.variants.items
      var datasourc = [String]()
      for item in items!{
        if item.availableForSale == true{
          variant?.items.append(item)
          datasourc.append(item.title)
        }
      }
      
      let dropDown = DropDown(anchorView: sender)
      dropDown.dataSource = datasourc
      dropDown.selectionAction = {[unowned self](index, item) in
        sender.setTitle(item, for: UIControl.State());
        self.parent.upsellSelectedVariants?[tag] = (variant?.items[index])!
        self.parent.selectedProductsForUpsell[tag] = ["product":self.products![tag],"selected":variant!.items[index]]
          let priceFont = mageFont.regularFont(size: 15.0)
        let specialPriceFont = mageFont.regularFont(size: 15.0)
        let priceColor = UIColor.gray;
        let specialPriceColor = UIColor.red;
        let price = NSMutableAttributedString()
          let attr1 = [NSAttributedString.Key.foregroundColor:specialPriceColor,NSAttributedString.Key.font:specialPriceFont]
        
        let compareAtPrice = variant?.items[index].compareAtPrice == nil ? "false" : ( (variant?.items[index].price)! < (variant?.items[index].compareAtPrice!)! ? Currency.stringFrom((variant?.items[index].compareAtPrice!)!) : "false" )
        if  compareAtPrice != "false"{
          let attribute1 = NSAttributedString(string:  Currency.stringFrom((variant?.items[index].price)!), attributes: attr1  as [NSAttributedString.Key : Any])
          price.append(attribute1)
          
            let attr = [NSAttributedString.Key.strikethroughStyle:1,NSAttributedString.Key.font: priceFont,NSAttributedString.Key.foregroundColor:priceColor] as [NSAttributedString.Key : Any]
          price.append(NSAttributedString(string: " "))
          let attribute = NSAttributedString(string:  compareAtPrice, attributes: attr)
          price.append(attribute)
          collectioncell.priceLabel.attributedText = price;
        }
        else {
            let attr = [NSAttributedString.Key.foregroundColor:priceColor,NSAttributedString.Key.font:priceFont]
          let attribute = NSAttributedString(string:  Currency.stringFrom((variant?.items[index].price)!), attributes: attr  as [NSAttributedString.Key : Any])
          price.append(attribute)
          collectioncell.priceLabel.attributedText = price;
        }
        self.setPrice()
      }
      dropDown.bottomOffset = CGPoint(x: 0, y:sender.bounds.height)
      if dropDown.isHidden {
        let _ = dropDown.show();
      } else {
        dropDown.hide();
      }
    }
  }
  
  func setPrice(){
    var comparePrice = Decimal(0)
    var mainPrice = Decimal(0)
    for index in parent.upsellSelectedVariants!{
      let compareAtPrice = index.compareAtPrice == nil ? "false" : ( (index.price) < (index.compareAtPrice!) ? "\((index.compareAtPrice!))" : "false" )
      if(compareAtPrice != "false"){
        comparePrice += Decimal(string: compareAtPrice)!
        mainPrice += index.price
      }
      else
      {
        mainPrice += index.price
        comparePrice += index.price
      }
    }
      let priceFont = mageFont.regularFont(size: 15.0)
    let specialPriceFont = mageFont.regularFont(size: 15.0)
    let priceColor = UIColor.gray;
    let specialPriceColor = UIColor.red;
    let price = NSMutableAttributedString()
      let attr1 = [NSAttributedString.Key.foregroundColor:specialPriceColor,NSAttributedString.Key.font:specialPriceFont]
    if(mainPrice == comparePrice){
        let attr = [NSAttributedString.Key.foregroundColor:priceColor,NSAttributedString.Key.font:priceFont]
      let attribute = NSAttributedString(string:  Currency.stringFrom(mainPrice), attributes: attr  as [NSAttributedString.Key : Any])
      price.append(attribute)
      self.totalPriceLabel.attributedText = price;
    }
    else{
      let attribute1 = NSAttributedString(string:  Currency.stringFrom(mainPrice), attributes: attr1  as [NSAttributedString.Key : Any])
      price.append(attribute1)
      
        let attr = [NSAttributedString.Key.strikethroughStyle:1,NSAttributedString.Key.font: priceFont,NSAttributedString.Key.foregroundColor:priceColor] as [NSAttributedString.Key : Any]
      price.append(NSAttributedString(string: " "))
      let attribute = NSAttributedString(string:  Currency.stringFrom(comparePrice), attributes: attr)
      price.append(attribute)
      
      totalPriceLabel.attributedText = price;
    }
  }
}

extension UpsellProductsCell: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return CGSize(width: collectionView.frame.width - 15, height: 350)
  }
}
*/
