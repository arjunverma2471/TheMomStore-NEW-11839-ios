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
import MobileBuySDK
import AlgoliaSearchClient

final class ClientQuery {
  
  static let maxImageDimension = Int32(UIScreen.main.bounds.width)
  // ----------------------------------
  //  MARK: - Shop -
  //
  static func queryForShopName() -> MobileBuySDK.Storefront.QueryRootQuery {
    return MobileBuySDK.Storefront.buildQuery(inContext: .init(country: Client.shared.getCurrencyCodeVal(),language: Client.shared.getLanguageCode())) { $0
      .shop { $0
        .name()
        
      }
    }
  }
    //---------------------------------
    // Mark : - Fetch Currency Details
    //
    
    static func queryForCurrency()->MobileBuySDK.Storefront.QueryRootQuery{
        return MobileBuySDK.Storefront.buildQuery() { $0
                .localization{$0
                  // For the current country
                  .availableLanguages { $0
                    .isoCode()
                    .endonymName()
                    .name()
                }
                  
                .availableCountries{$0
                .currency{$0
                .isoCode()
                .name()
                .symbol()
                }
                .isoCode()
                .name()
                .unitSystem()
                }
                }
        }
    }
  
  // ----------------------------------
  //  MARK: - LOGIN Customer Token -
  //
  static func queryForCustomerToken( email:String,password:String)->MobileBuySDK.Storefront.MutationQuery{
    let accessTokenInput = MobileBuySDK.Storefront.CustomerAccessTokenCreateInput(email: email, password: password)
    return MobileBuySDK.Storefront.buildMutation(inContext: .init(country: Client.shared.getCurrencyCodeVal())) {$0
      .customerAccessTokenCreate(input: accessTokenInput, {$0
        .customerAccessToken
        {$0
          .accessToken()
          .expiresAt()
        }
        .customerUserErrors{$0
          .field()
          .message()
        }
      })
      
    }
  }
    
    
  
  static func queryForMultipassToken()->MobileBuySDK.Storefront.MutationQuery
  {
    //let accessTokenInput = MobileBuySDK.Storefront.CustomerAccessTokenCreateInput(email: email, password: password)
    return MobileBuySDK.Storefront.buildMutation(inContext: .init(country: Client.shared.getCurrencyCodeVal())) {$0
      .customerAccessTokenCreateWithMultipass(multipassToken: "7102d3a6952bb568b86d60383a6075a2"){
        $0
        .customerAccessToken
          {
          $0
          .accessToken()
          .expiresAt()
        }
        .customerUserErrors{$0
          .field()
          .message()
        }
      }
    }
  }
  
  // ----------------------------------
  //  MARK: - Update Customer Token -
  //
  
  static func queryForCustomerTokenUpdate(accessToken:String)->MobileBuySDK.Storefront.MutationQuery{
    return MobileBuySDK.Storefront.buildMutation(inContext: .init(country: Client.shared.getCurrencyCodeVal())){$0
      .customerAccessTokenRenew(customerAccessToken: accessToken, {$0
        .customerAccessToken{$0
          .accessToken()
          .expiresAt()
        }
      })
    }
  }
  
  // ----------------------------------
  //  MARK: - SIGNUP  -
  //
  static func queryForSignUp(email:String,password:String,firstName:String,lastName:String,acceptsMarketing:Bool)->MobileBuySDK.Storefront.MutationQuery
  {
    let customerInput = MobileBuySDK.Storefront.CustomerCreateInput.create(email: email, password: password, firstName: Input(orNull: firstName), lastName: Input(orNull: lastName), acceptsMarketing: Input(orNull:acceptsMarketing))
    return MobileBuySDK.Storefront.buildMutation(inContext: .init(country: Client.shared.getCurrencyCodeVal(),language: Client.shared.getLanguageCode()))
    { $0
      .customerCreate(input: customerInput, {$0
        .customer{$0
          .createdAt()
          .firstName()
          .lastName()
          .id()
          .acceptsMarketing()
          .email()
          .phone()
          .displayName()
          .tags()
        }
        .customerUserErrors{$0
          .field()
          .message()
        }
      })
    }
  }
  
