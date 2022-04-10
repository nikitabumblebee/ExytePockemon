//
//  ViewModel.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/10/22.
//

import Foundation
import UIKit

class ParentControllerViewModel {
    private(set) var pokemons: [Pokemon] = []
    
    init() {
        self.pokemons = loadPokemons()
    }
    
    private func loadPokemons() -> [Pokemon] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.pokemons
    }
    
    func getFavoritePokemons() -> [Pokemon] {
        return pokemons.filter { $0.isFavorite }
    }
    
    func getConcretePokemonByID(id: Int) -> Pokemon? {
        return pokemons.first { $0.id == id }
    }
    
    func setFavoriteHidden() -> Bool {
        return pokemons.filter { $0.isFavorite }.count > 0 ? false : true
    }
}
