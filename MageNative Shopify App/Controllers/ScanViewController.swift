//
//  ScanViewController.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 02/03/20.
//  Copyright © 2020 MageNative. All rights reserved.
//

import UIKit
import AVFoundation

protocol BarcodeProtocol {
  func searchBarcode(text: String)
}

class ScanViewController: UIViewController {
  
  @IBOutlet var messageLabel:UILabel!
  var check = true;
  @IBOutlet weak var image: UIImageView!
  @IBOutlet weak var cancelButton: UIButton!
    
  
    
  var captureSession = AVCaptureSession()
  
  var videoPreviewLayer: AVCaptureVideoPreviewLayer?
  var qrCodeFrameView: UIView?
  var urlToNavigate=""
  var cancelButtonCheck = false
  var barcodeScannerCheck = false;
  var delegate: BarcodeProtocol?
  
  private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                    AVMetadataObject.ObjectType.code39,
                                    AVMetadataObject.ObjectType.code39Mod43,
                                    AVMetadataObject.ObjectType.code93,
                                    AVMetadataObject.ObjectType.code128,
                                    AVMetadataObject.ObjectType.ean8,
                                    AVMetadataObject.ObjectType.ean13,
                                    AVMetadataObject.ObjectType.aztec,
                                    AVMetadataObject.ObjectType.pdf417,
                                    AVMetadataObject.ObjectType.itf14,
                                    AVMetadataObject.ObjectType.dataMatrix,
                                    AVMetadataObject.ObjectType.interleaved2of5,
                                    AVMetadataObject.ObjectType.qr]
  
  override func viewDidLoad() {
    super.viewDidLoad()
      cancelButton.titleLabel?.text = "Cancel".localized
      
    cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
    // Get the back-facing camera for capturing videos
    let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
    
    guard let captureDevice = deviceDiscoverySession.devices.first else {
        print("Failed to get the camera device".localized)
      return
    }
    
    do {
      // Get an instance of the AVCaptureDeviceInput class using the previous device object.
      let input = try AVCaptureDeviceInput(device: captureDevice)
      
      // Set the input device on the capture session.
      captureSession.addInput(input)
      
      // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
      let captureMetadataOutput = AVCaptureMetadataOutput()
      captureSession.addOutput(captureMetadataOutput)
      captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
      // Set delegate and use the default dispatch queue to execute the call back
      captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
      
      captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
      
    } catch {
      // If any error occurs, simply print it out and don't continue any more.
      print(error)
      return
    }
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
    videoPreviewLayer?.frame = view.layer.bounds
    view.layer.addSublayer(videoPreviewLayer!)
    
    // Start video capture.
    captureSession.startRunning()
    
    // Move the message label and top bar to the front
    view.bringSubviewToFront(messageLabel)
    //view.bringSubview(toFront: topbar)
    
    // Initialize QR Code Frame to highlight the QR code
    qrCodeFrameView = UIView()
    
    if let qrCodeFrameView = qrCodeFrameView {
      qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
      qrCodeFrameView.layer.borderWidth = 2
      view.addSubview(qrCodeFrameView)
      view.bringSubviewToFront(qrCodeFrameView)
      view.bringSubviewToFront(image)
      view.bringSubviewToFront(cancelButton)
    }
      
      
    
    // Do any additional setup after loading the view.
  }
  
  func launchApp(encodedString: [String:Any]) {
    
    if presentedViewController != nil {
      return
    }
    captureSession.stopRunning()
    print("encodedString")
    print(encodedString)
    if(encodedString.count > 0){
      let id = encodedString["token"] as! String
      Client.shared.setApiId(id: id)
      let mid = encodedString["mid"] as! String
      Client.shared.setMerchantId(merchantId: mid)
      let shopurl = encodedString["shopUrl"] as! String
      Client.shared.setShopUrl(url: shopurl)
      (UIApplication.shared.delegate as! AppDelegate).loadHomepage()
    }
    
  }
  
  
  @objc func cancelButtonPressed(){
    self.navigationController?.popViewController(animated: true)
  }
  
}
extension ScanViewController: AVCaptureMetadataOutputObjectsDelegate {
  
