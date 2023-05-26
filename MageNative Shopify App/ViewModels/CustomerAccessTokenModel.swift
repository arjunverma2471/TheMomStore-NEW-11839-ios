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

import UIKit

class CustomerAccessTokenModel: ViewModel {
    typealias ModelType = MobileBuySDK.Storefront.CustomerAccessToken
    let model: ModelType?
    let accessToken:String
    let expireAt:Date
    required init(from model: ModelType) {
        self.model = model
        self.accessToken = model.accessToken
        self.expireAt = model.expiresAt
    }
}

extension MobileBuySDK.Storefront.CustomerAccessToken:ViewModeling{
    typealias ViewModelType = CustomerAccessTokenModel
    
    
}
