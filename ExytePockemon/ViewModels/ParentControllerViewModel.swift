//
//  ViewModel.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/10/22.
//

import Foundation
import UIKit

class ParentControllerViewModel {
    let pokemonsCollectionModel: PokemonCollectionModel
    
    init() {
        self.pokemonsCollectionModel = PokemonCollectionModel()
    }
    
    func getUnlikedPokemons() -> [Pokemon] {
        return pokemonsCollectionModel.pokemons.filter { $0.isFavorite == false }
    }
    
    func getFavoritePokemons() -> [Pokemon] {
        return pokemonsCollectionModel.pokemons.filter { $0.isFavorite }
    }
    
    func getConcretePokemonByID(id: Int) -> Pokemon? {
        return pokemonsCollectionModel.pokemons.first { $0.id == id }
    }
    
    func setFavoriteHidden() -> Bool {
        return pokemonsCollectionModel.pokemons.filter { $0.isFavorite }.count > 0 ? false : true
    }
}
