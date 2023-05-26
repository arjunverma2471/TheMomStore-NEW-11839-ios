//
//  DiscountCouponCell.swift
//  MageNative Shopify App
//
//  Created by Yash Pratap Singh sisodia on 23/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import UIKit

class DiscountCouponCell: UITableViewCell {

    @IBOutlet weak var viewALLView: UIView!
    @IBOutlet weak var noCodeRequireLbl: UILabel!
    @IBOutlet weak var copyLbl: UILabel!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var couponCodeLbl: UILabel!
    @IBOutlet weak var couponLbl: UILabel!
    @IBOutlet weak var viewAllLbl: UILabel!
    @IBOutlet weak var couponStack: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor(light: UIColor(hexString: "#F2F2F2"),dark: UIColor.provideColor(type: .cartVc).backGroundColor)
        self.parentView.backgroundColor = UIColor(light: UIColor.white,dark: UIColor(hexString: "#F2F2F2", alpha: 0.15))
        
        self.copyButton.layer.cornerRadius = 10
//        self.copyButton.backgroundColor = UIColor.AppTheme()
        self.viewAllButton.setTitle("", for: .normal)
        self.viewALLView.backgroundColor = .AppTheme()
//        self.copyLbl.textColor = UIColor.textColor()
        self.viewAllLbl.textColor = UIColor(light: .white,dark: UIColor.provideColor(type: .cartVc).textColor)
        self.couponCodeLbl.numberOfLines = 2
        self.couponLbl.numberOfLines = 2
        self.noCodeRequireLbl.isHidden = true
        self.copyButton.setImage(resizeImage(image: UIImage(named: "copyIcon")!, targetSize: CGSize(width: 30, height: 30)), for: .normal)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(discount: DiscountCouponModel) {
        self.copyButton.setTitle("", for: .normal)
        self.couponLbl.text = "CODE: \(discount.title?.uppercased() ?? "" )"
        self.couponCodeLbl.text = discount.summary ?? "No Description"
        if let type = discount.typename {
            if type.contains("Automatic") {
                self.copyButton.isHidden = true
//                self.copyLbl.isHidden  = true
                self.noCodeRequireLbl.isHidden = false
            } else {
                self.copyButton.isHidden = false
//                self.copyLbl.isHidden  = false
                self.noCodeRequireLbl.isHidden = true
            }
        } 
        
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}
