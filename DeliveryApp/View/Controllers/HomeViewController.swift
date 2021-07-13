//
//  HomeViewController.swift
//  DeliveryApp
//
//  Created by Samir Hasanli on 12.07.21.
//


import UIKit
import CoreLocation
import Firebase

class HomeViewController: UIViewController {
    
//MARK:-OBJECTs
    var homeVM = HomeViewModel()
    var locationManager = CLLocationManager()
    let userName : String = "Khayala"
    
    let homeCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    let basketButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints =  false
        button.setImage(UIImage(named: "shopping-cart"), for: .normal)
        return button
    }()
    
    let hiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints =  false
        return label
    }()
    
    let deliveredToLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.text = "Delivery to"
        label.translatesAutoresizingMaskIntoConstraints =  false
        return label
    }()
    
    var locationButton: UIButton = {
        var button = UIButton()
        button.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        button.setTitle("Add current location", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints =  false
        return button
    }()
    
    let searchTextField : UITextField = {
        let field = UITextField()
        field.leftViewMode = .always
        field.backgroundColor = #colorLiteral(red: 0.9298995818, green: 0.9298995818, blue: 0.9298995818, alpha: 1)
        field.placeholder = "Search"
        field.translatesAutoresizingMaskIntoConstraints = false
        field.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingChanged)
        return field
    }()
    let searchButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

//MARK:-LYFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(basketButton)
        view.addSubview(hiLabel)
        view.addSubview(deliveredToLabel)
        view.addSubview(locationButton)
        view.addSubview(searchTextField)
        view.addSubview(searchButton)
        view.addSubview(homeCollectionView)
        
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        filteredItems = allItems
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCurrentLocation()
        self.homeVM.login { result in
            if result == true {
                if allItems.count < 1 {
                    self.homeVM.fetchData { result in
                        if result == true{
                            filteredItems = allItems
                            self.homeCollectionView.reloadData()
                        } else {
                        }
                    }
                }
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setSubviews()
    }
//MARK:-SET SUBVIEWS
    @objc func setSubviews(){
        basketButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height/16).isActive = true
        basketButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.frame.size.width/16).isActive = true
        basketButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/16).isActive = true
        basketButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/16).isActive = true
        
        hiLabel.centerYAnchor.constraint(equalTo: basketButton.centerYAnchor).isActive = true
        hiLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.frame.size.width/16).isActive = true
        hiLabel.text = "Hello \(userName)!"
        
        deliveredToLabel.topAnchor.constraint(equalTo: hiLabel.bottomAnchor,  constant: view.frame.size.width/16).isActive = true
        deliveredToLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.frame.size.width/16).isActive = true
        deliveredToLabel.font = UIFont(name: "Helvetica", size: view.frame.size.height/50)
        
        locationButton.topAnchor.constraint(equalTo: deliveredToLabel.bottomAnchor, constant: view.frame.size.width/50).isActive = true
        locationButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.frame.size.width/16).isActive = true
        locationButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: view.frame.size.height/40)
        
        searchTextField.topAnchor.constraint(equalTo: locationButton.bottomAnchor, constant: view.frame.size.height/50).isActive = true
        searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -view.frame.size.width/8).isActive = true
        searchTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/14).isActive = true
        searchTextField.layer.cornerRadius = view.frame.size.height/28
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/16, height: view.frame.size.height/14))
        
        searchButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor).isActive = true
        searchButton.centerXAnchor.constraint(equalTo: searchTextField.rightAnchor, constant: -view.frame.size.height/26).isActive = true
        
        homeCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10).isActive = true
        homeCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        homeCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        homeCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true

    }
//MARK:-FUNCTIONS
    @objc private func textFieldEditingDidChange(_ sender: Any){
            if searchTextField.text?.count == 0 {
                filteredItems = allItems
                self.homeCollectionView.reloadData()
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.homeVM.filterData(search: self.searchTextField.text!)
                    self.homeCollectionView.reloadData()
                }
            }
        }
    @objc func cartButtonTapped(){
        let vc = CartViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
//MARK:-<<<<<<<<lOCATIONS>>>>>>>>>>>
    @objc private func locationButtonTapped(_ sender: Any){
        if locationButton.titleLabel?.text == "Add current location"  {
            self.promtForAuthorization()
        } else {
        }
    }
    private func getCurrentLocation(){
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    func promtForAuthorization(){
        let alert = UIAlertController(title: "Location access is needed to get your current location", message: "Please allow location access", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { [weak self] _ in
            self?.locationButton.setTitle("Add current location", for: .normal)
        }
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        alert.preferredAction = settingsAction

        present(alert, animated: true, completion: nil)
    }
}
//MARK:-<<<<<<<<EXTENSIONS>>>>>>>>>>>
extension HomeViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0] as CLLocation
        globalUserLocation = userLocation
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { placemarks, error in
            if (error != nil) {
                print("Error happened while Reversing geocode location")
            }
            let placemark = placemarks! as [CLPlacemark]
            if (placemark.count>0) {
                let placemark = placemarks![0]
                let administrativeArea = placemark.administrativeArea ?? ""
                let country = placemark.country ?? ""
                
                self.locationButton.setTitle("\(administrativeArea), \(country)", for: .normal)
            }
        }
    }
}
extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width-50, height: collectionView.frame.width/1.5)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredItems.count ?? 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewCell
        cell.backgroundColor = .white
        cell.item_image.load(urlSting: filteredItems[indexPath.row].item_image)
        cell.item_name.text = filteredItems[indexPath.row].item_name
        cell.item_details.text = filteredItems[indexPath.row].item_details
        cell.item_ratings.rating = Double(filteredItems[indexPath.row].item_ratings)
        filteredItems[indexPath.row].isAdded ? cell.addButton.setImage(UIImage(named: "checkmark"), for: .normal) : cell.addButton.setImage(UIImage(named: "addButton"), for: .normal)
        
        cell.buttonTapCallBack = {
                self.homeVM.addToCart(item: filteredItems[indexPath.row])
                self.homeCollectionView.reloadData()
        }
        return cell
    }
}
