//
//  PokemonLoader.swift
//  Pokedex
//
//  Created by Karolina Beata Natalia Guzewska on 27.11.2017.
//  Copyright © 2017 Karolina Beata Natalia Guzewska. All rights reserved.
//

import Foundation
import UIKit

enum PokemonApiError : Error {
    case parsingDataFailed
    case parsingHTTPURLResponseFailed
    case unexpectedStatusCode(statusCode: Int)
}

//class PokemonHTTPLoader {
//    func load() throws -> [Pokemon] {
//
//    }
//}

