//
//  KangarooCustomerHistoryViewController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 17/05/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
import DropDown
class KangarooCustomerHistoryViewController: UIViewController {
    let kangarooViewModel = KangarooRewardsViewModel()
    var pageNumber: Int = 1
    fileprivate let contentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(KangarooCustomerHistoryCell.self, forCellWithReuseIdentifier: KangarooCustomerHistoryCell.reuseID)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchHistory(pageNumber: pageNumber)
        self.navigationItem.title = "History"
        view.backgroundColor = .viewBackgroundColor()
        setupUI()
    }
    
    private func setupUI() {
        collectionLayout()
        setupDelegates()
    }
    
    private func collectionLayout() {
        view.addSubview(contentCollectionView)
        contentCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.trailingAnchor)
    }
    
    private func setupDelegates() {
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
    }
    
    private func fetchHistory(pageNumber: Int) {
        self.addLoaderToView()
        kangarooViewModel.fetchKangarooCustomerHistory(pageNumber: pageNumber) {[weak self] result in
            switch result {
            case .success:
                self?.reloadCollection()
            case .failed(let err):
                print("Kangaroo \(err)")
                self?.reloadCollection()
            }
        }
    }
    
    private func addLoaderToView() {
        DispatchQueue.main.async {[weak self] in
            self?.view.isUserInteractionEnabled = false
            self?.view.addLoader()
        }
    }
    
    
    private func reloadCollection() {
        DispatchQueue.main.async {[weak self] in
            self?.contentCollectionView.reloadData()
            self?.view.stopLoader()
            self?.view.isUserInteractionEnabled = true
        }
    }
}

extension KangarooCustomerHistoryViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kangarooViewModel.customerHistory?.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KangarooCustomerHistoryCell.reuseID, for: indexPath) as! KangarooCustomerHistoryCell
        if let history = kangarooViewModel.customerHistory?.data {
            cell.setupData(history: history[indexPath.item])
        }
        cell.copyButtonTapped = {[weak self] in
            self?.view.showmsg(msg: "Code Copied!")
        }
        cell.menuButtonTapped = {[weak self] in
            if let code = cell.codeLabel.text {
                self?.showDropDown(couponCode: code, anchorView: cell.menuButton)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 32, height: 100)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let count = kangarooViewModel.customerHistory?.data?.count else {return}
        if indexPath.item == count - 1 {
            if let next =  kangarooViewModel.customerHistory?.links?.next {
                if next != "" {
                    self.pageNumber += 1
                    self.fetchHistory(pageNumber: self.pageNumber)
                }
            }
        }
            
    }
    
    
}
extension KangarooCustomerHistoryViewController {
    func showDropDown(couponCode: String, anchorView: UIButton) {
        let dropDown = DropDown()
        DropDown.startListeningToKeyboard()
        dropDown.dismissMode = .onTap
        dropDown.direction = .bottom
        DropDown.appearance().setupCornerRadius(10)
        DropDown.appearance().textColor = UIColor.systemRed
        DropDown.appearance().selectedTextColor = UIColor.systemRed
        DropDown.appearance().textFont = mageFont.mediumFont(size: 14)
        DropDown.appearance().cellHeight = 40
        DropDown.appearance().backgroundColor = UIColor(red: 250/255, green: 249/255, blue: 246/255, alpha: 1)
        dropDown.anchorView = anchorView
        dropDown.dataSource = ["Delete Coupon"]
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
           // self.view.addLoader()
            self.cancelCouponCode(coupon: couponCode)
        }
        
        dropDown.width = 200
        
        dropDown.show()
    }
    
    
    private func cancelCouponCode(coupon: String) {
        kangarooViewModel.deleteCoupon(coupon_code: coupon) {[weak self] result in
            switch result {
            case .success:
                self?.fetchHistory(pageNumber: 1)
            case .failed(let err):
                print("Kangaroo err \(err)")
                self?.reloadCollection()
            }
        }
    }
}

