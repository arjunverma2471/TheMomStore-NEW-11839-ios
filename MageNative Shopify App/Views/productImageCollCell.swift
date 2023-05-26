//
//  productImageCollCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 15/06/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import UIKit

class productImageCollCell: UICollectionViewCell {
  
  
  @IBOutlet weak var productImage: UIImageView!
 
  
//  var panGesture  = UIPanGestureRecognizer()
  
  
  
  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
    initiate()
  }
  
  func initiate(){
    productImage.enableZoom()
//    productImage.isUserInteractionEnabled = true
//    productImage.addGestureRecognizer(panGesture)
    
  }
}

extension UIImageView {
  func enableZoom() {
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
    isUserInteractionEnabled = true
    addGestureRecognizer(pinchGesture)
  }

  @objc
  private func startZooming(_ sender: UIPinchGestureRecognizer) {
    let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
    guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
    sender.view?.transform = scale
    sender.scale = 1
  }
}
