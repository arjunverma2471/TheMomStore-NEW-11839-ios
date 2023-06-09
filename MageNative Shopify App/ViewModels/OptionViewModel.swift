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
class OptionViewModel: ViewModel {

    typealias ModelType = MobileBuySDK.Storefront.SelectedOption
    
    let model : ModelType?
    let name : String
    let value : String
    
    required init(from model: ModelType) {
        self.model = model
        self.name = model.name
        self.value = model.value
    }
    
}

extension MobileBuySDK.Storefront.SelectedOption: ViewModeling {
    typealias ViewModelType = OptionViewModel
}
