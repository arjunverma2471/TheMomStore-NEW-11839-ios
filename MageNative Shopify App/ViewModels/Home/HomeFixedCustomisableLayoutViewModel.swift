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

import Foundation
class HomeFixedCustomisableLayoutViewModel {
    let cell_background_color : UIColor?
    let header : String?
    let header_action : String?
    let header_action_background_color : UIColor?
    let header_action_color : UIColor?
    let header_action_font_weight : String?
    let header_action_text : String?
    let header_action_title_font_style : String?
    let header_background_color : UIColor?
    let header_deal : String?
    let header_deal_color : UIColor?
    let header_subtitle :String?
    let header_subtitle_color : UIColor?
    let header_subtitle_font_weight : String?
    let header_subtitle_text : String?
    let header_subtitle_title_font_style : String?
    let header_title_color : UIColor?
    let header_title_font_weight : String?
    let header_title_text : String?
    let no_list_item: String?
    let item_border : String?
    let item_border_color : UIColor?
    var item_compare_at_price : String?
    var item_compare_at_price_color :UIColor?
    var item_compare_at_price_font_style : String?
    var item_compare_at_price_font_weight : String?
    let item_deal_end_date : String?
    let item_deal_format : String?
    let item_deal_message :String?
    let item_deal_start_date :String?
    var item_header_font_style :String?
    var item_in_a_row : String?
    var item_layout_type :String?
    var item_price : String?
    var item_price_color : UIColor?
    var item_price_font_style : String?
    var item_price_font_weight : String?
    var item_row : String?
    let item_shape : String?
    let item_text_alignment : NSTextAlignment?
    var item_title : String?
    var item_title_color : UIColor?
    let item_title_font_style : String?
    let item_title_font_weight :String?
    let items : [[String:Any]]?
    let  panel_background_color :UIColor?
    let timestamp : String?
    let type : String?
    let uniqueId : String?
    let validated : String?
    let queryString :String?
    let productIds: [String]?
    var linkValue: String?
    var linking: String?
    init(from model:[String:Any]) {
        self.cell_background_color = calculateColor(strA: model["cell_background_color"] as? String)
        self.item_title_color = calculateColor(strA: model["item_title_color"] as? String)
        //print(model["item_title_color"] as? String)
        self.item_row = model["item_row"] as? String
        self.item_in_a_row = model["item_in_a_row"] as? String
        self.header_title_color = calculateColor(strA: model["header_title_color"] as? String)
        self.header = model["header"] as? String
        self.header_action = model["header_action"] as? String
        self.header_action_background_color = calculateColor(strA:model["header_action_background_color"] as? String)
        self.header_action_color = calculateColor(strA:model["header_action_color"] as? String)
        self.header_action_title_font_style = model["header_action_title_font_style"] as? String
        self.header_action_font_weight = model["header_action_font_weight"] as? String
        self.header_action_text = model["header_action_text"] as? String
        self.header_background_color = calculateColor(strA:model["header_background_color"] as? String)
        self.header_deal = model["header_deal"] as? String
        self.header_deal_color = calculateColor(strA:model["header_deal_color"] as? String)
        self.header_subtitle_title_font_style = model["header_subtitle_title_font_style"] as? String
        self.header_subtitle = model["header_subtitle"] as? String
        self.header_subtitle_color = calculateColor(strA:model["header_subtitle_color"] as? String)
        self.header_subtitle_text = model["header_subtitle_text"] as? String
        self.header_subtitle_font_weight = model["header_subtitle_font_weight"] as? String
        self.header_title_font_weight = model["header_title_font_weight"] as? String
        self.header_title_text = model["header_title_text"] as? String
        self.item_border = model["item_border"] as? String
        self.item_border_color = calculateColor(strA:model["item_border_color"] as? String)
        self.item_header_font_style = model["item_header_font_style"] as? String
        self.item_deal_end_date = model["item_deal_end_date"] as? String
        self.item_shape = model["item_shape"] as? String
        self.item_layout_type = model["item_layout_type"] as? String
        self.item_price_color = calculateColor(strA:model["item_price_color"] as? String)
        self.item_price = model["item_price"] as? String
        self.item_title = model["item_title"] as? String
        self.item_compare_at_price = model["item_compare_at_price"] as? String
        self.item_price_font_weight = model["item_price_font_weight"] as? String
        self.item_price_font_style = model["item_price_font_style"] as? String
        self.item_compare_at_price_font_weight = model["item_compare_at_price_font_weight"] as? String
        self.item_compare_at_price_font_style = model["item_compare_at_price_font_style"] as? String
        self.item_compare_at_price_color = calculateColor(strA:model["item_compare_at_price_color"] as? String)
        self.no_list_item = model["no_list_item"] as? String
        
        switch model["item_text_alignment"] as? String {
        case "center":
              self.item_text_alignment = .center
        case "right":
            self.item_text_alignment = Client.locale == "ar" ? .left : .right
        default:
            self.item_text_alignment = Client.locale == "ar" ? .right : .left
        }
        self.item_title_font_style = model["item_title_font_style"] as? String
        self.item_title_font_weight = model["item_title_font_weight"] as? String
        self.items = model["items"] as? [[String:Any]]
        self.panel_background_color = calculateColor(strA:model["panel_background_color"] as? String)
        self.timestamp = model["timestamp"] as? String
        self.type = model["type"] as? String
        self.uniqueId = model["uniqueId"] as? String
        self.validated = model["validated"] as? String
        self.item_deal_format = model["item_deal_format"] as? String
        self.item_deal_message = model["item_deal_message"] as? String
        self.item_deal_start_date = model["item_deal_start_date"] as? String
        self.queryString = (self.items?.first?["product_value"] as? [String])?.joined(separator: " OR id:")
        self.productIds = self.items?.first?["product_value"] as? [String]
        self.linkValue =  self.items?.first?["link_value"] as? String ?? ""
        self.linking = model["linking_type"] as? String
    }
}
