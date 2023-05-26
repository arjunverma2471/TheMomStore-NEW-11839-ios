//
//  SelectThemeView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 20/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
class SelectThemeView : UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var labelHeading: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    var dataSource = ["Grocery".localized,"MarketPlace".localized,"Fashion".localized]
    var view: UIView!
    override init(frame: CGRect)
    {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    func xibSetup()
    {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        // Make the view stretch with containing view
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        self.setupView()
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func setupView() {
        if #available(iOS 13.0, *) {
            backgroundView.backgroundColor = UIColor.secondarySystemBackground
        } else {
            // Fallback on earlier versions
        }
        closeBtn.setTitle("", for: .normal)
        labelHeading.text = "Theme Designs".localized
        labelHeading.font = mageFont.mediumFont(size: 12.0)
        
        let nib = UINib(nibName: PreviewThemeCell.className, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "PreviewThemeCell")
        
        
        
        
        
        
    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SelectThemeView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func loadData() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
    }
    
    
    
    
    
}
extension SelectThemeView : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviewThemeCell", for: indexPath) as! PreviewThemeCell
        cell.setupData(data: dataSource[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 10, height: collectionView.frame.height / 3 - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = dataSource[indexPath.row]
        if data == "Default".localized {
            UserDefaults.standard.removeObject(forKey: "HomeDataJSON")
            UserDefaults.standard.removeObject(forKey: "staticJSONEnabled")
            UserDefaults.standard.removeObject(forKey: "themeSelected")
            (UIApplication.shared.delegate as! AppDelegate).loadHomepage()
        }
        else {
            guard let path = Bundle.main.path(forResource: "LocalSortData", ofType: "json") else {return}
            guard let value = try? String(contentsOfFile: path) else {return}
             let data = Data(value.utf8)
            UserDefaults.standard.setValue(data, forKey: "HomeDataJSON")
            UserDefaults.standard.setValue(true, forKey: "staticJSONEnabled")
            (UIApplication.shared.delegate as! AppDelegate).loadHomepage()
        }
        
    }
    
    
}
