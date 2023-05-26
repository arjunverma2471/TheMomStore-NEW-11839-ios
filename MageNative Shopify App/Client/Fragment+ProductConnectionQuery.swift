//
//  Fragment+ProductConnectionQuery.swift
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



extension MobileBuySDK.Storefront.ProductConnectionQuery {
  
    @discardableResult
    func fragmentForStandardProduct() -> MobileBuySDK.Storefront.ProductConnectionQuery { return self
            .pageInfo { $0
            .hasNextPage()
            }
            .edges { $0
            .cursor()
            .node { $0
              //Fetching Metafield
//            .metafield(namespace: "sizechartsrelentles", key: "size_charts"){ $0
//                  .namespace()
//                  .key()
//                  .reference{ $0
//                  .onGenericFile{ $0
//                  .url()
//                      }
//                    }
//                  }
          
            .id()
            .title()
            .description()
            .descriptionHtml()
            .variants(first: 250) { $0
            .fragmentForStandardVariant()
            }
            
            .handle()
            .productType()
            .vendor()
            .collections(first:250) { $0
            .fragmentForCollectionId()
            }
            
                
            .totalInventory()
            .tags()
            .options{ $0
            .id()
            .name()
            .values()
                
            }
                
            .availableForSale()
            
            .images(first : 250){$0
            .fragmentForStandardProductImage()
            }
            .requiresSellingPlan()
            .sellingPlanGroups(first : 250) { $0
            .edges{ $0
            .node { $0
            .name()
            .options { $0
            .name()
            .values()
                
            }
            .sellingPlans(first : 250) { $0
            .edges { $0
            .node { $0
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
            .pageInfo { $0
            .hasNextPage()
          }
            }
            }
            }
            .pageInfo { $0
              .hasNextPage()
            }
            }
            .onlineStoreUrl()
            .media(first: 20){$0
            .fragmentForProductMedia()
            }
            }
            }
    }
    
}

extension MobileBuySDK.Storefront.MediaConnectionQuery{
  @discardableResult
  func fragmentForProductMedia() -> MobileBuySDK.Storefront.MediaConnectionQuery { return self
    .pageInfo { $0
      .hasNextPage()
    }
    .edges { $0
      .cursor()
      .node { $0
        .mediaContentType()
        .onModel3d { $0
          .fragmentForModelMedia()
        }
        .onVideo { $0
          .fragmentForModelVideo()
        }
        
        .onExternalVideo{ $0
          .fragmentForExternalVideo()
        }
        
        .onMediaImage{ $0
          .fragmentForImageMedia()
        }
      }
    }
  }
}


extension MobileBuySDK.Storefront.Model3dQuery{
  @discardableResult
  func fragmentForModelMedia() -> MobileBuySDK.Storefront.Model3dQuery { return self
    .previewImage {$0
    .url()// .originalSrc()
    }
    .sources{ $0
      .format()
      .mimeType()
      .url()
    }
  }
}

extension MobileBuySDK.Storefront.MediaImageQuery{
  @discardableResult
  func fragmentForImageMedia() -> MobileBuySDK.Storefront.MediaImageQuery { return self
    .id()
    .image{
      $0
           // .url()//.originalSrc()
            .url()//.transformedSrc()
    }
  }
}


extension MobileBuySDK.Storefront.VideoQuery{
  @discardableResult
  func fragmentForModelVideo() -> MobileBuySDK.Storefront.VideoQuery { return self
    .id()
    .previewImage {$0
    .url()// .originalSrc()
    }
    .sources { $0
      .url()
      .format()
    }
  }
}

extension MobileBuySDK.Storefront.ExternalVideoQuery{
  @discardableResult
  func fragmentForExternalVideo() -> MobileBuySDK.Storefront.ExternalVideoQuery { return self
    .id()
    .embedUrl()
    .originUrl()
    //.embeddedUrl()
    .previewImage {$0
    .height()
    .width()
    .url()
      //.originalSrc() .height() .width() .transformedSrc()
    }
  }
}


extension MobileBuySDK.Storefront.CollectionConnectionQuery {
  
  @discardableResult
  func fragmentForCollectionId() -> MobileBuySDK.Storefront.CollectionConnectionQuery { return self
    .pageInfo { $0
      .hasNextPage()
    }
    .edges { $0
      .cursor()
      .node { $0
                .id()
                .title()
                .handle()
                .descriptionHtml()

                .image({ $0
                .url()
                })

              }

    }
  }
}
