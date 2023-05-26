//
//  NotificationService.swift
//  Notifications
//
//  Created by cedcoss on 24/08/18.
//  Copyright © 2018 MageNative. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
      self.contentHandler = contentHandler
      bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
      print("&*&*&*&*&*&*&**&*&*&*&*")
        let userInfo = request.content.userInfo
        let main=userInfo["gcm.notification.data"] as? String
        
        if let data = main?.data(using: .utf8) {
          guard let data = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {return;}
            if let image = data["image"] as? String{
                if(image != ""){
                    if let fileUrl = URL(string: image){
                        // Download the attachment
                        URLSession.shared.downloadTask(with: fileUrl) { (location, response, error) in
                          if let location = location {
                            // Move temporary file to remove .tmp extension
                            let tmpDirectory = NSTemporaryDirectory()
                            let tmpFile = "file://".appending(tmpDirectory).appending(fileUrl.lastPathComponent)
                            let tmpUrl = URL(string: tmpFile)!
                            try! FileManager.default.moveItem(at: location, to: tmpUrl)
                            // Add the attachment to the notification content
                            if let attachment = try? UNNotificationAttachment(identifier: "", url: tmpUrl) {
                              self.bestAttemptContent?.attachments = [attachment]
                            }
                              self.bestAttemptContent?.sound = UNNotificationSound.default
                          }
                          // Serve the notification content
                          self.contentHandler!(self.bestAttemptContent!)
                        }.resume()
                    }
                }
            }
            
        }
      /*if let urlString = request.content.userInfo["image"] as? String, let fileUrl = URL(string: urlString) {
        // Download the attachment
        URLSession.shared.downloadTask(with: fileUrl) { (location, response, error) in
          if let location = location {
            // Move temporary file to remove .tmp extension
            let tmpDirectory = NSTemporaryDirectory()
            let tmpFile = "file://".appending(tmpDirectory).appending(fileUrl.lastPathComponent)
            let tmpUrl = URL(string: tmpFile)!
            try! FileManager.default.moveItem(at: location, to: tmpUrl)
            // Add the attachment to the notification content
            if let attachment = try? UNNotificationAttachment(identifier: "", url: tmpUrl) {
              self.bestAttemptContent?.attachments = [attachment]
            }
          }
          // Serve the notification content
          self.contentHandler!(self.bestAttemptContent!)
        }.resume()
      }
      if let notificationData = request.content.userInfo["data"] as? [String: String] {
        print(notificationData);
        print("&*&*&*&*&*&*&*")
        // Grab the attachment
        
      }*/
    }

}
