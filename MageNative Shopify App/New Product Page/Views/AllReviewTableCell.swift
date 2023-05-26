//
//  AllReviewTableCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 20/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

/*import Foundation
import UIKit
class AllReviewTableCell : UITableViewCell {
    var headingColor = UIColor(hexString: "#2472C1")
    var subheadingColor = UIColor(hexString: "#6B6B6B")
    var parent: UIViewController?
    
    lazy var nameInitials : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.boldFont(size: 20.0)
        label.textAlignment = .center
        label.textColor = headingColor
        return label
    }()
    
    lazy var reviewerName : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.regularFont(size: 14.0)
        label.textColor = headingColor
        return label
    }()
    
    lazy var review : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.regularFont(size: 12.0)
        label.textColor = subheadingColor
        label.numberOfLines = 2
        return label
    }()
    
    lazy var timeLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.regularFont(size: 12.0)
        label.textColor = headingColor
        return label
    }()
    
    var starView = StarCosmosView()
    
    lazy var imagesCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0 , right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false;
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        
        collectionView.register(JudgemeImageview.self, forCellWithReuseIdentifier: JudgemeImageview.className)
//        collectionView.register(ProductQuantityTextFieldCell.self, forCellWithReuseIdentifier: ProductQuantityTextFieldCell.className)
        return collectionView
    }()
    
    
    
    var pictures = [[String:String]]()
    lazy var separatorLine : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.secondarySystemBackground
        } else {
            view.backgroundColor = .lightGray
            // Fallback on earlier versions
        }
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isMultipleTouchEnabled = true
        contentView.isUserInteractionEnabled = true
        selectionStyle = .none
        initView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        backgroundColor = .white
        addSubview(nameInitials)
        addSubview(reviewerName)
        addSubview(review)
        addSubview(timeLabel)
        addSubview(starView)
        addSubview(separatorLine)
        nameInitials.anchor(top: safeAreaLayoutGuide.topAnchor, left: leadingAnchor, paddingTop: 8, paddingLeft: 16, width: 40, height: 40)
        reviewerName.anchor(top: safeAreaLayoutGuide.topAnchor, left: nameInitials.trailingAnchor, paddingTop: 8, paddingLeft: 16, height: 35)
        
        review.anchor(top: nameInitials.bottomAnchor, left: leadingAnchor, bottom: timeLabel.topAnchor, right: trailingAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 4, paddingRight: 8)
        timeLabel.anchor(top: review.bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 16, height: 35)
        starView.anchor(top: reviewerName.topAnchor, left: reviewerName.trailingAnchor, right: trailingAnchor, paddingTop: 0, paddingLeft: 8, paddingRight: 16, width: 50, height: 30)
        separatorLine.anchor(top: timeLabel.bottomAnchor, left: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: trailingAnchor, paddingTop: 4, paddingLeft: 16, paddingBottom: 4, paddingRight: 16, height: 2)
        starView.layer.cornerRadius = 5.0
        starView.layer.masksToBounds = true
    }
    
    
    func configureData(ratingData:[String:String], pictures: [[String:String]]?) {
        nameInitials.layer.cornerRadius = 20.0
        nameInitials.layer.masksToBounds = true
        nameInitials.layer.borderColor = UIColor(hexString: "#A5C8ED").cgColor
        nameInitials.backgroundColor = UIColor(hexString: "#EAF2FB")
        nameInitials.layer.borderWidth = 2.0
      var nameInitial = ""
        let nameArray = ratingData["reviewer_name"]?.components(separatedBy: " ")
        if let nameArr = nameArray{
            for val in nameArr {
              nameInitial += (val.first?.description) ?? ""
            }
        }
        
     
      nameInitials.text = nameInitial.uppercased()
    reviewerName.text = ratingData["reviewer_name"]
      timeLabel.text = ratingData["review_date"]
      review.text = ratingData["content"]
        starView.starLabel.text = ratingData["rating"]
        starView.starLabel.font = mageFont.mediumFont(size: 14.0)
        starView.starLabel.textColor = .white
        starView.view.backgroundColor = UIColor(hexString: "#28A138")
        if let pictur = pictures{
            timeLabel.isHidden = true;
            if(pictur.count>0){
                self.pictures = pictur
                
            }
            
            timeLabel.anchor(top: imagesCollection.bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 0, paddingLeft: 16, paddingRight: 16, height: 0)
            
            separatorLine.anchor(top: timeLabel.bottomAnchor, left: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: trailingAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 4, paddingRight: 16, height: 2)
        }
        else{
            
            timeLabel.anchor(top: imagesCollection.bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 16, height: 35)
            
            separatorLine.anchor(top: timeLabel.bottomAnchor, left: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: trailingAnchor, paddingTop: 4, paddingLeft: 16, paddingBottom: 4, paddingRight: 16, height: 2)
        }
        imagesCollection.delegate = self;
        imagesCollection.dataSource = self;
        imagesCollection.reloadData()
    }
    
//    func configureData(ratingData:[String:String]) {
//
//        nameInitials.layer.cornerRadius = 20.0
//        nameInitials.layer.masksToBounds = true
//        nameInitials.layer.borderColor = UIColor(hexString: "#A5C8ED").cgColor
//        nameInitials.backgroundColor = UIColor(hexString: "#EAF2FB")
//        nameInitials.layer.borderWidth = 2.0
//      var nameInitial = ""
//        let nameArray = ratingData["reviewer_name"]?.components(separatedBy: " ")
//        if let nameArr = nameArray{
//            for val in nameArr {
//              nameInitial += (val.first?.description) ?? ""
//            }
//        }
//
//
//      nameInitials.text = nameInitial.uppercased()
//    reviewerName.text = ratingData["reviewer_name"]
//      timeLabel.text = ratingData["review_date"]
//      review.text = ratingData["content"]
//        starView.starLabel.text = ratingData["rating"]
//        starView.starLabel.font = mageFont.mediumFont(size: 14.0)
//        starView.starLabel.textColor = .white
//        starView.view.backgroundColor = UIColor(hexString: "#28A138")
//
//
//    }
}
extension AllReviewTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JudgemeImageview.className, for: indexPath) as! JudgemeImageview
        cell.setup(url: pictures[indexPath.row]["original"] ?? "")
        return cell;
//        if indexPath.row == quantityArray.count {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductQuantityTextFieldCell.className, for: indexPath) as! ProductQuantityTextFieldCell
//            cell.textField.delegate = self
//            cell.textField.text = customQuantity
//            cell.textField.keyboardType = .numberPad
//            return cell
//        }
//        else {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductVariationViewCell.className, for: indexPath) as! ProductVariationViewCell
//            cell.textLabel.text = quantityArray[indexPath.row]
//            initialSelected == indexPath.row ? cell.textLabel.selectedItem() : cell.textLabel.unselectedItem()
//            cell.textLabel.layer.cornerRadius = 25.0
//            cell.textLabel.layer.masksToBounds = true
//            return cell
//        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let productViewController:ProductImageViewController = storyboard.instantiateViewController()
        productViewController.staticImage = pictures[indexPath.row]["original"] ?? ""
        productViewController.modalPresentationStyle = .fullScreen
        parent?.present(productViewController, animated: false, completion: nil)
    }
}*/
//
//  AllReviewTableCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 20/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
class AllReviewTableCell : UITableViewCell {
    var headingColor = UIColor(hexString: "#2472C1")
    var subheadingColor = UIColor(hexString: "#6B6B6B")
    
