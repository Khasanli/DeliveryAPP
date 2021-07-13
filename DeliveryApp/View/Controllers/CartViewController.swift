//
//  CartViewController.swift
//  DeliveryApp
//
//  Created by Samir Hasanli on 13.07.21.
//

import UIKit

class CartViewController: UIViewController {
    let homeVM = HomeViewModel()
    var totalCost : Float = 0
    
    let backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints =  false
        button.setImage(UIImage(named: "backarrow"), for: .normal)
        return button
    }()
    
    let orderButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints =  false
        button.backgroundColor = #colorLiteral(red: 0.2303615212, green: 0.6917119026, blue: 0.2143333554, alpha: 1)
        button.setTitle("Order", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(orderButtonTapped), for: .touchUpInside)
        return button
    }()
    let emptyLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .lightGray
        label.text = "Cart is empty!"
        label.translatesAutoresizingMaskIntoConstraints =  false
        return label
    }()
    let totalCostLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .black
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints =  false
        return label
    }()
    
    let cartCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CartCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(emptyLabel)
        view.addSubview(backButton)
        view.addSubview(cartCollectionView)
        view.addSubview(totalCostLabel)
        view.addSubview(orderButton)
        cartCollectionView.dataSource = self
        cartCollectionView.delegate = self
        calculateTotalCost()
        setSubviews()
    }
    @objc private func backButtonTapped(){
        let vc = HomeViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
    @objc func setSubviews(){
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height/16).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.frame.size.width/16).isActive = true
        backButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/16).isActive = true
        backButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/16).isActive = true
        
        cartCollectionView.topAnchor.constraint( equalTo: view.topAnchor, constant: view.frame.size.height/8).isActive = true
        cartCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        cartCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -view.frame.size.height/4).isActive = true
        cartCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        totalCostLabel.topAnchor.constraint(equalTo: cartCollectionView.bottomAnchor).isActive = true
        totalCostLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        totalCostLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2/3).isActive = true
        totalCostLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/16).isActive = true
        totalCostLabel.font = UIFont(name: "Helvetica-Bold", size: view.frame.size.width/20)
        
        orderButton.topAnchor.constraint(equalTo: cartCollectionView.bottomAnchor).isActive = true
        orderButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        orderButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3).isActive = true
        orderButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/16).isActive = true
        orderButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: view.frame.size.width/20)
        
        emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emptyLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        emptyLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/8).isActive = true
        emptyLabel.font = UIFont(name: "Helvetica", size: view.frame.size.width/15)


    }
    private func calculateTotalCost(){
        var value : Float = 0
        if cartItems.count > 0 {
            cartItems.forEach { item in
                value += Float(item.item.item_cost) * Float(item.quantity)
                self.totalCost = value
            }
            emptyLabel.isHidden = true
            cartCollectionView.isHidden = false
            self.totalCostLabel.text = "Total Cost: \(self.totalCost)"
        } else {
            emptyLabel.isHidden = false
            cartCollectionView.isHidden = true
            self.totalCost = 0
            self.totalCostLabel.text = "Total Cost: \(self.totalCost)"
        }
    }
    @objc private func orderButtonTapped(){
        if cartItems.count > 0 {
            self.homeVM.updateOrder(totalCost: self.totalCost)
        }
    }
}


extension CartViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width/3)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cartItems.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CartCollectionViewCell
        cell.item_name.text = cartItems[indexPath.row].item.item_name
        cell.item_details.text = cartItems[indexPath.row].item.item_details
        cell.item_image.load(urlSting: cartItems[indexPath.row].item.item_image)
        cell.item_cost.text = "$\(cartItems[indexPath.row].item.item_cost)"
        cell.quantity.text = "\(cartItems[indexPath.row].quantity)"
        self.calculateTotalCost()

        if Int(cartItems[indexPath.row].quantity) == 1 {
            cell.minusButtonTapCallBack = {
                allItems[self.homeVM.getAllItemIndex(item: cartItems[indexPath.row].item, isCartIndex: false)].isAdded = false
                filteredItems[self.homeVM.getIndex(item: cartItems[indexPath.row].item, isCartIndex: false)].isAdded = false
                cartItems.remove(at: indexPath.row)
                self.cartCollectionView.reloadData()
                self.calculateTotalCost()

            }
        }
        if Int(cartItems[indexPath.row].quantity) > 1 {
            cell.minusButtonTapCallBack = {
                cartItems[indexPath.row].quantity -= 1
                self.cartCollectionView.reloadData()
            }
        }
        if Int(cartItems[indexPath.row].quantity) > 0 {
            cell.plusButtonTapCallBack = {
                cartItems[indexPath.row].quantity += 1
                self.cartCollectionView.reloadData()
            }
        }
        return cell
    }
}
