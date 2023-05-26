//
//  NativeAddressListTVCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 13/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class NativeAddressListTVCell: UITableViewCell {
  
  var parent: UIViewController?
  var checkoutID = GraphQL.ID(rawValue: "")
  var emailReceived = String()
  
  @IBOutlet weak var addressCollection: UICollectionView!
  
  var addresses : PageableArray<AddressesViewModel>?{
    didSet{
      addressCollection.reloadData()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  func setupView(){
    let nib = UINib(nibName: NativeAddressListCVCelll.className, bundle: nil)
    addressCollection.register(nib, forCellWithReuseIdentifier: NativeAddressListCVCelll.className)
    addressCollection.delegate = self
    addressCollection.dataSource = self
  }
}

extension NativeAddressListTVCell: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return addresses?.items.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NativeAddressListCVCelll.className, for: indexPath) as! NativeAddressListCVCelll
    if let addresses = addresses?.items[indexPath.item] {
      cell.configureFrom(addresses)
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    return collectionView.calculateCellSize(numberOfColumns: 2, of: 100)
    return CGSize(width: collectionView.frame.width/1.5 - 10, height: 100)
    
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let address = addresses?.items[indexPath.row]
    
    let firstName       = address?.firstName ?? ""
    let lastName        = address?.lastName ?? ""
    let address1        = address?.address1 ?? ""
    let address2        = address?.address2 ?? ""
    let city            = address?.city ?? ""
    let zip             = address?.zip ?? ""
    let country         = address?.country ?? ""
    let province        = address?.province ?? ""
    let phone           = address?.phone ?? ""
    
    let addressFields = ["firstName":firstName,
                         "lastName":lastName,
                         "address1":address1,
                         "address2":address2,
                         "city":city,
                         "zip":zip,
                         "country":country,
                         "province":province,
                         "phone":phone]
    print("AddressFields Cehck ==",addressFields)
    
    self.parent?.view.addLoader()
    Client.shared.customerAddShippingAddress(address: addressFields, checkoutID: checkoutID) { response, error in
      self.parent?.view.stopLoader()
      if let response = response {
        print("AvailaibleShippingRate==",response.availableShippingRate)
        if response.availableShippingRate?.count ?? 0 > 0 {
          let vc = ShippingMethodViewController()
          vc.availableShippingRate = response.availableShippingRate ?? []
          vc.checkoutId = response.checkId
          vc.email = self.emailReceived
          self.parent?.navigationController?.pushViewController(vc, animated: true)
        }
        else {
          self.parent?.view.showmsg(msg: "Kindly try with a different address".localized)
          return;
        }
      }
    }
  }
}
