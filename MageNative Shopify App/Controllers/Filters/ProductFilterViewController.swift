//
//  ProductFilterViewController.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 09/03/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit
import MobileBuySDK
import RxSwift

protocol FilterClicked{

   //func applyFilter(selectedPrice:[String:String], filter: [String], filterCount:[String:Int])
    func applyFilter(selectedPrice:[Double], filter: [String], filterCount:[String:Int])
    func applyBoostCommerceFilterFromAPI(selectedPrice: [String : String], filter: [String:[String]], selectedFilter: SelectedFilterModel?)

}

class ProductFilterViewController: BaseViewController {

    var delegate: FilterClicked?
    
    var disposeBag = DisposeBag()
    var selectFilterCount = [String:Int]()
    fileprivate lazy var applyFilterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.backgroundColor = .AppTheme()
        button.setTitleColor(UIColor.textColor(), for: .normal)
        button.setTitle("Apply Filter".localized, for: .normal)
        button.titleLabel?.font = mageFont.mediumFont(size: 16.0)
        return button;
    }()
    
    fileprivate lazy var resetButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.backgroundColor = .white
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(hexString: "#D1D1D1").cgColor
        button.setTitle("Reset".localized, for: .normal)
        button.setTitleColor(UIColor.AppTheme(), for: .normal)
        button.backgroundColor = UIColor.white
        button.titleLabel?.font = mageFont.mediumFont(size: 16.0)
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
        collectionView.backgroundColor = UIColor(light: UIColor(hexString: "#F2F2F2"),dark: UIColor.init(hexString: "#524e50"))
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
    
    var priceRange = [Int:[Double]]()
    
    var priceSelected = [Double]()
    
    var handleString = ""
    
    var filters: [AvailableFilterViewModel] = []{
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        let titleWidth = ("Apply Filter".localized as NSString).size(withAttributes: [NSAttributedString.Key.font: mageFont.mediumFont(size: 16)]).width
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: titleWidth, height: 30))
        title.font = mageFont.mediumFont(size: 16)
        title.text = "Apply Filter".localized
        title.textColor = UIColor(light: Client.navigationThemeData?.icon_color ?? .white, dark: .white)
        navigationItem.leftBarButtonItems?.append(UIBarButtonItem(customView: title))
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func resetClicked(_ sender: UIButton){
           
          
        if self.selectedFilterArray.isEmpty && self.priceSelected.isEmpty{//&& self.selectedprice.isEmpty {
       
               self.navigationController?.popViewController(animated: true, completion: {
                   
               })
           }
           else{
           self.navigationController?.popViewController(animated: true, completion: {
              // self.delegate?.applyFilter(selectedPrice: [String:String](), filter: [String](),filterCount: [:])
               self.delegate?.applyFilter(selectedPrice: [], filter: [String](),filterCount: [:])
           })
           }
           
           
       }
    
    
    @objc func applyClicked(_ sender: UIButton){
//        print("1====>",self.selectedFilterArray)
//        print("2=====>",self.selectedprice)
        
        if self.selectedFilterArray.isEmpty && self.priceSelected.isEmpty {//&& self.selectedprice.isEmpty {
            self.view.showmsg(msg: "Please select any filter to apply".localized)
            return;
        }
        self.navigationController?.popViewController(animated: true, completion: {
            self.delegate?.applyFilter(selectedPrice: self.priceSelected, filter: self.selectedFilterArray,filterCount: self.selectFilterCount)
           // self.delegate?.applyFilter(selectedPrice: self.selectedprice, filter: self.selectedFilterArray,filterCount: self.selectFilterCount)
        })
    }
    
    private func initView(){
        view.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .filterViewController).backGroundColor)
