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
import SwiftUI

class ProductViewModel: ViewModel {
  typealias ModelType = MobileBuySDK.Storefront.Product
  
  let model : ModelType?
  let id:       String
  let title:    String
  let summary:  String
    let description : String?
  var price:    String
  var compareAtPrice:String
  let images:   PageableArray<ImageViewModel>
  let variants: PageableArray<VariantViewModel>
  let onlineStoreUrl:URL?
  let media: PageableArray<ProductMediaViewModel>?
  let totalInventory:String
  let tag : [String]
  let handle:String
  let vendor : String
  
 
  var availableForSale:Bool
    var currencyCode : String
    var optionsIds : [String]
    var optionNames : [String]
    var optionValues : [String]
    var requiresSellingPlan : Bool
    var sellingPlanGroupNames : [String]?
    var sellingPlansGroups : PageableArray<ProductSellingPlanGroupModel>
    var collections : PageableArray<CollectionViewModel>
    
  // ----------------------------------
  //  MARK: - Init -
  //
  required init(from model: ModelType) {
    self.model    = model
    
    
    let variants = model.variants.edges.viewModels.sorted {
      $0.price < $1.price
    }
      self.currencyCode = model.variants.edges.first?.node.price.currencyCode.rawValue ?? ""
      CurrencyCode.shared.saveCurrencyCode(code: self.currencyCode)
    let lowestPrice = variants.first?.price
    self.id       = model.id.rawValue
    self.title    = model.title
    self.summary  = model.descriptionHtml
      self.description = model.description
    self.price    = lowestPrice == nil ? "false" : Currency.stringFrom(lowestPrice!)
    self.onlineStoreUrl = model.onlineStoreUrl
    self.totalInventory = model.totalInventory?.description ?? ""
    self.handle = model.handle
    self.vendor = model.vendor
    self.tag = model.tags
    
    self.availableForSale = model.availableForSale
    self.images   = PageableArray(
      with:     model.images.edges,
      pageInfo: model.images.pageInfo
    )
    let specialPrice = variants.first?.compareAtPrice
    self.compareAtPrice = specialPrice == nil ? "false" : ( lowestPrice! < specialPrice! ? Currency.stringFrom(specialPrice!) : "false" )
    
    self.variants = PageableArray(
      with:     model.variants.edges,
      pageInfo: model.variants.pageInfo
    )
    //self.variants = self.variants.items.filter{}
    self.media = PageableArray(
      with:     model.media.edges,
      pageInfo: model.media.pageInfo
    )
      self.optionsIds = [String]()
      self.optionNames = [String]()
      self.optionValues = [String]()
      for itm in model.options {
          self.optionsIds.append(itm.id.rawValue)
          self.optionNames.append(itm.name)
          self.optionValues = itm.values
      }
      self.requiresSellingPlan = model.requiresSellingPlan   //PRODUCT CAN BE PURCHASED ONLY AS A PART OF SELLING PLAN
      self.sellingPlansGroups = PageableArray(
        with: model.sellingPlanGroups.edges,
        pageInfo: model.sellingPlanGroups.pageInfo)
      self.collections = PageableArray(with: model.collections.edges, pageInfo: model.collections.pageInfo)
      
//          for items in 0..<model.sellingPlanGroups.edges.count + 1{
//              let itm = model.sellingPlanGroups.edges[items]
//              itm.node.name = "One Time Purchase"
//          }
        
     
//      for itms in model.sellingPlanGroups.edges {
//          self.sellingPlanGroupNames?.append(itms.node.name)
//
//      }
  }
}

extension MobileBuySDK.Storefront.Product: ViewModeling {
  typealias ViewModelType = ProductViewModel
}
