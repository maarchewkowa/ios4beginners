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
    let pokemonLoader = PokemonHTTPLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonLoader.loadPokemonList { (decodedPokemon) in
            DispatchQueue.main.async {
                self.pokemonList = decodedPokemon
                self.pokemonCollectionView.reloadData()
                print(self.pokemonList)
            }
        }
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
        cell.backgroundColor = UIColor(hex: 0xf1f1f1)
        let pokemon = pokemonList[indexPath.item]
        cell.pokemonNameLabel.textColor = pokemon.keyColor
        cell.pokemonNameLabel.text = pokemon.name
        cell.pokemonImage.image = nil
        cell.pokemonId = pokemon.number
        cell.pokemonImage.backgroundColor = pokemon.keyColor

        pokemonLoader.loadPokemonThumbnail(pokemonNumber: pokemon.number) { (pokemonImage) in
            DispatchQueue.main.async {
                if cell.pokemonId == pokemon.number{
                    cell.pokemonImage.image =  pokemonImage
                }
            }
        }
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

