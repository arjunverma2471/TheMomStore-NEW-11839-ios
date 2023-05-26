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

class ProductImageViewController: UIViewController {
  
  @IBOutlet weak var dissmissView: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!
    var staticImage = ""
  var images : [ImageViewModel]?
  var selectedImage = Int()
  var scrolled = 0
    
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.reloadData()
    dissmissView.addTarget(self, action: #selector(self.dismissView(_:)), for: .touchUpInside)
    self.view.bringSubviewToFront(dissmissView)
  }
  
  @objc func dismissView(_ sender:UIButton){
      print("Dismissed Clicked productimage")
    self.dismiss(animated: true, completion: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.isPagingEnabled = false
        let indexPath = IndexPath(item: selectedImage, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: false)
        collectionView.isPagingEnabled = true
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
       
//        if scrollView == collectionView{
//            scrolled = 1
//        }
//        else{
//            scrolled = 0
//        }
    }
}

extension ProductImageViewController:UICollectionViewDataSource,UICollectionViewDelegate
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(staticImage != ""){
            return 1
        }
      return images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell       = collectionView.dequeueReusableCell(withReuseIdentifier: "productImageCollCell", for: indexPath) as? productImageCollCell
  //    cell?.productImage.setImageFrom(images?[indexPath.row].url)
        if(staticImage != ""){
            cell?.productImage.setImageFrom(URL(string: staticImage)!)
        }
        else{
            
            cell?.productImage.setImageFrom(images?[indexPath.row].url)
//            if scrolled == 0 {
//                cell?.productImage.setImageFrom(images?[selectedImage].url)
//            }
//            else{
//                cell?.productImage.setImageFrom(images?[indexPath.row].url)
//            }
        }
        
        
      return cell!
    }
    
  
    
}

extension ProductImageViewController:UICollectionViewDelegateFlowLayout
{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
  }
   
}
