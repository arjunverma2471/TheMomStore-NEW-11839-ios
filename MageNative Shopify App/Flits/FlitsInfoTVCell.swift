//
//  FlitsInfoTVCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 25/07/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class FlitsInfoTVCell: UITableViewCell {
  
  @IBOutlet weak var infoDesc: UILabel!
  @IBOutlet weak var infoTitle: UILabel!
  @IBOutlet weak var infoImage: UIImageView!
  
  @IBOutlet weak var containerView: UIView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    containerView.cardView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
  
  var infoData: AllRulesDatum?{
    didSet{
      guard let infoData = infoData else {
        return
      }

      let customData  = self.getCustomData(infoData: infoData)
      infoTitle.text = customData?.title
      infoDesc.text  = customData?.desc
      infoImage.image = customData?.image
    }
  }
  
  func convertBase64StringToImage (imageBase64String:String) -> UIImage {
      let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
      let image = UIImage(data: imageData!)
      return image ?? UIImage()
  }
  
  
  func getCustomData(infoData:AllRulesDatum)->CustomDataForInfo?{
    let symbol = Currencies.currency(for:Client.shared.getCurrencyCode()!)!.shortestSymbol
    let credit = Double(infoData.credits ?? 0)
    guard var columnValue =  infoData.columnValue else {return nil}
    columnValue     = betweenString(columnValue: columnValue )
    
    switch infoData.title {
    case "register_rule_title":
      return CustomDataForInfo(image: UIImage(named: infoData.title ?? "placeholder"), title: "Register Credit", desc: "Register and get \(symbol)\(credit/100)")
    case "subscribe_rule_title":
      return CustomDataForInfo(image: UIImage(named: infoData.title ?? "placeholder"), title: "Subscriber credit", desc: "Subscribe and get \(symbol)\(credit/100)")
    case "order_number_rule_title":
      return CustomDataForInfo(image: UIImage(named: infoData.title ?? "placeholder"), title: "Credit on specific order", desc: "Earn \(symbol)\(credit/100) credit on your order number 1")
    case "after_order_number_rule_title":
      return CustomDataForInfo(image: UIImage(named: infoData.title ?? "placeholder"), title: "Credit on order number \(columnValue) and next orders", desc: "You can earn \(credit/100) credit on order number \(columnValue) and next orders 3, 4..... n")
    case "spent_on_cart_rule_title":
      return CustomDataForInfo(image: UIImage(named: infoData.title ?? "placeholder"), title: "Spend on cart", desc: "Your cart value is between \(columnValue). Congratulations you are eligible to use \(symbol)\(credit/100) credit.")
    case "add_product_to_wishlist_rule_title":
      return CustomDataForInfo(image: UIImage(named: infoData.title ?? "placeholder"), title: "Wishlisted product credit", desc: "You can earn \(symbol)\(credit/100) credit when you add product/s in wishlist.")
    default:
      return nil
    }
  }
  
  func betweenString(columnValue:String)->String{
    let symbol = Currencies.currency(for:Client.shared.getCurrencyCode()!)!.shortestSymbol
    if columnValue.contains(":"){
      let token = columnValue.components(separatedBy: ":")
      guard let firstRange = token.first, var secondRange = token.last else {return columnValue}
      if  secondRange == "-1"{
        secondRange = "or more"
        return "\(symbol)\(firstRange)-\(secondRange)"
      }
      return "\(symbol)\(firstRange)-\(symbol)\(secondRange)"
    }
    return  columnValue
  }
}

struct CustomDataForInfo {
  var image = UIImage(named: "cartIcon")
  var title = ""
  var desc  = ""
}
