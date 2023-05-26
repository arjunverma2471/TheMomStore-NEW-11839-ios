//
//  GrowaveFAQViewController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 30/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
class GrowaveFAQViewController : UIViewController {
    
    
    
    private lazy var headingLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.boldFont(size: 14.0)
        label.text = "FAQ".localized
        label.textAlignment = .center
        label.textColor = UIColor(light: UIColor(hexString: "#050505", alpha: 1),dark: UIColor.provideColor(type: .SideMenuController).textColor)
        return label
    }()
    
    private lazy var mainTable : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        let nib = UINib(nibName: GrowaveFAQTableCell.className, bundle: nil)
        table.register(nib, forCellReuseIdentifier: GrowaveFAQTableCell.className)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    var quesData = ["HOW DO I PARTICIPATE?".localized,"HOW CAN I EARN POINTS?".localized,"HOW CAN I SPEND MY POINTS?".localized]
    var ansData = ["In order to join the program, just click “Create a store account”. Once you have done it, you are welcome to participate in all actions we have prepared for you to earn points.".localized,"You can earn points by completing actions listed in rewards tab. Just click on “Rewards” tab to see the list of activities available for you to take part.".localized,"It’s very simple and straightforward. Just click on “Rewards” tab and you will see the list of all discounts you can redeem your points for. So you can greatly boost your savings.".localized]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    
    func setupView() {
        self.view.backgroundColor = UIColor.viewBackgroundColor()
        view.addSubview(headingLabel)
        view.addSubview(mainTable)
        headingLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leadingAnchor, right: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8, height: 45)
        
        mainTable.anchor(top: headingLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leadingAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 8, paddingLeft: 8,paddingBottom: 8, paddingRight: 8)
    }
    
    
    
    
    
    
}

extension GrowaveFAQViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GrowaveFAQTableCell", for: indexPath) as! GrowaveFAQTableCell
        cell.heading.font = mageFont.mediumFont(size: 12.0)
        cell.subHeading.font = mageFont.regularFont(size: 12.0)
        cell.heading.text = quesData[indexPath.row]
        cell.subHeading.text = ansData[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
    
}
