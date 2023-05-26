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

protocol wishListDelegate {
  func addToWishListProduct(_ cell: ProductCollectionViewCell, didAddToWishList sender: Any)
}

class ProductCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var addToWishList: UIButton!
  @IBOutlet weak var productName: UILabel!
  @IBOutlet weak var productImage: UIImageView!
  @IBOutlet weak var productPrice: UILabel!
  @IBOutlet weak var addToCart: UIButton!  
  @IBOutlet weak var outOfStockImage: UIImageView!
    
  var show_Shimmer = false
  var isFromHome=Bool()
  var priceFont = mageFont.boldFont(size: 14.0)
  var specialPriceFont = mageFont.lightFont(size: 14.0)
  var itemNameFont = mageFont.regularFont(size: 15.0)
  var priceColor = UIColor.black;
  var specialPriceColor = UIColor.red;
  var itemTitleColor = UIColor.black;
  var specialPriceHide = false;
  var delegate:wishListDelegate?
  var gridCellCheck = false
    
    let discountLabel: UILabel = {
        let lbl = UILabel()
        lbl.discountStyle()
        return lbl
    }()

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
        return label
    }()
        
    func initView(){
        
        let screenWidth = self.frame.width
        productImage.backgroundColor = .randomAlpha
        addSubview(outOfStockLabel)
        productImage.contentMode = .scaleAspectFit
        productImage.layer.masksToBounds = true
        productImage.clipsToBounds = true;
        outOfStockLabel.anchor(left: productImage.leadingAnchor, bottom: productImage.bottomAnchor, paddingLeft: 0, paddingBottom: 0, width: (0.65*screenWidth), height: 30)
    }
    
  override func awakeFromNib() {
    super.awakeFromNib()
      self.initView()
    addToWishList.addTarget(self, action: #selector(self.addItemToWishList(_:)), for: .touchUpInside)
  }
    
  func setupView(_ model:ProductViewModel)
  {
      productImage.addSubview(discountLabel)
      discountLabel.topAnchor.constraint(equalTo: productImage.topAnchor, constant: 3).isActive = true
      discountLabel.leadingAnchor.constraint(equalTo: productImage.leadingAnchor, constant: 3).isActive = true
      discountLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
      discountLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
      
 
      
      productPrice.numberOfLines = 0
      productName.numberOfLines = 1
    if !self.isFromHome {
      if customAppSettings.sharedInstance.inAppWishlist {
        self.addToWishList.isHidden = false;
      }
    }
    
    if customAppSettings.sharedInstance.inAppAddToCart {
      if self.addToCart != nil {
        self.addToCart.isHidden = false;
      }
    }
    
    productName?.text = model.title
    productName.font = itemNameFont
    
    productName.textColor = itemTitleColor
    productPrice.attributedText =  self.calCulatePrice(model)
    //  productPrice.lineBreakMode = .byWordWrapping
    productImage.setImageFrom(model.images.items.first?.url)
      let wishProduct = CartProduct(product: model, variant: WishlistManager.shared.getVariant(model.variants.items.first!))
  /*  if WishlistManager.shared.isProductinWishlist(product: model){
      addToWishList.setImage(#imageLiteral(resourceName: "heartFilled"), for: .normal)
      
    }
    else {
      addToWishList.setImage(#imageLiteral(resourceName: "heartEmpty"), for: .normal)
    }  */
      if WishlistManager.shared.isProductVariantinWishlist(product: wishProduct){
          addToWishList.setImage(#imageLiteral(resourceName: "heartFilled"), for: .normal)
      }
      else {
          addToWishList.setImage(#imageLiteral(resourceName: "heartEmpty"), for: .normal)
      }
      
   if self.outOfStockImage != nil {
       self.outOfStockImage.isHidden = true
    }
          if model.availableForSale {
            self.outOfStockLabel.isHidden=true
          }
          else {
            self.outOfStockLabel.isHidden=false
          }
  }
  
  @objc func addItemToWishList(_ sender:UIButton){
    self.delegate?.addToWishListProduct(self, didAddToWishList: sender)
  }
  
  func calCulatePrice(_ model:ProductViewModel) -> NSMutableAttributedString?{
    let price = NSMutableAttributedString()
      let attr1 = [NSAttributedString.Key.foregroundColor:specialPriceColor,NSAttributedString.Key.font:priceFont]
    if (gridCellCheck)
    {
      //let specialPrice = model.variants.items.first?.compareAtPrice
      let compareAtPrice = model.variants.items.first?.compareAtPrice == nil ? "false" : ( (model.variants.items.first?.price)! < (model.variants.items.first?.compareAtPrice!)! ? Currency.stringFrom((model.variants.items.first?.compareAtPrice!)!) : "false" )
      if  compareAtPrice != "false" && specialPriceHide == false
      {
        let attribute1 = NSAttributedString(string:  model.price, attributes: attr1  as [NSAttributedString.Key : Any])
       
          let attr = [NSAttributedString.Key.strikethroughStyle:1,NSAttributedString.Key.font: specialPriceFont,NSAttributedString.Key.foregroundColor:priceColor] as [NSAttributedString.Key : Any]
        
        let attribute = NSAttributedString(string:  compareAtPrice, attributes: attr)
          price.append(attribute)
          price.append(NSAttributedString(string: " "))
        price.append(attribute1)
          
          let minusPrice = ((model.variants.items.first?.compareAtPrice ?? 0.0)-(model.variants.items.first?.price ?? 0.0))
          //let averagePrice = (((model.variants.items.first?.compareAtPrice ?? 0.0)+(model.variants.items.first?.price ?? 0.0))/2)
          let percentage = ((minusPrice/(model.variants.items.first?.compareAtPrice ?? 0.0))*100)
            let val = String(format: "%.0f", Double(truncating : percentage as? NSNumber ?? 0))
            let offerString: NSMutableAttributedString = NSMutableAttributedString(string: "\(val)% "+"Off".localized)
          offerString.addAttribute(NSAttributedString.Key.foregroundColor,value: UIColor.textColor(), range: NSMakeRange(0, offerString.length))
          discountLabel.attributedText = offerString
          discountLabel.isHidden = false
        return price
      }
      else
      {
        let attr = [NSAttributedString.Key.foregroundColor:priceColor,NSAttributedString.Key.font:priceFont]
        let attribute = NSAttributedString(string:  model.price, attributes: attr  as [NSAttributedString.Key : Any])
        price.append(attribute)
        discountLabel.isHidden = true
        return price
      }
    }
    else
    {
      if model.compareAtPrice != "false" && specialPriceHide == false{
        let attribute1 = NSAttributedString(string:  model.price, attributes: attr1  as [NSAttributedString.Key : Any])
       
        
          let attr = [NSAttributedString.Key.strikethroughStyle:1,NSAttributedString.Key.font: specialPriceFont,NSAttributedString.Key.foregroundColor:priceColor] as [NSAttributedString.Key : Any]
         
        let attribute = NSAttributedString(string:  model.compareAtPrice, attributes: attr)
          price.append(attribute)
        price.append(NSAttributedString(string: " "))
        price.append(attribute1)
        
        let minusPrice = ((model.variants.items.first?.compareAtPrice ?? 0.0)-(model.variants.items.first?.price ?? 0.0))
        //let averagePrice = (((model.variants.items.first?.compareAtPrice ?? 0.0)+(model.variants.items.first?.price ?? 0.0))/2)
        let percentage = ((minusPrice/(model.variants.items.first?.compareAtPrice ?? 0.0))*100)
          let val = String(format: "%.0f", Double(truncating : percentage as? NSNumber ?? 0))
          let offerString: NSMutableAttributedString = NSMutableAttributedString(string: "\(val)% "+"Off".localized)
        offerString.addAttribute(NSAttributedString.Key.foregroundColor,value: UIColor.textColor(), range: NSMakeRange(0, offerString.length))
        price.append(NSMutableAttributedString(string : "  "))
//        price.append(offerString)
        discountLabel.attributedText = offerString
          discountLabel.isHidden = false
        return price
      }
      else {
          let attr = [NSAttributedString.Key.foregroundColor:priceColor,NSAttributedString.Key.font:priceFont]
        let attribute = NSAttributedString(string:  model.price, attributes: attr  as [NSAttributedString.Key : Any])
        price.append(attribute)
          discountLabel.isHidden = true
        return price
      }
    }
  }
}
