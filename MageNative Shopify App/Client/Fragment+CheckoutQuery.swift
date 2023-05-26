//
//  Fragment+CheckoutQuery.swift
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
extension MobileBuySDK.Storefront.CheckoutQuery {
  
  @discardableResult
  func fragmentForCheckout() -> MobileBuySDK.Storefront.CheckoutQuery { return self
    .id()
    .ready()
    .requiresShipping()
    .taxesIncluded()
    .email()
    .shippingAddress { $0
      .name()
      .firstName()
      .lastName()
      .phone()
      .address1()
      .address2()
      .city()
      .country()
      //.countryCode()
      .countryCodeV2()
      .province()
      .provinceCode()
      .zip()
    }
    .shippingLine { $0
      .handle()
      .title()
      .price{$0
        .amount()

      }
    }
    .note()
    .lineItems(first: 250) { $0
      .edges { $0
        
        .cursor()
        .node { $0
          
        
        
          .variant { $0
            .id()
            .selectedOptions{$0
              .name()
              .value()
            }  
            .product { $0
                .id()
                .title()
            .collections(first : 250) { $0
            .edges { $0
            .cursor()
            .node { $0 
            .id()
            }
            }
            }
            }
            .price{$0
              .amount()
              .currencyCode()
            }
            .compareAtPrice{$0
            .amount()
            .currencyCode()
          }
            .image( { $0
            .url()
            })
            .title()
            .quantityAvailable()
            .currentlyNotInStock()
            .sku()
            
            
          }
          .id()
          .title()
          
          .discountAllocations{$0
            .allocatedAmount{$0
              .amount()
            }
            .discountApplication{$0
              .allocationMethod()
              .onAutomaticDiscountApplication{$0
                .allocationMethod()
              }
              .onDiscountCodeApplication{$0
                .code()
                .allocationMethod()
              }
            }
            
          }
          
          .title()
          .quantity()
        }
      }
    }
    .lineItemsSubtotalPrice({$0
        .amount()
        .currencyCode()
    })
    .availableShippingRates( { $0
    .ready()
    .shippingRates { $0
    .handle()
    .price { $0
    .amount()
    }
    .title()
    }
    })
    .appliedGiftCards{$0
      .amountUsed{$0
        .amount()
      }
      .balance{$0
        .amount()
      }
    }
    .webUrl()
    .currencyCode()
    .subtotalPrice{ $0
      .amount()
    }
    //.subtotalPrice()
    .totalTax{$0
      .amount()
    }
    .totalTax{$0
      .amount()
    }
    //.totalTax()
    .totalPrice{$0
      .amount()
    }
    //.totalPrice()
    .paymentDue{$0
      .amount()
    }
    //.paymentDue()
    .discountApplications(first: 10) { $0
    .edges { $0
    .node { $0
    .allocationMethod()
    .targetSelection()
    .targetType()
    .value { $0
    .onMoneyV2 { $0
    .amount()
    .currencyCode()
    }
    .onPricingPercentageValue { $0
    .percentage()
    }
    }
    }
    }
    }
  }
}



//extension MobileBuySDK.Storefront.CartQuery {
//    @discardableResult
//    func fragmentForCart() -> MobileBuySDK.Storefront.CartQuery {
//        .id()
//        
//    }
//}
