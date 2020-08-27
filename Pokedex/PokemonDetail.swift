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
        
        pokemonName.text = safeData.name
        pokemonIndex.text = DataStylize.indexConvert(id: safeData.id)
        
        
        pokemonName.sizeToFit()
//      https://stackoverflow.com/questions/38714272/how-to-make-uitextview-height-dynamic-according-to-text-length
        pokemonName.translatesAutoresizingMaskIntoConstraints = true
        pokemonIndex.sizeToFit()
        pokemonIndex.translatesAutoresizingMaskIntoConstraints = true
    }
}

// how to make it show pokemon as we scroll???
