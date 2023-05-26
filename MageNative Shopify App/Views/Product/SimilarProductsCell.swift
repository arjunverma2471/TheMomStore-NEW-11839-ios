//
//  SimilarProductsCell.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 27/03/20.
//  Copyright © 2020 MageNative. All rights reserved.
//

import UIKit

protocol RecommendedProductsLayoutUpdate {
  func updateLayoutAccordingToGrid(collection:UICollectionView?, productsArray: Array<ProductViewModel>!, recommendedName: String)
}

protocol updateCartData {
 func reloadcartData()
}

class SimilarProductsCell: UITableViewCell, ProductAddProtocol {
  
  func productAdded() {
//    if let parent = self.parent as? ProductViewController {
//      parent.setupCartBadgeCount()
//    }
    self.parent.setupTabbarCount()
    
    updateDelegate?.reloadcartData()
    
  }
  
  @IBOutlet weak var headingLabel: UILabel!
  @IBOutlet weak var productsCollectionView: UICollectionView!
  
  var products: Array<ProductViewModel>!
  var recommendedName = ""
  var delegate:productClicked?
  var layoutDelegate: RecommendedProductsLayoutUpdate?
  var updateDelegate: updateCartData?
  var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
    var show_Shimmer = false
  
  var parent = UIViewController()
  
  override func awakeFromNib() {
    super.awakeFromNib()
      
    // Initialization code
  }
  
  func configure(){
    productsCollectionView.delegate = self;
    productsCollectionView.dataSource = self;
    layoutDelegate?.updateLayoutAccordingToGrid(collection: productsCollectionView, productsArray: products, recommendedName: recommendedName)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
}

extension SimilarProductsCell:UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return products?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimilarProductsSliderCell", for: indexPath) as! SimilarProductsSliderCell
    cell.delegate = self
    cell.layer.masksToBounds = false
    cell.layer.shadowOffset  = CGSize(width: 0, height: 0)
      cell.layer.shadowColor = UIColor(light: .lightGray,dark: UIColor.provideColor(type: .cartVc).backGroundColor).cgColor
    cell.layer.shadowOpacity = 0.7
    cell.layer.cornerRadius  = 2
    cell.delegate            = self
    cell.addToCart.addTarget(self, action: #selector(addToCartPressed(_:)), for: .touchUpInside)
      cell.addToCart.titleLabel?.font = mageFont.mediumFont(size: 15.0)
      cell.addToCart.setTitle("Add To Bag".localized, for: .normal)
    cell.addToCart.tag = indexPath.item
    cell.setupView((products[indexPath.row].model?.viewModel)!)
      
      cell.addToCart.isHidden = true
      cell.bottomWishlist.isHidden = true
      
    return cell
  }
  
  @objc func addToCartPressed(_ sender:UIButton) {
      if self.products[sender.tag].sellingPlansGroups.items.count > 0 {
          let product         = self.products[sender.tag]
          let productViewController=ProductVC()
          productViewController.product = product
          self.parent.navigationController?.pushViewController(productViewController, animated: true)
         
      }
      else {
          if(self.products[sender.tag].variants.items.first?.title == "Default Title"){
            if(!(self.products[sender.tag].variants.items.first?.availableForSale ?? false)){
              self.quickAddClicked(productId: self.products[sender.tag].id , title: self.products[sender.tag].title ,error: true)
            }
            else
            {
              let variantt = WishlistManager.shared.getVariant((self.products[sender.tag].variants.items.first)!)
              let product = self.products[sender.tag]
                let item = CartProduct(product: (product), variant: variantt, quantity: 1)
                CartManager.shared.addToCart(item)
              
                self.quickAddClicked(productId: self.products[sender.tag].id , title: self.products[sender.tag].title ,error: false)
              
            }
          }
          else
          {
            self.quickAddClicked(productId: self.products[sender.tag].id ,title: "",error: false)
          }
      }
    
  }
  
  func quickAddClicked(productId: String,title: String,error: Bool) {
    if(title == ""){
      let vc = AddToCartVC()
      vc.id = productId
      self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self.parent, presentingViewController: vc)
      vc.modalPresentationStyle = .custom
      vc.delegate = self;
      vc.isFromWishlist=false
      vc.transitioningDelegate = self.halfModalTransitioningDelegate
      self.parent.present(vc, animated: true, completion: nil)
    }
    else{
      if(error)
      {
        self.parent.view.makeToast(title+" not available.".localized, duration: 2.0, position: .center)
      }
      else
      {
        self.parent.view.makeToast(title+" added to cart.".localized, duration: 2.0, position: .center)
        self.parent.setupTabbarCount()
      }
    }
  }
}

extension SimilarProductsCell:similarWishlistDelegate
{  
  func addToWishListProduct(_ cell: SimilarProductsSliderCell, didAddToWishList sender: Any) {
    
    guard let indexPath = self.productsCollectionView.indexPath(for: cell) else {return}
    let product = self.products[indexPath.row]
    guard let productModel = product.model?.viewModel else {return}
    let wishProduct = CartProduct.init(product:productModel , variant: WishlistManager.shared.getVariant(product.variants.items.first!))
  
      if WishlistManager.shared.isProductVariantinWishlist(product: wishProduct){
          WishlistManager.shared.removeFromWishList(wishProduct)
      }
      else {
          WishlistManager.shared.addToWishList(wishProduct)
      }
    self.productsCollectionView.reloadItems(at: [indexPath])
    self.parent.setupTabbarCount()
  }
}

extension SimilarProductsCell:UICollectionViewDelegate{
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.delegate?.productCellClicked(product: (products[indexPath.row].model?.viewModel)!, sender: self)
  }
}

extension SimilarProductsCell: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if  UIDevice.current.model.lowercased() == "ipad".lowercased() {
        return collectionView.calculateHalfCellSize(numberOfColumns: 3.1)
    }
      return collectionView.calculateHalfCellSize(numberOfColumns: 2.3)
  }
}

