//
//  ARPopupViewController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 16/06/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import UIKit

class ARPopupViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var topLabel: UILabel!
  
  var arLocalPath = ""
  var arModelData = [ProductMediaViewModel]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.collectionView.delegate=self
    self.collectionView.dataSource=self
    self.collectionView.reloadData()
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.arModelData.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "arPopupCollCell", for: indexPath) as? arPopupCollCell
    
    let image = self.arModelData[indexPath.row].arPreviewImage
    cell?.arImage.setImageFrom(image.getURL())
    
    return cell!
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.fetchArModel(self.arModelData[indexPath.row])
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.view.frame.width/3, height: 220)
  }
}


extension ARPopupViewController
{
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
