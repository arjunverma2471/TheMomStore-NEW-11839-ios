//
//  KangarooRewardsViewController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 27/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import UIKit

class KangarooRewardsViewController: UIViewController {
    private var headerCollectionItems = ["Reward Yourself", "Exclusive Offers", "Tiers",  "Profile"]
    var sliderLeftAnchor: NSLayoutConstraint?
    var bottomView = GrowaveRewardsBottomTabView()
    let kangarooViewModel = KangarooRewardsViewModel()
    
    fileprivate let headerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(KangarooHeaderCollectionCell.self, forCellWithReuseIdentifier: KangarooHeaderCollectionCell.reuseID)
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
        collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: [])
        return collectionView
    }()
    
    fileprivate let contentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(KangarooContentCollectionCell.self, forCellWithReuseIdentifier: KangarooContentCollectionCell.reuseID)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    fileprivate let sliderView: UIView = {
        let view = UIView()
        view.backgroundColor = .AppTheme()
        view.layer.cornerRadius = 2
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let sliderShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        fetchKangarooBranches()
        view.addLoader()
        setupNavigationBar()
        view.backgroundColor = .viewBackgroundColor()
        headerCollectionLayout()
        setupDelegates()
        scrollTo(index: 0)
        sliderViewLayout()
        sliderShadowViewLayout()
        setupBottomView()
        contentCollectionViewLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchEmail()
    }
    
    func setupBottomView() {
        view.addSubview(bottomView)
        bottomView.historyBtn.setTitle("", for: .normal)
        bottomView.historyBtn.addTarget(self, action: #selector(showCustomerHistory(_:)), for: .touchUpInside)
        bottomView.historyBtn.tintColor = .black
        bottomView.faqBtn.isHidden = true
        bottomView.anchor(left: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.trailingAnchor, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, height: 45)
    }
    
    
    
    
    private func setupNavigationBar() {
        navigationItem.title = "Rewards"
    }
    
    private func headerCollectionLayout() {
        view.addSubview(headerCollectionView)
        headerCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingTop: 10, height: 50)
    }
    
    private func contentCollectionViewLayout() {
        view.addSubview(contentCollectionView)
        contentCollectionView.anchor(top: sliderShadowView.bottomAnchor, left: view.leadingAnchor, bottom: bottomView.topAnchor, right: view.trailingAnchor, paddingTop: 10, paddingBottom: 10)
    }
    
    private func sliderShadowViewLayout() {
        view.addSubview(sliderShadowView)
        sliderShadowView.anchor(left: view.leadingAnchor, bottom: sliderView.bottomAnchor, right: view.trailingAnchor, height: 4)
    }
    
    private func sliderViewLayout() {
        view.addSubview(sliderView)
        let height = 4.0
        sliderLeftAnchor = sliderView.leadingAnchor.constraint(equalTo: headerCollectionView.leadingAnchor)
        sliderLeftAnchor?.isActive = true
        sliderView.widthAnchor.constraint(equalTo: headerCollectionView.widthAnchor, multiplier: 1/4).isActive = true
        sliderView.heightAnchor.constraint(equalToConstant: height).isActive = true
        sliderView.bottomAnchor.constraint(equalTo: headerCollectionView.bottomAnchor).isActive = true
        
    }
    
    private func setupDelegates() {
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
    }
    
    @objc func showCustomerHistory(_ sender: UIButton) {
        let vc = KangarooCustomerHistoryViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension KangarooRewardsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == headerCollectionView {
            return headerCollectionItems.count
        }
        else {
            return headerCollectionItems.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == headerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KangarooHeaderCollectionCell.reuseID, for: indexPath) as!  KangarooHeaderCollectionCell
            cell.label.text = headerCollectionItems[indexPath.item]
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KangarooContentCollectionCell.reuseID, for: indexPath) as!  KangarooContentCollectionCell
            cell.backgroundColor = .clear
            cell.parent = self
            cell.cellName = headerCollectionItems[indexPath.row]
            cell.customerData = kangarooViewModel.kangarooProfle
            cell.customerConsent = kangarooViewModel.customerConsent
            cell.customerRewards = kangarooViewModel.customerRewards?.data ?? [KangarooCustomerRewardsData]()
            cell.customerOffers = kangarooViewModel.customerOffers?.data ?? [KangarooCustomerRewardsData]()
            cell.tiers = kangarooViewModel.tiers.first?.tierLevels?.reversed() ?? [KangarooTiersLevel]()
            cell.currentUserPoints = kangarooViewModel.userPoint
            cell.updateKangarooDelegate = self
            cell.reloadCollection()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == contentCollectionView{
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
        else {
            return CGSize(width: (Int(collectionView.frame.size.width) / headerCollectionItems.count), height: 45)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == headerCollectionView {
            let count = CGFloat(headerCollectionItems.count)
            let x = (CGFloat(indexPath.item) * (collectionView.frame.size.width)) / count
            scrollTo(index: indexPath.item)
            sliderLeftAnchor?.constant = x
        }
    }
    
    private func scrollTo(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        contentCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.x / view.frame.size.width)
        headerCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}
