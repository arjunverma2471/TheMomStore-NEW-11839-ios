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

class HomeCollectionListSliderViewModel {
    
    let header : String?
    let header_background_color : UIColor?
    let header_subtitle : String?
    let header_subtitle_color : UIColor?
    let header_subtitle_font_weight : String?
    let header_subtitle_text :String?
    let header_subtitle_title_font_style :String?
    let header_text : String?
    let header_title_color : UIColor?
    let item_border : String?
    let item_border_color : UIColor?
    let item_header_font_style : String?
    let item_header_font_weight : String?
    let item_shape : String?
    let item_text_alignment : String?
    let item_title_font_weight :String?
    let item_title_font_style :String?
    let item_total :String?
    let items : [[String:String]]?
    let panel_background_color :UIColor?
    let timestamp : String?
    let type : String?
    let uniqueId : String?
    let validated : String?
    
    init(from model:[String:Any]) {
        self.header = model["header"] as? String
        self.header_background_color = calculateColor(strA: model["header_background_color"] as? String)
        self.header_subtitle = model["header_subtitle"] as? String
        self.header_subtitle_color = calculateColor(strA: model["header_subtitle_color"] as? String)
        self.header_subtitle_font_weight = model["header_subtitle_font_weight"] as? String
        self.header_subtitle_text  = model["header_subtitle_text"] as? String
        self.header_subtitle_title_font_style  = model["header_subtitle_font_style"] as? String
        self.header_text  = model["header_title_text"] as? String
        self.header_title_color  = calculateColor(strA:model["header_title_color"] as? String)
        self.item_border  = model["item_border"] as? String
        self.item_border_color  = calculateColor(strA:model["item_border_color"] as? String)
        self.item_header_font_weight  = model["header_title_font_weight"] as? String
        self.item_header_font_style  = model["header_title_font_style"] as? String
        self.item_shape  = model["item_shape"] as? String
        self.item_text_alignment  = model["item_text_alignment"] as? String
        self.item_title_font_style  = model["item_title_font_style"] as? String
        self.item_title_font_weight  = model["item_title_font_weight"] as? String
        self.item_total  = model["item_total"] as? String
        self.items  = model["items"] as? [[String:String]]
        self.panel_background_color  = calculateColor(strA:model["panel_background_color"] as? String)
        self.timestamp  = model["timestamp"] as? String
        self.type  = model["type"] as? String
        self.uniqueId  = model["uniqueId"] as? String
        self.validated  = model["validated"] as? String
        
    }
    
}
