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
import MobileBuySDK
protocol ProductAddProtocol {
    func productAdded()
}
class WishlistViewController: BaseViewController {
    
    
    var flitsWishlistManager: FlitsProfileManager?
    
    @IBOutlet weak var collectionView: UICollectionView!
    var cartbutton : BadgeButton!
    static let shared = WishlistViewController()
    var wishListData = [WishlistDetail]()
    var wishlistArrayData : Array<ProductViewModel>?
    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
    
    let shimmer = customShimmerView(cellsArray: [productListingShimmerTC.reuseID], productListCount: 20)
    
    var wishlistQtyLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUPTable()
        self.updateNavigationBarData()
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 13
        self.navigationItem.rightBarButtonItems?.insert(space, at: 0)
        cartbutton = BadgeButton(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        cartbutton.setImage(UIImage(named: "bag"), for: .normal)
        cartbutton.imageView?.contentMode = .scaleAspectFit;
        cartbutton.addTarget(self, action: #selector(bagButtonClicked(_:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItems?.insert(UIBarButtonItem(customView: cartbutton), at: 0)
    }
    
    func updateNavigationBarData() {
        let titleWidth = ("My Wishlist".localized as NSString).size(withAttributes: [NSAttributedString.Key.font: mageFont.mediumFont(size: 15)]).width//width calculate
        
        let titleQtyWidth = (" (\((DBManager.shared.wishlistProducts?.count == 0 ? nil : DBManager.shared.wishlistProducts?.count) ?? 0) "+"Items)".localized as NSString).size(withAttributes: [NSAttributedString.Key.font: mageFont.regularFont(size: 12)]).width//width calculate
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: titleWidth, height: 30))
        title.font = mageFont.mediumFont(size: 15)
        title.text = "My Wishlist".localized
        title.textColor = UIColor(light: Client.navigationThemeData?.icon_color ?? .white, dark: UIColor.white)
        
        wishlistQtyLabel.frame = CGRect(x: 0, y: 0, width: titleQtyWidth, height: 30)
        wishlistQtyLabel.font = mageFont.regularFont(size: 12)
        self.wishlistQtyLabel.textColor =  UIColor(light: Client.navigationThemeData?.icon_color ?? .white, dark: UIColor.white)
        if let count = DBManager.shared.wishlistProducts?.count {
            if count == 0 {
                self.wishlistQtyLabel.text = ""
            }
            else {
                self.wishlistQtyLabel.text = " (\(count) "+"Items)".localized
            }
        }

