//
//  AppUpdate+Extension.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 08/10/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import Foundation
import UIKit


enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
}

extension HomeViewController{
//extension AppDelegate{
    func isUpdateAvailable(completion: @escaping (Bool?, Error?) -> Void) throws -> URLSessionDataTask {
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
              
            //Replace the country code in below url based on region for which the app is being made live to get instant update
            let url = URL(string: "https://itunes.apple.com/in/lookup?bundleId=\(identifier)") else {
                throw VersionError.invalidBundleInfo
        }
            
        let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                if let error = error { throw error }
                
                guard let data = data else { throw VersionError.invalidResponse }
                            
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                print("--version--",json)
                      
                guard let result = (json?["results"] as? [Any])?.first as? [String: Any], let lastVersion = result["version"] as? String else {
                    throw VersionError.invalidResponse
                }
                
                print("version in app store", lastVersion,currentVersion);
                completion(lastVersion > currentVersion, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
        return task
    }
  
    
    func showAppUpdatePopup(){
        
        let updateView = UIAlertController(title: "New Version Available", message: "There is a newer version available for download! Please update the app by visiting the Apple Store", preferredStyle: .alert)
        
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.topViewController
        }
            updateView.addAction(UIAlertAction(title: "Update", style: .default, handler: { _ in
                let appUrl = Client.appLiveUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                if let Url = URL(string: appUrl){
                    if(UIApplication.shared.canOpenURL(Url)){
                        UIApplication.shared.open(Url)
                        self.showAppUpdatePopup()
                    }
                }
            }))
        rootViewController?.present(updateView, animated: true, completion: nil)
//        self.present(updateView, animated: true, completion: nil)
    }
}
