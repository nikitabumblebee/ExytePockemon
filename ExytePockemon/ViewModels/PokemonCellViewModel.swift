//
//  PokemonCellViewModel.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/10/22.
//

import Foundation

/// Provides `PockemonCellCollectionViewCell` view model
class PokemonCellViewModel {
    
    /// Instance of `PokeminCell` model
    let pokemonModel: PokemonCell
    
    init(pokemon: Pokemon) {
        self.pokemonModel = PokemonCell(pokemon: pokemon)
    }
    
    /**
     Change status of pokemon
     
     Calling this method will change favorite status of pokemon
     */
    func changeFavoriteStatus() {
        pokemonModel.changeFavoriteStatus()
    }
}
