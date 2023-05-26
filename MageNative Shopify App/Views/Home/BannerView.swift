//
//  BannerView.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 06/02/20.
//  Copyright © 2020 MageNative. All rights reserved.
//

import UIKit

class BannerView: UIView {
    
    var view: UIView!
    var banners : [[String:String]]?
    var delegate:bannerClicked?
    var singleTopImage: UIImageView?
    var model: HomeTopBarViewModel?
    
    @IBOutlet weak var bannerView: FSPagerView!{
        didSet {
            self.bannerView.automaticSlidingInterval = 4
            self.bannerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    
    @IBOutlet weak var pageControl: FSPageControl!
    
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
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "BannerView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func configure(from model:HomeTopBarViewModel){
        self.model = model;
        self.banners = model.items
        self.bannerView.dataSource = self
        self.bannerView.delegate = self
        self.pageControl.numberOfPages = self.banners?.count ?? 0;
        self.pageControl.contentHorizontalAlignment = .center
        self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        self.pageControl.hidesForSinglePage = true
        
        self.pageControl.backgroundColor = .clear;
        if(model.item_dots != "1")
        {
            pageControl.isHidden = true;
        }
        else{
            pageControl.isHidden = false;
        }
        //self.pageControl.setImage(UIImage(named: "dash"), for: .selected)
        
        //self.pageControl.setImage(nil, for: .normal)
        
        //self.pageControl.setStrokeColor(UIColor.red, for: .selected)
        self.pageControl.setFillColor(model.active_dot_color, for: .selected)
        self.pageControl.setFillColor(model.inactive_dot_color, for: .normal)
        bannerView.reloadData()
    }
}

extension BannerView:FSPagerViewDataSource{
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return banners?.count ?? 0
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        if let imageUrl = banners![index]["image_url"]{
            let url = URL(string: imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            cell.imageView?.setImageFrom(url)
            cell.imageView?.contentMode = .scaleAspectFit
            cell.imageView?.clipsToBounds = true
            cell.layer.shadowColor = UIColor.white.cgColor
            cell.imageView?.layer.shadowColor = UIColor.white.cgColor
            if(model?.shape == "rounded"){
                cell.imageView?.layer.cornerRadius = 15.0
                cell.layer.masksToBounds = true;
                cell.layer.cornerRadius = 15.0;
            }
        }
        return cell
    }
}

extension BannerView:FSPagerViewDelegate{
    // MARK:- FSPagerView Delegate
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        self.delegate?.bannerDidSelect(banner: banners?[index], sender: self)
        
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        self.pageControl.currentPage = pagerView.currentIndex
        if let imageUrl = banners![pagerView.currentIndex]["image_url"]{
            let url = URL(string: imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            //singleTopImage?.setImageFrom(url)
        }
    }
    
    
}
