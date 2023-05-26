//
//  JudgemeImageview.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 02/08/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
class JudgemeImageview: UICollectionViewCell {
   
    lazy var filterImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false;
        image.tintColor = .black
        image.contentMode = .scaleAspectFit
        return image;
    }()
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    private func initView(){
        
        addSubview(filterImageView)
        
        NSLayoutConstraint.activate([
            filterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            filterImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            filterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            filterImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            
            
        ])
        
    }
    
    func setup(url: String){
        filterImageView.setImageFrom(URL(string: url)!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
