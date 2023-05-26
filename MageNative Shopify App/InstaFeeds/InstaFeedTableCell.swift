//
//  InstaFeedTableCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 08/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class InstaFeedTableCell: UITableViewCell {
    
    lazy var lbl_username: PaddingLabel = {
        let username = PaddingLabel(withInsets: 0, 0, 10, 0)
        username.translatesAutoresizingMaskIntoConstraints = false
        username.font = mageFont.mediumFont(size: 16.0)
        username.textAlignment = .center
        username.textColor = .black
        //username.backgroundColor = .cyan
        username.text = "Instagram Feeds".localized
        return username
    }()
    
    lazy var feedCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let feeds = UICollectionView(frame: .zero, collectionViewLayout: layout)
        feeds.backgroundColor = .clear
        feeds.translatesAutoresizingMaskIntoConstraints = false
        let nib = UINib(nibName: FeedCell.className, bundle: nil)
        feeds.register(nib, forCellWithReuseIdentifier: FeedCell.className)
        feeds.delegate = self
        feeds.dataSource = self
        return feeds
    }()
    lazy var btn_viewMore: UIButton = {
        let viewMore = UIButton()
        viewMore.translatesAutoresizingMaskIntoConstraints = false
        viewMore.titleLabel?.font = mageFont.boldFont(size: 14.0)
        viewMore.setTitleColor(.black, for: .normal)
        viewMore.setTitle("View More".localized, for: .normal)
        //viewMore.backgroundColor = .red
        viewMore.addTarget(self, action: #selector(viewMoreInstaFeeds(_:)), for: .touchUpInside)
        viewMore.titleEdgeInsets = UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 0)
        viewMore.isHidden = true
        return viewMore
    }()
    var feeds = [InstagramMedia]()
    var newModel: [InstagramMedia]?
    
    var count = 0
    var type: InstaType = .grid
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupViews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setupViews(){
        
        contentView.addSubview(lbl_username)
        contentView.addSubview(feedCollection)
        contentView.addSubview(btn_viewMore)
        
        lbl_username.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        lbl_username.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        lbl_username.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        lbl_username.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        btn_viewMore.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        btn_viewMore.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        btn_viewMore.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        btn_viewMore.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        feedCollection.topAnchor.constraint(equalTo: self.lbl_username.bottomAnchor).isActive = true
        feedCollection.bottomAnchor.constraint(equalTo: btn_viewMore.bottomAnchor).isActive = true
        feedCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        feedCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true

    }
    func configureNew(from model:InstaViewModel?, count: Int, scroll: Int) {
      
        self.newModel = model?.data
        DispatchQueue.main.async {
            if self.newModel?.count ?? 0 > 0{
                self.lbl_username.text = "Instagram Feeds @\(self.newModel?[0].username ?? "")"
                self.count = count;
                if(scroll==0){
                    self.type = .grid
                    self.feedCollection.isScrollEnabled = false;
                }
                else{
                    self.type = .scroll
                    let layout = UICollectionViewFlowLayout()
                    layout.scrollDirection = .horizontal
                    self.feedCollection.isScrollEnabled = true;
                    self.feedCollection.collectionViewLayout = layout
                }
                self.btn_viewMore.isHidden = true
//                if self.newModel?.count ?? 0 < 7{
//                    self.btn_viewMore.isHidden = true
//                }
//                else{
//                    self.btn_viewMore.isHidden = false
//                }
                self.feedCollection.reloadData()
            }
        }
        
    }
    @objc func viewMoreInstaFeeds(_ sender : UIButton){
        print("View More")
       // let instagramURL = URL(string: self.feeds[0].permalink)
        let instagramURL = URL(string: Client.BASE_INSTAGRAM_URL + "\(self.newModel?[0].username ?? "")/")
        if let instagramURL = instagramURL {
            if UIApplication.shared.canOpenURL(instagramURL) {
                UIApplication.shared.open(instagramURL)
            }
        }
    }
    
}
extension InstaFeedTableCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.newModel?.count ?? 0 > 0 {
            if self.newModel?.count ?? 0 < count{
                return  self.newModel?.count ?? 0
            }
            else{
            return count
            }
            
        }
        else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.className, for: indexPath as IndexPath) as! FeedCell
        if self.newModel?.count ?? 0 > 0  {
            //cell.configure(model: self.newModel?[indexPath.item])
            cell.lbl_caption.text = self.newModel?[indexPath.item].caption
            let url = URL(string: self.newModel?[indexPath.item].media_url ?? "")
            cell.feedImage.setImageFrom(url)
        }
        cell.lbl_caption.font = mageFont.regularFont(size: 13.0)
        cell.feedImage.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        cell.lbl_caption.adjustsFontSizeToFitWidth = true
        cell.feedImage.layer.borderWidth = 0.5
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((UIScreen.main.bounds.width-40)/3 - 2), height: ((UIScreen.main.bounds.width-40)/3 - 2))
//        print("Device=======>",UIDevice.current.model.lowercased())
//        print("Device Specific========>",UIDevice.current.name)
//        var yourWidth = 0.0
//        var yourHeight = 0.0
//        if  UIDevice.current.model.lowercased() == "ipad".lowercased() {
//
////            if UIDevice.current.name == "iPad (5th generation)"{
////
////                return collectionView.calculateHalfCellSize(numberOfColumns: 3, of: 80)
////
////
////            }
////            else{
//
//            return collectionView.calculateHalfCellSize(numberOfColumns: 3, of: 80)
//
//
//          // }
//        }
//        else{
//        let yourWidth = collectionView.bounds.width/2
//        let yourHeight = yourWidth
//        return CGSize(width: yourWidth, height: yourHeight)
        //}
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let instagramURL = URL(string: self.newModel?[indexPath.item].permalink ?? "")
        if let instagramURL = instagramURL {
            if UIApplication.shared.canOpenURL(instagramURL) {
                UIApplication.shared.openURL(instagramURL)
            }
        }
        
    }
}

class PaddingLabel: UILabel {

    var topInset: CGFloat
    var bottomInset: CGFloat
    var leftInset: CGFloat
    var rightInset: CGFloat

    required init(withInsets top: CGFloat, _ bottom: CGFloat,_ left: CGFloat,_ right: CGFloat) {
        self.topInset = top
        self.bottomInset = bottom
        self.leftInset = left
        self.rightInset = right
        super.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}
