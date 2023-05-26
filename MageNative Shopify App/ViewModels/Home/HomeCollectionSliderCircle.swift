/**
 * CedCommerce
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the End User License Agreement (EULA)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://cedcommerce.com/license-agreement.txt
 *
 * @category  Ced
 * @package   MageNative
 * @author    CedCommerce Core Team <connect@cedcommerce.com >
 * @copyright Copyright CEDCOMMERCE (http://cedcommerce.com/)
 * @license      http://cedcommerce.com/license-agreement.txt
 */

class HomeCollectionSliderViewModel {
   let type:String?
   let timestamp:String?
   let uniqueId:String?
   let show_item_title:Bool
   let item_border:String?
   var item_title_color:UIColor?
   var item_border_color:UIColor?
   var panel_background_color:UIColor?
   let item_font_weight:String?
   let item_font_style:String?
   let collection:[[String:String]]?
    
    let cornerRadius: String?
    
    var item_shape: String?
    
    
    init(from model:[String:Any]){
        let data = model
        self.type = data["type"] as? String
        self.timestamp = data["timestamp"] as? String
        self.uniqueId = data["uniqueId"] as? String
        self.show_item_title = (data["item_title"] as? String == "1") ? true : false
        self.item_border = data["item_border"] as? String
        self.item_font_weight = data["item_font_weight"] as? String
        self.item_font_style = data["item_font_style"] as? String
        self.collection = data["items"] as? [[String:String]]
        self.item_title_color = calculateColor(strA: (data["item_title_color"] ))
        self.item_border_color = calculateColor(strA: data["item_border_color"])
        self.panel_background_color = calculateColor(strA: data["panel_background_color"])
        self.item_shape = data["item_shape"] as? String
        self.cornerRadius  = data["corner_radius"] as? String
        
    }
}

func calculateColor(strA:Any?)->UIColor? {
    if let js = strA as? String {
        
    let json = try? JSON(data:(js).data(using: .utf8)!).dictionary
        if var str = json?["color"]?.stringValue, let opacity = json?["opacity"]?.floatValue  {
            if str == "#ffffff" || str == "#FFFFFF"{
                return UIColor(light: .white,dark: .black)
            }
            return UIColor(hexString: str, alpha: CGFloat(opacity))
        }
    }
    return nil
}
