//
//  sizeChartPopUpController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 22/02/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import UIKit
import WebKit

class sizeChartPopUpController: UIViewController,WKNavigationDelegate {

  @IBOutlet weak var sizeChartView: WKWebView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addLoader()
    sizeChartView.navigationDelegate=self    
    // Do any additional setup after loading the view.
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    self.view.stopLoader()
  }
  
  
  
  @IBAction func closeView(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */

}
