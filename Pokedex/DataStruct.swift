//
//  PokemonList.swift
//  Pokedex
//
//  Created by Kelly Ho on 2020-08-21.
//  Copyright © 2020 Inc. All rights reserved.
//

import Foundation

// FROM: https://pokeapi.co/api/v2/pokemon
struct PokemonListURLContainer: Decodable {
    let results: [PokemonListURL]
}

struct PokemonListURL: Decodable {
    let name: String
    let url: String
}

// FROM: https://pokeapi.co/api/v2/pokemon/1/
struct PokemonDetailInfo: Decodable {
    let id: Int
    let name: String
    let sprites: SpritList
    let types: [TypeList]
}

struct SpritList: Decodable {
    let front_default: URL
}

struct TypeList: Decodable {
    let slot: Int
    let type: TypeSlot
}

struct TypeSlot: Decodable {
    let name: String
}

// FROM https://pokeapi.co/api/v2/pokemon-species/1/

struct PokemonSpecies: Decodable {
    let flavor_text_entries: [PokemonFlavorText]
}

struct PokemonFlavorText: Decodable {
    let flavor_text: String
}
