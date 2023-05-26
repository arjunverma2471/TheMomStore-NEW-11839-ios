//
//  GrowaveWishlistViewController.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 23/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import UIKit

class GrowaveBoardsViewController: UIViewController {
    let growaveWishlistViewModel = GrowaveWishlistViewModel()
    var textField: UITextField?
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
    
    lazy var newBoardButton : UIButton = {
        let button = UIButton()
        button.setTitle("ADD BOARD".localized, for: .normal)
        button.addTarget(self, action: #selector(showInputField), for: .touchUpInside)
        button.cardView()
        button.backgroundColor = UIColor.AppTheme()
        button.setTitleColor(UIColor.textColor(), for: .normal)
        button.titleLabel?.font = mageFont.mediumFont(size: 14)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.showLoader()
        fetchBoards()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .viewBackgroundColor()
        self.title = "Wishlists".localized
        newBoardButtonLayout()
        boardCollectionLayout()
        setupDelegates()
    }
    
    private func boardCollectionLayout() {
        view.addSubview(boardCollectionView)
        boardCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, bottom: newBoardButton.topAnchor, right: view.trailingAnchor, paddingTop: 10, paddingLeft: 16, paddingBottom: 20, paddingRight: 16)
    }
    
    private func newBoardButtonLayout() {
        view.addSubview(newBoardButton)
        newBoardButton.anchor(left: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.trailingAnchor, paddingLeft: 20, paddingBottom: 10, paddingRight: 20, height: 44)
    }
    
    private func setupDelegates() {
        boardCollectionView.delegate = self
        boardCollectionView.dataSource = self
        boardCollectionView.emptyDataSetSource = self
        boardCollectionView.emptyDataSetDelegate = self
    }
    
    private func fetchBoards() {
        growaveWishlistViewModel.fetchBoards {[weak self] result in
            switch result {
            case .success:
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
    
    private func deleteBoard(boardID: String) {
        growaveWishlistViewModel.deleteBoard(boardId: boardID) {[weak self] result in
            switch result {
            case .success:
                self?.fetchBoards()
            case .failed(let err):
                self?.fetchBoards()
                print("DEBUG: \(err)")
            }
        }
    }
    
    private func renameBoard(board_id: String) {
        let alert = UIAlertController(title: "Modify Board".localized, message: "Please enter the board name".localized, preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler:{[weak self] (UIAlertAction) in
            if let board_title = self?.textField?.text{
                self?.modifyBoard(title: board_title, board_id: board_id)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func modifyBoard(title: String, board_id: String) {
        view.showLoader()
        growaveWishlistViewModel.modifyBoard(boardId: board_id, title: title) {[weak self] result in
            switch result {
            case .success:
                self?.fetchBoards()
            case .failed(let err):
                self?.showErrMessage(message: err)
            }
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
    
    func configurationTextField(textField: UITextField!) {
        if (textField) != nil {
            self.textField = textField!
            self.textField?.placeholder = "List name".localized;
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
    
    private func fetchItems(boardId: String) {
        growaveWishlistViewModel.fetchWishlistItems(boardId: boardId) { result in
            switch result {
            case .success:
                print("Successfully fetched items in board")
            case .failed(let err):
                print(err)
            }
        }
    }
    
}

extension GrowaveBoardsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return growaveWishlistViewModel.boards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GrowaveWishlistCell.reuseID, for: indexPath) as! GrowaveWishlistCell
        cell.feedData(board: growaveWishlistViewModel.boards[indexPath.item])
        cell.deleteButtonTapped = {[weak self] in
            self?.fetchItems(boardId: (self?.growaveWishlistViewModel.boards[indexPath.item].boardID)!)
            guard let boardId = self?.growaveWishlistViewModel.boards[indexPath.item].boardID else {return}
            let alert = UIAlertController(title: "Delete Board?".localized, message: "Are you sure you want to delete the board?".localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete".localized, style: .destructive, handler: {[weak self] action in
                cell.removeProductFromBoard(boardId: boardId, ids: self?.growaveWishlistViewModel.wishlistItems ?? [GraphQL.ID]())
                self?.deleteBoard(boardID:  boardId)
            }))
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .default))
            self?.present(alert, animated: true)
        }
        
        cell.editButtonTapped = {[weak self] in
            self?.renameBoard(board_id: self?.growaveWishlistViewModel.boards[indexPath.item].boardID ?? "")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = growaveWishlistViewModel.boards[indexPath.item].boardID {
            let vc = GrowaveBoardWishlistViewController()
            vc.boardID = id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

extension GrowaveBoardsViewController: DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
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

