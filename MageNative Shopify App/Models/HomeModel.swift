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

struct HomeModel:Codable {
    let success:Bool
    let email:String
   // let banners:[banner]?
    let bannersAdditional:additional?
    let collections:[collection]?

    init(from decoder:Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decode(Bool.self, forKey: .success)
        self.email  = try container.decode(String.self, forKey: .email)
    //    self.banners  =  try container.decode([banner].self, forKey: .banners)
        do {
            self.bannersAdditional  = try container.decode(additional.self, forKey: .bannersAdditional)
        }catch {
            self.bannersAdditional = nil
        }
        self.collections  = try container.decode([collection].self, forKey: .collections)

    }
}

struct sort_order {
    let fields:[String:Any]?
}

struct additional:Codable {
    let middle:[String]?
    let bottom:[String]?
}

struct banner{
     let data:[String:String]?
}

struct collection:Codable {
    let id:String?
    let title:String?
}



struct collectionCircleSlider {
    let data:[String:Any]?
}
