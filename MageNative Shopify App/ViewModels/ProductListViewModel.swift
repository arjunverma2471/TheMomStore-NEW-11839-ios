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

class ProductListViewModel: ViewModel {
  
  
  typealias ModelType = MobileBuySDK.Storefront.ProductEdge
  let productModel:MobileBuySDK.Storefront.Product.ViewModelType?
  let cursor:   String?
  let model : ModelType?
  let id:       String
  let title:    String
  let summary:  String
  let price:    String
  let compareAtPrice:String
  let images:   PageableArray<ImageViewModel>
  let variants: PageableArray<VariantViewModel>
  let onlineStoreUrl:URL?
  let media: PageableArray<ProductMediaViewModel>?
  let availableForSale:Bool
    var requiresSellingPlan : Bool
    var sellingPlansGroups : PageableArray<ProductSellingPlanGroupModel>
    var collections : PageableArray<CollectionViewModel>
  
  // ----------------------------------
  //  MARK: - Init -
  //
  required init(from model: ModelType) {
    
    self.model    = model
    self.cursor   = model.cursor
    self.productModel = nil
    let variants = model.node.variants.edges.viewModels.sorted {
      $0.price < $1.price
    }
    let currency = model.node.variants.edges.first?.node.price.currencyCode.rawValue ?? ""
    CurrencyCode.shared.saveCurrencyCode(code: currency)
    let lowestPrice = variants.first?.price
    self.id       = model.node.id.rawValue
    self.title    = model.node.title
    self.summary  = model.node.descriptionHtml
    self.price    = lowestPrice == nil ? "false" : Currency.stringFrom(lowestPrice!)
    self.onlineStoreUrl = model.node.onlineStoreUrl
    self.availableForSale = model.node.availableForSale
    self.images   = PageableArray(
      with:     model.node.images.edges,
      pageInfo: model.node.images.pageInfo
    )
      
    let compareAtprice = variants.first?.compareAtPrice
    self.compareAtPrice = compareAtprice == nil ? "false" : Currency.stringFrom(compareAtprice!)
    
    self.variants = PageableArray(
      with:     model.node.variants.edges,
      pageInfo: model.node.variants.pageInfo
    )
    print("--model--\(model.node.media.edges)")
    self.media = PageableArray(
      with:     model.node.media.edges,
      pageInfo: model.node.media.pageInfo
    )
      self.requiresSellingPlan = model.node.requiresSellingPlan   //PRODUCT CAN BE PURCHASED ONLY AS A PART OF SELLING PLAN
      self.sellingPlansGroups = PageableArray(
        with: model.node.sellingPlanGroups.edges,
        pageInfo: model.node.sellingPlanGroups.pageInfo)
      
      self.collections = PageableArray(with: model.node.collections.edges, pageInfo: model.node.collections.pageInfo)
    
  }
  
  // ----------------------------------
  //  MARK: - Init -
  //
  init(from model:ProductViewModel) {
    self.cursor = "Null"
    self.productModel = model
    self.model = nil
    self.id       = model.id
    self.title    = model.title
    self.summary  = model.summary
    self.price    =  model.price
    self.onlineStoreUrl = model.onlineStoreUrl
    
    self.images   = model.images
    self.compareAtPrice = model.compareAtPrice
    
    self.variants = model.variants
    self.media = model.media
    self.availableForSale = model.availableForSale
      self.requiresSellingPlan=model.requiresSellingPlan
      self.sellingPlansGroups=model.sellingPlansGroups
      self.collections = model.collections
  }
  
  
}

extension MobileBuySDK.Storefront.ProductEdge: ViewModeling {
  typealias ViewModelType = ProductListViewModel
}
