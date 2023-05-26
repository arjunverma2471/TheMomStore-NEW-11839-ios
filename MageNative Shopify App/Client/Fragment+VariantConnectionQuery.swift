//
//  Fragment+VariantConnectionQuery.swift
//  Storefront
//
//  Created by Shopify.
//  Copyright (c) 2017 Shopify Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import MobileBuySDK


extension MobileBuySDK.Storefront.ProductVariantConnectionQuery {
  
  @discardableResult
  func fragmentForStandardVariant() -> MobileBuySDK.Storefront.ProductVariantConnectionQuery { return self
    .pageInfo { $0
      .hasNextPage()
    }
    .edges { $0
      .cursor()
      .node { $0
        .id()
        .title()
        .price{$0
          .amount()
          .currencyCode()
        }
        
        .quantityAvailable()
        .compareAtPrice{$0
          .amount()
        }
        .sku()
        .currentlyNotInStock()
        .sellingPlanAllocations(first:20) { $0
        .edges { $0
        .node { $0
        .sellingPlan { $0
        .id()
        .name()
        .description()
        .recurringDeliveries()
        .options {$0
            .name()
            .value()
        }
        .priceAdjustments { $0
        .orderCount()
        
        .adjustmentValue { $0
        .onSellingPlanPercentagePriceAdjustment { $0
        .adjustmentPercentage()
        }
        .onSellingPlanFixedPriceAdjustment { $0
        .price { $0
        .amount()
        .currencyCode()
        }
        }
        .onSellingPlanFixedAmountPriceAdjustment { $0
        .adjustmentAmount { $0
        .amount()
        .currencyCode()
        }
        }
        }
        }
        }
        }
        }
        }
        .availableForSale()
        .image({$0
        .url()
        })
        .selectedOptions{$0
          .name()
          .value()
        }        
      }
    }
  }
}
