//
//  Extensions.swift
//  DeliveryApp
//
//  Created by Samir Hasanli on 13.07.21.
//

import Foundation
import UIKit

extension UIImageView {
    func load(urlSting: String){
        guard let url = URL(string: urlSting) else {
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
