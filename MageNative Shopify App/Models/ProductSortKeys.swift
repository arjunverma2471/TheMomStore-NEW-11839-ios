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
struct ProductSortKeys {
    static let sortKeys = [["Popularity".localized:MobileBuySDK.Storefront.ProductCollectionSortKeys.bestSelling,"reverse":false],["Price: High to Low".localized:MobileBuySDK.Storefront.ProductCollectionSortKeys.price,"reverse":true],["Price: Low to High":MobileBuySDK.Storefront.ProductCollectionSortKeys.price,"reverse":false],["Name: A to Z".localized:MobileBuySDK.Storefront.ProductCollectionSortKeys.title,"reverse":false],["Name: Z to A".localized:MobileBuySDK.Storefront.ProductCollectionSortKeys.title,"reverse":true]]
}