    var parent: UIViewController?
    lazy var nameInitials : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.boldFont(size: 20.0)
        label.textAlignment = .center
        label.textColor = headingColor
        return label
    }()
    
    lazy var reviewerName : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.regularFont(size: 14.0)
        label.textColor = headingColor
        return label
    }()
    
    lazy var review : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.regularFont(size: 12.0)
        label.textColor = subheadingColor
        label.numberOfLines = 2
        return label
    }()
    
    lazy var timeLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = mageFont.regularFont(size: 12.0)
        label.textColor = headingColor
        return label
    }()
    
    lazy var imagesCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0 , right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false;
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        
        collectionView.register(JudgemeImageview.self, forCellWithReuseIdentifier: JudgemeImageview.className)
//        collectionView.register(ProductQuantityTextFieldCell.self, forCellWithReuseIdentifier: ProductQuantityTextFieldCell.className)
        return collectionView
    }()
    
    var starView = StarCosmosView()
    
    
    lazy var separatorLine : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.secondarySystemBackground
        } else {
            view.backgroundColor = .lightGray
            // Fallback on earlier versions
        }
        return view
    }()
    
    var pictures = [[String:String]]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isMultipleTouchEnabled = true
        contentView.isUserInteractionEnabled = true
        selectionStyle = .none
        initView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        backgroundColor = .white
        addSubview(nameInitials)
        addSubview(reviewerName)
        addSubview(review)
        addSubview(timeLabel)
        addSubview(starView)
        addSubview(separatorLine)
        addSubview(imagesCollection)
        nameInitials.anchor(top: safeAreaLayoutGuide.topAnchor, left: leadingAnchor, paddingTop: 8, paddingLeft: 16, width: 40, height: 40)
        reviewerName.anchor(top: safeAreaLayoutGuide.topAnchor, left: nameInitials.trailingAnchor, paddingTop: 8, paddingLeft: 16, height: 35)
        
        review.anchor(top: nameInitials.bottomAnchor, left: leadingAnchor, bottom: imagesCollection.topAnchor, right: trailingAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 4, paddingRight: 8)
        
        starView.anchor(top: reviewerName.topAnchor, left: reviewerName.trailingAnchor, right: trailingAnchor, paddingTop: 0, paddingLeft: 8, paddingRight: 16, width: 50, height: 30)
        starView.layer.cornerRadius = 5.0
        starView.layer.masksToBounds = true
    }
    
    
    func configureData(ratingData:[String:String], pictures: [[String:String]]?) {
        nameInitials.layer.cornerRadius = 20.0
        nameInitials.layer.masksToBounds = true
        nameInitials.layer.borderColor = UIColor(hexString: "#A5C8ED").cgColor
        nameInitials.backgroundColor = UIColor(hexString: "#EAF2FB")
        nameInitials.layer.borderWidth = 2.0
      var nameInitial = ""
        let nameArray = ratingData["reviewer_name"]?.components(separatedBy: " ")
        if let nameArr = nameArray{
            for val in nameArr {
              nameInitial += (val.first?.description) ?? ""
            }
        }
        
     
      nameInitials.text = nameInitial.uppercased()
    reviewerName.text = ratingData["reviewer_name"]
      timeLabel.text = ratingData["review_date"]
      review.text = ratingData["content"]
        starView.starLabel.text = ratingData["rating"]
        starView.starLabel.font = mageFont.mediumFont(size: 14.0)
        starView.starLabel.textColor = .white
        starView.view.backgroundColor = UIColor(hexString: "#28A138")
        if let pictur = pictures{
            //timeLabel.isHidden = true;
            if(pictur.count>0){
                self.pictures = pictur
                imagesCollection.anchor(top: review.bottomAnchor, left: leadingAnchor, bottom: timeLabel.topAnchor, right: trailingAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 4, paddingRight: 8, height: 150)
                timeLabel.anchor(top: imagesCollection.bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 0, paddingLeft: 16, paddingRight: 16, height: 0)
                
                separatorLine.anchor(top: timeLabel.bottomAnchor, left: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: trailingAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 4, paddingRight: 16, height: 2)
            }
            else{
                timeLabel.anchor(top: review.bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 16, height: 35)
                
                separatorLine.anchor(top: timeLabel.bottomAnchor, left: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: trailingAnchor, paddingTop: 4, paddingLeft: 16, paddingBottom: 4, paddingRight: 16, height: 2)
            }
        }
        else{
            
            timeLabel.anchor(top: review.bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 16, height: 35)
            
            separatorLine.anchor(top: timeLabel.bottomAnchor, left: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: trailingAnchor, paddingTop: 4, paddingLeft: 16, paddingBottom: 4, paddingRight: 16, height: 2)
        }
        imagesCollection.delegate = self;
        imagesCollection.dataSource = self;
        imagesCollection.reloadData()
    }
}
extension AllReviewTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JudgemeImageview.className, for: indexPath) as! JudgemeImageview
        cell.setup(url: pictures[indexPath.row]["original"] ?? "")
        return cell;
//        if indexPath.row == quantityArray.count {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductQuantityTextFieldCell.className, for: indexPath) as! ProductQuantityTextFieldCell
//            cell.textField.delegate = self
//            cell.textField.text = customQuantity
//            cell.textField.keyboardType = .numberPad
//            return cell
//        }
//        else {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductVariationViewCell.className, for: indexPath) as! ProductVariationViewCell
//            cell.textLabel.text = quantityArray[indexPath.row]
//            initialSelected == indexPath.row ? cell.textLabel.selectedItem() : cell.textLabel.unselectedItem()
//            cell.textLabel.layer.cornerRadius = 25.0
//            cell.textLabel.layer.masksToBounds = true
//            return cell
//        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let productViewController:ProductImageViewController = storyboard.instantiateViewController()
        productViewController.staticImage = pictures[indexPath.row]["original"] ?? ""
        productViewController.modalPresentationStyle = .fullScreen
        parent?.present(productViewController, animated: false, completion: nil)
    }
}
