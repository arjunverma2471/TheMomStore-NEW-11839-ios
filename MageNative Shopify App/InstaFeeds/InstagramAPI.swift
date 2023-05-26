//
//  InstagramAPI.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 07/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation

class InstagramAPI {
    
    static let shared = InstagramAPI()
    
    
    func getMediaData(completion: @escaping (Feed) -> Void) {
        
        
        let tokenRequest = URLRequest(url: URL(string: "https://dev-mobileappnew.cedcommerce.com/shopifymobilenew/instagramfeedsapi/getinstafeeds?mid=\(Client.merchantID)")!)
        let tokenSession = URLSession.shared
        let tokenTask = tokenSession.dataTask(with: tokenRequest) { data1, response1, error1 in
            if let tokenresponse = response1 {
                print(response1)
            }
            
            guard error1 == nil && data1 != nil else
            {
              DispatchQueue.main.sync
              {
                  print("error=\(error1)")
                if error1?.localizedDescription=="The Internet connection appears to be offline."{
                }
              }
              return;
            }
            
            do { let jsonData1 = try JSONDecoder().decode(InstaToken.self, from: data1!)
                Client.INSTA_ACCESS_TOKEN = jsonData1.data;
                print(jsonData1)
                let urlString = Client.BASE_INSTAGRAM_GRAPH_URL + "fields=id,media_url,permalink,username,caption&access_token="+Client.INSTA_ACCESS_TOKEN
                
                let request = URLRequest(url: URL(string: urlString)!)
                
                let session = URLSession.shared
                let task = session.dataTask(with: request, completionHandler: { data, response, error in
                    if let response = response {
                        print(response)
                    }
                    
                    guard error == nil && data != nil else
                    {
                      DispatchQueue.main.sync
                      {
                          print("error=\(error)")
                        if error?.localizedDescription=="The Internet connection appears to be offline."{
                        }
                      }
                      return;
                    }
                    
                    do { let jsonData = try JSONDecoder().decode(Feed.self, from: data!)
                        print(jsonData)
                        completion(jsonData)
                    }
                    catch let error as NSError {
                        print(error)
                    }
                })
                task.resume()
            }
            catch let error1 as NSError {
                print(error1)
            }
        }
        tokenTask.resume()
        
    }
    
}
/* Extra for testing
 // let urlString = "https://v1.nocodeapi.com/feeddemo/instagram/qlwxObxHOHoYVJuF"
   //let urlString = "https://v1.nocodeapi.com/insta_test/instagram/MkuYepFzvHxhEImt"
//let urlString = "https://graph.instagram.com/me/media?fields=id,media_url,permalink,username,caption&access_token=IGQVJXYkNrbl8yaEg3N3MwbF9MRWJUa09KV1VwMDBJeEJhNWRIQWhTWEtQOTY4TFpUdHdqTFc1VmRmcG5ZASFYxVmVUN2J0R1MyeVRMTEI1b1RSSi1sQnQtRV9kbFE0TE83M2xMd0U3V0VzYmhCdGV2UwZDZD"
 */
struct InstaToken: Codable{
    let success: Bool
    let data: String
}
