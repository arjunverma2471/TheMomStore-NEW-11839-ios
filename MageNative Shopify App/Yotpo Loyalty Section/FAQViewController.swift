//
//  FAQViewController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 11/06/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import Foundation
import UIKit
class FAQViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   

    @IBOutlet weak var topHeading: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var quesData = ["HOW DO I PARTICIPATE?".localized, "HOW CAN I EARN POINTS?".localized , "WHAT CAN I REDEEM MY POINTS FOR?".localized , "HOW DO I REDEEM MY POINTS?".localized, "HOW DO I CHECK MY POINTS BALANCE?".localized , "DOES IT COST ANYTHING TO BEGIN EARNING POINTS?".localized, "DO I HAVE TO ENROLL OR REGISTER IN INDIVIDUAL PROMOTIONS?".localized , "HOW LONG WILL IT TAKE FOR POINTS TO POST TO MY ACCOUNT?".localized,"DO MY POINTS EXPIRE?".localized , "WHAT HAPPENS TO MY POINTS IF I MAKE A RETURN?".localized , "HOW DO I CONTACT SUPPORT IF I HAVE QUESTIONS ABOUT MY POINTS?".localized , "I'M VERY CLOSE TO EARNING A REWARD. CAN I BUY EXTRA POINTS TO GET THERE?".localized ,"WHAT IF I DON'T WANT TO RECEIVE PROMOTIONAL EMAILS?".localized]
    var answerData = ["Joining is easy! Just click the Create An Account button to get started. Once you're registered with our store, you'll have the opportunity to take part in all of the exciting ways we currently offer to earn points!".localized , "You can earn points by participating in any of our innovative promotions! Simply click on the 'Earn Points' tab to view and take part in our current opportunities. In addition, make sure to check back often, as we're adding great new ways for you to earn points all the time!".localized, "Glad you asked! We want to make it easy and fun to redeem your hard-earned points. Just visit the 'Get Rewards' tab to view all of our exciting reward options.".localized , "Exchanging your points for great rewards couldn't be easier! Simply visit the 'Get Rewards' tab to view all of our great reward options and click the 'Redeem' button to redeem your reward.".localized,"Your up-to-date points balance is always displayed in the top of this popup.".localized, "Absolutely not! Sign up is 100% free, and it will never cost you anything to earn points. Make sure to visit the 'Earn Points' tab to get started.".localized , "Once you register for an account, you're all set – we don't require you to register for individual promotions in order to be eligible. Just fulfill the requirements of a promotion, and we'll post the points to your account immediately!".localized, "You should receive points in your account instantly once you complete a promotion!".localized , "Nope! Your points will never expire.".localized ,"When you return an item, you lose the associated credit you originally earned by buying the item in the first place.Sound kind of confusing? Let's take an example: let's say you had previously spent $50 towards a 'spend $100, earn 500 points' promotion, and you decide to buy a $20 item, which bumps you up to $70. If you decide to return that item, your progress would also go back down to $50 – it's just like you hadn't bought the item in the first place.".localized , "Our team is ready and waiting to answer your questions about our rewards program! Just send us an email and we'll be in touch.".localized , "We currently require you to have enough points to redeem any of the awards you see listed on the 'Get Rewards' tab.".localized , "From time to time, you'll receive program-related emails from us. If you'd prefer to not receive those types of emails anymore, just click the 'Unsubscribe' button when you receive your next email.".localized]
    override func viewDidLoad() {
        super.viewDidLoad()
        topHeading.text = "FREQUENTLY ASKED QUESTIONS".localized
        topHeading.backgroundColor = UIColor.AppTheme()
        topHeading.textColor = UIColor.textColor()
        topHeading.font = mageFont.mediumFont(size: 15.0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQTableCell", for: indexPath) as! FAQTableCell
        cell.headingLbl.text = quesData[indexPath.row]
        cell.descriptionLbl.text = answerData[indexPath.row]
        cell.headingLbl.font = mageFont.regularFont(size: 15.0)
        cell.descriptionLbl.font = mageFont.regularFont(size: 15.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150//UITableView.automaticDimension
    }
    
}
