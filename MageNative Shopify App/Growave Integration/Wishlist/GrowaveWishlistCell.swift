//
//  GrowaveWishlistCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 23/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import UIKit

class GrowaveWishlistCell: UICollectionViewCell {
    static let reuseID = "GrowaveWishlistCell"
    var isFromWishlistVC = false
    var deleteButtonTapped: (()->())?
    var editButtonTapped: (()->())?
    fileprivate let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Board Name"
        label.textAlignment = .left
        label.textColor = UIColor(light: UIColor(hexString: "#050505", alpha: 1),dark: UIColor.provideColor(type: .newLoginVC).textColor)
        label.font = mageFont.mediumFont(size: 14)
        return label
    }()
    
    lazy var editButton : UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.setImage(UIImage(named: "pencil")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .black
        button.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var deleteButton : UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.setImage(UIImage(named: "BinBag")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .black
        button.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        return button
    }()
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted && isFromWishlistVC{
                self.layer.cornerRadius = 5
                self.layer.borderColor = UIColor.textColor().cgColor
                self.layer.borderWidth = 1
            }
            else {
                self.layer.cornerRadius = 5
                self.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
                self.layer.borderWidth = 1
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected && isFromWishlistVC{
                self.layer.cornerRadius = 5
                self.layer.borderColor = UIColor.textColor().cgColor
                self.layer.borderWidth = 1
            }
            else {
                self.layer.cornerRadius = 5
                self.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
                self.layer.borderWidth = 1
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.layer.borderWidth = 1
        nameLabelLayout()
        editButtonLayout()
        deleteButtonLayout()
    }
    
    private func nameLabelLayout() {
        contentView.addSubview(nameLabel)
        nameLabel.anchor(top: contentView.topAnchor, left: contentView.leadingAnchor, bottom: contentView.bottomAnchor, right: contentView.trailingAnchor, paddingTop: 8, paddingLeft: 10, paddingBottom: 8, paddingRight: 100)
    }
    
    private func editButtonLayout() {
        contentView.addSubview(editButton)
        editButton.anchor(top: contentView.topAnchor, bottom: contentView.bottomAnchor, right: contentView.trailingAnchor, paddingTop: 8, paddingBottom: 8, paddingRight: 10, width: 20)
    }
    
    private func deleteButtonLayout() {
        contentView.addSubview(deleteButton)
        deleteButton.anchor(top: contentView.topAnchor, bottom: contentView.bottomAnchor, right: editButton.leadingAnchor, paddingTop: 8, paddingBottom: 8, paddingRight: 30, width: 20)
    }
    
    func feedData(board: GrowaveBoardListData) {
        self.nameLabel.text = board.title
    }
    
    @objc func deleteTapped() {
        deleteButtonTapped?()
    }
    
    @objc func editTapped() {
        editButtonTapped?()
    }
    
    func removeProductFromBoard(boardId: String, ids: [GraphQL.ID]) {
        Client.shared.fetchMultiProducts(ids: ids, completion: {[weak self] (response, error) in
            if let response = response {
                response.forEach({ item in
                    guard let productModel = item.model?.viewModel else {return}
                    let wishProduct = CartProduct.init(product: productModel, variant: WishlistManager.shared.getVariant(productModel.variants.items.first!))
                    WishlistManager.shared.removeFromWishList(wishProduct)
                })
            }
        })
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
