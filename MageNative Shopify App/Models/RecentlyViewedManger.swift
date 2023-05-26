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

/*class recentlyViewedManager {
 static let shared = recentlyViewedManager()
 
 var recentlyViewedProduct : [ProductViewModel] = []
 
 private let backQueue    = DispatchQueue(label: "com.magenative.Queue")
 private var saveWish = false
 private var wishURL: URL = {
 let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
 let documentsURL  = URL(fileURLWithPath: documentsPath)
 let cartURL       = documentsURL.appendingPathComponent("\(Client.shopUrl)recentlyviewnew2.json")
 return cartURL
 }()
 
 
 
 private init() {
 self.readRecentlyViewed{ items in
 if let items = items {
 self.recentlyViewedProduct = items
 }
 }
 }
 
 private func saveWishData() {
 let serializedItems = self.recentlyViewedProduct.serialize()
 self.backQueue.async {
 do {
 let data = try JSONSerialization.data(withJSONObject: serializedItems, options: [])
 try data.write(to: self.wishURL, options: [.atomic])
 
 
 } catch let error {
 print("\(error)")
 }
 
 DispatchQueue.main.async {
 self.saveWish = false
 }
 }
 }
 
 
 private func readRecentlyViewed(completion: @escaping ([ProductViewModel]?) -> Void) {
 self.backQueue.async {
 do {
 let data            = try Data(contentsOf: self.wishURL)
 let serializedItems = try JSONSerialization.jsonObject(with: data, options: [])
 
 let recentlyView = [ProductViewModel].deserialize(from: serializedItems as! [SerializedRepresentation])
 DispatchQueue.main.async {
 completion(recentlyView)
 }
 
 } catch let error {
 print("Failed to load cart from disk: \(error)")
 DispatchQueue.main.async {
 completion(nil)
 }
 }
 }
 }
 
 
 func clearAll(){
 self.recentlyViewedProduct = []
 self.saveWishData()
 }
 
 func addtoRecentlyViewed(_ product:ProductViewModel){
 if self.recentlyViewedProduct.count >= 10 {
 self.recentlyViewedProduct.removeFirst()
 if getIndexOfproduct(product) ==  nil {
 self.recentlyViewedProduct.append(product)
 }
 }else {
 if getIndexOfproduct(product) ==  nil {
 self.recentlyViewedProduct.append(product)
 }
 
 
 
 }
 self.saveWishData()
 }
 
 func getIndexOfproduct(_ product:ProductViewModel) ->Int?{
 return  self.recentlyViewedProduct.firstIndex(where: {$0.id == product.id})
 }
 }*/
