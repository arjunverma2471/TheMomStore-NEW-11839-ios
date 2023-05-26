//
//  Scene3DViewController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 06/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
class Scene3DViewController : UIViewController {
    
    @IBOutlet weak var sceneView: SCNView!
    
    var product : ProductMediaViewModel!
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetch3Dmodel(product)
    }
    
    
    func fetch3Dmodel(_ product: ProductMediaViewModel){
        
        if product.type == .model3d {
            if(product.arUrl != ""){
                let url = URL(string:product.arUrl)
                getData(from: url!) {[weak self] data, response, error in
                    guard let data = data, error == nil else { return }
                    //print(response?.suggestedFilename ?? url.lastPathComponent)3
                    print("Download Finished")
                    DispatchQueue.main.async() {
                        self?.url = self?.saveImageDocumentDirectory(image: data, imageName: "model") ?? ""
                        self?.loadCompleteView()
                    }
                }
            }
        }
    }
    
    
    func loadCompleteView() {
        let uRL = URL(fileURLWithPath: self.url)
        do {
             let scene = try SCNScene(url: uRL, options: .none)
            
            // 2: Add camera node
            let cameraNode = SCNNode()
            cameraNode.camera = SCNCamera()
            // 3: Place camera
            cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)//(x: 0, y: 10, z: 35)
            // 4: Set camera on scene
            scene.rootNode.addChildNode(cameraNode)
            
            // 5: Adding light to scene
            let lightNode = SCNNode()
            lightNode.light = SCNLight()
            lightNode.light?.type = .omni
            lightNode.position = SCNVector3(x: 0, y: 10, z: 35)
            scene.rootNode.addChildNode(lightNode)
            
            // 6: Creating and adding ambien light to scene
            let ambientLightNode = SCNNode()
            ambientLightNode.light = SCNLight()
            ambientLightNode.light?.type = .ambient
            ambientLightNode.light?.color = UIColor.darkGray
            scene.rootNode.addChildNode(ambientLightNode)
            
            // If you don't want to fix manually the lights
            //        sceneView.autoenablesDefaultLighting = true
            
            // Allow user to manipulate camera
            sceneView.allowsCameraControl = true
            
            // Show FPS logs and timming
            // sceneView.showsStatistics = true
            
            // Set background color
            sceneView.backgroundColor = UIColor.white
            
            // Allow user translate image
            sceneView.cameraControlConfiguration.allowsTranslation = false
            
            
            
            // Set scene settings
            sceneView.scene = scene
        }
        catch {
            
        }
        
    }
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    
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
    

    
    
    
    
}
    
    
   
    
    
   
    
    
    
   
    
    
    
    
   
    
    
