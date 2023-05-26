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
extension MobileBuySDK.Storefront.OrderConnectionQuery {
  
  @discardableResult
  func fragmentForStandardOrder() -> MobileBuySDK.Storefront.OrderConnectionQuery { return self
    
    .pageInfo { $0
      .hasNextPage()
    }
    .edges { $0
      .cursor()
      .node { $0
        .totalPrice{$0
          .amount()
          .currencyCode()
        }
        .id()
        .orderNumber()
        .totalPrice{$0
          .amount()
        }
        .fulfillmentStatus()
        .financialStatus()
        .customerLocale()
        .customerUrl()
        .email()
        .statusUrl()
        .phone()
        .cancelReason()
        .canceledAt()
        .subtotalPrice{$0
          .amount()
          .currencyCode()
        }
        .totalTax{$0
          .amount()
          .currencyCode()
        }
        .totalShippingPrice{$0
          .amount()
          .currencyCode()
        }
        .processedAt()
        .currencyCode()
        
        .shippingAddress{$0
          .fragmentForStandardMailAddress()
        }
        
        .totalRefunded { $0
          .amount()
          .currencyCode()
        }
        
        .lineItems(first: 250) { $0
          .edges { $0
            .cursor()
            .node { $0
              .variant { $0
                .id()
                .price{$0
                  .amount()
                  .currencyCode()
                }
                .product{ $0
                  .id()
                }
                .title()
                .image {
                  $0
                        .url()
                   
                }
              }
              .currentQuantity()
              .title()
              .quantity()
            }
          }
          .pageInfo{$0
            .hasNextPage()
          }
        }
      }
    }
  }
}
