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
/*
import UIKit

class ProductVariantSelectController: UIViewController {
  
  @IBOutlet weak var applySelection: UIButton!
  @IBOutlet weak var popViewControl: UIBarButtonItem!
  @IBOutlet weak var productDetails: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var selectedVariantImage: UIImageView!
  
  var productVariants:PageableArray<VariantViewModel>!
  var referenceOBject:ProductSelectVariantCell!
  var parentViewControl : ProductViewController!
  var selectedIndex :IndexPath?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let shopUrl = Client.shopUrl.replacingOccurrences(of: ".myshopify.com", with: "")
    let ref = BaseViewController.secondaryDb?.reference(withPath: shopUrl).child("additional_info")
    ref?.child("appthemecolor").observe(.value, with: {
      snapshot in
      if let dataObject = snapshot.value as? String {
        UserDefaults.standard.set(dataObject, forKey: "color")
        Client.shared.setTextColor(val: dataObject)
        self.applySelection.backgroundColor = UIColor(hexString: dataObject)
      }
    })
    popViewControl.target = self
    popViewControl.action = #selector(self.dismissView)
    self.fillBaseVariant(product: parentViewControl.selectedVariant)
    self.setupCollectionView()
    applySelection.addTarget(self, action: #selector(self.selectOption(sender:)), for: .touchUpInside)
  }
  
  @objc func dismissView(){
    self.dismiss(animated: true, completion: nil)
  }
  
  func fillBaseVariant(product:VariantViewModel){
    selectedVariantImage.setImageFrom(product.image)
    productDetails.text = product.title
  }
  
  func setupCollectionView(){
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @objc func selectOption(sender:UIButton)
  {
    guard let index = selectedIndex else {return}
    let selectedVariant = self.productVariants.items[index.row]
    self.dismiss(animated: true, completion: {
      self.parentViewControl.selectedVariant = selectedVariant
      self.parentViewControl.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: . fade)
      self.referenceOBject.variantStack.arrangedSubviews.forEach({
        $0.removeFromSuperview()
      })
      self.referenceOBject.configure(from: selectedVariant, for: self.parentViewControl)
    })
  }
}

extension ProductVariantSelectController:UICollectionViewDelegate
{
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let product = self.productVariants.items[indexPath.item]
    self.fillBaseVariant(product: product)
    let cell = collectionView.cellForItem(at: indexPath)
    makeCellSelected(cell: cell, index: indexPath)
    
    if !product.availableForSale{
      self.applySelection.isEnabled = false
      self.applySelection.backgroundColor = UIColor.red
    }
    else
    {
      self.applySelection.isEnabled = true
      let shopUrl = Client.shopUrl.replacingOccurrences(of: ".myshopify.com", with: "")
      let ref = BaseViewController.secondaryDb?.reference(withPath: shopUrl).child("additional_info")
      ref?.child("appthemecolor").observe(.value, with: {
        snapshot in
        if let dataObject = snapshot.value as? String {
          UserDefaults.standard.set(dataObject, forKey: "color")
          Client.shared.setTextColor(val: dataObject)
          self.applySelection.backgroundColor = UIColor(hexString: dataObject)
        }
      })
    }
  }
  
  func makeCellSelected(cell:UICollectionViewCell?,index:IndexPath){
    cell?.layer.borderColor = UIColor.blue.cgColor
    cell?.layer.borderWidth = 1
    self.selectedIndex = index
  }
  
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath)
    cell?.layer.borderColor = UIColor.white.cgColor
    cell?.layer.borderWidth = 0
  }
}

extension ProductVariantSelectController:UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return productVariants.items.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell    = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.className, for: indexPath) as! ProductCollectionViewCell
    let product = self.productVariants.items[indexPath.item]
    cell.productImage.setImageFrom(product.image)
    cell.productName.text = product.title
    cell.productPrice.text = Currency.stringFrom(product.price)
    if  parentViewControl.selectedVariant.id == product.id {
      makeCellSelected(cell: cell, index: indexPath)
      self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    else {
      cell.layer.borderColor = UIColor.white.cgColor
      cell.layer.borderWidth = 0
    }
    return cell
  }
}

extension ProductVariantSelectController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return collectionView.calculateCellSize(numberOfColumns: 3)
  }
}

*/
