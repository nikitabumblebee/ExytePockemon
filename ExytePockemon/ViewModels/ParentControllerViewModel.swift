//
//  ViewModel.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/10/22.
//

import Foundation
import UIKit

/// Proviedes `ViewController`'s view model
class ParentControllerViewModel {
    
    /// Instance of `PokemonCollectionModel` model
    let pokemonsCollectionModel: PokemonCollectionModel
    
    /// Initializes `ParentControllerViewModel`
    init() {
        self.pokemonsCollectionModel = PokemonCollectionModel()
    }
    
    /**
     Get array of unliked pokemins
     
     Calling this method will return an array of `Pokemon` that isn't liked
     
     - Returns: An array of unliked pokemons
     */
    func getUnlikedPokemons() -> [Pokemon] {
        return pokemonsCollectionModel.pokemons.filter { $0.isFavorite == false }
    }
    
    /**
     Get array of favorite pokemons
     
     Calling this method will return an array of `Pokemon` that user is liked
     
     - Returns: An array of liked pokemons
     */
    func getFavoritePokemons() -> [Pokemon] {
        return pokemonsCollectionModel.pokemons.filter { $0.isFavorite }
    }
    
    /**
     Get pokemon
     
     Calling this method will return concrete `Pokemon`
     
     - Parameters:
        - id: ID of selected `Pokemon`
     
     - Returns: `Pokemon` by ID
     */
    func getConcretePokemonByID(id: Int) -> Pokemon? {
        return pokemonsCollectionModel.pokemons.first { $0.id == id }
    }
    
    /**
     Hides collection of favorite pokemons
     
     Calling this method will check count of favorite pokemons
     
     - Returns: Is favorite pokemons count is more that 0 -> `true`, else -> `false`
     */
    func setFavoriteHidden() -> Bool {
        return pokemonsCollectionModel.pokemons.filter { $0.isFavorite }.count > 0 ? false : true
    }
}