  // ----------------------------------
  //  MARK: - checkoutCustomerAssociateV2 -
  //
  static func checkoutCustomerAssociateV2(checkoutId: GraphQL.ID, token: String)-> MobileBuySDK.Storefront.MutationQuery
  {
    return MobileBuySDK.Storefront.buildMutation(inContext: .init(country: Client.shared.getCurrencyCodeVal())){ $0
      .checkoutCustomerAssociateV2(checkoutId: checkoutId, customerAccessToken: token) {$0
        .checkout {$0
          .fragmentForCheckout()
          .appliedGiftCards{$0
            .id()
          }
        }
        .checkoutUserErrors {$0
          .code()
          .field()
          .message()
        }
        .customer {$0
          .id()
        }
      }
      
    }
  }
    
    
    static func checkoutShippingAddressUpdateV2(address:[String:String] , checkoutID : GraphQL.ID!) -> MobileBuySDK.Storefront.MutationQuery {
        let addressInput = MobileBuySDK.Storefront.MailingAddressInput.create(address1: Input(orNull:address["address1"]), address2: Input(orNull:address["address2"]), city: Input(orNull:address["city"]), country: Input(orNull:address["country"]), firstName: Input(orNull:address["firstName"]), lastName: Input(orNull:address["lastName"]), phone: Input(orNull:address["phone"]), province: Input(orNull:address["province"]), zip: Input(orNull:address["zip"]))
        
        return MobileBuySDK.Storefront.buildMutation(inContext: .init(country: Client.shared.getCurrencyCodeVal())){ $0
                .checkoutShippingAddressUpdateV2(shippingAddress: addressInput, checkoutId: checkoutID) { $0
                .checkout { $0
                .fragmentForCheckout()
                }

                .checkoutUserErrors { $0
                .code()
                .field()
                .message()
                }
                }
        }
    }
    
    
    static func checkoutShippingLineUpdate(checkoutID : GraphQL.ID, shippingRateHandle : String) -> MobileBuySDK.Storefront.MutationQuery {
        return MobileBuySDK.Storefront.buildMutation(inContext: .init(country: Client.shared.getCurrencyCodeVal())){ $0
                .checkoutShippingLineUpdate(checkoutId: checkoutID, shippingRateHandle: shippingRateHandle) { $0
                .checkout { $0
                .fragmentForCheckout()
                }
                .checkoutUserErrors { $0
                .code()
                .field()
                .message()
                }
                    
                }
        }
    }
    
    
    
    
    static func checkoutCompleteWithCreditCardV2(checkoutId : GraphQL.ID, payment : MobileBuySDK.Storefront.CreditCardPaymentInputV2) -> MobileBuySDK.Storefront.MutationQuery {
        return MobileBuySDK.Storefront.buildMutation(inContext: .init(country: Client.shared.getCurrencyCodeVal())){ $0
                .checkoutCompleteWithCreditCardV2(checkoutId:  checkoutId, payment: payment) { $0
                          .payment { $0
                              .id()
                              .transaction{$0
                                  .statusV2()
                                  .kind()
                              }
                              .ready()
                              .test()
                              .errorMessage()
                              .nextActionUrl()
                          }
                          .checkout { $0
                          .fragmentForCheckout()
                          }
                          .checkoutUserErrors { $0
                              .code()
                              .field()
                              .message()
                          }
                      }
                  
        }
    }
    
    
   
