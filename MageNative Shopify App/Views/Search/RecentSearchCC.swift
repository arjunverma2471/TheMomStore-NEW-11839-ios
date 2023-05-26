//
//  RecentSearchCC.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 22/09/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import UIKit

class RecentSearchCC: UICollectionViewCell {
    static var reuseID = "RecentSearchCC"
    lazy var outerView : UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor(hexString: "#D1D1D1", alpha: 1).cgColor
        view.layer.cornerRadius = 2.0
        return view
    }()
    lazy var itemVal: UILabel = {
        let lbl = UILabel()
        lbl.font = mageFont.regularFont(size: 11)
        lbl.textColor = UIColor(light: .black, dark: UIColor.provideColor(type: .recentSearchView).textColor)
        return lbl
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setView(){
        addSubview(outerView)
        outerView.anchor(top: safeAreaLayoutGuide.topAnchor,left: leadingAnchor,bottom: safeAreaLayoutGuide.bottomAnchor,right: trailingAnchor,paddingTop: 4,paddingLeft: 2,paddingBottom: 4,paddingRight: 2)
        outerView.addSubview(itemVal)
        itemVal.center(inView: outerView)
    }
    func populateData(data: String){
        itemVal.text = data
    }
}
