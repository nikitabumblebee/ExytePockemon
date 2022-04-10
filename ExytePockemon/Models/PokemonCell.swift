//
//  PokemonCell.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/10/22.
//

import Foundation

/// Provides pokemon cell model
class PokemonCell {
    
    /// Instance of `Pokemon` for cell
    let pokemon: Pokemon
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    /**
     Change favorite status
     
     Calling this method will change status of `Pokemon` in CoreData entity
     */
    func changeFavoriteStatus() {
        pokemon.isFavorite.toggle()
        DBManager.shared().updateEntity(entityName: "PokemonList", entity: pokemon, value: pokemon.isFavorite, forKey: "isFavorite")
    }
}
