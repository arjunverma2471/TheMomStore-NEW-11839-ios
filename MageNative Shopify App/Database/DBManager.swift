//
//  DBManager.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 01/02/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import Foundation
import RealmSwift

class CartDetail: Object{
    @objc dynamic var qty: Int = 0
    @objc dynamic var id: String = ""
    @objc dynamic var variant: VariantDetail!
    @objc dynamic var sellingPlanId : String = ""
}

class VariantDetail: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var id: String = ""
    @objc dynamic var imageUrl: String = ""
}

class WishlistDetail: Object{
    @objc dynamic var qty: Int = 0
    @objc dynamic var id: String = ""
    @objc dynamic var title : String = ""
    @objc dynamic var variant: VariantDetail!
}

class RecentlyDetail: Object{
    @objc dynamic var id: String = ""
    @objc dynamic var variant: VariantDetail!
}


final class DBManager{
    var cartProducts: [CartDetail]?
    var wishlistProducts: [WishlistDetail]?
    var recentlyProducts: [RecentlyDetail]?
    static let shared = DBManager()
    
    // ----------------------------------
    //  MARK: - Init -
    //
    init(){
        
        getWishlistData()
        getCartDetails()
        getRecentlyDetails()
            
    }
    
    // ----------------------------------
    //  MARK: - Clear Cart -
    //
    func clearCartData(){
        do{
            let realm = try Realm()
            let real = (realm.objects(CartDetail.self))
            try? realm.write{
                realm.delete(real)
                self.getCartDetails()
            }
            
        }
        catch let err{
            print(err.localizedDescription)
        }
    }
    
    // ----------------------------------
    //  MARK: - Clear wishlist -
    //
    func clearWishlistData(){
        do{
            let realm = try Realm()
            let real = (realm.objects(WishlistDetail.self))
            try? realm.write{
                realm.delete(real)
                self.getWishlistData()
            }
        }
        catch let err{
            print(err.localizedDescription)
        }
    }
    
    // ----------------------------------
        //  MARK: - Get recently viewed products -
        //
        func getRecentlyDetails(){
          do{
            let realm = try Realm()
            if(realm.objects(RecentlyDetail.self).count > 0){
              
                self.recentlyProducts = realm.objects(RecentlyDetail.self).toArray(type: RecentlyDetail.self).reversed()
              
            }
            else{
              recentlyProducts = [RecentlyDetail]()
            }
          }
          catch let err{
            print(err.localizedDescription)
          }
        }
    
    
      // ----------------------------------
      //  MARK: - Clear Recently viewed products -
      //
      func clearRecentlyData(){
          do{
              let realm = try Realm()
              let real = (realm.objects(RecentlyDetail.self))
              try? realm.write{
                  realm.delete(real)
                  self.getRecentlyDetails()
              }
              
          }
          catch let err{
              print(err.localizedDescription)
          }
      }
        
    
    
    // ----------------------------------
    //  MARK: - Fetch wishlist products -
    //
    func getWishlistData(){
        do{
            let realm = try Realm()
            if(realm.objects(WishlistDetail.self).count > 0){
                wishlistProducts = realm.objects(WishlistDetail.self).toArray(type: WishlistDetail.self)
                
            }
            else{
                wishlistProducts = [WishlistDetail]()
            }
            
        }
        catch let err{
            print(err.localizedDescription)
        }
        
    }
    
    
    // ----------------------------------
    //  MARK: - Get cart products -
    //
  func getCartDetails(){
    do{
      let realm = try Realm()
      if(realm.objects(CartDetail.self).count > 0){
        
        self.cartProducts = realm.objects(CartDetail.self).toArray(type: CartDetail.self)
        
      }
      else{
        cartProducts = [CartDetail]()
      }
    }
    catch let err{
      print(err.localizedDescription)
    }
  }
    // ----------------------------------
       //  MARK: - Add to recently viewed -
       //
       func addToRecently(product: ProductViewModel,variant: VariantViewModel){
       do{
         let realm = try Realm()
         let user = RecentlyDetail()
           user.id = product.id
         let selectedVariant = VariantDetail()
           selectedVariant.id = variant.id
           selectedVariant.title = variant.title
           selectedVariant.imageUrl = variant.image?.absoluteString ?? ""
           user.variant = selectedVariant
         try? realm.write{
             var real = realm.objects(RecentlyDetail.self).toArray(type: RecentlyDetail.self)
             let filter = real.filter{$0.id==user.id && $0.variant.id == user.variant.id}
             if(filter.count==0){
                 realm.add(user)
             }
             else{
                 realm.delete(real.filter{$0.id == user.id && $0.variant.id == user.variant.id})
                 realm.add(user)
             }
             real = realm.objects(RecentlyDetail.self).toArray(type: RecentlyDetail.self)
             

             let count = real.count
             if(count>10){
                 realm.delete(real[0..<count-10])
             }
             self.recentlyProducts = realm.objects(RecentlyDetail.self).toArray(type: RecentlyDetail.self).reversed()
         }
       }
       catch let err{
         print(err.localizedDescription)
       }
     }
       
    
    
