//
//  BoostCommerceFilerVC.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 27/12/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit
import MobileBuySDK
import RxSwift

class BoostCommerceFilterVC: UIViewController {
    var boostCommerceProducts  : [Product]?
    var collectionId = ""
    var delegate: FilterClicked?
    var boostCommerceAPIHandler: BoostCommerceAPIHandler?
    var disposeBag = DisposeBag()
    fileprivate lazy var applyFilterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.backgroundColor = .AppTheme()
        button.setTitleColor(UIColor.textColor(), for: .normal)
        button.setTitle("Apply".localized, for: .normal)
        button.titleLabel?.font = mageFont.mediumFont(size: 15.0)
        
        return button;
    }()
    
    fileprivate lazy var resetButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.backgroundColor = .white
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.AppTheme().cgColor
        button.setTitle("Reset".localized, for: .normal)
        button.setTitleColor(UIColor(hexString: "#6B6B6B"), for: .normal)
        button.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .filterViewController).backGroundColor)
        button.titleLabel?.font = mageFont.mediumFont(size: 15.0)
        return button;
    }()
    lazy var filterBtnStack: UIStackView = {
        let stack  = UIStackView(arrangedSubviews: [resetButton,applyFilterButton])
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }()
    fileprivate lazy var mainCollection: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        collectionView.translatesAutoresizingMaskIntoConstraints = false;
        collectionView.backgroundColor = UIColor(light: UIColor(hexString: "#F2F2F2"),dark: UIColor.provideColor(type: .filterViewController).backGroundColor)
        collectionView.register(FilterMainCollectionCell.self, forCellWithReuseIdentifier: FilterMainCollectionCell.className)
        return collectionView
    }()
    
    fileprivate lazy var fieldsCollection: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        collectionView.translatesAutoresizingMaskIntoConstraints = false;
        collectionView.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .filterViewController).backGroundColor)
        collectionView.register(FilterFieldsCollectionCell.self, forCellWithReuseIdentifier: FilterFieldsCollectionCell.className)
        collectionView.register(FilterPriceCollectionCell.self, forCellWithReuseIdentifier: FilterPriceCollectionCell.className)
        return collectionView
    }()
    
    
    lazy var borderLine: UIView = {
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false;
        border.backgroundColor = UIColor(light: .black,dark: UIColor.provideColor(type: .filterViewController).white)
        
        return border;
    }()
    
    var filterStackHeight : NSLayoutConstraint!
    
    var handleString = ""
    
    var filters: [FilterOptions] = []{
        didSet{
            mainCollection.dataSource = self
            mainCollection.delegate = self;
            fieldsCollection.delegate = self;
            fieldsCollection.dataSource = self;
            mainCollection.reloadData()
            fieldsCollection.reloadData()
        }
    }
    
    var selectedFilter = 0{
        didSet{
            fieldsCollection.reloadData()
        }
    }
    
    
    var selectedFilterArray = [String]()
    var selectedprice = [String:String]()
    var selectedFilterArrayAPI = [String:[String]]()
    
    var selectedFilterModel : SelectedFilterModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        let titleWidth = ("Filter".localized as NSString).size(withAttributes: [NSAttributedString.Key.font: mageFont.mediumFont(size: 16)]).width
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: titleWidth, height: 30))
        title.font = mageFont.mediumFont(size: 16)
        title.text = "Filter".localized
        title.textColor = UIColor(light: UIColor.AppTheme(), dark: .white)
        navigationItem.leftBarButtonItems?.append(UIBarButtonItem(customView: title))
        // Do any additional setup after loading the view.
    }
    init(collId: String = ""){
        self.collectionId = collId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func resetClicked(_ sender: UIButton){
           
          
           if self.selectedFilterArrayAPI.isEmpty && self.selectedprice.isEmpty {
       
               self.navigationController?.popViewController(animated: true, completion: {
                   
               })
           }
           else{
           self.navigationController?.popViewController(animated: true, completion: {
             //  self.delegate?.applyFilter(selectedPrice: [String:String](), filter: [String]())
               self.delegate?.applyBoostCommerceFilterFromAPI(selectedPrice: [String:String](), filter: [String:[String]](), selectedFilter: SelectedFilterModel(isSelected: false, selectedIndex: Int(), selectedFilter: FilterOptions(json: JSON())))
           })
           }
           
           
       }
    
    
    @objc func applyClicked(_ sender: UIButton){
//        print("1====>",self.selectedFilterArray)
//        print("2=====>",self.selectedprice)
        
        if self.selectedFilterArrayAPI.isEmpty && self.selectedprice.isEmpty {
            self.view.showmsg(msg: "Please select any filter to apply".localized)
            return;
        }
        self.navigationController?.popViewController(animated: true, completion: {
           // self.delegate?.applyFilter(selectedPrice: self.selectedprice, filter: self.selectedFilterArray)
            self.delegate?.applyBoostCommerceFilterFromAPI(selectedPrice: self.selectedprice, filter: self.selectedFilterArrayAPI,selectedFilter: self.selectedFilterModel)
        })
        
    }
    
    private func initView(){
        view.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .filterViewController).backGroundColor)
