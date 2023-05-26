////
////  BoostCommerceSearchVC.swift
////  MageNative Shopify App
////
////  Created by cedcoss on 18/07/22.
////  Copyright © 2022 MageNative. All rights reserved.
////
//
//import UIKit
//
//class BoostCommerceSearchVC: UIViewController {
//
//
//  var boostCommerceSearchVM:BoostCommerceSearchVM?
//  
//  fileprivate lazy var searchBar: UISearchBar = {
//    let search = UISearchBar()
//    search.translatesAutoresizingMaskIntoConstraints = false;
//    return search
//  }()
//
//  fileprivate lazy var productsCollectionView: UICollectionView = {
//    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//    let layout = UICollectionViewFlowLayout()
//    layout.scrollDirection = .vertical
//    collectionView.collectionViewLayout = layout
//    collectionView.translatesAutoresizingMaskIntoConstraints = false;
//    collectionView.backgroundColor = .white
//    //      collectionView.register(UINib(nibName: AlgoliaProductNewCell.className, bundle: nil), forCellWithReuseIdentifier: AlgoliaProductNewCell.className)
//    //      collectionView.register(UINib(nibName: AlgoliaCollectionCell.className, bundle: nil), forCellWithReuseIdentifier: AlgoliaCollectionCell.className)
//    return collectionView
//  }()
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    setupView()
//    initiateDataLoadingSequence()
//  }
//
//  func initiateDataLoadingSequence(){
//    boostCommerceSearchVM = BoostCommerceSearchVM()
//    boostCommerceSearchVM?.getInstantSearchData(for: ["q":"dress"], completion: { [weak self] (dataReceived) in
//      guard let dataReceived = dataReceived else {return}
//      if dataReceived{
//        self?.productsCollectionView.reloadData()
//      }
//    })
//  }
//
//  func setupView(){
//    view.backgroundColor = DynamicColor.systemBackground
//    view.addSubview(searchBar)
//    view.addSubview(productsCollectionView)
//    searchBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//    searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//    searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//    searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
//    productsCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5).isActive = true
//    productsCollectionView.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor).isActive = true
//    productsCollectionView.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor).isActive = true
//    productsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//  }
//}
//
//extension BoostCommerceSearchVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
//
//  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    return boostCommerceSearchVM?.bcSearchProductsModel?.products?.count ?? 0
//  }
//
//  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    let cell = UICollectionViewCell()
//    cell.backgroundColor = .red
//    return cell
//  }
//
//  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    if UIDevice.current.model.lowercased() == "ipad".lowercased(){
//      return collectionView.calculateCellSize(numberOfColumns: 4,of: 185.0)
//    }
//    return collectionView.calculateCellSize(numberOfColumns: 2,of: 150.0)
//  }
//  //      if(searchedData.count > 0){
//  //          if UIDevice.current.model.lowercased() == "ipad".lowercased(){
//  //              return collectionView.calculateCellSize(numberOfColumns: 4,of: 185.0)
//  //          }
//  //          return collectionView.calculateCellSize(numberOfColumns: 2,of: 150.0)
//  //      }
//  //Collection Cell Size
//  //      return CGSize(width: UIScreen.main.bounds.width - 10, height: 3/7*self.view.frame.width)
//}
//
