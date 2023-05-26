//
//  VariantVC.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 12/04/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class VariantVC: UIViewController {
  
  var product: ProductViewModel?
  var disposeBag = DisposeBag()
  
  var selectedVariant: VariantViewModel?{
    didSet{
        selectedVariant?.selectedOptions.forEach { data in
        let dict = [data.name:data.value]
        VariantSelectionManager.shared.setUserSelectedVariants(dict)
      }
    }
  }
    
  lazy var variantTable: UITableView = {
    let table = UITableView()
    table.backgroundColor = .clear
    //      table.separatorStyle = .none
    table.translatesAutoresizingMaskIntoConstraints = false
    let nib = UINib(nibName: VariantVCTVCell.className, bundle: nil)
    table.register(nib, forCellReuseIdentifier: VariantVCTVCell.className)
    table.delegate = self
    table.dataSource = self
    return table
  }()
  
  lazy var stackView:UIStackView = {
    let v = UIStackView()
    v.axis = .horizontal
    v.distribution = .fillEqually
    v.spacing = 10
    v.alignment = .fill
    v.translatesAutoresizingMaskIntoConstraints = false
    return v
  }()
  
  lazy var applyButton:UIButton = {
    let button = UIButton(type: .system)
    button.backgroundColor = .clear
    button.backgroundColor = UIColor.AppTheme()
    button.setTitleColor(UIColor.textColor(), for: .normal)
    button.setTitle("DONE", for: .normal)
    button.titleLabel?.font = mageFont.mediumFont(size: 15.0)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.cornerRadius = 10
    button.rx.tap.bind{[weak self] in
      self?.dismiss(animated: true, completion: nil)
    }.disposed(by: disposeBag)
    return button
  }()
  
  lazy var cancelButton:UIButton = {
    let button = UIButton(type: .system)
    button.backgroundColor = .clear
    button.backgroundColor = UIColor.AppTheme()
    button.setTitleColor(UIColor.textColor(), for: .normal)
    button.setTitle("CANCEL", for: .normal)
    button.titleLabel?.font = mageFont.mediumFont(size: 15.0)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.rx.tap.bind{[weak self] in
      self?.dismiss(animated: true, completion: nil)
    }.disposed(by: disposeBag)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    setupView()
  }
  
  func setupView(){
    
    self.view.addSubview(stackView)
    stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
    stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
    stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
    stackView.heightAnchor.constraint(equalToConstant: 45).isActive = true
//    stackView.addArrangedSubview(cancelButton)
    stackView.addArrangedSubview(applyButton)
    
    self.view.addSubview(variantTable)
    variantTable.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    variantTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    variantTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    variantTable.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: 8).isActive = true
  }
}

extension VariantVC: UITableViewDataSource,UITableViewDelegate{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return product?.model?.options.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: VariantVCTVCell.className, for: indexPath) as! VariantVCTVCell
    cell.selectedVariant = self.selectedVariant
    cell.item = product?.model?.options[indexPath.section]
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let staticHeight = CGFloat(45)
    let count = returnHeight(product?.model?.options[indexPath.section].values.count ?? 0 )
//   debugPrint("See==",CGFloat(count * 50) + CGFloat(staticHeight))
   return CGFloat(count * 45) + CGFloat(staticHeight)
    
  }
  
  func returnHeight(_ count: Int) -> Int {
      if count % 4 != 0{
          return count / 4 + 1
      }
      return count / 4
  }
}
