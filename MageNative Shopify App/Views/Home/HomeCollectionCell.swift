/**
 * CedCommerce
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the End User License Agreement (EULA)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://cedcommerce.com/license-agreement.txt
 *
 * @category  Ced
 * @package   MageNative
 * @author    CedCommerce Core Team <connect@cedcommerce.com >
 * @copyright Copyright CEDCOMMERCE (http://cedcommerce.com/)
 * @license      http://cedcommerce.com/license-agreement.txt
 */


import UIKit

protocol productClicked:AnyObject {
  func productCellClicked(product:ProductViewModel,sender:Any)
}

class HomeCollectionCell: UITableViewCell {
  
  @IBOutlet weak var titleView: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  fileprivate var products: PageableArray<ProductListViewModel>!
  @IBOutlet weak var collectionImageView: UIImageView!
  
  @IBOutlet weak var ViewAll: UIButton!
  var delegate:productClicked?
  var scrollHorizontal = false
  var parentView = HomeViewController()
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func prepareForReuse() {
    products = nil
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.reloadData()
  }
  
  func configureFrom(_ collection:collection?){
    collectionView.delegate = nil
    collectionView.dataSource = nil
    guard let collection = collection else {return}
      self.titleView.text = collection.title ?? ""
    fetchProducts(collection: collection)
    
    if scrollHorizontal {
      collectionView.isScrollEnabled = true
      if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
        layout.scrollDirection = .vertical
      }
    }
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}

extension HomeCollectionCell:UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return products?.items.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.className, for: indexPath) as! ProductCollectionViewCell
    cell.delegate = self
    cell.isFromHome=true
    cell.setupView((products.items[indexPath.row].model?.node.viewModel)!)
    return cell
  }
}

extension HomeCollectionCell:UICollectionViewDelegate{
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.delegate?.productCellClicked(product: (products.items[indexPath.row].model?.node.viewModel)!, sender: self)
  }
}

extension HomeCollectionCell: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if scrollHorizontal {
      return collectionView.calculateCellSize(numberOfColumns: 2)
    }
    return CGSize(width: collectionView.frame.width/3-1, height: 100)
  }
}

extension HomeCollectionCell:wishListDelegate{
  func addToWishListProduct(_ cell: ProductCollectionViewCell, didAddToWishList sender: Any) {
    guard let indexPath = self.collectionView.indexPath(for: cell) else {return}
    let product = self.products.items[indexPath.row]
    guard  let viewModel = product.model?.node.viewModel else {return}
    let wishProduct = CartProduct.init(product: viewModel, variant: WishlistManager.shared.getVariant(product.variants.items.first!))
   /* if WishlistManager.shared.isProductinWishlist(product: viewModel) {
      WishlistManager.shared.removeFromWishList(wishProduct)
    }else {
      WishlistManager.shared.addToWishList(wishProduct)
    } */
      if WishlistManager.shared.isProductVariantinWishlist(product: wishProduct){
          WishlistManager.shared.removeFromWishList(wishProduct)
      }
      else {
          WishlistManager.shared.addToWishList(wishProduct)
      }
    parentView.setupTabbarCount()
    parentView.setupNavBarCount()
    self.collectionView.reloadItems(at: [indexPath])
  }
}
extension HomeCollectionCell{
  func fetchProducts(collection: collection){
    Client.shared.fetchProducts(coll:collection,sortKey:MobileBuySDK.Storefront.ProductCollectionSortKeys.bestSelling,limit: 9 , completion: {
      [weak self] response,image,error,handle   in
      
      if let response = response {
        self?.products = response
        self?.products.items=[]
        for item in response.items{
          if item.model?.node.availableForSale == true{
            self?.products.items.append(item)
          }
        }
        self?.collectionImageView.setImageFrom(image)
        self?.collectionView.dataSource = self
        self?.collectionView.delegate = self
        self?.collectionView.reloadData()
      }      
    })
  }
}
