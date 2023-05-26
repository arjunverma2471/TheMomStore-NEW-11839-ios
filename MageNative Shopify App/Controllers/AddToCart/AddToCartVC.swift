//
//  AddToCartVC.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 27/01/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddToCartVC: UIViewController {
  
  lazy var selectOptionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false;
    label.text = "Select Options".localized;
    label.font = mageFont.mediumFont(size: 15.0)
    return label;
  }()
  
  lazy var closeButton: UIButton = {
    let button = UIButton();
    button.translatesAutoresizingMaskIntoConstraints = false;
    button.setTitle("X", for: .normal);
      button.titleLabel?.font = mageFont.regularFont(size: 20.0)
    button.setTitleColor(.black, for: .normal)
    button.rx.tap.bind{[weak self] in
      self?.dismiss(animated: true, completion: nil)
    }.disposed(by: disposeBag)
    return button;
  }()
  
  lazy var variantsCollectionView: UICollectionView = {
    let collect = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    collect.collectionViewLayout = layout
    collect.backgroundColor = .white
    collect.translatesAutoresizingMaskIntoConstraints = false;
    collect.register(AddToCartCollectionCell.self, forCellWithReuseIdentifier: AddToCartCollectionCell.className)
    return collect;
  }()
  
  var disposeBag = DisposeBag()
  lazy var plusButton: UIButton = {
    let button = UIButton();
    button.translatesAutoresizingMaskIntoConstraints = false;
    button.setTitleColor(.black, for: .normal)
    button.setTitle("+", for: .normal)
      button.titleLabel?.font = mageFont.boldFont(size: 30.0)
    button.layer.cornerRadius = 20
    button.layer.borderWidth = 2
    button.layer.borderColor = UIColor.black.cgColor
    button.clipsToBounds = true;
    button.rx.tap.bind{[weak self] in
      self?.qtyLabel.text = "\(Int(self?.qtyLabel.text ?? "1")! + 1)"
    }.disposed(by: disposeBag)
    
    return button;
  }()
  
  lazy var minusButton: UIButton = {
    let button = UIButton();
    button.translatesAutoresizingMaskIntoConstraints = false;
    button.setTitleColor(.black, for: .normal)
    button.setTitle("-", for: .normal)
    button.titleLabel?.font = mageFont.boldFont(size: 30.0)
    button.layer.cornerRadius = 20
    button.layer.borderWidth = 2
    button.layer.borderColor = UIColor.black.cgColor
    button.clipsToBounds = true;
    button.rx.tap.bind{[weak self] in
      if(self?.qtyLabel.text != "1"){
        self?.qtyLabel.text = "\(Int(self?.qtyLabel.text ?? "1")! - 1)"
      }
      
    }.disposed(by: disposeBag)
    return button;
  }()
  
  var delegate: ProductAddProtocol?
  var isFromWishlist=Bool()
  
  lazy var addToCartButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false;
    button.setTitle("Add To Bag".localized, for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .black
      button.titleLabel?.font = mageFont.boldFont(size: 15.0)
    button.rx.tap.bind{[weak self] in
      
      if !(self?.selectedVariant.currentlyNotInStock ?? false) {
        if(!(self?.selectedVariant.availableForSale)!){
          self?.view.showmsg(msg: (self?.product.title)! + " not available".localized)
          return;
        }
      }
      
      if DBManager.shared.cartProducts?.count ?? 0 > 0 {
        for CartDetail in DBManager.shared.cartProducts! {
          let variantId = CartDetail.variant.id
          if self?.selectedVariant.id == variantId {
            if !(self?.selectedVariant.currentlyNotInStock ?? false) {
              if (Int(self?.selectedVariant.availableQuantity ?? "") ?? 0) > 0 {
                if CartDetail.qty > (Int(self?.selectedVariant.availableQuantity ?? "") ?? 0) {
                  self?.view.makeToast("You have already added the maximum available quantities for this Variant".localized, duration: 2.5, position: .center)
                  return;
                }
                else if CartDetail.qty + (Int(self?.qtyLabel.text ?? "1")!) > (Int(self?.selectedVariant.availableQuantity ?? "") ?? 0) {
                  self?.view.makeToast("You have already added the maximum available quantities for this Variant".localized, duration: 2.5, position: .center)
                  return;
                }
              }
            }
          }
          else {
            if !(self?.selectedVariant.currentlyNotInStock ?? false) {
              if (Int(self?.qtyLabel.text ?? "1")!) > (Int(self?.selectedVariant.availableQuantity ?? "") ?? 0) {
                self?.view.makeToast("Available Quantity : ".localized+"\(self?.selectedVariant.availableQuantity ?? "")", duration: 2.5, position: .center)
                return;
              }
            }
          }
        }
      }
      else {
        if !(self?.selectedVariant.currentlyNotInStock ?? false) {
          if (Int(self?.qtyLabel.text ?? "1")!) > (Int(self?.selectedVariant.availableQuantity ?? "") ?? 0) {
            self?.view.makeToast("Available Quantity : ".localized+"\(self?.selectedVariant.availableQuantity ?? "")", duration: 2.5, position: .center)
            return;
          }
        }
      }
      let item = CartProduct(product: self!.product, variant: WishlistManager.shared.getVariant(self!.selectedVariant), quantity: Int(self?.qtyLabel.text ?? "1")!)
      CartManager.shared.addToCart(item)
      if (self?.isFromWishlist)! {
        WishlistManager.shared.removeFromWishList(item)
      }
      self?.view.showmsg(msg: (self?.product.title)! + " added to cart.".localized)
      self?.setupTabbarCount()
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {[weak self] in
        self?.delegate?.productAdded()
        self?.dismiss(animated: true, completion: nil)
      }
    }.disposed(by: disposeBag)
    
    return button;
  }()
  
  lazy var qtyLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false;
    label.text = "1"
      label.font = mageFont.regularFont(size: 14.0)
    label.textColor = .black
    label.textAlignment = .center
    return label;
  }()
    
    
    lazy var availableQtyLabel: UILabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false;
      label.text = ""
        label.font = mageFont.regularFont(size: 14.0)
      label.textColor = .black
      label.textAlignment = .left
      return label;
    }()
  
  var id: String!
  private var product: ProductViewModel!
  private var selectedVariant: VariantViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    loadData()
    // Do any additional setup after loading the view.
  }
  
  func loadData(){
    //self.id = id
    Client.shared.fetchSingleProduct(of: id){[weak self]
      response,error   in
      if let response = response {
        self?.product = response
        let variants = response.variants.items
        self?.selectedVariant = variants.first
        self?.setup()
        //response.variants.items.
      }else {
        //self.showErrorAlert(error: error?.localizedDescription)
      }
    }
  }
  
  private func setup(){
    view.addSubview(selectOptionLabel)
    view.addSubview(closeButton)
    view.addSubview(variantsCollectionView)
    view.addSubview(plusButton)
    view.addSubview(minusButton)
    view.addSubview(qtyLabel)
    view.addSubview(addToCartButton)
      
      view.addSubview(availableQtyLabel)
    
    NSLayoutConstraint.activate([
      selectOptionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
      selectOptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
      closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
      closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
      closeButton.heightAnchor.constraint(equalToConstant: 25),
      closeButton.widthAnchor.constraint(equalToConstant: 25),
      variantsCollectionView.topAnchor.constraint(equalTo: selectOptionLabel.bottomAnchor, constant: 10),
      variantsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
      variantsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
      variantsCollectionView.heightAnchor.constraint(equalToConstant: CGFloat((product.variants.items.first?.selectedOptions.count ?? 0 * 25)+255)),
      
      availableQtyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      availableQtyLabel.topAnchor.constraint(equalTo: variantsCollectionView.bottomAnchor, constant: 1),
      availableQtyLabel.heightAnchor.constraint(equalToConstant: 30),
      availableQtyLabel.widthAnchor.constraint(equalToConstant: 300),
      
      minusButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
      minusButton.topAnchor.constraint(equalTo: availableQtyLabel.bottomAnchor, constant: 5),
      minusButton.heightAnchor.constraint(equalToConstant: 40),
      minusButton.widthAnchor.constraint(equalToConstant: 40),
      //minusButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
      qtyLabel.widthAnchor.constraint(equalToConstant: 30),
      qtyLabel.topAnchor.constraint(equalTo: minusButton.topAnchor),
      qtyLabel.bottomAnchor.constraint(equalTo: minusButton.bottomAnchor),
      qtyLabel.leadingAnchor.constraint(equalTo: minusButton.trailingAnchor, constant: 5),
      plusButton.leadingAnchor.constraint(equalTo: qtyLabel.trailingAnchor, constant: 5),
      plusButton.widthAnchor.constraint(equalToConstant: 40),
      plusButton.topAnchor.constraint(equalTo: qtyLabel.topAnchor),
      plusButton.bottomAnchor.constraint(equalTo: qtyLabel.bottomAnchor),
      addToCartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
      addToCartButton.widthAnchor.constraint(equalToConstant: 150),
      addToCartButton.heightAnchor.constraint(equalToConstant: 40),
      addToCartButton.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
    ])
    setData()
    //self.availableQtyLabel.text = "\(self.selectedVariant.availableQuantity) " + "Available Quantity".localized
     initialSetup()
     //updateView()
  }
  
  private func setData(){
    variantsCollectionView.delegate = self;
    variantsCollectionView.dataSource = self;
    variantsCollectionView.reloadData()
  }
    private func initialSetup(){
        self.addToCartButton.isHidden = true
        self.availableQtyLabel.isHidden = true
        self.minusButton.isHidden = true
        self.plusButton.isHidden = true
        self.qtyLabel.isHidden = true
    }
    private func updateView(){
        self.addToCartButton.isHidden = false
        self.availableQtyLabel.isHidden = false
        
        //|| self.selectedVariant.availableQuantity.hasPrefix("-")
        if self.selectedVariant.availableQuantity == "0" &&  !self.selectedVariant.availableForSale{
            self.addToCartButton.setTitle("Out Of Stock", for: .normal)
            self.plusButton.isUserInteractionEnabled = false
            self.minusButton.isUserInteractionEnabled = false
            self.addToCartButton.isUserInteractionEnabled = false
            //
            self.minusButton.isHidden = true
            self.plusButton.isHidden = true
            self.qtyLabel.isHidden = true

        }
        else{
            self.addToCartButton.setTitle("Add To Bag".localized, for: .normal)
            self.plusButton.isUserInteractionEnabled = true
            self.minusButton.isUserInteractionEnabled = true
            self.addToCartButton.isUserInteractionEnabled = true
            //
            self.minusButton.isHidden = false
            self.plusButton.isHidden = false
            self.qtyLabel.isHidden = false
            
        }
    }
}

extension AddToCartVC: UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return product.variants.items.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddToCartCollectionCell.className, for: indexPath) as! AddToCartCollectionCell
    cell.configure(variant: product.variants.items[indexPath.row],selected: selectedVariant)
    return cell;
  }
}

extension AddToCartVC:UICollectionViewDelegate{
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.selectedVariant = product.variants.items[indexPath.row]
      self.availableQtyLabel.text = "\(self.selectedVariant.availableQuantity) " + "Available Quantity".localized
    updateView()
    collectionView.reloadData()
  }
}

extension AddToCartVC: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 170, height: CGFloat((product.variants.items.first?.selectedOptions.count ?? 0 * 25)+205))
  }
}