extension KangarooRewardsViewController: UpdateKangarooDetils {
    func updateKangarooDetails(firstName: String, lastName: String, email: String, dob: String) {
        view.addLoader()
        kangarooViewModel.updateKangarooAccountDetails(firstName: firstName, lastName: lastName, email: email, dob: dob) {[weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {[weak self] in
                    self?.view.showmsg(msg: "Account Details Successfully Updated.")
                }
                self?.fetchUser(email: email)
            case .failed(let err):
                print("Kangaroo \(err)")
            }
        }
    }
    
    func updateKangarooConsent(allow_sms: Bool, allow_email: Bool) {
        view.addLoader()
        if let userId = UserDefaults.standard.value(forKey: "kangarooUserId") as? String {
            kangarooViewModel.kangarooCustomerConsents(userId: userId, allow_sms: allow_sms, allow_email: allow_email)

        }
                
    }
    
    func fetchUser(email: String) {
        kangarooViewModel.fetchKangarooCustomer(email: email) {[weak self] result in
            switch result {
            case .success:
                self?.fetchKangarooCustomerRewards()
                self?.fetchKangarooCustomerOffers()
                self?.fetchKangarooTiers()
                self?.fetchCustomerConsent()
                DispatchQueue.main.async {
                    self?.bottomView.pointsLabel.text = "\(self?.kangarooViewModel.userPoint ?? 0)"
                }
                self?.reloadCollections()
            case .failed(let err):
                print("Kangaroo \(err)")
                self?.view.stopLoader()
            }
        }
    }
    
    func fetchEmail() {
        Client.shared.fetchCustomerDetails(completeion: {[weak self]
            response,error in
            if let response = response {
                if let email = response.email {
                    self?.fetchUser(email: email)
                    
                }
            }else {
                self?.view.stopLoader()
                self?.showErrorAlert(error: error?.localizedDescription)
            }
        })
    }
    
    func fetchKangarooCustomerRewards() {
        kangarooViewModel.fetchKangarooCustomerRewards(pageNumber: 1) {[weak self] result in
            switch result {
            case .success:
                self?.reloadCollections()
            case .failed(let err):
                print("Kanagrooo \(err)")
            }
        }
    }
    
    func fetchKangarooCustomerOffers() {
        kangarooViewModel.fetchKangarooCustomerOffers(pageNumber: 1) {[weak self] result in
            switch result {
            case .success:
                self?.reloadCollections()
            case .failed(let err):
                print("Kanagrooo \(err)")
            }
        }
    }
    
    func fetchKangarooTiers() {
        kangarooViewModel.fetchKangarooTiers {[weak self] result in
            switch result {
            case .success:
                self?.reloadCollections()
            case .failed(let err):
                print("Kanagrooo \(err)")
            }
        }
    }
    
    
    func fetchCustomerConsent() {
        kangarooViewModel.fetchCustomerConsent {[weak self] result in
            switch result {
            case .success:
                self?.reloadCollections()
            case .failed(let err):
                print("Kanagrooo \(err)")
            }
        }
    }
    func fetchKangarooBranches() {
        kangarooViewModel.fetchKangarooBranches { result in
            switch result {
            case .success:
                print("Successfully got branches")
            case .failed(let err):
                print("Kangaroo err \(err)")
            }
        }
    }
    
    
    private func reloadCollections() {
        DispatchQueue.main.async {[weak self] in
            self?.contentCollectionView.reloadData()
            self?.headerCollectionView.reloadData()
            self?.headerCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: [])
            self?.view.stopLoader()
        }
    }
}
