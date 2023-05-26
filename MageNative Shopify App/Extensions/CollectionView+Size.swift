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

import Foundation

extension UICollectionView
{
    func calculateCellSize (numberOfColumns columns:Int, of height:CGFloat = 90.0, imagesize: CGSize = CGSize(width: 1, height: 1), spacing: CGFloat = 0) -> CGSize {
    let layout         = self.collectionViewLayout as! UICollectionViewFlowLayout
    let itemSpacing    = layout.minimumInteritemSpacing * CGFloat(columns - 1)
    let sectionSpacing = layout.sectionInset.left + layout.sectionInset.right
    var length         = (UIScreen.main.bounds.width - itemSpacing - sectionSpacing - spacing) / CGFloat(columns)
        
        if(imagesize != CGSize(width: 1, height: 1)){
            if(imagesize.width<length){
                return CGSize(
                  width:  length,
                  height: imagesize.height//+height
                )
            }
            else{
                return CGSize(
                  width:  length,
                  height: length*(imagesize.height/imagesize.width)//+height
                )
            }
        }
        else{
            return CGSize(
              width:  length,
              height: length+height
            )
        }
    
  }
  
    func calculateHalfCellSize (numberOfColumns columns:CGFloat, of height:CGFloat = 80.0, imagesize: CGSize = CGSize(width: 1, height: 1)) -> CGSize {
    let layout         = self.collectionViewLayout as! UICollectionViewFlowLayout
    let itemSpacing    = layout.minimumInteritemSpacing * CGFloat(columns - 1)
    let sectionSpacing = layout.sectionInset.left + layout.sectionInset.right
    let length         = (UIScreen.main.bounds.width - itemSpacing - sectionSpacing) / CGFloat(columns)
        
    
        if(imagesize != CGSize(width: 1, height: 1)){
            if(imagesize.width<length){
                return CGSize(
                  width:  imagesize.width,
                  height: imagesize.height//+height
                )
            }
            else{
                return CGSize(
                  width:  length,
                  height: length*(imagesize.height/imagesize.width)//+height
                )
            }
        }
        else{
            return CGSize(
              width:  length,
              height: length+height
            )
        }
    
  }
  
  func calculateVerticalCellSize (numberOfColumns columns:Int, of height:CGFloat = 107.0) -> CGSize {
    let layout         = self.collectionViewLayout as! UICollectionViewFlowLayout
    let itemSpacing    = layout.minimumInteritemSpacing * CGFloat(columns - 1)
    let sectionSpacing = layout.sectionInset.left + layout.sectionInset.right
    let length         = (UIScreen.main.bounds.width - itemSpacing - sectionSpacing) / CGFloat(columns)
    return CGSize(
      width:  length,
      height: height
    )
  }
    
    
    // old
    func calculateCellSizeOld (numberOfColumns columns:Int, of height:CGFloat = 90.0, addSpacing:Int = 0) -> CGSize {
    let layout         = self.collectionViewLayout as! UICollectionViewFlowLayout
    let itemSpacing    = layout.minimumInteritemSpacing * CGFloat(columns - 1) + CGFloat(addSpacing)
    let sectionSpacing = layout.sectionInset.left + layout.sectionInset.right
    let length         = (UIScreen.main.bounds.width - itemSpacing - sectionSpacing) / CGFloat(columns)
    return CGSize(
      width:  length,
      height: length + height
      
    )
  }
  
  func calculateHalfCellSizeOld (numberOfColumns columns:CGFloat, of height:CGFloat = 80.0) -> CGSize {
    let layout         = self.collectionViewLayout as! UICollectionViewFlowLayout
    let itemSpacing    = layout.minimumInteritemSpacing * CGFloat(columns - 1)
    let sectionSpacing = layout.sectionInset.left + layout.sectionInset.right
    let length         = (UIScreen.main.bounds.width - itemSpacing - sectionSpacing) / CGFloat(columns)
    return CGSize(
      width:  length,
      height: length+height
    )
  }
  
  func calculateVerticalCellSizeOld (numberOfColumns columns:Int, of height:CGFloat = 107.0) -> CGSize {
    let layout         = self.collectionViewLayout as! UICollectionViewFlowLayout
    let itemSpacing    = layout.minimumInteritemSpacing * CGFloat(columns - 1)
    let sectionSpacing = layout.sectionInset.left + layout.sectionInset.right
    let length         = (UIScreen.main.bounds.width - itemSpacing - sectionSpacing) / CGFloat(columns)
    return CGSize(
      width:  length,
      height: height
    )
  }
}
