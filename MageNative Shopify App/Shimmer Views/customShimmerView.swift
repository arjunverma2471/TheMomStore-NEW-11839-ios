//
//  customShimmerView.swift
//  MageNative Magento Platinum
//
//  Created by Cedcoss on 14/02/22.
//  Copyright © 2022 CEDCOSS Technologies Private Limited. All rights reserved.
//

import UIKit

class customShimmerView: UIView {

    var cellsArray = [bannerShimmerTC.reuseID,bannerShimmerTC.reuseID,bannerShimmerTC.reuseID,bannerShimmerTC.reuseID,bannerShimmerTC.reuseID]
    var productListingCount = 2
    
    lazy var shimmerTable:UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
//        table.backgroundColor = .clear
        table.estimatedRowHeight = 285
        table.register(categoryShimmerTC.self, forCellReuseIdentifier: categoryShimmerTC.reuseId)
        table.register(bannerShimmerTC.self, forCellReuseIdentifier: bannerShimmerTC.reuseID)
        table.register(productListingShimmerTC.self, forCellReuseIdentifier: productListingShimmerTC.reuseID)
        table.register(wishlistProductShimmerTC.self, forCellReuseIdentifier: wishlistProductShimmerTC.reuseID)
        table.register(orderListShimmerTC.self, forCellReuseIdentifier: orderListShimmerTC.reuseID)
        table.register(priceTotalShimmerTC.self, forCellReuseIdentifier: priceTotalShimmerTC.reuseId)
        table.register(cartproductShimmerTC.self, forCellReuseIdentifier: cartproductShimmerTC.reuseID)
        table.register(priceTotalShimmerTC.self, forCellReuseIdentifier: priceTotalShimmerTC.reuseId)
        table.delegate = self
        table.dataSource = self
        return table
    }()

    //MARK: - Initializers

    convenience init(cellsArray:[String],productListCount:Int = UIDevice.current.model.lowercased() == "ipad".lowercased() ? 4 : 2) {
        self.init(frame: .zero)
        self.cellsArray = cellsArray
        self.productListingCount = productListCount
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
//        backgroundColor = .darkGray
//        startShimmeringEffect()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - UIHelpers

    func configureUI(){
        addSubview(shimmerTable)
        shimmerTable.anchor(top: topAnchor, left: leadingAnchor, bottom: bottomAnchor, right: trailingAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
    }
}

//MARK: - UITableView Implementation

extension customShimmerView:UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellItem = cellsArray[indexPath.row]
        print("cellItem\(cellItem)")
        
        switch cellItem{
        case bannerShimmerTC.reuseID:
            let cell = tableView.dequeueReusableCell(withIdentifier: bannerShimmerTC.reuseID, for: indexPath) as! bannerShimmerTC
            cell.populate()
            return cell
        case productListingShimmerTC.reuseID:
            let cell = tableView.dequeueReusableCell(withIdentifier: productListingShimmerTC.reuseID, for: indexPath) as! productListingShimmerTC
            cell.populate(with: productListingCount)
            return cell
        case categoryShimmerTC.reuseId:
            let cell = tableView.dequeueReusableCell(withIdentifier: categoryShimmerTC.reuseId, for: indexPath) as! categoryShimmerTC
            cell.populateWithCategory()
            return cell
        case wishlistProductShimmerTC.reuseID:
            let cell = tableView.dequeueReusableCell(withIdentifier: wishlistProductShimmerTC.reuseID, for: indexPath) as! wishlistProductShimmerTC
            cell.populate()
            return cell
        case orderListShimmerTC.reuseID:
            let cell = tableView.dequeueReusableCell(withIdentifier: orderListShimmerTC.reuseID, for: indexPath) as! orderListShimmerTC
            cell.populate()
            return cell
        case priceTotalShimmerTC.reuseId:
            let cell = tableView.dequeueReusableCell(withIdentifier: priceTotalShimmerTC.reuseId, for: indexPath) as! priceTotalShimmerTC
            cell.populate()
            return cell
        case cartproductShimmerTC.reuseID:
            let cell = tableView.dequeueReusableCell(withIdentifier: cartproductShimmerTC.reuseID, for: indexPath) as! cartproductShimmerTC
            cell.populate()
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: bannerShimmerTC.reuseID, for: indexPath) as! bannerShimmerTC
            cell.populate()
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch cellsArray[indexPath.row]{
        case bannerShimmerTC.reuseID:
            return 285
        case categoryShimmerTC.reuseId:
            return 80
        case productListingShimmerTC.reuseID:
            return CGFloat((productListingCount/2 + productListingCount%2)*270)
        case wishlistProductShimmerTC.reuseID:
            return 110
        case orderListShimmerTC.reuseID:
            return 180
        case priceTotalShimmerTC.reuseId:
            return 145
        case cartproductShimmerTC.reuseID:
            return 150
        default:
            return 285
        }
    }

}
