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
class WishlistManager {
  static let shared = WishlistManager()
  private let backQueue    = DispatchQueue(label: "com.magenative.Queue")
  private var saveWish     = false
  
  var customerID           : String?
  var customerEmail        : String?
  
  private var wishURL: URL = {
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    let documentsURL  = URL(fileURLWithPath: documentsPath)
    let cartURL       = documentsURL.appendingPathComponent("\(Client.shopUrl)wishnew1.json")
    return cartURL
  }()
  // ----------------------------------
  //  MARK: - Number of items in wishlist -
  //
  var wishCount: Int {
    if let wishlistProducts = DBManager.shared.wishlistProducts{
      return wishlistProducts.reduce(0) {
        $0 + $1.qty
      }
    }
    else{
      return 0
    }
  }
  // ----------------------------------
  //  MARK: - Get details of wishlisht items -
  //
  func readWishList(completion: @escaping ([ProductViewModel]?) -> Void) {
    if let wishlistProducts = DBManager.shared.wishlistProducts{
        let ids = wishlistProducts.compactMap{GraphQL.ID(rawValue: $0.id)}
      Client.shared.fetchMultiProducts(ids: ids, completion: { (response, error) in
        if let response = response {
          completion(response)
        }else {
          completion(nil)
        }
      })
    }
  }
  
  // ----------------------------------
  //  MARK: - Get wishlist product by the id of product -
  //
  func fetchWishProduct(id: String) -> [WishlistDetail]{
    return (DBManager.shared.wishlistProducts?.filter{$0.id == id})!
  }
  
  // ----------------------------------
  //  MARK: - Clear wishlist -
  //
  func clearWishlist(){
    DBManager.shared.clearWishlistData()
  }
  
  // ----------------------------------
  //  MARK: - Make the VariantDetail structure from variant -
  //
  func getVariant(_ variants: VariantViewModel)->VariantDetail{
    let variant = VariantDetail()
    variant.id = variants.id
    variant.title = variants.title
    variant.imageUrl = variants.image?.absoluteString ?? ""
    return variant
  }
  
  // ----------------------------------
  //  MARK: - Remove the product from wishlist -
  //
  func removeFromWishList(_ product:CartProduct){
    if let _ = DBManager.shared.wishlistProducts{
      DBManager.shared.removeWishlist(product: product)
    }
    if customAppSettings.sharedInstance.flitsIntegration{
      getCustomerID { val in
        if val{
          self.flitsRemoveFromWishlist(productHandle: product.productModel?.handle, productID: product.productModel?.id)
        }
      }
    }
  }
  // ----------------------------------
  //  MARK: - Add to wishlist -
  //
  func addToWishList(_ product:CartProduct,id: String? = "", title
                     : String? = "",price: String? = ""){
    
      DBManager.shared.addToWishlist(product: product, id: id, title: title)
      if let productModel = product.productModel{
          let params : [AppEvents.ParameterName:Any] = [AppEvents.ParameterName.content:productModel.title, AppEvents.ParameterName.contentType:productModel.price]
                AppEvents.shared.logEvent(.addedToWishlist, parameters: params)
       
        Analytics.logEvent(AnalyticsEventAddToWishlist, parameters: [AnalyticsParameterItemID: "id-\(productModel.id)",
                           AnalyticsParameterItemName: productModel.title,
                           AnalyticsParameterPrice: productModel.price])
      }
      else{
          let params : [AppEvents.ParameterName:Any] = [AppEvents.ParameterName.content:title!, AppEvents.ParameterName.contentType:price!]
                AppEvents.shared.logEvent(.addedToWishlist, parameters: params)
       
        Analytics.logEvent(AnalyticsEventAddToWishlist, parameters: [AnalyticsParameterItemID: "id-\(id!)",
                           AnalyticsParameterItemName: title!,
                           AnalyticsParameterPrice: price!])
      }
    if customAppSettings.sharedInstance.flitsIntegration{
      getCustomerID { val in
        if val{
          self.flitsAddToWishlist(productHandle: product.productModel?.handle, productID: product.productModel?.id)
        }
      }
    }
  }
  
  // ----------------------------------
  //  MARK: - Check if product is in wishlist -
  //
  func isProductinWishlist(product:ProductViewModel) -> Bool{
    if let wishlistProducts = DBManager.shared.wishlistProducts{
      return wishlistProducts.contains(where: {$0.id == product.id})
    }
    else{
      return false;
    }
  }
    
    func isProductVariantinWishlist(product:CartProduct) -> Bool {
        let variantID = product.variant.id
        if let wishlistProducts = DBManager.shared.wishlistProducts{
            return wishlistProducts.contains(where: {$0.variant.id == variantID})
        }
        else{
          return false;
        }
    }

  // MARK :- Flits
  
  func flitsAddToWishlist(productHandle:String?,productID:String?){
    guard let productID = productID, let productHandle = productHandle else {
      return
    }

    let params = ["customer_id": self.customerID ?? "",
                  "customer_email": self.customerEmail ?? "",
                  "product_id": productID.components(separatedBy: "/").last ?? "",
                  "product_handle": productHandle,
                  "wsl_product_count": "1"]
    
    print("params$$",params)
      Networking.shared.sendRequestUpdated(api: "https://app.getflits.com/api/1/\(Client.flitsUserId)/wishlist/add_to_wishlist?token=\(Client.flitsToken)", type: .POST, params: params, includePureURLString: true) { (result) in
      switch result{
      case .success(let data):
        do{
          let json                     = try JSON(data: data)
          print("flitsAddToWishlist ==",json)
        }catch let error {
          print(error)
        }
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func flitsRemoveFromWishlist(productHandle:String?,productID:String?){
    guard let productID = productID, let productHandle = productHandle else {
      return
    }
    
    let params = ["customer_id": self.customerID ?? "",
                  "customer_email": self.customerEmail ?? "",
                  "product_id": productID.components(separatedBy: "/").last ?? "",
                  "product_handle": productHandle,
                  "wsl_product_count": "1"]
    
    print("params$$",params)
    Networking.shared.sendRequestUpdated(api: "https://app.getflits.com/api/1/\(Client.flitsUserId)/wishlist/remove_from_wishlist?token=\(Client.flitsToken)", type: .DELETE, params: params, includePureURLString: true) { (result) in
      switch result{
      case .success(let data):
        do{
          let json                     = try JSON(data: data)
          print("flitsRemoveFromWishlist ==",json)
        }catch let error {
          print(error)
        }
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func getCustomerID(completion:@escaping(Bool)->()){
    if Client.shared.isAppLogin(){
    Client.shared.fetchCustomerDetails(completeion: {
      response,error   in
      if let response = response {
        self.customerEmail = response.email
        self.customerID    = response.customerId?.components(separatedBy: "/").last ?? ""
        completion(true)
      }
    })
    }else{
      completion(false)
    }
  }
  
  //END
}