//        view.addSubview(applyFilterButton)
//        view.addSubview(resetButton)
        view.addSubview(filterBtnStack)
        view.addSubview(mainCollection)
        view.addSubview(fieldsCollection)
        view.addSubview(borderLine)
        filterBtnStack.anchor(left: view.leadingAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.trailingAnchor,paddingLeft: 16,paddingBottom: 8,paddingRight: 16, height: 50)
        NSLayoutConstraint.activate([
            mainCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mainCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            mainCollection.bottomAnchor.constraint(equalTo: filterBtnStack.topAnchor, constant: -8),
            fieldsCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            fieldsCollection.topAnchor.constraint(equalTo: mainCollection.topAnchor),
            fieldsCollection.bottomAnchor.constraint(equalTo: mainCollection.bottomAnchor),
            mainCollection.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            fieldsCollection.leadingAnchor.constraint(equalTo: mainCollection.trailingAnchor),
            borderLine.heightAnchor.constraint(equalTo: mainCollection.heightAnchor),
            borderLine.leadingAnchor.constraint(equalTo: mainCollection.trailingAnchor, constant: 2),
            borderLine.bottomAnchor.constraint(equalTo: filterBtnStack.topAnchor),
        ])
        applyFilterButton.addTarget(self, action: #selector(applyClicked(_:)), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetClicked(_:)), for: .touchUpInside)
        loadData()
        checkFilterResetButtons()
    }
    
    func checkFilterResetButtons(){
        if selectedFilterArray.count > 0 || self.priceSelected.count > 0 {//self.selectedprice.count > 0{
            self.resetButton.alpha  = 1.0
            self.resetButton.isEnabled = true
            self.applyFilterButton.isEnabled = true
            self.applyFilterButton.alpha = 1.0
            let itemCount = selectFilterCount.filter{$0.value > 0}
            if itemCount.count > 0 {
                self.applyFilterButton.setTitle("Apply Filter(\(itemCount.count))", for: .normal)
            }
            else {
                self.applyFilterButton.setTitle("Apply Filter".localized, for: .normal)
            }
            
        }
        else{
            self.resetButton.alpha = 0.5
            self.applyFilterButton.alpha = 0.5
            self.resetButton.isEnabled = false
            self.applyFilterButton.isEnabled = false
            self.applyFilterButton.setTitle("Apply Filter".localized, for: .normal)
        }
    }
    
    func loadData(){
        Client.shared.fetchAvailableFilters(handle: handleString) { [weak self] filter, error in
            if(error==nil){
                if let filter = filter{
                    self?.filters = filter
                    if let defaultCurrency = UserDefaults.standard.value(forKey: "defaultCurrency") as? String{
                        if(defaultCurrency != CurrencyCode.shared.getCurrencyCode()){
                            self?.filters = filter.filter{$0.filterType != "PRICE_RANGE"}
                        }
                    }
                    let priceFilter = filter.filter{$0.filterType == "PRICE_RANGE"}
                    if let input = priceFilter.first?.values.first?.input.toJSON() as? [String:Any]{
                        if let price = input["price"] as? [String:Double]{
                            if var minPrice = price["min"], var maxPrice = price["max"] {
                                self?.getIntervals(min: &minPrice, max: &maxPrice, interval: 5)
                                print(self?.priceRange.count)
                                
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    
    func getIntervals( min:inout Double, max:inout Double, interval:Int)
    {
        max -= min
        let size = round((max-1)/Double(interval))
        for i in 0..<interval {
            var result = [Double]()
            let inf = i + i * Int(size);
            let sup = Double(inf) + size < max ? Double(inf) + size: max;
            result.append(Double(inf)+min)
            result.append(sup+min)
            self.priceRange[i] = result
            if(inf >= Int(max) || sup >= max){break;}
        }
        
    }


}
extension ProductFilterViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView==mainCollection){
            return filters.count
        }
        else{
            if(filters.count>0){
                if filters[selectedFilter].filterType == "PRICE_RANGE" {
                    return priceRange.count
                }
                else {
                    return filters[selectedFilter].values.count
                }
                
            }
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == mainCollection){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterMainCollectionCell.className, for: indexPath) as! FilterMainCollectionCell
            if(selectedFilter == indexPath.row){
                cell.configure(filter: filters[indexPath.row], selected: true, selectedFilterCount: self.selectFilterCount)
            }
            else{
                cell.configure(filter: filters[indexPath.row], selected: false, selectedFilterCount: self.selectFilterCount)
            }
            return cell;
        }
        else{
            if filters[selectedFilter].filterType == "PRICE_RANGE" {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterFieldsCollectionCell.className, for: indexPath) as! FilterFieldsCollectionCell
                cell.configurePrice(data: self.priceRange[indexPath.row] ?? [], selectedPrice: priceSelected)
                return cell
                
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterFieldsCollectionCell.className, for: indexPath) as! FilterFieldsCollectionCell
                cell.configure(filter: filters[selectedFilter].values[indexPath.row], selectedFilters: selectedFilterArray)
                
                return cell;
            }
         /*   if let input = filters[selectedFilter].values[indexPath.row].input.toJSON() as? [String:AnyObject]{
                if(input.keys.contains("price")){
                    if customAppSettings.sharedInstance.boostCommerceEnabled {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterPriceCollectionCell.className, for: indexPath) as! FilterPriceCollectionCell
                        cell.parent = self;
                        cell.configure(filter: filters[selectedFilter].values[indexPath.row], selectedPrice: selectedprice)
                        cell.closureToPriceUpdate = { [weak self] dt in
                            self?.selectedprice = dt
                            self?.checkFilterResetButtons()
                        }
                        return cell;
                    }
                    else {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterFieldsCollectionCell.className, for: indexPath) as! FilterFieldsCollectionCell
                        cell.configurePrice(data: self.priceRange[indexPath.row] ?? [], selectedPrice: [])
                        return cell
                    }
                    
                }
                else{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterFieldsCollectionCell.className, for: indexPath) as! FilterFieldsCollectionCell
                    cell.configure(filter: filters[selectedFilter].values[indexPath.row], selectedFilters: selectedFilterArray)
                    
                    return cell;
                }
            }
            */
        }
    }
}