//        view.addSubview(applyFilterButton)
//        view.addSubview(resetButton)
        
     
        filterStackHeight = NSLayoutConstraint(item: filterBtnStack, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 50)
        view.addSubview(filterBtnStack)
        view.addSubview(mainCollection)
        view.addSubview(fieldsCollection)
        view.addSubview(borderLine)
        filterBtnStack.anchor(left: view.leadingAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.trailingAnchor,paddingLeft: 4,paddingBottom: 0,paddingRight: 4)
        NSLayoutConstraint.activate([
//            resetButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
//            resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
//            resetButton.heightAnchor.constraint(equalToConstant: 50),
//            resetButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.47),
//            applyFilterButton.topAnchor.constraint(equalTo: resetButton.topAnchor),
//            applyFilterButton.leadingAnchor.constraint(equalTo: resetButton.trailingAnchor, constant: 4),
//            applyFilterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -4),
//            applyFilterButton.heightAnchor.constraint(equalTo: resetButton.heightAnchor),
            mainCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2),
            mainCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            mainCollection.bottomAnchor.constraint(equalTo: filterBtnStack.topAnchor, constant: -2),
            fieldsCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -2),
            fieldsCollection.topAnchor.constraint(equalTo: mainCollection.topAnchor),
            fieldsCollection.bottomAnchor.constraint(equalTo: mainCollection.bottomAnchor),
            mainCollection.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            fieldsCollection.leadingAnchor.constraint(equalTo: mainCollection.trailingAnchor),
            borderLine.heightAnchor.constraint(equalTo: mainCollection.heightAnchor),
            borderLine.leadingAnchor.constraint(equalTo: mainCollection.trailingAnchor, constant: 2),
            borderLine.bottomAnchor.constraint(equalTo: filterBtnStack.topAnchor),
        ])
        filterStackHeight.isActive = true
        applyFilterButton.addTarget(self, action: #selector(applyClicked(_:)), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetClicked(_:)), for: .touchUpInside)
        loadData()
        checkFilterResetButtons()
    }
    
    func checkFilterResetButtons(){
        if selectedFilterArrayAPI.count > 0 || self.selectedprice.count > 0{
//            self.resetButton.isHidden = false;
//            self.applyFilterButton.isHidden = false;
            filterBtnStack.isHidden = false
            filterStackHeight.constant = 50
            //self.resetButton.alpha = 1
        }
        else{
//            self.resetButton.isHidden = true
//            self.applyFilterButton.isHidden = true;
            //self.resetButton.alpha = 0
            filterBtnStack.isHidden = true
            filterStackHeight.constant = 0
        }
    }
    
    func loadData(filterData:[String:[String]] = [:]){
        var postString = [String:Any]()
        if filterData.count > 0{
            postString = filterData
        }
        else if selectedFilterArrayAPI.count > 0 {
            postString = selectedFilterArrayAPI
        }
        
        postString["collection_scope"] = self.collectionId
        if(!selectedprice.isEmpty){
            postString["pf_p_price"]="\(selectedprice["min"] ?? ""):\(selectedprice["max"] ?? "")"
        }
        boostCommerceAPIHandler = BoostCommerceAPIHandler()
        boostCommerceAPIHandler?.getInstantFilterResults(postString, completion: { [weak self] feed in
          self?.view.stopLoader()
          guard let feed = feed else {return}
            print(feed)
            self?.filters = feed.filterOptions
            
        })
    }

}
extension BoostCommerceFilterVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView==mainCollection){
            return filters.count
        }
        else{
            if(filters.count>0){
                return filters[selectedFilter].filterType == "price" ? 1 : filters[selectedFilter].values.count
            }
            return 0
       }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == mainCollection){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterMainCollectionCell.className, for: indexPath) as! FilterMainCollectionCell
            if(selectedFilter == indexPath.row){
                cell.configureBC(filter: filters[indexPath.row], selected: true)
            }
            else{
                cell.configureBC(filter: filters[indexPath.row], selected: false)
            }
            return cell;
        }
        else{
            print(filters[selectedFilter].filterType)
                if(filters[selectedFilter].filterType == "price"){
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterPriceCollectionCell.className, for: indexPath) as! FilterPriceCollectionCell
                    cell.filterParent = self;
                    cell.configureBC(filter: filters[selectedFilter].priceRange, selectedPrice: selectedprice)
                    cell.closureToPriceUpdate = { [weak self] dt in
                        self?.selectedprice = dt
                        self?.checkFilterResetButtons()
                    }
                    return cell;
                }
                else{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterFieldsCollectionCell.className, for: indexPath) as! FilterFieldsCollectionCell
                   // let filterOptionId = filters[selectedFilter].filterOptionId
                    cell.configureBC(data: filters[selectedFilter].values[indexPath.row], index: indexPath.row, selectedFilters: selectedFilterArrayAPI[filters[selectedFilter].filterOptionId] ?? [])

                    return cell;
                }
            //}
        }
        
    }
}

