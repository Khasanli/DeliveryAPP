//
//  File.swift
//  DeliveryApp
//
//  Created by Samir Hasanli on 13.07.21.
//

import UIKit

class CartCollectionViewCell: UICollectionViewCell {
    var plusButtonTapCallBack: () -> () = {}
    var minusButtonTapCallBack: () -> () = {}

    
    let plusButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "add-square"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let minusButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "minus-square"), for: .normal)
        button.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let item_image : UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 5
        image.backgroundColor = .lightGray
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    let item_name : UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let quantity : UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let item_cost : UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let item_details : UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .gray
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//MARK:-LYFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(item_image)
        contentView.addSubview(item_name)
        contentView.addSubview(item_details)
        contentView.addSubview(item_cost)
        contentView.addSubview(minusButton)
        contentView.addSubview(quantity)
        contentView.addSubview(plusButton)
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)

        setSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//MARK:-SET SUBVIEWS
    private func setSubviews(){
        
        item_image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        item_image.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/3).isActive = true
        item_image.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        item_image.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: contentView.frame.size.width/16).isActive = true
        
        item_name.leftAnchor.constraint(equalTo: item_image.rightAnchor, constant: contentView.frame.size.width/20).isActive = true
        item_name.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        item_name.widthAnchor.constraint(equalTo: contentView.widthAnchor,multiplier: 1/2).isActive = true
        item_name.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1/3).isActive = true
        item_name.font = UIFont(name: "Helvetica-Bold", size: contentView.frame.size.width/15)
        
        item_details.leftAnchor.constraint(equalTo: item_image.rightAnchor, constant: contentView.frame.size.width/20).isActive = true
        item_details.centerYAnchor.constraint(equalTo: item_image.centerYAnchor).isActive = true
        item_details.widthAnchor.constraint(equalTo: contentView.widthAnchor,multiplier: 1/2).isActive = true
        item_details.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1/3).isActive = true
        item_details.font = UIFont(name: "Helvetica", size: contentView.frame.size.width/30)
        
        item_cost.leftAnchor.constraint(equalTo: item_image.rightAnchor, constant: contentView.frame.size.width/20).isActive = true
        item_cost.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        item_cost.widthAnchor.constraint(equalTo: contentView.widthAnchor,multiplier: 1/6).isActive = true
        item_cost.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1/3).isActive = true
        item_cost.font = UIFont(name: "Helvetica-Bold", size: contentView.frame.size.width/12)
        
        plusButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -contentView.frame.size.width/16).isActive = true
        plusButton.centerYAnchor.constraint(equalTo: item_cost.centerYAnchor).isActive = true
        plusButton.widthAnchor.constraint(equalTo: contentView.widthAnchor,multiplier: 1/12).isActive = true
        plusButton.heightAnchor.constraint(equalTo: contentView.widthAnchor,multiplier: 1/12).isActive = true
        
        
        quantity.rightAnchor.constraint(equalTo: plusButton.leftAnchor, constant: -contentView.frame.size.width/32).isActive = true
        quantity.centerYAnchor.constraint(equalTo: item_cost.centerYAnchor).isActive = true
        quantity.font = UIFont(name: "Helvetica", size: contentView.frame.size.width/15)
        
        minusButton.rightAnchor.constraint(equalTo: quantity.leftAnchor, constant: -contentView.frame.size.width/32).isActive = true
        minusButton.centerYAnchor.constraint(equalTo: item_cost.centerYAnchor).isActive = true
        minusButton.widthAnchor.constraint(equalTo: contentView.widthAnchor,multiplier: 1/12).isActive = true
        minusButton.heightAnchor.constraint(equalTo: contentView.widthAnchor,multiplier: 1/12).isActive = true
        
    }
    @objc func plusButtonTapped(){
        plusButtonTapCallBack()
    }
    @objc func minusButtonTapped(){
        minusButtonTapCallBack()
    }
}
