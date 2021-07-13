//
//  HomeCollectionViewCell.swift
//  DeliveryApp
//
//  Created by Samir Hasanli on 13.07.21.
//

import Foundation
import UIKit
import Cosmos

class HomeCollectionViewCell: UICollectionViewCell {

//MARK:-OBJECTs
    var buttonTapCallBack: () -> () = {}
    
    let addButton : UIButton = {
        let button = UIButton()
        //button.setImage(UIImage(named: "addButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let item_image : UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .lightGray
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    let item_name : UILabel = {
        let label = UILabel()
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
    
    let item_ratings : CosmosView = {
        var view = CosmosView()
        view.settings.totalStars = 5
        view.settings.updateOnTouch = false
        view.settings.fillMode = .precise
        view.settings.filledImage = UIImage(named: "filledStar")?.withRenderingMode(.alwaysOriginal)
        view.settings.emptyImage = UIImage(named: "emptyStar")?.withRenderingMode(.alwaysOriginal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//MARK:-LYFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(item_image)
        contentView.addSubview(item_name)
        contentView.addSubview(item_details)
        contentView.addSubview(addButton)
        contentView.addSubview(item_ratings)
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        setSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//MARK:-SET SUBVIEWS
    private func setSubviews(){
        addButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        addButton.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1/7).isActive = true
        addButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1/7).isActive = true
        addButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true
        
        item_image.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        item_image.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        item_image.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 3/4).isActive = true
        item_image.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        item_name.topAnchor.constraint(equalTo: item_image.bottomAnchor).isActive = true
        item_name.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/2).isActive = true
        item_name.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1/8).isActive = true
        item_name.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        item_name.font = UIFont(name: "Helvetica-Bold", size: contentView.frame.size.width/10)
        
        item_details.topAnchor.constraint(equalTo: item_name.bottomAnchor).isActive = true
        item_details.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        item_details.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1/8).isActive = true
        item_details.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        item_details.font = UIFont(name: "Helvetica", size: contentView.frame.size.width/25)
        
        item_ratings.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        item_ratings.centerYAnchor.constraint(equalTo: item_name.centerYAnchor).isActive = true

    }
    @objc func addButtonTapped(){
        buttonTapCallBack()
    }
}