        let stack = UIStackView(arrangedSubviews: [title, wishlistQtyLabel])
        stack.distribution = .fill
        stack.axis = .horizontal
        navigationItem.leftBarButtonItems?.append(UIBarButtonItem(customView: stack))
    }
    
    func updateWishlistHeading() {
        self.wishlistQtyLabel.textColor =  UIColor(light: Client.navigationThemeData?.icon_color ?? .white, dark: UIColor.white)
        if let count = DBManager.shared.wishlistProducts?.count {
            if count == 0 {
                self.wishlistQtyLabel.text = ""
            }
            else {
                self.wishlistQtyLabel.text = " (\(count) "+"Items)".localized
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //    self.setupFlitsWishlist()
        self.loadData()
        self.setupTabbarCount()
        self.updateCartCount()
        //JS
        self.tabBarController?.tabBar.tabsVisiblty()
    }
    
    func setupFlitsWishlist(){
        if customAppSettings.sharedInstance.flitsIntegration{
            flitsWishlistManager = FlitsProfileManager()
            flitsWishlistManager?.flitsViewWishlist(completion: { wishProducts in
            })
        }
    }
    
    func loadData(){
        shimmer.frame = self.view.bounds
        view.addSubview(shimmer)
        view.bringSubviewToFront(shimmer)
        wishListData = [WishlistDetail]()
        wishlistArrayData = []
        wishListData = DBManager.shared.wishlistProducts ?? [WishlistDetail]()
        if wishListData.count > 0 {
            var ids = [GraphQL.ID]()
            for items in wishListData {
                ids.append(GraphQL.ID(rawValue: items.id))
            }
            Client.shared.fetchMultiProducts(ids: ids) { response, error in
                if let response = response {
                    self.wishlistArrayData = response
                    DispatchQueue.main.async {
                        self.shimmer.removeFromSuperview()
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                self.shimmer.removeFromSuperview()
                self.collectionView.reloadData()
            }
            
        }
       
        
        // self.setUPTable()
    }
    
    func setUPTable(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
        self.collectionView.emptyDataSetSource = self
        self.collectionView.emptyDataSetDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension WishlistViewController:UICollectionViewDelegate
{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let product = self.wishlistArrayData?[indexPath.row] else {return}
        let wishlistData = self.wishListData[indexPath.row]
        let selectedVariant = product.variants.items.filter{$0.id==wishlistData.variant.id}.first
        guard let selectedVariant = selectedVariant else {return}
        let productViewController=ProductVC()
        productViewController.product = product
        productViewController.selectedVariant = selectedVariant
        self.navigationController?.pushViewController(productViewController, animated: true)
    }
}

extension WishlistViewController:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wishlistArrayData?.count ?? 0 > 0 ? wishlistArrayData?.count ?? 0 : 0
       // return wishListData.count > 0 ? wishListData.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wishlistCollectionCell", for: indexPath) as? wishlistCollectionCell
        cell?.parent = self;
        if let data = wishlistArrayData?[indexPath.row] {
            cell?.configureWishlistData(model: data, wishModel: wishListData[indexPath.row])
        }
        cell?.deleteButton.addTarget(self, action: #selector(deleteProduct(_:)), for: .touchUpInside)
        cell?.deleteButton.tag = indexPath.row
        cell?.outerView.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .wishListCollectionCell).backGroundColor)
        cell?.moveToCart.addTarget(self, action: #selector(addToCartPressed(_:)), for: .touchUpInside)
        cell?.moveToCart.tag = indexPath.row
        return cell!
    }
    
    @objc func deleteProduct(_ sender:UIButton) {
        SweetAlert().showAlert("Warning".localized, subTitle: "Do you want remove this Item from Wishlist?".localized, style: AlertStyle.warning, buttonTitle:"No".localized, buttonColor:UIColor(hexString: "#cd7b72") , otherButtonTitle:  "Yes".localized, otherButtonColor:UIColor(hexString: "#29b456")) { (isOtherButton) -> Void in
            if isOtherButton == true {
                print("Cancel Button  Pressed")
            }
            else {
                let product = self.wishlistArrayData?[sender.tag]
                let wishlistData = self.wishListData[sender.tag]
                let cartProd = CartProduct(product: product, variant: wishlistData.variant)
                WishlistManager.shared.removeFromWishList(cartProd)
                self.wishListData.remove(at: sender.tag)
                self.loadData()
                self.updateWishlistHeading()
                self.setupTabbarCount()
                _ = SweetAlert().showAlert("Deleted!".localized, subTitle: "Your Item has been Removed!".localized, style: AlertStyle.success)
                self.updateCartCount()
            }
        }
    }
    
    @objc func addToCartPressed(_ sender : UIButton) {
        guard let product = self.wishlistArrayData?[sender.tag] else {return}
        let wishlistData = self.wishListData[sender.tag]
        let selectedVariant = product.variants.items.filter{$0.id==wishlistData.variant.id}.first
        guard let selectedVariant = selectedVariant else {return}
        if product.requiresSellingPlan {
            let productViewController=ProductVC()
            productViewController.product = product
            productViewController.selectedVariantID = selectedVariant.id
            self.navigationController?.pushViewController(productViewController, animated: true)
        }
        
        let availableQty = selectedVariant.availableQuantity
        let availableForSale = selectedVariant.availableForSale
        if  availableQty == "0" &&  !availableForSale{
            self.view.makeToast("Product is Currently out of stock.".localized, duration: 1.5, position: .center)
        }
        else{
            let cartProd = CartProduct(product: product, variant: WishlistManager.shared.getVariant(selectedVariant),quantity: 1)
            var msg = ""
            if selectedVariant.title == "Default Title" {
                msg = "You have added ".localized + product.title + " to your cart.".localized
                
            }
            else {
                msg = "You have added ".localized + selectedVariant.title + " of product ".localized + product.title + " in your cart.".localized
                
            }
            CartManager.shared.addToCart(cartProd)
            WishlistManager.shared.removeFromWishList(cartProd)
            self.view.showmsg(msg: msg)
            
            self.loadData()
            self.updateWishlistHeading()
            self.setupTabbarCount()
            self.updateCartCount()
        }
        
    }
    
    @objc func bagButtonClicked(_ sender : UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let data = DBManager.shared.cartProducts?.filter{$0.sellingPlanId != ""}
        if data?.count ?? 0 > 0 {
            let vc : NewCartViewController = storyboard.instantiateViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let viewController:CartViewController = storyboard.instantiateViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func updateCartCount() {
        print("CART COUNT====>", CartManager.shared.cartCount.description)
        cartbutton.badge = CartManager.shared.cartCount == 0 ? nil : CartManager.shared.cartCount.description
        
    }
}


extension WishlistViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.model.lowercased() == "ipad".lowercased(){
            return collectionView.calculateCellSize(numberOfColumns: 4,of: 150.0)
        }
        return collectionView.calculateCellSize(numberOfColumns: 2,of: 175)
    }
}

extension WishlistViewController:DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return DBManager.shared.wishlistProducts?.count == 0
    }
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        let custom = EmptyView()
        custom.delegate = self;
        custom.configure(imageName: "emptyWishlist", title: EmptyData.wishListTitle, subtitle: EmptyData.wishDescription)
        return custom;
    }
}

extension WishlistViewController: QuickCartProtocol{
    func quickAddClicked(productId: String,title: String,error: Bool) {
        if(title == ""){
            let vc = AddToCartVC()
            vc.id = productId
            self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: vc)
            vc.modalPresentationStyle = .custom
            vc.delegate = self;
            vc.isFromWishlist=true
            vc.transitioningDelegate = self.halfModalTransitioningDelegate
            self.present(vc, animated: true, completion: nil)
        }
        else{
            if(error){
                self.view.makeToast(title+" not available.".localized, duration: 2.0, position: .center)
            }
            else{
                self.view.makeToast(title+" added to cart.".localized, duration: 2.0, position: .center)
                self.loadData()
                self.setupTabbarCount()
                self.setUPTable()
                self.updateCartCount()
            }
        }
    }
}

extension WishlistViewController: ProductAddProtocol{
    func productAdded() {
        self.loadData()
        self.setupTabbarCount()
        self.setUPTable()
        self.updateCartCount()
    }
}
