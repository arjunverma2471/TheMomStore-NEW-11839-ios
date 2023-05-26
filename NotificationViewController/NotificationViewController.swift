//
//  NotificationViewController.swift
//  NotificationViewController
//
//  Created by Manohar Singh Rawat on 07/01/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    @IBOutlet weak var myImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
        let attachments = notification.request.content.attachments
        for attach in attachments{
            print("imageL ", attach.url)
            guard let imag = try? Data(contentsOf: attach.url) else{return}
            myImage.image = UIImage(data: imag)
        }
    }

}
