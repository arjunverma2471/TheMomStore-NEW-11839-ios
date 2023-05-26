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
class CustomerViewModel:ViewModel{
    typealias ModelType = MobileBuySDK.Storefront.Customer
    let model: ModelType?
    let customerId:String?
    let createdAt:Date?
    let firstName:String?
    let lastName:String?
    let email:String?
    let displayName:String?
    let customerTags : [String]?
    required init(from model: ModelType) {
        self.model = model
        self.email = model.email
        self.customerId = model.id.rawValue
        self.firstName = model.firstName
        self.createdAt = model.createdAt
        self.displayName = model.displayName
        self.lastName = model.lastName
        self.customerTags = model.tags
    }
    
}

extension MobileBuySDK.Storefront.Customer:ViewModeling{
     typealias ViewModelType = CustomerViewModel
}
