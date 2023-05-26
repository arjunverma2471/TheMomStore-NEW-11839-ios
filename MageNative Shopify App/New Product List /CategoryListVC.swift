//
//  CategoryListVC.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 12/09/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class CategoryListVC: BaseViewController {

    
    fileprivate lazy var searchBarButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.layer.borderColor = UIColor(hexString: "#D1D1D1").cgColor
        button.layer.borderWidth = 1.0
        return button;
    }()
    
    fileprivate lazy var searchImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false;
        image.image = UIImage(named: "search")
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor(light: UIColor(hexString: "#383838"), dark: UIColor.provideColor(type: .categoryListVC).tintColor)
        return image;
    }()
    
    fileprivate lazy var searchTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false;
        title.text = "Search by products & brands".localized
        title.font = mageFont.regularFont(size: 12)
        title.textColor =  UIColor(light: UIColor(hexString: "#6B6B6B"), dark: UIColor.provideColor(type: .categoryListVC).textColor)
        return title;
    }()
    
    fileprivate lazy var categoryCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        layout.minimumInteritemSpacing = 6
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
        collectionView.translatesAutoresizingMaskIntoConstraints = false;
        collectionView.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .categoryListVC).collectionViewBackgroundColor)
        
        collectionView.register(CategoryListCC.self, forCellWithReuseIdentifier: CategoryListCC.className)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    fileprivate var collections: PageableArray<CollectionViewModel>!
    
    var imageSize = CGSize(width: 1, height: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
//        self.title = "All Collections".localized
        // Do any additional setup after loading the view.
    }
    
    private func initView(){
        self.navigationItem.title = ""
        updateNavBar()
        view.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .categoryListVC).backGroundColor)
        view.addSubview(searchBarButton)
        view.addSubview(categoryCollectionView)
        view.addSubview(searchImage)
        view.addSubview(searchTitle)
        searchBarButton.anchor(top: view.topAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, height: 50)
        categoryCollectionView.anchor(top: searchBarButton.bottomAnchor, left: view.leadingAnchor, bottom: view.bottomAnchor, right: view.trailingAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        searchImage.anchor(left: searchBarButton.leadingAnchor, paddingLeft: 10,width: 15, height: 15);
        searchTitle.centerYAnchor.constraint(equalTo: searchBarButton.centerYAnchor).isActive = true;
        searchTitle.anchor(left: searchImage.trailingAnchor, right: searchBarButton.trailingAnchor, paddingLeft: 5, paddingRight: 5)
        searchImage.centerYAnchor.constraint(equalTo: searchBarButton.centerYAnchor).isActive = true;
        searchBarButton.addTarget(self, action: #selector(searchButtonClicked(_:)), for: .touchUpInside)
        loadCategories()
    }
    
    func updateNavBar(){
        let titleWidth = ("All Collections".localized as NSString).size(withAttributes: [NSAttributedString.Key.font: mageFont.mediumFont(size: 15)]).width//width calculate
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: titleWidth, height: 30))
        title.font = mageFont.mediumFont(size: 15)
        title.text = "All Collections".localized
        title.textColor = UIColor(light: Client.navigationThemeData?.icon_color ?? .white, dark: UIColor.white)
        let stack = UIStackView(arrangedSubviews: [title])
        stack.distribution = .fill
        stack.axis = .horizontal
        navigationItem.leftBarButtonItems?.append(UIBarButtonItem(customView: stack))
    }
    
    
    @objc func searchButtonClicked(_ sender: UIButton){
        if customAppSettings.sharedInstance.showTabbar{
            self.parent?.tabBarController?.selectedIndex = 1;
        }else{
            let viewController = GetNavigation.shared.getCategoriesController()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        //self.navigationController?.pushViewController(GetNavigation.shared.getSearchController(), animated: true)
    }
    
    func loadCategories(){
        self.view.addLoader()
        Client.shared.fetchCollections(maxImageWidth: 300, maxImageHeight: 300, completion: {
            result,error  in
            self.view.stopLoader()
            if let results = result {
                self.collections = results
                self.categoryCollectionView.delegate = self;
                self.categoryCollectionView.dataSource = self;
                self.categoryCollectionView.reloadData()
            }else {
                //self.showErrorAlert(error: error?.localizedDescription)
            }
        })
    }
}

extension CategoryListVC:UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collections?.items.count ?? 0
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell       = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryListCC.className, for: indexPath) as! CategoryListCC
    let collection = self.collections.items[indexPath.row]
    cell.configure(collection)
    return cell
  }
}

extension CategoryListVC:UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let collection         = self.collections.items[indexPath.row]
        let productListingController=ProductListVC()//:ProductListViewController = self.storyboard!.instantiateViewController()
        productListingController.collection = collection
        self.navigationController?.pushViewController(productListingController, animated: true)
    }
}

extension CategoryListVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(imageSize != CGSize(width: 1, height: 1)){
            return CGSize(width: UIScreen.main.bounds.width-10, height: 120*(imageSize.height/imageSize.width))
        }
        return CGSize(width: UIScreen.main.bounds.width-10, height: 120)
    }
}
