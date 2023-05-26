//
//  WishlistBoardsView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 23/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import UIKit
protocol ReloadWishlistItem {
    func reloadWishlistItem(productID: String, indexPath: IndexPath)
}
protocol ItemMoveToBoard {
    func itemMoveToBoard()
}
class WishlistBoardsView: UIViewController {
    let growaveWishlistViewModel = GrowaveWishlistViewModel()
    var product : ProductViewModel!
    var current_board_id: String = ""
    var destinationBoardID = ""
    var textField: UITextField?
    var indexPath: IndexPath?
    var delegate: ReloadWishlistItem!
    var itemMoveToBoardDelegate: ItemMoveToBoard!
    var isFromChangeBoard = false
    var boardID = ""
    lazy var dismissButton : UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.setImage(UIImage(named: "cancelled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .black
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()
    
    fileprivate let seperator: UIView = {
        let seperatorLine = UIView()
        seperatorLine.cardView()
        seperatorLine.backgroundColor = UIColor.lightGray
        return seperatorLine
    }()
    
    lazy var boardButton : UIButton = {
        let button = UIButton()
        button.setTitle("ADD BOARD".localized, for: .normal)
        button.addTarget(self, action: #selector(showInputField), for: .touchUpInside)
        button.cardView()
        button.backgroundColor = UIColor.AppTheme()
        button.setTitleColor(UIColor.textColor(), for: .normal)
        button.titleLabel?.font = mageFont.mediumFont(size: 14)
        return button
    }()
    
    lazy var wishListButton : UIButton = {
        let button = UIButton()
        button.setTitle("ADD TO WISHLIST".localized, for: .normal)
        button.addTarget(self, action: #selector(addToWishlist), for: .touchUpInside)
        button.cardView()
        button.backgroundColor = UIColor.AppTheme().withAlphaComponent(0.8)
        button.setTitleColor(UIColor.textColor(), for: .normal)
        button.titleLabel?.font = mageFont.mediumFont(size: 14)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    fileprivate let boardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        if #available(iOS 13.0, *) {
            collection.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .productListVC).collectionViewBackgroundColor)
        } else {
            collection.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .productListVC).collectionViewBackgroundColor)
            // Fallback on earlier versions
        }
        collection.showsVerticalScrollIndicator = false
        collection.register(GrowaveWishlistCell.self, forCellWithReuseIdentifier: GrowaveWishlistCell.reuseID)
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewBackgroundColor()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.showLoader()
        fetchBoards()
    }
    
    private func setupUI() {
        dismissButtonLayout()
        seperatorLayout()
        boardbuttonLayout()
        wishlistButtonLayout()
        setupDelegates()
        boardCollectionViewLayout()
    }
    
    private func dismissButtonLayout() {
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.trailingAnchor, paddingTop: 10, paddingBottom: 10, paddingRight: 20, width: 30, height: 30)
    }
    
    private func seperatorLayout() {
        view.addSubview(seperator)
        seperator.anchor(top: dismissButton.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingTop: 10, height: 2)
    }
    
    private func boardbuttonLayout() {
        view.addSubview(boardButton)
        boardButton.anchor(left: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.trailingAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, height: 44)
    }
    
    private func wishlistButtonLayout() {
        if isFromChangeBoard {
            wishListButton.setTitle("Move".localized, for: .normal)
        }
        else {
            wishListButton.setTitle("ADD TO WISHLIST".localized, for: .normal)
        }
        view.addSubview(wishListButton)
        wishListButton.anchor(left: view.leadingAnchor, bottom: boardButton.topAnchor, right: view.trailingAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, height: 44)
    }
    
    
    private func boardCollectionViewLayout() {
        view.addSubview(boardCollectionView)
        boardCollectionView.anchor(top: seperator.bottomAnchor, left: view.leadingAnchor, bottom: wishListButton.topAnchor, right: view.trailingAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 10, paddingRight: 20)
    }
    
    private func setupDelegates() {
        boardCollectionView.delegate = self
        boardCollectionView.dataSource = self
    }
    
    private func fetchBoards() {
        growaveWishlistViewModel.fetchBoards {[weak self] result in
            switch result {
            case .success:
                if self?.isFromChangeBoard == true{
                    self?.growaveWishlistViewModel.boards =  self?.growaveWishlistViewModel.boards.filter({$0.boardID != self?.boardID}) ?? [GrowaveBoardListData]()
                }
                self?.reloadCollection()
            case .failed(let err):
                self?.showErrMessage(message: err)
            }
        }
    }
    
    private func createBoard(title: String) {
        growaveWishlistViewModel.createBoard(title: title) {[weak self] result in
            switch result {
            case .success:
                self?.fetchBoards()
            case .failed(let err):
                self?.showErrMessage(message: err)
            }
        }
    }
    
    private func reloadCollection() {
        DispatchQueue.main.async {[weak self] in
            self?.boardCollectionView.reloadData()
            self?.view.hideLoader()
        }
    }
    
    private func showErrMessage(message: String) {
        DispatchQueue.main.async {[weak self] in
            self?.view.hideLoader()
            print("DEBUG: \(message)")
            self?.view.showmsg(msg: message)
        }
    }
    
    func configurationTextField(textField: UITextField!) {
        if (textField) != nil {
            self.textField = textField!
            self.textField?.placeholder = "List name".localized;
        }
    }
    
    @objc func showInputField() {
        let alert = UIAlertController(title: "Add New Board".localized, message: "Please enter the board name".localized, preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Ok".localized, style: .default, handler:{[weak self] (UIAlertAction) in
            if let board_title = self?.textField?.text{
                self?.createBoard(title: board_title)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addToWishlist() {
        moveProduct(destinationBoardID: destinationBoardID)
        
    }
    
    private func moveProduct(destinationBoardID: String) {
        guard let productId = product.id.components(separatedBy: "/").last else {return}
        if isFromChangeBoard {
            changeBoard(destination_board_id: destinationBoardID)
        }
        else {
            growaveWishlistViewModel.addToWishlist(productId: productId, boardId: current_board_id) {[weak self] result in
                switch result {
                case .success:
                    self?.addToLocalWishlist(productID: productId)
                    if let indexPath = self?.indexPath {
                        self?.delegate.reloadWishlistItem(productID: productId, indexPath: indexPath)
                    }
                    self?.dismiss()
                case .failed(let err):
                    print("DEBUG: \(err)")
                    self?.showMessage(message: "The product is already in the wishlist.".localized)
                }
            }
        }
       
    }
    
    private func addToLocalWishlist(productID: String) {
        DispatchQueue.main.async {[weak self] in
            let item = self?.product.variants.items.first
            let wishProduct = CartProduct.init(product: self?.product, variant: WishlistManager.shared.getVariant(item!))
            if WishlistManager.shared.isProductVariantinWishlist(product: wishProduct){
                WishlistManager.shared.removeFromWishList(wishProduct)
                let msg =  "Item removed from wishlist.".localized
                self?.view.showmsg(msg: msg)
            }
            else {
                let msg =  "Item added to wishlist.".localized
                self?.view.showmsg(msg: msg)
                WishlistManager.shared.addToWishList(wishProduct)
            }
            self?.setupTabbarCount()
            if let indexPath = self?.indexPath {
                self?.delegate.reloadWishlistItem(productID: productID, indexPath: indexPath)
            }
        }
        
    }
    
    private func changeBoard(destination_board_id: String) {
        guard let productId = product.id.components(separatedBy: "/").last else {return}
        growaveWishlistViewModel.moveProductToBoard(product_id: productId, current_board_id: boardID, destination_board_id: destination_board_id) {[weak self] result in
            switch result {
            case .success:
                self?.dismiss()
                self?.itemMoveToBoardDelegate.itemMoveToBoard()
                self?.showMessage(message: "Product is successfuly moved to the board.")
            case .failed(let err):
                print("DEBUG: \(err)")
            }
        }
    }
    
    private func dismiss() {
        DispatchQueue.main.async {[weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    private func showMessage(message: String) {
        DispatchQueue.main.async {[weak self] in
            self?.view.showmsg(msg: message)
        }
    }
}

extension WishlistBoardsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return growaveWishlistViewModel.boards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GrowaveWishlistCell.reuseID, for: indexPath) as! GrowaveWishlistCell
        cell.backgroundColor = UIColor.AppTheme()
        cell.deleteButton.isHidden = true
        cell.editButton.isHidden = true
        cell.isFromWishlistVC = true
        cell.feedData(board: growaveWishlistViewModel.boards[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = growaveWishlistViewModel.boards[indexPath.item].boardID {
            if isFromChangeBoard {
                guard let id = growaveWishlistViewModel.boards[indexPath.item].boardID else {return}
                self.destinationBoardID = id
                self.wishListButton.backgroundColor = UIColor.AppTheme()
                self.wishListButton.isUserInteractionEnabled = true
            }
            else {
                self.current_board_id = id
                self.wishListButton.backgroundColor = UIColor.AppTheme()
                self.wishListButton.isUserInteractionEnabled = true
            }
            
        }
        if isFromChangeBoard {
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    
}

extension WishlistBoardsView: DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "No board list".localized)
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return  growaveWishlistViewModel.boards.count == 0
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "")
    }
}


