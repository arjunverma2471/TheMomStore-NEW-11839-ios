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
import RxSwift
import RxCocoa

protocol cartQuantityUpdate {
  func updateCartQuantity(sender:CartProductCell,quantity:Int,model:LineItemViewModel?)
    
}

protocol ShowError{
    func showErrorMsg(msg: String)
}

class CartProductCell: UITableViewCell {
    
    let discountLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.backgroundColor = UIColor.AppTheme()
        lbl.font = mageFont.regularFont(size: 10)
        lbl.textColor = UIColor.textColor()
        lbl.textAlignment = .center
        lbl.isHidden = true
        return lbl
    }()
    
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var qtyStack: UIStackView!
    @IBOutlet weak var incrementQty: UIButton!
  @IBOutlet weak var decrementQty: UIButton!
  @IBOutlet weak var productQty: UITextField!
  @IBOutlet weak var productPrice: UILabel!
  @IBOutlet weak var variantTitle: UILabel!
  @IBOutlet weak var productTitle: UILabel!
  @IBOutlet weak var productImage: UIImageView!
  @IBOutlet weak var deleteProduct: UIButton!
  @IBOutlet weak var moveToWishlist: UIButton!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var quantityError: UILabel!
    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var quantityLabelHeight: NSLayoutConstraint!
    var priceColor = UIColor(hexString: "#6B6B6B");
    var specialPriceColor = UIColor(hexString: "#103356");
  var itemTitleColor = UIColor.black;
    var errorDelegate: ShowError?
  var delegate:cartQuantityUpdate?
  var model:LineItemViewModel?
  var parent=CartViewController()//UIViewController()
  var disposeBag = DisposeBag()
    
  override func awakeFromNib() {
    super.awakeFromNib()
      //qtyStack.customize(radiusSize: 8.0)
      borderView.backgroundColor = UIColor(light: UIColor(hexString: "#F2F2F2"), dark: UIColor(hexString: "#0F0F0F"))
      self.buttonStackView.backgroundColor = UIColor(light: UIColor(hexString: "#F2F2F2"),dark: UIColor(hexString: "#F2F2F2"))
      productImage.backgroundColor = UIColor(light: UIColor.white, dark: UIColor.provideColor(type: .cartVc).backGroundColor)
      self.contentView.backgroundColor = UIColor(light: UIColor.white, dark: UIColor.provideColor(type: .cartVc).backGroundColor)
      productQty.isUserInteractionEnabled = false
    productQty.textAlignment = .center;
      variantTitle.numberOfLines = 0
    incrementQty.addTarget(self, action: #selector(self.incrementQty(sender:)), for: .touchUpInside)
    decrementQty.addTarget(self, action: #selector(self.decrementQty(sender:)), for: .touchUpInside)
    deleteProduct.addTarget(self, action: #selector(self.deleteProduct(sender:)), for: .touchUpInside)
    productImage.layer.cornerRadius = 8.0
    productImage.clipsToBounds=true
      productImage.contentMode = .scaleAspectFit
      productImage.layer.borderWidth = 0.5
      productImage.layer.borderColor = UIColor(light: .lightGray,dark:UIColor.white.withAlphaComponent(0.5)).cgColor
      if customAppSettings.sharedInstance.inAppWishlist {
          moveToWishlist.isHidden = false
      }
      else {
          moveToWishlist.isHidden = true
      }
      decrementQty.titleLabel?.font = mageFont.regularFont(size: 18)
      incrementQty.titleLabel?.font = mageFont.regularFont(size: 18)
      
      productQty.font = mageFont.regularFont(size: 14)
      moveToWishlist.setTitle("Move To Wishlist".localized, for: .normal)
      deleteProduct.setTitle("Remove".localized, for: .normal)
      moveToWishlist.titleLabel?.font = mageFont.regularFont(size: 12)
      moveToWishlist.setTitleColor(UIColor(light: UIColor.init(hexString: "#6B6B6B"),dark: .white), for: .normal)
      deleteProduct.titleLabel?.font = mageFont.regularFont(size: 12)
      deleteProduct.setTitleColor(UIColor(light: UIColor.init(hexString: "#6B6B6B"),dark: .white), for: .normal)
      qtyStack.layer.cornerRadius = 4.0
      qtyStack.clipsToBounds = true
  }
  
  func configure(from model:LineItemViewModel){
    self.model = model
      
    self.productImage.setImageFrom(model.image)
    self.productTitle.text = model.title
    
    if model.variantTitle == "Default Title"
    {
      self.variantTitle.text =  ""
    }
    else
    {
        var variant = ""
        for index in model.variantOptions!{
            variant += "\(index.name):\(index.value) \n"
        }
        variant = String(variant.dropLast(2))
      self.variantTitle.text =  variant
    }
      if parent.wholesaleDataFetched {
          self.productPrice.attributedText = self.calculateWholeSalePrice(model: model)
      }
      else {
          self.productPrice.attributedText = self.calCulatePrice(model)
      }
    
    self.productQty.text =  String(model.quantity)
      self.productQty.addTarget(self, action: #selector(textFieldChange(_:)), for: .editingDidEnd)
    if !(model.currentlyNotInStock) {
      self.checkForQuantityError(model: model)
    }
      self.productTitle.textColor = UIColor(light: UIColor(hexString: "#050505"), dark: UIColor.provideColor(type: .cartVc).textColor)
      self.variantTitle.textColor = UIColor(light: UIColor(hexString: "#6B6B6B"), dark: UIColor.provideColor(type: .cartVc).textColor)
      self.productTitle.font = mageFont.regularFont(size: 13.0)
      self.variantTitle.font = mageFont.regularFont(size: 12.0)
      self.productQty.font = mageFont.regularFont(size: 14.0)
      self.incrementQty.titleLabel?.font = mageFont.regularFont(size: 18.0)
      self.decrementQty.titleLabel?.font = mageFont.regularFont(size: 18.0)
      self.productQty.backgroundColor = UIColor.AppTheme()
      self.incrementQty.backgroundColor = UIColor.AppTheme()
      self.decrementQty.backgroundColor = UIColor.AppTheme()
      self.productQty.textColor = UIColor.textColor()
      self.incrementQty.setTitleColor(UIColor.textColor(), for: .normal)
      self.decrementQty.setTitleColor(UIColor.textColor(), for: .normal)
      
      
      productImage.addSubview(discountLabel)
      discountLabel.topAnchor.constraint(equalTo: productImage.topAnchor).isActive = true
      discountLabel.leadingAnchor.constraint(equalTo: productImage.leadingAnchor).isActive = true
      discountLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
      discountLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
      
      
      
      
      
      
      
      
      
      
      
      
      
      moveToWishlist.rx.tap.bind{ [weak self] in
          self?.parent.view.addLoader()
          let proId = self?.parent.cartManager.getProductId(product: model) ?? ""
          Client.shared.fetchSingleProduct(of: proId){[weak self]
            response,error   in
            if let response = response {
                self?.parent.view.stopLoader()
                let selectedVariant = model.variantID
              if let variants = response.variants.items.filter({$0.id == selectedVariant}).first {
                
                let product = CartProduct(product: response, variant: WishlistManager.shared.getVariant(variants))
                guard let _ = response.model?.viewModel else {return}
                
               
                  if !(WishlistManager.shared.isProductVariantinWishlist(product: product)) {
                      WishlistManager.shared.addToWishList(product)
                  }
                  self?.parent.cartManager.deleteQty(model)
                  self?.parent.applyDiscountCode = ""
               // DBManager.shared.removeFromCart(product: self!.products[sender.tag])
                  self?.parent.checkForCartUpdate()
                  self?.parent.setupTabbarCount()
              }
            }
            else {
              print("error")
              //self.showErrorAlert(error: error?.localizedDescription)
            }
          }
          
      }.disposed(by: disposeBag)
      
  }
  
    override func prepareForReuse() {
      super.prepareForReuse()
      disposeBag = DisposeBag()
    }
  
    @objc func textFieldChange(_ textField : UITextField) {
        guard let qtyText = self.productQty.text else {return}
        guard  let qty = Int(qtyText) else {return}
        self.delegate?.updateCartQuantity(sender: self, quantity:qty, model: self.model)
    }
    
    
  func checkForQuantityError(model:LineItemViewModel) {
      quantityLabelHeight.constant = 0
      quantityError.text = ""
      quantityError.isHidden=true;
  /*  if model.availableQuantity == 0
    {
      self.incrementQty.isHidden=true
      self.decrementQty.isHidden=true
       // errorDelegate?.showErrorMsg(msg: "The product is currently not in stock".localized)
      //self.quantityError.isHidden=false
        //quantityLabelHeight.constant = 25
      //self.quantityError.text = "The product is currently not in stock".localized
    }
    
    else if model.availableQuantity < 0
    {
      self.incrementQty.isHidden=false
      self.decrementQty.isHidden=false
      //self.quantityError.isHidden=true
        //quantityLabelHeight.constant = 0
      //self.quantityError.text = ""
    }
    
    else if model.quantity > model.availableQuantity
    {
      self.incrementQty.isHidden=true
      self.decrementQty.isHidden=false
      //self.quantityError.isHidden=false
        //quantityLabelHeight.constant = 25
      //self.quantityError.text = "Available Quantity : ".localized+"\(model.availableQuantity)"
    }
    else
    {*/
      self.incrementQty.isHidden=false
      self.decrementQty.isHidden=false
      //self.quantityError.isHidden=true
        //quantityLabelHeight.constant = 0
      //self.quantityError.text = ""
   // }
      //self.quantityError.font = mageFont.regularFont(size: 15.0)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
  @objc func incrementQty(sender:UIButton)
  {
    guard let qtyText = self.productQty.text else {return}
    guard  var qty = Int(qtyText) else {return}
    if self.model?.currentlyNotInStock == true {
      qty += 1
      delegate?.updateCartQuantity(sender: self, quantity:qty, model: self.model)
    }
    else {
      let variantQty = self.model?.availableQuantity
      if qty == variantQty {
        self.parent.view.makeToast("Only".localized + " \(variantQty ?? 0) " + "Quantities Available".localized, duration: 1.5, position: .center)
        return;
      }
      qty += 1
      delegate?.updateCartQuantity(sender: self, quantity:qty, model: self.model)
    }
  }
  
  func calCulatePrice(_ model:LineItemViewModel) -> NSMutableAttributedString?
  {
    let price = NSMutableAttributedString()
    let attr1 = [NSAttributedString.Key.foregroundColor:UIColor(light: .black,dark: .white),NSAttributedString.Key.font : mageFont.mediumFont(size: 13.0)]
    //let specialPrice = model.variants.items.first?.compareAtPrice
      let compareAtPrice = model.compareAtPrice == nil ? "false" : ((model.individualPrice) < (model.compareAtPrice ?? 0.0) ? Currency.stringFrom((model.compareAtPrice ?? 0.0)) : "false")
    
    if  compareAtPrice != "false"
    {
      let attribute1 = NSAttributedString(string:  Currency.stringFrom((model.individualPrice)), attributes: attr1  as [NSAttributedString.Key : Any])
      price.append(attribute1)
      
      let attr = [NSAttributedString.Key.strikethroughStyle:1,NSAttributedString.Key.foregroundColor:UIColor(light: .darkGray,dark: .white),NSAttributedString.Key.font : mageFont.mediumFont(size: 13.0)] as [NSAttributedString.Key : Any]
      price.append(NSAttributedString(string: " "))
      let attribute = NSAttributedString(string:  compareAtPrice, attributes: attr)
     price.append(NSMutableAttributedString(string : "\n"))
      price.append(attribute)
      
        let minusPrice = ((model.compareAtPrice ?? 0.0)-(model.individualPrice))
        let percentage = ((minusPrice/(model.compareAtPrice ?? 0.0))*100)
      let val = String(format: "%.0f", Double(truncating : percentage as? NSNumber ?? 0))
      let offerString: NSMutableAttributedString =  NSMutableAttributedString(string: "(\(val)% "+"OFF".localized+")")
      offerString.addAttribute(NSAttributedString.Key.foregroundColor,value: UIColor.systemGreen, range: NSMakeRange(0, offerString.length))
//      price.append(NSMutableAttributedString(string : "  "))
//      price.append(offerString)
        discountLabel.isHidden = false
        discountLabel.text = " " + "(\(val)% "+"OFF".localized+")"
      return price
    }
    else {
        let attr = [NSAttributedString.Key.foregroundColor:UIColor(light: .darkGray,dark: .white), NSAttributedString.Key.font : mageFont.mediumFont(size: 13.0)]
      let attribute = NSAttributedString(string:  Currency.stringFrom((model.individualPrice)), attributes: attr  as [NSAttributedString.Key : Any])
      price.append(attribute)
        discountLabel.isHidden = true
      return price
    }
  }
    
    func calculateWholeSalePrice(model:LineItemViewModel) -> NSMutableAttributedString? {
        let price = NSMutableAttributedString()
        let attr1 = [NSAttributedString.Key.foregroundColor:UIColor(light: .black,dark: .white),NSAttributedString.Key.font : mageFont.regularFont(size: 13.0)]
        if model.compareAtPrice != model.individualPrice {
            let attribute1 = NSAttributedString(string:  Currency.stringFrom((model.compareAtPrice ?? 0.0)), attributes: attr1  as [NSAttributedString.Key : Any])
            price.append(NSMutableAttributedString(string : "\n"))
            price.append(attribute1)
            
            let attr = [NSAttributedString.Key.strikethroughStyle:1,NSAttributedString.Key.foregroundColor:UIColor(light: .darkGray,dark: .white),NSAttributedString.Key.font : mageFont.regularFont(size: 13.0)] as [NSAttributedString.Key : Any]
            price.append(NSAttributedString(string: " "))
            let attribute = NSAttributedString(string:  "\(model.individualPrice)", attributes: attr)
            price.append(attribute)
            let minusPrice = ((model.individualPrice)-(model.compareAtPrice ?? 0.0))
            let percentage = ((minusPrice/(model.individualPrice))*100)
            let val = String(format: "%.0f", Double(truncating : percentage as? NSNumber ?? 0))
            let offerString: NSMutableAttributedString =  NSMutableAttributedString(string: "(\(val)% "+"OFF".localized+")")
            offerString.addAttribute(NSAttributedString.Key.foregroundColor,value: UIColor.systemGreen, range: NSMakeRange(0, offerString.length))
//            price.append(NSMutableAttributedString(string : "  "))
//            price.append(offerString)
            discountLabel.isHidden = false
            discountLabel.text = " " + "(\(val)% "+"OFF".localized+")"
            return price
        }
        else {
            let attr = [NSAttributedString.Key.foregroundColor:UIColor(light: .darkGray,dark: .white), NSAttributedString.Key.font : mageFont.regularFont(size: 13.0)]
          let attribute = NSAttributedString(string:  Currency.stringFrom((model.individualPrice)), attributes: attr  as [NSAttributedString.Key : Any])
          price.append(attribute)
            discountLabel.isHidden = true
          return price
        }
    }
  
  @objc func decrementQty(sender:UIButton){
    guard let qtyText = self.productQty.text else {return}
    guard  var qty = Int(qtyText) else {return}
    qty -= 1
    if qty < 0  {return}
    delegate?.updateCartQuantity(sender: self, quantity:qty, model: self.model)
  }
  
  @objc func deleteProduct(sender:UIButton){
    
    SweetAlert().showAlert("Warning".localized, subTitle: "Do you want to remove this item from \n Bag?".localized, style: AlertStyle.warning, buttonTitle:"No".localized, buttonColor:UIColor(hexString: "#cd7b72") , otherButtonTitle:  "Yes".localized, otherButtonColor:UIColor(hexString: "#29b456")) { (isOtherButton) -> Void in
      if isOtherButton == true {
        print("Cancel Button  Pressed")
      }
      else {
        self.delegate?.updateCartQuantity(sender: self, quantity:0, model: self.model)
          if DBManager.shared.cartProducts?.count == 0 {
              if customAppSettings.sharedInstance.showTabbar{
                  self.parent.tabBarController?.selectedIndex = 0
                  self.parent.navigationController?.popToRootViewController(animated: true)
              }else{
                  self.parent.navigationController?.popToRootViewController(animated: true)
              }
          }
         
//        _ = SweetAlert().showAlert("Deleted!".localized, subTitle: "The Item has been Deleted!".localized, style: AlertStyle.success)
      }
    }
  }
}

extension UIStackView {
    func customize(backgroundColor: UIColor = .clear, radiusSize: CGFloat = 0) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = backgroundColor
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
        subView.layer.cornerRadius = radiusSize
        subView.layer.masksToBounds = true
        subView.clipsToBounds = true
    }
}
