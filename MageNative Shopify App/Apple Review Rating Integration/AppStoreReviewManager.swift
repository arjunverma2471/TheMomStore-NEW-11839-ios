//
//  AppStoreReviewManager.swift
//  MageNative Shopify App
//
//  Created by Yash Pratap Singh sisodia on 08/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import UIKit
import StoreKit

class AppReviewManager {
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Properties
    private let app = UIApplication.shared
    
    static let standard = AppReviewManager()
    
    

    
    // MARK: - Methods
    private func presentReviewRequest() {
        let twoSecondsFromNow = DispatchTime.now() + 2.0
        DispatchQueue.main.asyncAfter(deadline: twoSecondsFromNow) {
            SKStoreReviewController.requestReview()
        }
    }
    
    private func reviewOnAppStore() {
        guard let writeReviewURL = URL(string: "https://apps.apple.com/app/id1266263558?action=write-review")
            else { fatalError("Expected a valid URL") }
        app.open(writeReviewURL, options: [:], completionHandler: nil)
    }
    
    func askForReview() {
        reviewOnAppStore()
    }
    
     func showPopup(controller: UIViewController) {
        let alert = UIAlertController(title: "Enjoying Magenative App?", message: "Do you want to rate our app?\n\n\n\n\n\n", preferredStyle: .alert)
        let image = UIImageView(image: Bundle.main.icon)
        alert.view.addSubview(image)
        alert.addAction(UIAlertAction(title: "Not now", style: .cancel,handler: { action in
            controller.dismiss(animated: true)
        } ))
        alert.addAction(UIAlertAction(title: "Rate us", style: .default, handler: { action in
            controller.dismiss(animated: true) {
                self.askForReview()
            }
        }))
        image.translatesAutoresizingMaskIntoConstraints = false
        alert.view.addConstraint(NSLayoutConstraint(item: image, attribute: .centerX, relatedBy: .equal, toItem: alert.view, attribute: .centerX, multiplier: 1, constant: 0))
        alert.view.addConstraint(NSLayoutConstraint(item: image, attribute: .centerY, relatedBy: .equal, toItem: alert.view, attribute: .centerY, multiplier: 1, constant: 0))
        alert.view.addConstraint(NSLayoutConstraint(item: image, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60))
        alert.view.addConstraint(NSLayoutConstraint(item: image, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60))
        
        controller.present(alert, animated: true, completion: nil)
    }

}
 

extension Bundle {
    public var icon: UIImage? {
        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
            let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
            let lastIcon = iconFiles.last {
            return UIImage(named: lastIcon)
        }
        return nil
    }
}
