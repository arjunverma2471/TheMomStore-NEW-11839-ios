//
//  BottomSortVC.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 13/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import UIKit
import BottomPopup

protocol SortingSelected {
    func sortingSelected(sortValue:String)
}


class BottomSortVC: BottomPopupViewController {
    
    var height: CGFloat?
    
    var sortDelegate: SortingSelected?
    var currentSortKey: String?
    
    lazy var headingLabel:UILabel = {
        let l = UILabel()
        l.text = "Sort By".localized
        l.font = UIFont.init(name: "Poppins-Medium", size: 15)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var seperatorView:UIView = {
        let l = UIView()
        l.backgroundColor = UIColor(light: UIColor.init(hexString: "#D1D1D1"))
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    var parentVC: ProductListVC?
    
    var selectedSortValue: Int?{
        didSet{
            sortTable.reloadData()
        }
    }
    
    lazy var closeButton:UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "closeSort")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitleColor(UIColor(hexString: "#1c2b04"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 13)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var sortTable: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        let nib = UINib(nibName: "SortTVCells", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "SortTVCells")
      
                table.delegate = self
                table.dataSource = self
        return table
    }()
    
    var sortKeys: [String]?{
        didSet{
            self.sortTable.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
    }
    
    override var popupHeight: CGFloat { height ?? CGFloat(UIScreen.main.bounds.size.height / 1.5) }
    
    func initView(){
        view.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .quickAddToCart).backGroundColor)
        
        view.addSubview(headingLabel)
        headingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        headingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 15).isActive = true
        headingLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        
        view.addSubview(closeButton)
        closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        closeButton.centerYAnchor.constraint(equalTo: headingLabel.centerYAnchor, constant: 0).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 28).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        view.addSubview(seperatorView)
        seperatorView.leadingAnchor.constraint(equalTo: headingLabel.leadingAnchor, constant: 0).isActive = true
        seperatorView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 15).isActive = true
        seperatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        view.addSubview(sortTable)
        sortTable.leadingAnchor.constraint(equalTo: seperatorView.leadingAnchor, constant: 0).isActive = true
        sortTable.topAnchor.constraint(equalTo: seperatorView.bottomAnchor, constant: 15).isActive = true
        sortTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        sortTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
        sortTable.showsVerticalScrollIndicator = false
        closeButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        
    }
    
    @objc func dismissSelf(sender: UIButton){
        self.dismiss(animated: true)
    }
}


extension BottomSortVC: UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortKeys?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SortTVCells", for: indexPath) as! SortTVCells
        cell.sortHeader.text = sortKeys?[indexPath.row]
        cell.selectionStyle  = .none
        if selectedSortValue == indexPath.row{
            cell.sortStatusImage.image  = UIImage(named: "radio_checked")?.withRenderingMode(.alwaysTemplate)
            cell.sortStatusImage.tintColor = UIColor.AppTheme()
        }else{
            cell.sortStatusImage.image = UIImage(named: "radio_unchecked")?.withRenderingMode(.alwaysTemplate)
            cell.sortStatusImage.tintColor = UIColor.init(hexString: "#D1D1D1")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSortValue = indexPath.row
        sortTable.reloadData()
        if let key = sortKeys?[indexPath.row].localized{
            sortDelegate?.sortingSelected(sortValue: key)
        }
        self.dismiss(animated: true)
    }
}
