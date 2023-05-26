//
//  RewardListingViewController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 10/06/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
class RewardListingViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var myRewardData = [[String:String]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        topLabel.text = "MY POINTS HISTORY".localized
        topLabel.backgroundColor = UIColor.AppTheme()
        topLabel.textColor = UIColor.textColor()
        topLabel.font = mageFont.mediumFont(size: 16.0)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRewardData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RewardListTableCell", for: indexPath) as! RewardListTableCell
        let data = myRewardData[indexPath.row]
        cell.configureData(str: data)
        cell.wrapperView.cardView()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
}
