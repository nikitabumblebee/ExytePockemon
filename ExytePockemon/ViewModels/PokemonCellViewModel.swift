//
//  PokemonCellViewModel.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/10/22.
//

import Foundation

class PokemonCellViewModel {
    
    let pokemonModel: PokemonCell
    
    init(pokemon: Pokemon) {
        self.pokemonModel = PokemonCell(pokemon: pokemon)
    }
    
    func changeFavoriteStatus() {
        pokemonModel.changeFavoriteStatus()
    }
}