    // ----------------------------------
    //  MARK: - Get cart product id using lineitem -
    //
    func getCartProduct(product: LineItemViewModel)->String{
     //  return (cartProducts!.filter{$0.variant.id == product.variantID}.first!.id)
     //   let x = cartProducts ?? [CartDetails]
        for items in cartProducts! {
            if items.variant.id == product.variantID {
                return items.id
            }
        }
        return ""
    }
    
    
    func getCartProductID(product:CartLineItemViewModel)->String{
        for items in cartProducts! {
            if items.variant.id == product.variantId {
                return items.id
            }
        }
        return ""
    }
    
    // ----------------------------------
    //  MARK: - Add to wishlist -
    //
  func addToWishlist(product: CartProduct, id: String?, title: String?){
    do{
      let realm = try Realm()
      let user = WishlistDetail()
        if let productModel = product.productModel{
            user.id = productModel.id
            user.title = productModel.title
        }
        else{
            user.id = id!
            user.title = title!
        }
      user.variant = product.variant
      
      user.qty = product.qty
      try? realm.write{
        realm.add(user)
        self.wishlistProducts = realm.objects(WishlistDetail.self).toArray(type: WishlistDetail.self)
      }
    }
    catch let err{
      print(err.localizedDescription)
    }
  }
    
    // ----------------------------------
    //  MARK: - Add to cart -
    //
  func addToCart(product: CartProduct, id: String){
    do{
      let realm = try Realm()
      if(realm.objects(CartDetail.self).count > 0)
      {
          if product.sellingPlanId != "" {
              let real = (realm.objects(CartDetail.self)).filter{$0.sellingPlanId == product.sellingPlanId}
              if(real.count > 0){
                try? realm.write{
                  real.first?.qty += product.qty
                  self.cartProducts = realm.objects(CartDetail.self).toArray(type: CartDetail.self)
                }
              }
              else{
                let user = CartDetail()
                  if let productModel = product.productModel{
                      user.id = productModel.id
                  }
                  else{
                      user.id = id
                  }
                
                user.variant = product.variant
                user.qty = product.qty
                  user.sellingPlanId = product.sellingPlanId
                try? realm.write{
                  realm.add(user)
                  self.cartProducts = realm.objects(CartDetail.self).toArray(type: CartDetail.self)
                }
              }
          }
          
          else {
              let real = (realm.objects(CartDetail.self)).filter{$0.variant.id == product.variant.id}
              if(real.count > 0){
                try? realm.write{
                  real.first?.qty += product.qty
                  self.cartProducts = realm.objects(CartDetail.self).toArray(type: CartDetail.self)
                }
              }
              else{
                let user = CartDetail()
                  if let productModel = product.productModel{
                      user.id = productModel.id
                  }
                  else{
                      user.id = id
                  }
                user.variant = product.variant
                user.qty = product.qty
                  user.sellingPlanId = product.sellingPlanId
                try? realm.write{
                  realm.add(user)
                  self.cartProducts = realm.objects(CartDetail.self).toArray(type: CartDetail.self)
                }
              }
          }
      }
      
      else{
        let user = CartDetail()
          if let productModel = product.productModel{
              user.id = productModel.id
          }
          else{
              user.id = id
          }
        user.variant = product.variant
        user.qty = product.qty
          user.sellingPlanId = product.sellingPlanId
        try? realm.write{
          realm.add(user)
          self.cartProducts = realm.objects(CartDetail.self).toArray(type: CartDetail.self)
        }
      }
    }
    catch let err{
      print(err.localizedDescription)
    }
  }
    
