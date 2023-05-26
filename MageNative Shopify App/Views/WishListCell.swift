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
//import RxSwift
//import RxCocoa

//protocol QuickCartProtocol {
//  func quickAddClicked(productId: String,title: String,error: Bool)
//}

class WishListCell: UITableViewCell {
  
//  @IBOutlet weak var addToCartButton: UIButton!
//  @IBOutlet weak var productImage: UIImageView!
//  @IBOutlet weak var productName: UILabel!
//  @IBOutlet weak var subTitle: UILabel!
//  @IBOutlet weak var price: UILabel!
//  var disposeBag = DisposeBag()
//  var delegate: QuickCartProtocol?
//
//  override func awakeFromNib() {
//    super.awakeFromNib()
//    // Initialization code
//  }
//
//  func configure(from model:ProductViewModel){
//    self.productImage.setImageFrom(model.images.items.first?.url)
//    self.productName.text = model.title
//    let wish = WishlistManager.shared.fetchWishProduct(id: model.id).first
//    if wish?.variant?.title == "Default Title"{
//      self.subTitle.text =  ""
//    }else{
//      self.subTitle.text =  wish?.variant?.title
//    }
//    self.price.text = model.price
//    addToCartButton.rx.tap.bind{[weak self] in
//      if(wish?.variant?.title == "Default Title"){
//        if(!(model.variants.items.first?.availableForSale ?? false)){
//          self?.delegate?.quickAddClicked(productId: model.id, title: model.title,error: true)
//        }
//        else{
//          let item = CartProduct(product: model, variant: (wish?.variant!)!, quantity: 1)
//          CartManager.shared.addToCart(item)
//          WishlistManager.shared.removeFromWishList(item)
//          self?.delegate?.quickAddClicked(productId: model.id, title: model.title,error: false)
//        }
//
//      }
//      else{
//        self?.delegate?.quickAddClicked(productId: model.id,title: "",error: false)
//      }
//
//    }.disposed(by: disposeBag)
//  }
//
//  override func prepareForReuse() {
//    super.prepareForReuse()
//    disposeBag = DisposeBag()
//  }
//
//
//  override func setSelected(_ selected: Bool, animated: Bool) {
//    super.setSelected(selected, animated: animated)
//
//    // Configure the view for the selected state
//  }
}