  // ----------------------------------
  //  MARK: - Storefront -
  //
  static func queryForCollections(limit: Int, after cursor: String? = nil, productLimit: Int = 25, productCursor: String? = nil,maxHeight:Int32,maxWidth:Int32) -> MobileBuySDK.Storefront.QueryRootQuery {
      return MobileBuySDK.Storefront.buildQuery(inContext: .init(country: Client.shared.getCurrencyCodeVal(),language: Client.shared.getLanguageCode()))  { $0
          .collections(first: Int32(limit), after: cursor,reverse: true, sortKey: .updatedAt) { $0
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
  }
    
    static func queryForProducts(in collection: CollectionViewModel? =  nil,coll:collection? = nil,with sortKey:MobileBuySDK.Storefront.ProductCollectionSortKeys? = nil,reverse:Bool?=nil, limit: Int, after cursor: String? = nil) -> MobileBuySDK.Storefront.QueryRootQuery {
        var id : GraphQL.ID!
        if  let collection = collection?.model?.node.id {
          id = collection
        }else {
          if let collId = coll?.id {
            let str1 = ("gid://shopify/Collection/"+collId)
            id = GraphQL.ID(rawValue: str1)
          }
        }
          
      return MobileBuySDK.Storefront.buildQuery(inContext: .init(country: Client.shared.getCurrencyCodeVal(),language: Client.shared.getLanguageCode())) {  $0
          
                  .collection(id:id) { $0
                  .handle()
                  .title()
                  .products(first: Int32(limit), after: cursor,reverse: reverse,sortKey:sortKey) { $0
                    .fragmentForStandardProduct()
                  }
                  .image({ $0
                  .url()
                  })
                  }
          }
    
    }
    // ----------------------------------
    //  MARK: - Get available product filters -
    //
    
    static func queryForFetchFilters(handle: String) -> MobileBuySDK.Storefront.QueryRootQuery{
        return MobileBuySDK.Storefront.buildQuery(inContext: .init(country: Client.shared.getCurrencyCodeVal(),language:Client.shared.getLanguageCode()))  { $0
            .collection(handle: handle){$0
                .handle()
                .products(first: 250) {$0
                    .filters {$0
                        .id()
                        .label()
                        .type()
                        .values {$0
                            .id()
                            .label()
                            .count()
                            .input()
                        }
                    }
                }
            }
        }
    }
    
    // ----------------------------------
    //  MARK: - Get filtered data -
    //
    
    static func queryForFilteredProducts(handle: String? =  nil,coll:collection? = nil,with sortKey:MobileBuySDK.Storefront.ProductCollectionSortKeys? = nil,reverse:Bool?=nil, limit: Int, after cursor: String? = nil, filter: [MobileBuySDK.Storefront.ProductFilter]? = nil) -> MobileBuySDK.Storefront.QueryRootQuery {
        
          
        if(filter?.isEmpty ?? false || filter == nil){
            return MobileBuySDK.Storefront.buildQuery(inContext: .init(country: Client.shared.getCurrencyCodeVal(),language:Client.shared.getLanguageCode())) {  $0
            
                    .collection(handle: handle) { $0
                    .handle()
                    
                    .products(first: Int32(limit), after: cursor,reverse: reverse,sortKey:sortKey) { $0
                      .fragmentForStandardProduct()
                    }
                    .image({ $0
                    .url()
                    })
                    }
                    
            }
        }
        else{
            return MobileBuySDK.Storefront.buildQuery(inContext: .init(country: Client.shared.getCurrencyCodeVal(),language: Client.shared.getLanguageCode())) {  $0
            
                    .collection(handle: handle) { $0
                    .handle()
                    
                    .products(first: Int32(limit), after: cursor,reverse: reverse,sortKey:sortKey, filters:filter) { $0
                      .fragmentForStandardProduct()
                    }
                    .image({ $0
                    .url()
                    })
                    }
                    
            }
        }
          
    }
    
    
  // ----------------------------------
  //  MARK: - Get products array by their ids -
  //
  
  static func queryForMultiProducts(of Ids: [GraphQL.ID]) -> MobileBuySDK.Storefront.QueryRootQuery{
      return MobileBuySDK.Storefront.buildQuery(inContext: .init(country: Client.shared.getCurrencyCodeVal(),language:Client.shared.getLanguageCode()))  { $0
      .nodes(ids: Ids) { $0
        .onProduct { $0
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
          .images(first : 250){ $0
          .fragmentForStandardProductImage()
          }
      
          .onlineStoreUrl()
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
          .media(first: 20){$0
            .fragmentForProductMedia()
          }
        }
      }
    }
  }
  
  // ----------------------------------
  //  MARK: - Get Recommended Products for a Product id -
  //
  
  static func queryForRecommendedProducts(of Id: GraphQL.ID? = nil) -> MobileBuySDK.Storefront.QueryRootQuery{
      return MobileBuySDK.Storefront.buildQuery(inContext: .init(country: Client.shared.getCurrencyCodeVal(),language:Client.shared.getLanguageCode()))  { $0
      .productRecommendations(productId: Id!) { $0
        .id()
        .title()
        .description()
        .descriptionHtml()
        .description()
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
        .images(first:250){ $0
        .fragmentForStandardProductImage()
        }
    
        .availableForSale()
        .onlineStoreUrl()
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
        .media(first: 20){$0
          .fragmentForProductMedia()
        }
      }
    }
  }
  
    
    // ----------------------------------
    //  MARK: - Get Single Product by id -
    //
    
    static func queryForSingleProduct(of Id: GraphQL.ID? = nil) -> MobileBuySDK.Storefront.QueryRootQuery {//"\(Client.shared.getStoreCurrencyCode())"
        return MobileBuySDK.Storefront.buildQuery(inContext: .init(country: Client.shared.getCurrencyCodeVal(),language:Client.shared.getLanguageCode())) { $0
        .node(id: Id!){ $0
          .onProduct{ $0
            // my_fields.filedemo  For testing
        .metafield(namespace: "sizechartsrelentles", key: "size_charts"){ $0
              .namespace()
              .key()
              .value()
              .type()
              .reference{ $0
              .onGenericFile{ $0
              .url()
                  }
                }
              }
            
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
            .images(first:250) { $0
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
  
  
  //-----------------------------------
  // MARK: - Search Product Query -
  //
  static func queryForSearchProducts(for query: String, limit: Int, after cursor: String? = nil,with sortKey:MobileBuySDK.Storefront.ProductSortKeys? = nil,reverse:Bool?=nil) -> MobileBuySDK.Storefront.QueryRootQuery {
      return MobileBuySDK.Storefront.buildQuery(inContext: .init(country: Client.shared.getCurrencyCodeVal(),language:Client.shared.getLanguageCode()))  { $0
          
      .products(first: Int32(limit), after: cursor, reverse: reverse, sortKey:sortKey, query: query){ $0
          
        .fragmentForStandardProduct()
      }
    }
  }
    
  //-----------------------------------
  // MARK: - Order -
  //
  static func queryForOrders(of customerToken: String, limit: Int, after cursor: String? = nil)-> MobileBuySDK.Storefront.QueryRootQuery {
      return MobileBuySDK.Storefront.buildQuery(inContext: .init(country: Client.shared.getCurrencyCodeVal(),language:Client.shared.getLanguageCode()))  {$0
      .customer(customerAccessToken: customerToken, {$0
        .orders(first: Int32(limit), after: cursor,reverse: true){$0
          .fragmentForStandardOrder()
        }
      })
    }
  }
  
  // ----------------------------------
  //  MARK: - Checkout -
  //
 
    static func mutationForCreateCart(with cartItems : [CartDetail],custom:[MobileBuySDK.Storefront.AttributeInput]?=nil,discountCode:String="",cartNote:String="") -> MobileBuySDK.Storefront.MutationQuery {
        let currentCurrencyCode = Client.shared.getCurrencyCodeVal()
        let lineItems = cartItems.map { item in
            MobileBuySDK.Storefront.CartLineInput.create(merchandiseId: GraphQL.ID(rawValue: item.variant.id),
                                            attributes: .init(orNull: nil),
                                            quantity: .value(Int32(item.qty)),
                                            sellingPlanId: item.sellingPlanId != "" ? .value(GraphQL.ID(rawValue: item.sellingPlanId)) : .init(orNull: nil))
        }

        let cartInput = MobileBuySDK.Storefront.CartInput.create(attributes: .value(custom),
                                                    lines: .value(lineItems),
                                                    discountCodes: .value([discountCode]),
                                                    note: .value(cartNote),

                                                    buyerIdentity: .value(MobileBuySDK.Storefront.CartBuyerIdentityInput.create(countryCode: .value(currentCurrencyCode))))
        
        return MobileBuySDK.Storefront.buildMutation(inContext: .init(country: currentCurrencyCode)) { $0
                .cartCreate(input: cartInput) { $0
                .cart{ $0
                .id()
                .checkoutUrl()
                .attributes({ $0
                .key()
                .value()
                })
              /*  .discountAllocations { $0
                .discountedAmount { $0
                .amount()
                }
                .onCartCodeDiscountAllocation { $0
                .discountedAmount { $0
                .amount()
                }
                }
                .onCartCustomDiscountAllocation{ $0
                .discountedAmount { $0
                .amount()
                }
                }
                .onCartAutomaticDiscountAllocation{ $0
                .discountedAmount { $0
                .amount()
                }
                }
                }*/
                .cost { $0
                .totalAmount { $0
                .amount()
                .currencyCode()
                  }
                .subtotalAmount { $0
                .amount()
                .currencyCode()
                  }
                .totalTaxAmount { $0
                .amount()
                .currencyCode()
                  }
                .totalDutyAmount { $0
                .amount()
                .currencyCode()
                  }
                }
                .lines(first : 250) {$0
                .edges { $0
                .node{ $0
                .id()
                .quantity()
                
                .merchandise { $0
                
                .onProductVariant{ $0
                .id()
                .title()
                .quantityAvailable()
                .currentlyNotInStock()
                .price { $0
                .currencyCode()
                .amount()
                }
                .image( { $0
                .url()
                })
                .product { $0
                .id()
                .title()
                    
                }
                }
                }
                .sellingPlanAllocation { $0
                .sellingPlan { $0
                .id()
                .name()
                }
                .priceAdjustments{ $0
                .price{ $0
                .amount()
                }
                .compareAtPrice { $0
                .amount()
                }
                .perDeliveryPrice { $0
                .amount()
                }
                }
                }
                .quantity()
                }
                }
                }
                }
                .userErrors { $0
                .field()
                .message()
                }
                }
        }
    }
    
    
    static func mutationForCreateCheckout(with cartItems: [CartDetail],custom:[MobileBuySDK.Storefront.AttributeInput]? = nil,productInput:[MobileBuySDK.Storefront.AttributeInput]? = nil) -> MobileBuySDK.Storefront.MutationQuery {
        let lineItems = cartItems.map { item in
            MobileBuySDK.Storefront.CheckoutLineItemInput.create(quantity: Int32(item.qty), variantId: GraphQL.ID(rawValue: item.variant.id),customAttributes: .value(productInput))
        }
        
        let currentCurrencyCode = Client.shared.getCurrencyCodeVal()
 
        let checkoutInput = MobileBuySDK.Storefront.CheckoutCreateInput.create(
            lineItems: .value(lineItems), customAttributes: .value(custom),
            allowPartialAddresses: .value(true),
            buyerIdentity: .value(MobileBuySDK.Storefront.CheckoutBuyerIdentityInput(countryCode: currentCurrencyCode))
        )
        
        return MobileBuySDK.Storefront.buildMutation(inContext: .init(country: currentCurrencyCode)) { $0
            .checkoutCreate(input: checkoutInput) { $0
                .checkout { $0
                    .fragmentForCheckout()
                    .appliedGiftCards{$0
                        .id()
                    }
                }
                .checkoutUserErrors{$0
                    .field()
                    .message()
                }
            }
        }
  }
    
//    static func mutationForGetCheckoutByID(with checkout : GraphQL.ID) -> MobileBuySDK.Storefront.MutationQuery {
//        let currentCurrencyCode = Client.shared.getCurrencyCodeVal()
//        return MobileBuySDK.Storefront.buildMutation(inContext: .init(country: currentCurrencyCode)) { $0
//                .chec
//
//
//        }
//    }
  
  
  // ----------------------------------
  //  MARK: - ForgotPassword -
  //
  static func mutationForForgetPassword(with email: String)-> MobileBuySDK.Storefront.MutationQuery
  {
      return MobileBuySDK.Storefront.buildMutation(inContext: .init(country: Client.shared.getCurrencyCodeVal(),language: Client.shared.getLanguageCode())) { $0
      .customerRecover(email: email){ $0
        .customerUserErrors{$0
          .message()
          .field()
        }
        
      }
    }
  }
  
  // -----------------------------------
  // MARK : - RenewToken -
  //
  
  static func mutationForRenewToken(accessToken:String)->MobileBuySDK.Storefront.MutationQuery {
    return MobileBuySDK.Storefront.buildMutation(inContext: .init(country: Client.shared.getCurrencyCodeVal())) {$0
      .customerAccessTokenRenew(customerAccessToken: accessToken){$0
        .customerAccessToken{$0
          .accessToken()
          .expiresAt()
        }
        .userErrors{$0
          .field()
          .message()
        }
      }
    }
  }
  
  // ----------------------------------
  //  MARK: - Navigation Menu query -
  //
  
  static func queryForNavigationMenu()->MobileBuySDK.Storefront.QueryRootQuery{
    return MobileBuySDK.Storefront.buildQuery(inContext: .init(country: Client.shared.getCurrencyCodeVal(), language: Client.shared.getLanguageCode())) { $0
      
        .menu(handle: "main-menu") { $0
            .items { $0
            .fragmentForMenuItemQuery()
              .items { $0
              .fragmentForMenuItemQuery()
                .items { $0
                .fragmentForMenuItemQuery()
                  .items { $0
                  .fragmentForMenuItemQuery()
                    .items { $0
                    .fragmentForMenuItemQuery()
                      .items { $0
                      .fragmentForMenuItemQuery()
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  
  
  // ----------------------------------
  //  MARK: - Available Languages Query -
  //
  static func queryForAvailableLanguage()->MobileBuySDK.Storefront.QueryRootQuery
  {
    
    return MobileBuySDK.Storefront.buildQuery(inContext: .init(country: Client.shared.getCurrencyCodeVal(), language: Client.shared.getLanguageCode())) { $0
          .localization { $0
            .language{ $0
            .name()
            .isoCode()
        }
          // For the current country
          .availableLanguages { $0
            .isoCode()
            .endonymName()
            .name()
        }
          // For the non current country
          .availableCountries{ $0
            .isoCode()
            .name()
          }
        }
      }
    }

  
  //END
  
  //Apply discountCode Query
  static func mutationForApplyCopounCode(_ discountCode: String, to checkoutID: String)->MobileBuySDK.Storefront.MutationQuery{
    let id = GraphQL.ID(rawValue: checkoutID)
    return MobileBuySDK.Storefront.buildMutation(inContext: .init( country: Client.shared.getCurrencyCodeVal())) { $0
        
      .checkoutDiscountCodeApplyV2(discountCode: discountCode, checkoutId: id){$0
      .checkoutUserErrors{$0
      .code()
      .field()
      .message()
      }
        .checkout { $0
          .fragmentForCheckout()
          .appliedGiftCards{$0
            .id()
          }
        }
      }
    }
  }
  
  //Remove discountCode Query
  static func mutationForRemoveCopounCode(to checkoutID: String)->MobileBuySDK.Storefront.MutationQuery{
    let id = GraphQL.ID(rawValue: checkoutID)
    return MobileBuySDK.Storefront.buildMutation(inContext: .init( country: Client.shared.getCurrencyCodeVal())) { $0
      .checkoutDiscountCodeRemove(checkoutId: id){$0
        .checkoutUserErrors{$0
          .field()
          .message()
        }
        .checkout { $0
          .fragmentForCheckout()
          .appliedGiftCards{$0
            .id()
          }
        }
      }
    }
  }
  
  //Apply GiftCard Query
  static func mutationForApplyGiftCardCode(_ discountCode: [String], to checkoutID: String)->MobileBuySDK.Storefront.MutationQuery{
    let id = GraphQL.ID(rawValue: checkoutID)
    return MobileBuySDK.Storefront.buildMutation(inContext: .init(country: Client.shared.getCurrencyCodeVal())) { $0
      .checkoutGiftCardsAppend(giftCardCodes: discountCode, checkoutId: id) { $0
        .checkoutUserErrors { $0
          .field()
          .message()
        }
        .checkout { $0
          .fragmentForCheckout()
          .appliedGiftCards{$0
            .id()
          }
          
        }
      }
    }
    
  }
  
  //Remove GiftCard Query
  static func mutationForRemoveGiftCardCode(_ discountCode: GraphQL.ID, to checkoutID: String)->MobileBuySDK.Storefront.MutationQuery{
    let id = GraphQL.ID(rawValue: checkoutID)
    return MobileBuySDK.Storefront.buildMutation(inContext: .init(country: Client.shared.getCurrencyCodeVal())) { $0
      .checkoutGiftCardRemoveV2(appliedGiftCardId: discountCode, checkoutId: id){$0
        .checkoutUserErrors { $0
          .field()
          .message()
        }
        .checkout { $0
          .appliedGiftCards{$0
            .id()
          }
          .fragmentForCheckout()
        }
      }
      
    }
    
  }
  
  
  //---------------------------------
  // Mark : - Fetch Customer Details
  static func queryForCustomer(accessToken:String)->MobileBuySDK.Storefront.QueryRootQuery{
    return MobileBuySDK.Storefront.buildQuery(inContext: .init(country: Client.shared.getCurrencyCodeVal(),language: Client.shared.getLanguageCode())){$0
      .customer(customerAccessToken: accessToken){$0
        .firstName()
        .lastName()
        .email()
        .displayName()
        .id()
        .createdAt()
        .tags()
        
      }
      
    }
  }
  
  
  //---------------------------------
  // Mark : - Fetch Customer Addresses Details
  static func queryForAddress(accessToken:String,limit: Int, after cursor: String? = nil)->MobileBuySDK.Storefront.QueryRootQuery{
    return MobileBuySDK.Storefront.buildQuery(inContext: .init(country: Client.shared.getCurrencyCodeVal(),language:Client.shared.getLanguageCode())){$0
      .customer(customerAccessToken: accessToken){$0
        .addresses(first: Int32(limit), after: cursor){$0
          .fragmentForStandardAddress()
        }
        
      }
    }
  }
  
  //---------------------------------
  // Mark : - Fetch Shop Details
  //
    static func queryForShop()->MobileBuySDK.Storefront.QueryRootQuery{
        return MobileBuySDK.Storefront.buildQuery() { $0
            
                .localization{$0
                .language{ $0
                .name()
                .isoCode()
                }
                
                .availableCountries{$0
                .currency{$0
                .isoCode()
                .name()
                .symbol()
                }
                .isoCode()
                .name()
                .unitSystem()
                }
                }
                .shop { $0
                .name()
                
                .privacyPolicy{$0
                .title()
                .url()
                }
                .termsOfService{$0
                .title()
                .url()
                }
                .refundPolicy{ $0
                .url()
                .title()
                }
                .paymentSettings{$0
                .currencyCode()
                .enabledPresentmentCurrencies()
                .countryCode()
                .cardVaultUrl()
                    
                }
                    
                }
        }
    }
  // ----------------------------------
  //  MARK: - Shop blog query -
  //
  
  static func queryForShopBlog()->MobileBuySDK.Storefront.QueryRootQuery{
    return MobileBuySDK.Storefront.buildQuery() { $0
        .blogs(first: 250){$0
            .pageInfo { $0
              .hasNextPage()
            }
            .edges{$0
                .cursor()
                .node{$0
                    .handle()
                    .onlineStoreUrl()
                    .title()
                    .authors{$0
                        .name()
                    }
                    
                }
            }
        }
    }
  }
  
  //---------------------------------
  // Mark : - Fetch Shop Details
  //
  static func queryForAllShopProducts(with sortKey:MobileBuySDK.Storefront.ProductSortKeys? = nil,reverse:Bool?=nil, limit: Int, after cursor: String? = nil)->MobileBuySDK.Storefront.QueryRootQuery{
    return MobileBuySDK.Storefront.buildQuery(inContext: .init(country: Client.shared.getCurrencyCodeVal(),language:Client.shared.getLanguageCode())) { $0
    
      .products(first: Int32(limit), after: cursor,reverse: reverse,sortKey:sortKey
      ){
        $0.fragmentForStandardProduct()
      }
    }
  }
  
  
  //---------------------------------
  // Mark : - Customer Add Address
  //
  static func customerAddAddressQuery(accessToken:String,address:[String:String])->MobileBuySDK.Storefront.MutationQuery{
    
    let addressInput = MobileBuySDK.Storefront.MailingAddressInput.create(address1: Input(orNull:address["address1"]), address2: Input(orNull:address["address2"]), city: Input(orNull:address["city"]), country: Input(orNull:address["country"]), firstName: Input(orNull:address["firstName"]), lastName: Input(orNull:address["lastName"]), phone: Input(orNull:address["phone"]), province: Input(orNull:address["province"]), zip: Input(orNull:address["zip"]))
    
    return MobileBuySDK.Storefront.buildMutation(inContext: .init(country: Client.shared.getCurrencyCodeVal())) {$0
      .customerAddressCreate(customerAccessToken: accessToken, address: addressInput){$0
        .customerUserErrors{$0
          .field()
          .message()
        }
        
        .customerAddress{$0
          .fragmentForStandardMailAddress()
        }
      }
    }
  }
    
    static func customerUpdateAddressQuery(accessToken:String,addressId:GraphQL.ID,address:[String:String])->MobileBuySDK.Storefront.MutationQuery{
            
            let addressInput = MobileBuySDK.Storefront.MailingAddressInput.create(address1: Input(orNull:address["address1"]), address2: Input(orNull:address["address2"]), city: Input(orNull:address["city"]), country: Input(orNull:address["country"]), firstName: Input(orNull:address["firstName"]), lastName: Input(orNull:address["lastName"]), phone: Input(orNull:address["phone"]), province: Input(orNull:address["province"]), zip: Input(orNull:address["zip"]))
            
            return MobileBuySDK.Storefront.buildMutation{$0
                .customerAddressUpdate(customerAccessToken: accessToken, id: addressId, address: addressInput){$0
                    .customerAddress{$0
                        .fragmentForStandardMailAddress()
                    }
                    .customerUserErrors{$0
                        .field()
                        .message()
                    }
                }
            }
        }
        
  
  
  //---------------------------------
  //MARK : - Customer Delete Address
  //
  static func customerDeleteAddress(addressId:GraphQL.ID?,with token:String)->MobileBuySDK.Storefront.MutationQuery{
    return MobileBuySDK.Storefront.buildMutation(inContext: .init(country: Client.shared.getCurrencyCodeVal())){$0
      .customerAddressDelete(id: addressId!, customerAccessToken: token){$0
        .customerUserErrors{$0
          .field()
          .message()
        }
        .deletedCustomerAddressId()
        
      }
      
    }
  }
    
    
    
    
  
  static func customerUpdateDetails(accessToken:String,email:String,password:String,firstName:String,lastName:String)->MobileBuySDK.Storefront.MutationQuery{
    
    let customer = MobileBuySDK.Storefront.CustomerUpdateInput.create(firstName: Input(orNull: firstName), lastName: Input(orNull: lastName), email: Input(orNull:email))
    if password != "" {
      customer.password = Input(orNull:password)
    }
    return MobileBuySDK.Storefront.buildMutation(inContext: .init(country: Client.shared.getCurrencyCodeVal(),language: Client.shared.getLanguageCode())){ $0
      .customerUpdate(customerAccessToken: accessToken, customer: customer){ $0
        .customer{ $0
            .tags()
          .firstName()
          .lastName()
          .email()
          .displayName()
          .id()
          .createdAt()
        }
        .customerUserErrors{ $0
          .message()
          .field()
          
        }
        
      }
    }
  }
  
  static func mutationForUpdateCheckout(_ id: String, updatingPartialShippingAddress address: PayPostalAddress) -> MobileBuySDK.Storefront.MutationQuery {
    
    let checkoutID   = GraphQL.ID(rawValue: id)
    let addressInput = MobileBuySDK.Storefront.MailingAddressInput.create(
      city:     address.city.orNull,
      country:  address.country.orNull,
      province: address.province.orNull,
      zip:      address.zip.orNull
    )
    
    return MobileBuySDK.Storefront.buildMutation(inContext: .init(country: Client.shared.getCurrencyCodeVal())) { $0
      .checkoutShippingAddressUpdateV2(shippingAddress: addressInput, checkoutId: checkoutID) { $0
        .checkoutUserErrors { $0
          .field()
          .message()
        }
        .checkout { $0
          .fragmentForCheckout()
          .appliedGiftCards{$0
            .id()
          }
        }
      }
    }
  }
  
  static func mutationForUpdateCheckout(_ id: String, updatingCompleteShippingAddress address: PayAddress) -> MobileBuySDK.Storefront.MutationQuery {
    
    let checkoutID   = GraphQL.ID(rawValue: id)
    let addressInput = MobileBuySDK.Storefront.MailingAddressInput.create(
      address1:  address.addressLine1.orNull,
      address2:  address.addressLine2.orNull,
      city:      address.city.orNull,
      country:   address.country.orNull,
      firstName: address.firstName.orNull,
      lastName:  address.lastName.orNull,
      phone:     address.phone.orNull,
      province:  address.province.orNull,
      zip:       address.zip.orNull
    )
    
    return MobileBuySDK.Storefront.buildMutation(inContext: .init(country: Client.shared.getCurrencyCodeVal())) { $0
      .checkoutShippingAddressUpdateV2(shippingAddress: addressInput, checkoutId: checkoutID) { $0
        .checkoutUserErrors { $0
          .field()
          .message()
        }
        .checkout { $0
          .fragmentForCheckout()
          .appliedGiftCards{$0
            .id()
          }
        }
      }
    }
  }
  
  static func mutationForUpdateCheckout(_ id: String, updatingShippingRate shippingRate: PayShippingRate) -> MobileBuySDK.Storefront.MutationQuery {
    
    return MobileBuySDK.Storefront.buildMutation(inContext: .init(country: Client.shared.getCurrencyCodeVal())) { $0
      .checkoutShippingLineUpdate(checkoutId: GraphQL.ID(rawValue: id), shippingRateHandle: shippingRate.handle) { $0
        .checkoutUserErrors { $0
          .field()
          .message()
        }
        .checkout { $0
          .fragmentForCheckout()
          .appliedGiftCards{$0
            .id()
          }
        }
      }
    }
  }
  
  static func mutationForUpdateCheckout(_ id: String, updatingEmail email: String) -> MobileBuySDK.Storefront.MutationQuery {
    
    return MobileBuySDK.Storefront.buildMutation(inContext: .init(country: Client.shared.getCurrencyCodeVal())) { $0
      .checkoutEmailUpdateV2(checkoutId: GraphQL.ID(rawValue: id), email: email) { $0
        .checkoutUserErrors { $0
          .field()
          .message()
        }
        .checkout { $0
          .fragmentForCheckout()
          .appliedGiftCards{$0
            .id()
          }
        }
      }
    }
  }
  
  static func mutationForCompleteCheckoutUsingApplePay(_ checkout: PayCheckout, billingAddress: PayAddress, token: String, idempotencyToken: String) -> MobileBuySDK.Storefront.MutationQuery {
    
    let mailingAddress = MobileBuySDK.Storefront.MailingAddressInput.create(
      address1:  billingAddress.addressLine1.orNull,
      address2:  billingAddress.addressLine2.orNull,
      city:      billingAddress.city.orNull,
      country:   billingAddress.country.orNull,
      firstName: billingAddress.firstName.orNull,
      lastName:  billingAddress.lastName.orNull,
      province:  billingAddress.province.orNull,
      zip:       billingAddress.zip.orNull
    )
    
    let paymentInput = MobileBuySDK.Storefront.TokenizedPaymentInputV3.create(
      paymentAmount:     MobileBuySDK.Storefront.MoneyInput(amount: checkout.paymentDue, currencyCode: MobileBuySDK.Storefront.CurrencyCode(rawValue: checkout.currencyCode)!),
      idempotencyKey: idempotencyToken,
      billingAddress: mailingAddress,
      paymentData:    token, type: .applePay
    )
    
    return MobileBuySDK.Storefront.buildMutation(inContext: .init(country: Client.shared.getCurrencyCodeVal())) { $0
      
      .checkoutCompleteWithTokenizedPaymentV3(checkoutId: GraphQL.ID(rawValue: checkout.id), payment: paymentInput) { $0
        .checkoutUserErrors{$0
          .field()
          .message()
        }
        .payment { $0
          .fragmentForPayment()
        }
      }
    }
  }
  
  static func queryForPayment(_ id: String) -> MobileBuySDK.Storefront.QueryRootQuery {
    return MobileBuySDK.Storefront.buildQuery(inContext: .init(country: Client.shared.getCurrencyCodeVal())) { $0
      .node(id: GraphQL.ID(rawValue: id)) { $0
        .onPayment { $0
          .fragmentForPayment()
        }
      }
    }
  }
  
  static func queryShippingRatesForCheckout(_ id: String) -> MobileBuySDK.Storefront.QueryRootQuery {
    
    return MobileBuySDK.Storefront.buildQuery(inContext: .init(country: Client.shared.getCurrencyCodeVal())) { $0
      .node(id: GraphQL.ID(rawValue: id)) { $0
        .onCheckout { $0
          .fragmentForCheckout()
          .appliedGiftCards{$0
            .id()
          }
          .availableShippingRates { $0
            .ready()
            .shippingRates { $0
              .handle()
              .price{$0
                .amount()
              }
              
              .title()
            }
          }
        }
      }
    }
  }
  
}