extension BoostCommerceFilterVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == mainCollection){
            if (self.selectedFilterModel?.isSelected == true && selectedFilterModel != nil) || !(selectedprice.isEmpty){
                if self.selectedFilterModel?.selectedIndex != indexPath.row{
                    self.loadData(filterData: selectedFilterArrayAPI)
                }else{
                    filters[indexPath.row] = self.selectedFilterModel!.selectedFilter
                }
            }
            selectedFilter = indexPath.row
            fieldsCollection.reloadData()
            mainCollection.reloadData()
        }
        else{
            if(filters[selectedFilter].values[indexPath.row].key.contains("price")){
                    print("price yess")

//                    if(cell.minTextfield.text != ""){
//                        selectedprice["min"] = cell.minTextfield.text
//
//                    }
//                    if(cell.maxTextfield.text != ""){
//                        selectedprice["max"] = cell.maxTextfield.text
//                    }
                }
                else{
                    let cell = collectionView.cellForItem(at: indexPath) as! FilterFieldsCollectionCell

                     let data = filters[selectedFilter].filterOptionId
                        let check = filters[selectedFilter].values[indexPath.row].key
                    if(selectedFilterArrayAPI[data]?.contains(check) == true){
                        cell.filterImageView.image = UIImage(named: "unchecked")
                        if let index = selectedFilterArrayAPI[data]?.firstIndex(where: {$0 == check}){
                            print(index)
                            selectedFilterArrayAPI[data]?.remove(at: index)
                        }
                       
                    }
                    else{
                        cell.filterImageView.image = UIImage(named: "check")
                       // selectedFilterArray.append((filters[selectedFilter].values[indexPath.row].key))
                        if selectedFilterArrayAPI.count > 0 && filters[selectedFilter].selectType == "multiple"{
                            selectedFilterArrayAPI.forEach{if $0.key == data{
                                selectedFilterArrayAPI[data]?.append(check)
                            }else{
                                selectedFilterArrayAPI[data] = [check]
                            }}
                        }else{
                            
                            selectedFilterArrayAPI[data] = [check]
                        }
//                        if filters[selectedFilter].selectType == "single"{
//                            cell.filterImageView.isHidden = true
//                            cell.title.textColor = .white
//                            cell.borderline.backgroundColor = .white
//                            cell.backgroundColor = UIColor.AppTheme()
//                        }
                        if (selectedFilterModel?.isSelected == false || selectedFilterModel == nil){
                            self.selectedFilterModel = SelectedFilterModel(isSelected: true, selectedIndex: selectedFilter, selectedFilter: filters[selectedFilter])
                        }
                    }
                    print(selectedFilterArrayAPI)
                   
                }
            //}
        }
        
        checkFilterResetButtons()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView==mainCollection){
            return CGSize(width: collectionView.frame.size.width - 10, height: 40)
        }
//        else{
//            if let input = filters[selectedFilter].values[indexPath.row].input.toJSON() as? [String:AnyObject]{
//                if(input.keys.contains("price")){
//                    return CGSize(width: collectionView.frame.size.width - 10, height: 120)
//                }
//            }
//        }
        return  CGSize(width: collectionView.frame.size.width - 10, height: filters[selectedFilter].filterType == "price" ? 120 : 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
