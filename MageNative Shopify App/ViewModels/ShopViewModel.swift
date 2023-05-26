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
/*
class ShopViewModel: ViewModel {
    typealias ModelType =  MobileBuySDK.Storefront.Shop
    let model: ModelType?
    let shopName:String
    let refundPolicyUrl:URL?
    let termsOfService:URL?
    let privacyPolicyUrl:URL?
    let currencyCode:String?
    required init(from model: ModelType) {
        self.model = model
        self.shopName = model.name
        self.refundPolicyUrl  = model.refundPolicy?.url
        self.termsOfService   = model.termsOfService?.url
        self.privacyPolicyUrl = model.privacyPolicy?.url
        self.currencyCode = model.paymentSettings.currencyCode.rawValue
    }
}

extension MobileBuySDK.Storefront.Shop:ViewModeling{
    typealias ViewModelType = ShopViewModel
}
*/

class ShopViewModel: ViewModel {
    typealias ModelType =  MobileBuySDK.Storefront.Shop
    let model: ModelType?
    let shopName:String
    let refundPolicyUrl:URL?
    let termsOfService:URL?
    let privacyPolicyUrl:URL?
    let currencyCode:String?
    let countryCode:String?
    let cardVaultUrl:URL?
    
    
    required init(from model: ModelType) {
        self.model = model
        self.shopName = model.name
        self.refundPolicyUrl  = model.refundPolicy?.url
        self.termsOfService   = model.termsOfService?.url
        self.privacyPolicyUrl = model.privacyPolicy?.url
        self.currencyCode = model.paymentSettings.currencyCode.rawValue
        self.countryCode = model.paymentSettings.countryCode.rawValue
        self.cardVaultUrl=model.paymentSettings.cardVaultUrl
    }
}

extension MobileBuySDK.Storefront.Shop:ViewModeling{
    typealias ViewModelType = ShopViewModel
}


