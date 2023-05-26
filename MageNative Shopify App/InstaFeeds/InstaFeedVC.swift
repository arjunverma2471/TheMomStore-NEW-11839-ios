////
////  InstaFeedVC.swift
////  MageNative Shopify App
////
////  Created by cedcoss on 07/06/22.
////  Copyright © 2022 MageNative. All rights reserved.
////
//
//import UIKit
//
//class InstaFeedVC: UIViewController {
//    lazy var lbl_username: UILabel = {
//        let username = UILabel()
//        username.translatesAutoresizingMaskIntoConstraints = false
//        username.font = mageFont.mediumFont(size: 15.0)
//        return username
//    }()
//    lazy var feedCollection: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        let feeds = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        feeds.backgroundColor = .clear
//        feeds.translatesAutoresizingMaskIntoConstraints = false
//        let nib = UINib(nibName: FeedCell.className, bundle: nil)
//        feeds.register(nib, forCellWithReuseIdentifier: FeedCell.className)
//        feeds.delegate = self
//        feeds.dataSource = self
//        return feeds
//    }()
//    
//    var feeds = [InstagramMedia]()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Do any additional setup after loading the view.
//        setupViews()
//        InstagramAPI.shared.getMediaData(completion: {
//            (data) in
//            // print(data)
//            self.feeds = data.data
////            print("FEEDS DATA ==>", self.feeds)
////            print("FEEDS DATA Count==>", self.feeds.count)
//            DispatchQueue.main.async {
//                if self.feeds.count > 0{
//                    self.lbl_username.text = "   Instagram Feeds @\(self.feeds[0].username)"
//                    self.title = "@\(self.feeds[0].username)"
//                    self.feedCollection.reloadData()
//                }
//            }
//            
//        })
//    }
//    func setupViews(){
//        self.title = "@username"
//        self.view.backgroundColor = UIColor(hexString: "#EFF8F7")
//        self.view.addSubview(lbl_username)
//        self.view.addSubview(feedCollection)
//        
//        lbl_username.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        lbl_username.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
//        lbl_username.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
//        lbl_username.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        
//        feedCollection.topAnchor.constraint(equalTo: self.lbl_username.bottomAnchor).isActive = true
//        feedCollection.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//        feedCollection.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
//        feedCollection.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
//    }
//    
//    
//    
//}
//extension InstaFeedVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.feeds.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.className, for: indexPath as IndexPath) as! FeedCell
//        if self.feeds.count > 0  {
//            cell.configure(model: self.feeds[indexPath.item])
//        }
//        cell.backgroundColor = UIColor.clear
//        
//        return cell
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let yourWidth = collectionView.bounds.width/2.0
//        let yourHeight = yourWidth
//        
//        return CGSize(width: yourWidth, height: yourHeight)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets.zero
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//    // MARK: - UICollectionViewDelegate protocol
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let instagramURL = URL(string: self.feeds[indexPath.item].permalink)
//        if let instagramURL = instagramURL {
//            if UIApplication.shared.canOpenURL(instagramURL) {
//                UIApplication.shared.openURL(instagramURL)
//            }
//        }
//        
//    }
//}
