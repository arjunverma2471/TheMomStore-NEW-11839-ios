//
//  NotificationNetworking.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 02/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
class NotificationNetworking {
    
    var notificationData: [NotificationSendModel]?
    
    func getNotificationCenterData(page:Int,completion : @escaping(JSON?)->Void) {
        print(getDate())
        let date = getDate()
     
        DispatchQueue.global(qos: .background).async {
           
            let url = "https://shopmobileapp.cedcommerce.com/shopifymobilenew/paneldataapi/notificationrecords?key=send&start_date=\(date)&end_date=\(date)&mid=\(Client.merchantID)&page=\(page)"
            SharedNetworking.shared.sendRequestUpdated(api: url, type: .GET) { (result) in
                switch result{
                case .success(let data):
                    do{
                        let json                     = try JSON(data: data)
                        print("notifData==",json)
                        completion(json)
                    }catch let error {
                        print(error)
                        completion(nil)
                    }
                case .failure(let error):
                    print(error)
                    completion(nil)

                }
            }
        }
    }
    
    
    func getDate()->String{
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date()) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // again convert your date to string
        let myStringDate = formatter.string(from: yourDate!)
        return myStringDate
       
    }
    
  
    
}


struct NotificationSendModel {
    let id : String?
    let merchant_id : String?
    let notification_data : String?
    let total_device_count : String?
    let type : String?
    let total_success_count : String?
    let created_at : String?
    let updated_at : String?
    var isExpanded = false
    
    init(json:JSON) {
        id = json["id"].stringValue
        merchant_id = json["merchant_id"].stringValue
        notification_data = json["notification_data"].stringValue
        total_device_count = json["total_device_count"].stringValue
        type = json["type"].stringValue
        total_success_count = json["total_success_count"].stringValue
        created_at = json["created_at"].stringValue
        updated_at = json["updated_at"].stringValue
        
        
    }
}

