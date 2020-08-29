//
//  PokemonCell.swift
//  Pokedex
//
//  Created by Kelly Ho on 2020-08-22.
//  Copyright © 2020 Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class PokemonCell: UITableViewCell {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var pokeImage: UIImageView!
    @IBOutlet var index: UILabel!
    
    func setPokemonList(data: PokemonDetailInfo) {
        
        name.text = data.name.capitalized
        index.text = DataStylize.indexConvert(id: data.id)
        loadImage(imageURL: data.sprites.front_default)
    }
    
    func loadImage(imageURL: URL) {
                
        AF.request(imageURL).responseImage { response in
            
            if case .success(let image) = response.result {
                self.pokeImage.image = image
            }
        }
    }
}
