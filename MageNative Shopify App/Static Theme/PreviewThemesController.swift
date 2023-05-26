//
//  PreviewThemesController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 20/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
class PreviewThemesController : UIViewController {
    
    lazy var headerTitle : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Theme Designs".localized
        label.font = mageFont.mediumFont(size: 16)
        label.textColor = UIColor(light: UIColor.black, dark:  .white)
        return label
    }()
    
    lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "close"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.tintColor = UIColor(light: .black,dark: UIColor.provideColor(type: .SideMenuController).white)
        btn.addTarget(self, action: #selector(closeBtnTapped), for: .touchUpInside)
        return btn
    }()
    private lazy var navigationBottomLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false;
        line.backgroundColor = UIColor(hexString: "#D1D1D1")
        return line;
    }()
    lazy var headerView: UIView = {
        let view = UIView()
        view.addSubview(headerTitle)
        view.addSubview(closeBtn)
        headerTitle.anchor(left: view.leadingAnchor, right: closeBtn.leadingAnchor, paddingLeft: 8, height: 35)
        headerTitle.centerY(inView: view)
       
        closeBtn.anchor(right: view.trailingAnchor, paddingRight: 8, width: 35, height: 35)
        closeBtn.centerY(inView: view)
        view.addSubview(navigationBottomLine)
        navigationBottomLine.anchor(left: view.leadingAnchor, bottom: view.bottomAnchor, right: view.trailingAnchor, paddingBottom: 2, height: 0.5)
        return view
    }()
    
    
    private lazy var dropDownButton : UIButton = {
        let button = UIButton()
        button.setTitle("All Stores".localized, for: .normal)
        button.setTitleColor(UIColor(light: UIColor(hexString: "#383838")), for: .normal)
        button.setupFont(fontType: .Regular, fontSize: 14.0)
        button.layer.borderWidth = 0.75
        button.layer.borderColor = UIColor(light: UIColor(hexString: "#CCCCCC")).cgColor
        button.addTarget(self, action: #selector(filterThemes(_:)), for: .touchUpInside)
        button.contentHorizontalAlignment = Client.locale == "ar" ? .right : .left
        return button
    }()
    
    
    private lazy var collectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 5, bottom: 5 , right: 5)
        collectionView.collectionViewLayout = layout
        collectionView.translatesAutoresizingMaskIntoConstraints = false;
        
        collectionView.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .productListVC).collectionViewBackgroundColor)
        let nib = UINib(nibName: PreviewThemeCell.className, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "PreviewThemeCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    var dataSource = ["Default".localized,"Grocery store".localized,"Home Decor store".localized,"Fashion store".localized]
    
    var themesData = ["Default".localized,"Grocery store".localized,"Home Decor store".localized,"Fashion store".localized]
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .productListVC).backGroundColor)
        self.view.addSubview(headerView)
        self.view.addSubview(dropDownButton)
        self.view.addSubview(collectionView)
        headerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingTop: 12, paddingLeft: 4,paddingRight: 10, height: 40)
        dropDownButton.anchor(top: headerView.bottomAnchor,left: view.safeAreaLayoutGuide.leadingAnchor, right: view.safeAreaLayoutGuide.trailingAnchor,paddingTop: 8, paddingLeft: 8, paddingRight: 8, height: 40)
        collectionView.anchor(top: dropDownButton.bottomAnchor, left: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.trailingAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
    }
    
    @objc func closeBtnTapped(_ sender : UIButton) {
        self.dismiss(animated: false)
        //self.navigationController?.popViewController(animated: false)
    }
    
    @objc func filterThemes(_ sender : UIButton) {
        let dropDown = DropDown(anchorView: sender)
        var dataSource = [String]()
        dataSource = ["Default".localized,"Grocery store".localized,"Home Decor store".localized,"Fashion store".localized ,"All Stores".localized]
        dropDown.dataSource = dataSource
        dropDown.selectionAction = {[unowned self](index, item) in
            sender.setTitle(item, for: UIControl.State());
            if item != "All Stores".localized {
                let data = themesData.filter{$0==item}
                self.dataSource = data
            }
            else {
                self.dataSource = themesData
            }
            collectionView.reloadData()
        }
        
        dropDown.bottomOffset = CGPoint(x: 0, y:sender.bounds.height)
        if dropDown.isHidden {
            dropDown.setAlignment(dropDown)
            let _ = dropDown.show();
        } else {
            dropDown.hide();
        }
    }
    
}
extension PreviewThemesController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviewThemeCell", for: indexPath) as! PreviewThemeCell
        cell.setupData(data: dataSource[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 10, height: 275)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let themeName = dataSource[indexPath.row]
        if themeName == "Default".localized {
            Client.homeStaticThemeJSON = Data()
            Client.homeStaticThemeColor = ""
            (UIApplication.shared.delegate as! AppDelegate).loadHomepage()
        }
        else if themeName == "Home Decor store".localized{
            guard let path = Bundle.main.path(forResource: "HomeDecor", ofType: "json") else {return}
            guard let value = try? String(contentsOfFile: path) else {return}
             let data = Data(value.utf8)
            Client.homeStaticThemeJSON = data
            Client.homeStaticThemeColor = "#0696B4"
            (UIApplication.shared.delegate as! AppDelegate).loadHomepage()
        }
        else if themeName == "Fashion store".localized{
            guard let path = Bundle.main.path(forResource: "Fashion", ofType: "json") else {return}
            guard let value = try? String(contentsOfFile: path) else {return}
             let data = Data(value.utf8)
            Client.homeStaticThemeJSON = data
            Client.homeStaticThemeColor = "#5B311F"
            (UIApplication.shared.delegate as! AppDelegate).loadHomepage()
        }
        else if themeName == "Grocery store".localized{
            guard let path = Bundle.main.path(forResource: "Grocery", ofType: "json") else {return}
            guard let value = try? String(contentsOfFile: path) else {return}
             let data = Data(value.utf8)
            Client.homeStaticThemeJSON = data
            Client.homeStaticThemeColor = "#03AD53"
            (UIApplication.shared.delegate as! AppDelegate).loadHomepage()
        }
        
    }
    
    
}
