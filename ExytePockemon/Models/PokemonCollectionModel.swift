//
//  PokemonCollectionModel.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/10/22.
//

import Foundation
import UIKit

/// Provides pokemon collection model
class PokemonCollectionModel {
    
    /// Gets an array of `Pokemon`
    private(set) var pokemons: [Pokemon] = []
    
    init() {
        pokemons = loadPokemons()
    }
    
    private func loadPokemons() -> [Pokemon] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.pokemons
    }
}
