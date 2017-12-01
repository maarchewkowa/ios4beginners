//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Karolina Beata Natalia Guzewska on 29.11.2017.
//  Copyright © 2017 Karolina Beata Natalia Guzewska. All rights reserved.
//

import UIKit

class PokemonDetailViewController: UIViewController {
    var pokemon: Pokemon?
    
    @IBOutlet weak var pokemonFullImage: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = pokemon!.name
        pokemonNameLabel.textColor = pokemon?.keyColor
        pokemonNameLabel.text = pokemon?.name
        pokemonFullImage.backgroundColor = pokemon?.keyColor

        let endpoint = "https://switter.int.daftcode.pl/api/pokemon/\(pokemon!.number)/image"
        let url = URL(string: endpoint)!
        var urlRequest = URLRequest(url: url)
        let deviceUUID = UIDevice.current.identifierForVendor?.uuidString ?? "unknown device uuid"
        urlRequest.addValue(deviceUUID, forHTTPHeaderField: "x-device-uuid")
        
        let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
        session.dataTask(with: urlRequest) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw PokemonApiError.parsingDataFailed }
                guard let httpResponse = response as? HTTPURLResponse else { throw PokemonApiError.parsingHTTPURLResponseFailed }
                
                if httpResponse.statusCode != 200 {
                    throw PokemonApiError.unexpectedStatusCode(statusCode: httpResponse.statusCode)
                }
                
                let pokemonImage = UIImage(data: data)
                
                DispatchQueue.main.async {
                    self.pokemonFullImage.image = pokemonImage
                }
                
            } catch {
                print(error)
            }
            }.resume()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
