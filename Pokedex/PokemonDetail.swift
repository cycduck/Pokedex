//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by Kelly Ho on 2020-08-23.
//  Copyright © 2020 Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class PokemonDetailViewController: UIViewController {
    
    @IBOutlet var pokemonName: UILabel!
    @IBOutlet var pokemonIndex: UILabel!
    @IBOutlet var pokemonImage: UIImageView!
    @IBOutlet var pokemonText: UITextView!
    
    var dataStorageVariable: PokemonDetailInfo? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let safeData = dataStorageVariable else { return }
        
        pokemonName.text = safeData.name.capitalized
        pokemonIndex.text = DataStylize.indexConvert(id: safeData.id)
        loadImage(imageURL: safeData.sprites.front_default)
        fetchDescription(id: safeData.id)
        
        
        pokemonName.sizeToFit()
//      https://stackoverflow.com/questions/38714272/how-to-make-uitextview-height-dynamic-according-to-text-length
        pokemonName.translatesAutoresizingMaskIntoConstraints = true
        pokemonIndex.sizeToFit()
        pokemonIndex.translatesAutoresizingMaskIntoConstraints = true
    }
    
    func loadImage(imageURL: URL) {
        AF.request(imageURL).responseImage { response in
            
            if case .success(let image) = response.result {
                self.pokemonImage.image = image
            }
        }
    }
    
    func fetchDescription(id: Int) {
        AF.request("https://pokeapi.co/api/v2/pokemon-species/\(id)/").responseDecodable(of: PokemonSpecies.self) { response in
            
            guard let safeData = response.value else {
                
                print("error retriving list")
                return
            }
            
            self.pokemonText.text = safeData.flavor_text_entries[0].flavor_text
        }
    }
}

// how to make it show pokemon as we scroll???
