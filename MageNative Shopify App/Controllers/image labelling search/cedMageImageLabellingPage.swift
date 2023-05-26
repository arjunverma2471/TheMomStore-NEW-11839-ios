//
//  cedMageImageLabellingPage.swift
//  ZeoMarket
//
//  Created by Manohar Singh Rawat on 24/07/19.
//  Copyright © 2019 MageNative. All rights reserved.
//

import UIKit

import Firebase
import MLKitVision
import MLKitImageLabeling

extension NewSearchVC: UINavigationControllerDelegate {
  
  @objc func imageSearchClicked(_ sender: UIButton){
    initializeMLModel()
  }
  
  func initializeMLModel(){
    let labelerOptions = ImageLabelerOptions()
    labelerOptions.confidenceThreshold = 0.7
    imageLabeler = ImageLabeler.imageLabeler(options: labelerOptions)
    opencameraController()
  }
  
  func opencameraController()
  {
    guard UIImagePickerController.isCameraDeviceAvailable(.front) ||
            UIImagePickerController.isCameraDeviceAvailable(.rear)
    else {
      return
    }
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = .camera
    imagePicker.allowsEditing = true;
    present(imagePicker, animated: true)
    
    
    // [END detect_label]
  }
  
}

// MARK: - UIImagePickerControllerDelegate

extension NewSearchVC: UIImagePickerControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    var imageToSave: UIImage?
    if let editedImage = info[.editedImage] as? UIImage{
      imageToSave = editedImage
    }
    else if let originalImage = info[.originalImage] as? UIImage{
      imageToSave = originalImage
    }
    //imageview.image = imageToSave;
    //resultsLabel.text = ""
    dismiss(animated: true, completion: nil)
    guard imageToSave != nil else{
      print("image not found")
      return;
    }
    let visionImage = VisionImage(image: imageToSave!)
    performMLMagicOn(visionImage)
  }
  
  func performMLMagicOn(_ visionImage: VisionImage){
    imageLabeler?.process(visionImage, completion: {[weak self] (labels, error) in
      if let _ = error{
        print("error")
        self?.navigationController?.popViewController(animated: true, completion: {
          self?.loadMLProducts(text: "")
        })
        return;
      }
      if let labels = labels{
        if(labels.count == 0){
          self?.navigationController?.popViewController(animated: true, completion: {
            self?.loadMLProducts(text: "")
          })
          return;
        }
        self?.datasourceArray = [String]()
        for visionLabel in labels{
          let resultText = visionLabel.text.trimmingCharacters(in: .whitespacesAndNewlines)
          self?.datasourceArray.append(resultText);
        }
        if(self?.datasourceArray.count ?? 0 > 0){
          self?.navigationController?.popViewController(animated: true, completion: {
            self?.loadMLProducts(text: self?.datasourceArray[0] ?? "")
          })
        }
      }
    })
  }
  
  func loadMLProducts(text: String){
    if(text == ""){
        self.view.makeToast("No Products Found In Collection".localized, duration: 2.0, position: .center);
      return;
    }
    searchBar.text = text;
    loadProducts(searchText:text)
  }
}
