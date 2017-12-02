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

extension URLRequest {
    mutating func addDeviceHeader(){
        let deviceUUID = UIDevice.current.identifierForVendor?.uuidString ?? "unknown device uuid"
        self.addValue(deviceUUID, forHTTPHeaderField: "x-device-uuid")
    }
}

class PokemonHTTPLoader {
    let apiBaseAddress = "https://switter.int.daftcode.pl/"

    func loadPokemonList(completionHandler: @escaping ([Pokemon]) -> ()) {
        let endpoint = "\(apiBaseAddress)api/pokemon"
        let url = URL(string: endpoint)!
        var urlRequest = URLRequest(url: url)
        urlRequest.addDeviceHeader()
        
        let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
        session.dataTask(with: urlRequest) { (data, response, error) in
            do {
                let data = try self.handleErrorsAndGetData(error: error, data: data, response: response)
                
                let jsonDecoder = JSONDecoder()
                let decodedPokemon = try jsonDecoder.decode([Pokemon].self, from: data)
                
                completionHandler(decodedPokemon)
                
            } catch {
                print(error)
            }
            }.resume()
    }
    
    func loadPokemonThumbnail(pokemonNumber: Int ,completionHandler: @escaping (UIImage) -> ()) {
        let endpoint = "\(apiBaseAddress)api/pokemon/\(pokemonNumber)/thumbnail"
        let url = URL(string: endpoint)!
        var urlRequest = URLRequest(url: url)
        urlRequest.addDeviceHeader()
        
        let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
        session.dataTask(with: urlRequest) { (data, response, error) in
            do {
                let data = try self.handleErrorsAndGetData(error: error, data: data, response: response)
                
                let pokemonImage = UIImage(data: data, scale: 1.5)
                completionHandler(pokemonImage!)
            } catch {
                print(error)
            }
            }.resume()
    }
    
    func loadPokemonImage(pokemonNumber: Int ,completionHandler: @escaping (UIImage) -> ()) {
        let endpoint = "\(apiBaseAddress)api/pokemon/\(pokemonNumber)/image"
        let url = URL(string: endpoint)!
        var urlRequest = URLRequest(url: url)
        urlRequest.addDeviceHeader()
        
        let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
        session.dataTask(with: urlRequest) { (data, response, error) in
            do {
                let data = try self.handleErrorsAndGetData(error: error, data: data, response: response)
                
                let pokemonImage = UIImage(data: data, scale: 0.8)
                completionHandler(pokemonImage!)
                
            } catch {
                print(error)
            }
            }.resume()
    }
    
    func handleErrorsAndGetData(error: Error?, data: Data?, response: URLResponse?) throws -> Data {
        if let error = error { throw error }
        guard let data = data else { throw PokemonApiError.parsingDataFailed }
        guard let httpResponse = response as? HTTPURLResponse else { throw PokemonApiError.parsingHTTPURLResponseFailed }
        
        if httpResponse.statusCode != 200 {
            throw PokemonApiError.unexpectedStatusCode(statusCode: httpResponse.statusCode)
        }
        return data
    }
}

