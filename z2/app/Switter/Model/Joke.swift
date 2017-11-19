//
//  Joke.swift
//  Switter
//
//  Created by Karolina Beata Natalia Guzewska on 19.11.2017.
//  Copyright © 2017 Karolina Beata Natalia Guzewska. All rights reserved.
//

import Foundation

struct Joke: Codable {
    var content: String
}

enum JokeApiError : Error {
    case parsingDataFailed
    case parsingHTTPURLResponseFailed
    case unexpectedStatusCode(statusCode: Int, responseString: String)
}

