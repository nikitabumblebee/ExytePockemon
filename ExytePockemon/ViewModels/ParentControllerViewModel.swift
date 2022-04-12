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
    
    let PAGE_ITEMS = 10
    
    private(set) var page: Int = 0
    
    /// Instance of `PokemonCollectionModel` model
    let pokemonsCollectionModel: PokemonCollectionModel
    
    var collectionSections: [Section] {
        if getFavoritePokemons().count == 0 {
            return [Section(title: "All", items: getUnlikedPokemons())]
        } else {
            return [Section(title: "Favorite", items: getFavoritePokemons()),
                        Section(title: "All", items: getUnlikedPokemons())]
        }
    }
    
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
    
    func incrementPageCount() {
        page = page + 1
    }
    
    func getVisibleItemsInSection(section: Int) -> Int {
        let totalItemsInCollectionSection = collectionSections[section].items.count
        let itemsToShow = page * PAGE_ITEMS
        if totalItemsInCollectionSection < PAGE_ITEMS || itemsToShow > totalItemsInCollectionSection || collectionSections[section].title == "Favorite" {
            return totalItemsInCollectionSection
        } else {
            return PAGE_ITEMS * page
        }
    }
}