extension ProductFilterViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == mainCollection){
            selectedFilter = indexPath.row
            fieldsCollection.reloadData()
            mainCollection.reloadData()
        }
        else{
            if filters[selectedFilter].filterType == "PRICE_RANGE" {
                
                //    if let input = filters[selectedFilter].values[indexPath.row].input.toJSON() as? [String:AnyObject]{
                
                //                if(input.keys.contains("price")){
                //                    print("price yess")
                //
                //                }
                
                let datatoCheck = priceRange[indexPath.row] ?? []
                if priceSelected.contains(datatoCheck.first ?? 0.0) && priceSelected.contains(datatoCheck.last ?? 0.0) {
                    priceSelected = []
                    self.selectFilterCount[filters[selectedFilter].filterId] = 0
                }
                else {
                    priceSelected = datatoCheck
                    self.selectFilterCount[filters[selectedFilter].filterId] = 1
                }
                fieldsCollection.reloadData()
                
            }
                else{
                    let cell = collectionView.cellForItem(at: indexPath) as! FilterFieldsCollectionCell
                    
                    
                    if(selectedFilterArray.contains(filters[selectedFilter].values[indexPath.row].input)){
                        cell.filterImageView.image = UIImage(named: "unchecked")
                        cell.filterImageView.tintColor = UIColor(hexString: "#9E9E9E")
                        if let index = selectedFilterArray.firstIndex(of: filters[selectedFilter].values[indexPath.row].input){
                            selectedFilterArray.remove(at: index)
                            var value = self.selectFilterCount[filters[selectedFilter].filterId] ?? 0
                            value -= 1
                            self.selectFilterCount[filters[selectedFilter].filterId] = value
                        }
                        
                    }
                    else{
                        cell.filterImageView.image = UIImage(named: "check")
                        cell.filterImageView.tintColor = .AppTheme()
                        selectedFilterArray.append(filters[selectedFilter].values[indexPath.row].input)
                        var value = self.selectFilterCount[filters[selectedFilter].filterId] ?? 0
                        value += 1
                        self.selectFilterCount[filters[selectedFilter].filterId] = value

                    }
                    
                }
                mainCollection.reloadData()
//            }
        }
        
        checkFilterResetButtons()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView==mainCollection){
            return CGSize(width: collectionView.frame.size.width, height: 40)
        }
        else{
            return CGSize(width: collectionView.frame.size.width - 10, height: 40)
//            if let input = filters[selectedFilter].values[indexPath.row].input.toJSON() as? [String:AnyObject]{
//                if(input.keys.contains("price")){
//                    return CGSize(width: collectionView.frame.size.width, height: 120)
//                }
//            }
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}