    // ----------------------------------
    //  MARK: - Update Cart -
    //
    func updateToCart(product: LineItemViewModel, qty: Int){
        do{
            let realm = try Realm()
            if(realm.objects(CartDetail.self).count > 0)
            {
                print(product.id)
                let real = (realm.objects(CartDetail.self)).filter{$0.variant.id == product.id}
                
                try? realm.write{
                    real.first?.qty = qty
                    self.getCartDetails()
                }
            }
        }
        catch let err{
            print(err.localizedDescription)
        }
    }
    
    func updateToCartProduct(product: CartLineItemViewModel, qty: Int){
        do{
            let realm = try Realm()
            if(realm.objects(CartDetail.self).count > 0)
            {
                if product.sellingPlanId != "" {
                    let real = (realm.objects(CartDetail.self)).filter{$0.sellingPlanId == product.sellingPlanId}
                    try? realm.write{
                        real.first?.qty = qty
                        self.getCartDetails()
                    }
                }
                else {
                    let real = (realm.objects(CartDetail.self)).filter{$0.variant.id == product.variantId}
                    try? realm.write{
                        real.first?.qty = qty
                        self.getCartDetails()
                    }
                }
                
                
            }
        }
        catch let err{
            print(err.localizedDescription)
        }
    }
    
    // ----------------------------------
    //  MARK: - Decrement of qty in cart item -
    //
    func deleteQtyCart(product: LineItemViewModel){
        do{
            let realm = try Realm()
            if(realm.objects(CartDetail.self).count > 0)
            {
                let real = (realm.objects(CartDetail.self)).filter{$0.variant.id == product.id}
                
                try? realm.write{
                    real.first?.qty = real.first!.qty - 1
                    self.getCartDetails()
                }
            }
        }
        catch let err{
            print(err.localizedDescription)
        }
    }
    
    // ----------------------------------
    //  MARK: - Remove cart item -
    //
    func removeFromCart(product: LineItemViewModel){
        do{
            let realm = try Realm()
            let real = (realm.objects(CartDetail.self)).filter{$0.variant.id == product.id}
            
            
            try? realm.write{
                realm.delete(real)
                self.getCartDetails()
            }
            
        }
        catch let err{
            print(err.localizedDescription)
        }
    }
    
    func removeFromCartProduct(product: CartLineItemViewModel){
        do{
            
            let realm = try Realm()
            if product.sellingPlanId != "" {
                let real = (realm.objects(CartDetail.self)).filter{$0.sellingPlanId == product.sellingPlanId}
                
                
                try? realm.write{
                    realm.delete(real)
                    self.getCartDetails()
                }
            }
            else {
                let real = (realm.objects(CartDetail.self)).filter{$0.variant.id == product.variantId}
                
                
                try? realm.write{
                    realm.delete(real)
                    self.getCartDetails()
                }
            }
            
            
        }
        catch let err{
            print(err.localizedDescription)
        }
    }
    
    // ----------------------------------
    //  MARK: - Remove from wishlist -
    //
    func removeWishlist(product: CartProduct){
        do{
            let realm = try Realm()
            let real = (realm.objects(WishlistDetail.self)).filter{$0.variant.id == product.variant.id}
            print(real)
            
            try? realm.write{
                realm.delete(real)
                self.getWishlistData()
            }
            
        }
        catch let err{
            print(err.localizedDescription)
        }
    }
    
    
}
extension Results {
    func toArray<T>(type: T.Type) -> [T] {
        return compactMap { $0 as? T }
    }
}
