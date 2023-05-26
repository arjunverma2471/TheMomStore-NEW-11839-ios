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

class ProductRelatedProductsCell: UITableViewCell {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var productCollection: UICollectionView!
     var products: PageableArray<ProductListViewModel>!{
        didSet {
            self.productCollection.reloadData()
        }
    }
    fileprivate let columns:  Int = 2
    var delegate:productClicked?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCollectionView()
    }
    
    
    func setupCollectionView(){
        productCollection.delegate = self
        productCollection.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ProductRelatedProductsCell:UICollectionViewDataSource{
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell    = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.className, for: indexPath) as! ProductCollectionViewCell
        let product = self.products.items[indexPath.item]
        cell.delegate = self
        guard let productmodel = product.model?.node.viewModel else {return cell}
        cell.setupView(productmodel)
        return cell
    }
    
    
}

extension ProductRelatedProductsCell:wishListDelegate{
    func addToWishListProduct(_ cell: ProductCollectionViewCell, didAddToWishList sender: Any) {
        guard let indexPath = self.productCollection.indexPath(for: cell) else {return}
        let product = self.products.items[indexPath.row]
        
        guard let productmodel = product.model?.node.viewModel else {return}
        let wishProduct = CartProduct.init(product: productmodel, variant: WishlistManager.shared.getVariant(product.variants.items.first!))
      
        if WishlistManager.shared.isProductVariantinWishlist(product: wishProduct){
            WishlistManager.shared.removeFromWishList(wishProduct)
        }
        else {
            WishlistManager.shared.addToWishList(wishProduct)
        }
        self.productCollection.reloadItems(at: [indexPath])
    }
}

extension ProductRelatedProductsCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return collectionView.calculateCellSize(numberOfColumns: self.columns)
    }
}


