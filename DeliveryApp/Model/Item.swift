//
//  Item.swift
//  DeliveryApp
//
//  Created by Samir Hasanli on 13.07.21.
//

import Foundation

struct Item: Identifiable {
    var id : String
    var item_name: String
    var item_cost: NSNumber
    var item_details: String
    var item_image: String
    var item_ratings: NSNumber
    var isAdded: Bool = false
}
