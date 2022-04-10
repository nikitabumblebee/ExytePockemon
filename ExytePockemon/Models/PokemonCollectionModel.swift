//
//  PokemonCollectionModel.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/10/22.
//

import Foundation
import UIKit

class PokemonCollectionModel {
    private(set) var pokemons: [Pokemon] = []
    
    init() {
        pokemons = loadPokemons()
    }
    
    private func loadPokemons() -> [Pokemon] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.pokemons
    }
}
