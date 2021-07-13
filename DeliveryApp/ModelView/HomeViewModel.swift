//
//  HomeViewModel.swift
//  DeliveryApp
//
//  Created by Samir Hasanli on 13.07.21.
//

import Foundation
import UIKit
import Firebase
import CoreLocation

var allItems : [Item] = []
var filteredItems : [Item] = []
var cartItems : [Cart] = []
var globalUserLocation = CLLocation()
var ordered = false

class HomeViewModel {
  
    var search = ""
    
    func login(completionHandler: @escaping (_ result: Bool) -> ()){
        Auth.auth().signInAnonymously { (res, err) in
            if err != nil {
                print(err?.localizedDescription)
                completionHandler(false)
                return
            }
            print("Success = \(String(describing: res?.user.uid))")
            completionHandler(true)
        }
    }
    func fetchData(completionHandler: @escaping (_ result: Bool) -> ()){
        let DB = Firestore.firestore()
        DB.collection("Items").getDocuments { snap, error in
            guard let itemData = snap else {
                return
            }
            allItems = itemData.documents.compactMap({ (doc) -> Item? in
                let id = doc.documentID
                let name = doc.get("item_name") as! String
                let cost = doc.get("item_cost") as! NSNumber
                let ratings = doc.get("item_ratings") as! NSNumber
                let image = doc.get("item_image") as! String
                let details = doc.get("item_details") as! String
                return Item(id: id, item_name: name, item_cost: cost, item_details: details, item_image: image, item_ratings: ratings)
            })
            completionHandler(true)
        }
    }
    func filterData(search: String) {
        filteredItems = allItems.filter {
            return $0.item_name.lowercased().contains(search.lowercased())
        }
    }
    func addToCart(item: Item){
        allItems[getAllItemIndex(item: item, isCartIndex: false)].isAdded = !item.isAdded
        filteredItems[getIndex(item: item, isCartIndex: false)].isAdded = !item.isAdded
        
        if item.isAdded {
            cartItems.remove(at: getIndex(item: item, isCartIndex: true))
            return
        }
        
        cartItems.append(Cart(item: item, quantity: 1))
    }
    func getIndex(item: Item, isCartIndex: Bool) -> Int {
        let index = filteredItems.firstIndex { item1 -> Bool in
            return item.id == item1.id
        } ?? 0
        
        let cartIndex = cartItems.firstIndex { item1 -> Bool in
            return item.id == item1.item.id
        } ?? 0
        
        return isCartIndex ? cartIndex : index
    }
    func  getAllItemIndex(item: Item, isCartIndex: Bool) -> Int {
        let indexForAllItems = allItems.firstIndex { item1 -> Bool in
            return item.id == item1.id
        } ?? 0
        
        let cartIndex = cartItems.firstIndex { item1 -> Bool in
            return item.id == item1.item.id
        } ?? 0
        
        return isCartIndex ? cartIndex : indexForAllItems
    }
    func updateOrder(totalCost: Float){
        let DB = Firestore.firestore()
        if ordered {
            ordered = false
            DB.collection("Users").document(Auth.auth().currentUser!.uid).delete{
                (err) in
                if err != nil {
                    ordered  = true
                }
            }
            return
        }
        var details : [[String: Any]] = []
        cartItems.forEach { (cart) in
            details.append([
                "item_name": cart.item.item_name,
                "item_quantity": cart.quantity,
                "item_cost": cart.item.item_cost
            ])
        }
        ordered = true
        DB.collection("Users").document(Auth.auth().currentUser!.uid).setData([
            "ordered_food": details,
            "totalCost": totalCost,
            "location": GeoPoint(latitude: globalUserLocation.coordinate.latitude, longitude: globalUserLocation.coordinate.longitude)
        ]) {
            (err) in
            if err != nil {
                ordered = false
                return
            }
            print("sucess")
        }
    }
}
