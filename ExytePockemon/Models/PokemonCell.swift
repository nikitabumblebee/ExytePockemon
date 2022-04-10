//
//  PokemonCell.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/10/22.
//

import Foundation

class PokemonCell {
    let pokemon: Pokemon
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    func changeFavoriteStatus() {
        pokemon.isFavorite.toggle()
        DBManager.shared().updateEntity(entityName: "PokemonList", entity: pokemon, value: pokemon.isFavorite, forKey: "isFavorite")
    }
}
