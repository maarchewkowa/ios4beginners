//
//  Pokemon.swift
//  Pokedex
//
//  Created by Karolina Beata Natalia Guzewska on 27.11.2017.
//  Copyright © 2017 Karolina Beata Natalia Guzewska. All rights reserved.
//

import Foundation
import UIKit

struct Pokemon: Codable {
    var color: Int
    var name: String
    var number: Int
}

extension Pokemon {
    var keyColor: UIColor {
        return UIColor(hex: color)
    }
}
    
    extension Pokemon: CustomDebugStringConvertible {
        var debugDescription : String {
            return "\(number) \(name)"
        }
}