  func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    // Check if the metadataObjects array is not nil and it contains at least one object.
    if metadataObjects.count == 0 {
      qrCodeFrameView?.frame = CGRect.zero
        messageLabel.text = "No QR code is detected".localized
      return
    }
    
    // Get the metadata object.
    let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
    
    if supportedCodeTypes.contains(metadataObj.type) {
      // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
      let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
      if let _ = barCodeObject{
        qrCodeFrameView?.frame = barCodeObject!.bounds
        //print(metadataObj.stringValue)
        if(barcodeScannerCheck){
          if(metadataObj.stringValue != ""){
            captureSession.stopRunning()
            
            self.navigationController?.popViewController(animated: true, completion: {
              self.delegate?.searchBarcode(text: metadataObj.stringValue!)
            })
          }
          
        }
        else{
          do{
            if let _ = metadataObj.stringValue{
              if let json = metadataObj.stringValue!.data(using: String.Encoding.utf8){
                if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:Any]{
                  captureSession.stopRunning()
                  let id = "\(jsonData["token"] ?? "")"
                  Client.shared.setApiId(id: id)
                  let mid = "\(jsonData["mid"] ?? "")"
                  Client.shared.setMerchantId(merchantId: mid)
                  let shopurl = "\(jsonData["shopUrl"] ?? "")"
                  Client.shared.setShopUrl(url: shopurl)
                  UserDefaults.standard.synchronize()
                  if(self.check)
                  {
                    self.clearMerchantData()
                    self.check = false;
                      FirebaseSetup.shared.firebaseInitialiseCheck = false;
                      DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                          (UIApplication.shared.delegate as! AppDelegate).getdata()
                          (UIApplication.shared.delegate as! AppDelegate).pushRedirect()
                      }
                  }
                  return;
                }
              }
            }
          }
          catch{
            
          }
        }
      }
      
    }
  }
  
    @objc func redirectDefaultStore(){
        Client.shared.setApiId(id: "c572b018c17d62853985e19b2b11a9a4")
        Client.shared.setMerchantId(merchantId: "18")
        Client.shared.setShopUrl(url: "magenative.myshopify.com")
        UserDefaults.standard.synchronize()
        if(self.check)
        {
          self.clearMerchantData()
          self.check = false;
            (UIApplication.shared.delegate as! AppDelegate).getdata()
            (UIApplication.shared.delegate as! AppDelegate).pushRedirect()
        }
    }
    
  func clearMerchantData(){
      UserDefaults.standard.removeObject(forKey: "HomeDataJSON")
      Client.homeStaticThemeJSON = Data()
      Client.homeStaticThemeColor = ""
    if(UserDefaults.standard.valueExists(forKey: "mageInfo")){
      UserDefaults.standard.removeObject(forKey: "mageInfo")
    }
    UserDefaults.standard.set(false, forKey: "mageShopLogin")
    if(UserDefaults.standard.valueExists(forKey: "defaultCurrency")){
      UserDefaults.standard.removeObject(forKey: "defaultCurrency")
    }
      UserDefaults.standard.removeObject(forKey: "HasLaunchedOnce")
    WishlistManager.shared.clearWishlist()
    CartManager.shared.deleteAll()
    // recentlyViewedManager.shared.clearAll()
      customAppSettings.sharedInstance.disableCustomSettings()
      Client.locale = "en"
      UserDefaults.standard.removeObject(forKey: "AppleLanguages")
      UserDefaults.standard.removeObject(forKey: "HasLaunchedOnce")
      UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
      UserDefaults.standard.removeObject(forKey: "firstlaunch")
      Bundle.setLanguage("en")
      customAppSettings.sharedInstance.rtlSupport = false;
      FirebaseSetup.shared.firebaseInitialiseCheck = false;
      Client.shared.client = Graph.Client(shopDomain: Client.shopUrl, apiKey: Client.apiKey, locale: Locale(identifier: Client.locale))
  }
}
