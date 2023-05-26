//
//  ProductViewController+AR.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 06/04/20.
//  Copyright © 2020 MageNative. All rights reserved.
//

import Foundation
import QuickLook
import SceneKit


extension ARPopupViewController: QLPreviewControllerDelegate, QLPreviewControllerDataSource{
  // MARK:- ARQuickLook DataSource Methods
  
  
  func fetchArModel(_ product: ProductMediaViewModel){
    
    if product.type == .model3d {
      if(product.arUrl != ""){
        let url = URL(string:product.arUrl)
        getData(from: url!) {[weak self] data, response, error in
          guard let data = data, error == nil else { return }
          //print(response?.suggestedFilename ?? url.lastPathComponent)
          print("Download Finished")
          DispatchQueue.main.async() {
            self?.arLocalPath = self?.saveImageDocumentDirectory(image: data, imageName: "model") ?? ""
            let previewController = QLPreviewController()
            previewController.dataSource = self
            previewController.delegate = self
            self?.present(previewController, animated: true)
          }
        }
      }
    }
  }
  
  func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
    if(arLocalPath != ""){
      return 1
    }
    return 0
  }
  
  func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
    
    // Getting the URL or path of the selected 3d model which will be of type .usdz
    let url = URL(fileURLWithPath: arLocalPath)
    // Returning the url as Preview Item to be displayed by the Quick Look
    return url as QLPreviewItem
  }
}



extension ProductVC: QLPreviewControllerDelegate, QLPreviewControllerDataSource{
  // MARK:- ARQuickLook DataSource Methods
  
  
  func fetchArModel(_ product: ProductMediaViewModel){
    
    if product.type == .model3d {
      if(product.arUrl != ""){
        let url = URL(string:product.arUrl)
        getData(from: url!) {[weak self] data, response, error in
          guard let data = data, error == nil else { return }
          //print(response?.suggestedFilename ?? url.lastPathComponent)
          print("Download Finished")
          DispatchQueue.main.async() {
            self?.arLocalPath = self?.saveImageDocumentDirectory(image: data, imageName: "model") ?? ""
            let previewController = QLPreviewController()
//              previewController.navigationItem.title = ""
//              previewController.navigationItem.titleView = nil
            //  previewController.navigationController?.navigationBar.isHidden = true
            previewController.dataSource = self
            previewController.delegate = self
            //  self?.navigationController?.pushViewController(previewController, animated: true)
          self?.present(previewController, animated: true)
          }
        }
      }
    }
  }
  
  func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
    if(arLocalPath != ""){
      return 1
    }
    return 0
  }
  
  
  
  func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
    
    // Getting the URL or path of the selected 3d model which will be of type .usdz
    let url = URL(fileURLWithPath: arLocalPath)
//      let previewItem = CustomPreviewItem(url: url, title: nil)
//    return previewItem as QLPreviewItem
    // Returning the url as Preview Item to be displayed by the Quick Look
    return url as QLPreviewItem
  }
  
  // Creation Of a Directory
  func createDirectory()-> String {
    
    let fileManager = FileManager.default
    
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("placeholderImages")
    if !fileManager.fileExists(atPath: paths){
      //print("--creation starts--")
      try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
      
    }else{
      //print("--creation fails--")
      print("Already dictionary created.")
      
    }
    //print("--- created ---")
    return paths
  }
  
  // save the image and imageName in directory
  
  func saveImageDocumentDirectory(image: Data, imageName: String) -> String?
  {
    //print("in saveImageDocumentDirectory")
    let fileManager = FileManager.default
    let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("placeholderImages")
    if !fileManager.fileExists(atPath: path)
    {
      try! fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
    }
    let url = NSURL(string: path)
    //print("\(imageName).jpg")
    let newImage = "\(imageName).usdz"
    let imagePath = url!.appendingPathComponent(newImage)
    let urlString: String = imagePath!.absoluteString
    let imageData = image
    do {
      let items = try fileManager.contentsOfDirectory(atPath: path)
      if items.isEmpty == true
      {
        fileManager.createFile(atPath: urlString as String, contents: imageData, attributes: nil)
        return urlString
      }
      else
      {
        print("original contents : ")
        print(try fileManager.contentsOfDirectory(atPath: path))
        if items.contains(newImage)
        {
          let index = items.firstIndex(of: newImage)
          //print(items[index!])
          let originalPath = url!.appendingPathComponent(items[index!])
          let urlStr2 = originalPath?.absoluteString
          try fileManager.removeItem(atPath: urlStr2!)
        }
        fileManager.createFile(atPath: urlString as String, contents: imageData, attributes: nil)
        return urlString
      }
    } catch {
      // failed to read directory – bad permissions, perhaps?
    }
    return ""
  }
  
  func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
  }
  
  
  
}

class CustomPreviewItem: NSObject, QLPreviewItem {
     
     var previewItemURL: URL?
     var previewItemTitle: String?
     
     init(url: URL?, title: String?) {
         previewItemURL = url
         previewItemTitle = title
     }
}
/*
class CustomPreviewController : QLPreviewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let staticView = UIView()
        staticView.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(staticView)
        staticView.topAnchor.constraint(equalTo: view.topAnchor,constant: 12).isActive = true
        staticView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        staticView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        staticView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
*/
