//
//  PokemonListViewController.swift
//  Pokedex
//
//  Created by Karolina Beata Natalia Guzewska on 27.11.2017.
//  Copyright © 2017 Karolina Beata Natalia Guzewska. All rights reserved.
//

import UIKit

class PokemonListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var pokemonCollectionView: UICollectionView!
    var pokemonList = [Pokemon]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let endpoint = "https://switter.int.daftcode.pl/api/pokemon"
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
                
                let jsonDecoder = JSONDecoder()
                let decodedPokemon = try jsonDecoder.decode([Pokemon].self, from: data)
                
                DispatchQueue.main.async {
                    self.pokemonList = decodedPokemon
                    self.pokemonCollectionView.reloadData()
                    print(self.pokemonList)
                }
                
            } catch {
                print(error)
            }
            }.resume()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCollectionViewCell", for: indexPath) as? PokemonCollectionViewCell else { fatalError() }
        cell.backgroundColor = UIColor.lightGray
        let pokemon = pokemonList[indexPath.item]
        cell.pokemonNameLabel.textColor = pokemon.keyColor
        cell.pokemonNameLabel.text = pokemon.name
        cell.pokemonImage.image = nil
        cell.pokemonId = pokemon.number
        
        
        let endpoint = "https://switter.int.daftcode.pl/api/pokemon/\(pokemon.number)/thumbnail"
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
                    cell.pokemonImage.image = pokemonImage
                }
                
            } catch {
                print(error)
            }
            }.resume()
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! PokemonDetailViewController
        let senderCell = sender as! PokemonCollectionViewCell
        destination.pokemon = pokemonList.filter({ (pokemon) in pokemon.number == senderCell.pokemonId })[0]
    }
    
    //func setNewPokemon(pokemon: Pokemon) {
    
    //}
}

