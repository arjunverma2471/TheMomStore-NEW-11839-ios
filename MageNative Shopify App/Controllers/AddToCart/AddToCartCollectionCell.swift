//
//  AddToCartCollectionCell.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 29/01/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import UIKit

class AddToCartCollectionCell: UICollectionViewCell {
  
  lazy var variantImageView: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false;
    image.contentMode = .scaleToFill
    image.layer.borderWidth = 2
    image.layer.borderColor = UIColor.black.cgColor
    image.layer.cornerRadius = 60//variantImageView.frame.width/2
    image.clipsToBounds = true
    return image
  }()
  
  lazy var cellView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false;
    view.backgroundColor = .white
    view.cardView()
    return view;
  }()
  
  lazy var nameStack: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.distribution = .equalSpacing
    stack.spacing = 5
    return stack
  }()
  
  private var variant: VariantViewModel!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(cellView)
    cellView.addSubview(variantImageView)
    cellView.addSubview(nameStack)
    NSLayoutConstraint.activate([
      cellView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
      cellView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
      cellView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
      cellView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
      nameStack.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 5),
      nameStack.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -5),
      nameStack.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -5),
      //variantImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
      //variantImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
      variantImageView.heightAnchor.constraint(equalToConstant: 120),
      variantImageView.widthAnchor.constraint(equalToConstant: 120),
      variantImageView.centerXAnchor.constraint(equalTo: cellView.centerXAnchor),
      variantImageView.bottomAnchor.constraint(equalTo: nameStack.topAnchor, constant: -5),
      //variantImageView.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
      //variantImageView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 5)
    ])
    
  }
  
  func configure(variant: VariantViewModel, selected: VariantViewModel){
    self.variant = variant
    variantImageView.setImageFrom(variant.image)
    nameStack.arrangedSubviews.forEach{(stack) in
      stack.removeFromSuperview()
    }
    variantImageView.setImageFrom(variant.image)
    for index in variant.selectedOptions
    {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false;
      nameStack.addArrangedSubview(label)
      label.heightAnchor.constraint(equalToConstant: 20).isActive = true;
      label.text = "\(index.name): \(index.value)"
        label.font = mageFont.regularFont(size: 15.0)
      label.textAlignment = .center
    }
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false;
    nameStack.addArrangedSubview(label)
    label.textAlignment = .center;
    label.heightAnchor.constraint(equalToConstant: 20).isActive = true;
    label.text = "Price: \(Currency.stringFrom(variant.price))"
      label.font = mageFont.regularFont(size: 14.0)
    if(selected === variant){
      cellView.backgroundColor = UIColor(hexString: "#FDFADC")
    }
    else{
      cellView.backgroundColor = .white
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
