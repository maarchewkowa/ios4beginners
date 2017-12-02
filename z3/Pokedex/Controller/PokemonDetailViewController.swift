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
    let pokemonLoader = PokemonHTTPLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = pokemon!.name
        pokemonNameLabel.textColor = pokemon?.keyColor
        pokemonNameLabel.text = pokemon?.name
        pokemonFullImage.backgroundColor = pokemon?.keyColor

        
        pokemonLoader.loadPokemonImage(pokemonNumber: (pokemon?.number)!) { (pokemonImage) in
            DispatchQueue.main.async {
                self.pokemonFullImage.image = pokemonImage
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
