//
//  RecentSearchView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 22/09/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation

class RecentSearchView: UIView{
    var view : UIView!
    @IBOutlet weak var recentSearchLbl: UILabel!
    
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var topLineView: UIView!
    
    @IBOutlet weak var bottomLineView: UIView!
    
    @IBOutlet weak var recentCollection: UICollectionView!
    
    var selectRecentItem: ((String) -> Void)?
    var recentSearchData: [String]? {
        didSet{
            if recentSearchData?.count ?? 0 > 0 {
                recentCollection.delegate = self
                recentCollection.dataSource = self
                recentCollection.reloadData()
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    required init?(coder aDecoder: NSCoder)
      {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        setView()
      }
    
    func setView(){
        view = loadViewFromNib()
        // use bounds not frame or it'll be offset
        view.frame = bounds
        // Make the view stretch with containing view
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        recentCollection.register(RecentSearchCC.self, forCellWithReuseIdentifier: RecentSearchCC.reuseID)
        
        topLineView.backgroundColor = UIColor(hexString: "#D1D1D1")
        bottomLineView.backgroundColor = UIColor(hexString: "#D1D1D1")
        clearBtn.contentHorizontalAlignment = .right
        clearBtn.setTitle("Clear All".localized, for: .normal)
        clearBtn.setTitleColor(.red, for: .normal)
        clearBtn.backgroundColor = UIColor(light: .white, dark: UIColor.provideColor(type: .recentSearchView).backGroundColor)
        clearBtn.titleLabel?.font = mageFont.regularFont(size: 12)
        clearBtn.semanticContentAttribute = Client.locale == "ar" ? .forceRightToLeft : .forceLeftToRight

        
        recentSearchLbl.text = "Recent Search".localized
        recentSearchLbl.font = mageFont.mediumFont(size: 15)
        addSubview(view)
    }
    func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "RecentSearchView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
extension RecentSearchView: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recentSearchData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recentCollection.dequeueReusableCell(withReuseIdentifier: RecentSearchCC.reuseID, for: indexPath) as! RecentSearchCC
        cell.populateData(data: recentSearchData?[indexPath.row] ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = (recentSearchData?[indexPath.item] ?? "") as NSString
        let width = text.size(withAttributes: [.font: mageFont.setFont(fontWeight: "regular", fontStyle: "normal", fontSize:  14)]).width
       return CGSize(width: width + 24, height: 35)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectRecentItem?(recentSearchData?[indexPath.row] ?? "")
    }
}
