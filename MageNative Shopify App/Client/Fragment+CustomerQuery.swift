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

extension MobileBuySDK.Storefront.MailingAddressConnectionQuery {
  
  @discardableResult
  func fragmentForStandardAddress() -> MobileBuySDK.Storefront.MailingAddressConnectionQuery { return self
    .edges{$0
      .cursor()
      .node{$0
        .fragmentForStandardMailAddress()
      }
    }
    .pageInfo{$0
      .hasNextPage()
    }
  }
}

extension MobileBuySDK.Storefront.MailingAddressQuery {
  @discardableResult
  func fragmentForStandardMailAddress() ->MobileBuySDK.Storefront.MailingAddressQuery{
    return self
      .id()
      .name()
      .address1()
      .address2()
      .city()
      .phone()
      .country()
      .firstName()
      .lastName()
      .province()
      .formattedArea()
      .zip()
      .countryCodeV2()
      .latitude()
      .longitude()
  }
}

