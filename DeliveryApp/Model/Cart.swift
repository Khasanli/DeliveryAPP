//
//  Cart.swift
//  DeliveryApp
//
//  Created by Samir Hasanli on 13.07.21.
//

import Foundation

struct Cart: Identifiable {
    var id = UUID().uuidString
    var item: Item
    var quantity: Int
}
