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

class HomeRecentlyViewedCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
     var parentView = HomeViewController()
    var products: [ProductViewModel]!{
        didSet {
            self.collectionView.reloadData()
        }
    }
      var delegate:productClicked?
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func configureFrom(){
        //self.products = recentlyViewedManager.shared.recentlyViewedProduct
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension HomeRecentlyViewedCell:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell    = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.className, for: indexPath) as! ProductCollectionViewCell
        let product = self.products[indexPath.item]
        cell.setupView(product)
        cell.delegate = self
        return cell
    }
}

extension HomeRecentlyViewedCell:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.productCellClicked(product: products[indexPath.row], sender: self)
    }
}

extension HomeRecentlyViewedCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if  UIDevice.current.model.lowercased() == "ipad".lowercased() {
            return collectionView.calculateCellSize(numberOfColumns: 6)
        }else {
            return CGSize(width: collectionView.frame.width/2, height: collectionView.frame.height - 10)
            
        }
    }
}


extension HomeRecentlyViewedCell:wishListDelegate{
    func addToWishListProduct(_ cell: ProductCollectionViewCell, didAddToWishList sender: Any) {
        guard let indexPath = self.collectionView.indexPath(for: cell) else {return}
        let product = self.products[indexPath.row]
        
        let wishProduct = CartProduct.init(product: product, variant: WishlistManager.shared.getVariant(product.variants.items.first!))
      
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


