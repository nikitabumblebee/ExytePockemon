//
//  NetworkManager.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/8/22.
//

import Foundation
import PokemonAPI
import SwiftUI

public class NetworkManager {
    
    public private(set) var totalPokemonCount: Int = 0
    
    public private(set) var pokemons: [Pokemon] = []
    
    public private(set) var isReady = false
    
    public func getPokemonCount() -> Int {
        PokemonAPI().pokemonService.fetchPokemonList() { result in
            switch result {
            case .success(let a):
                self.totalPokemonCount = a.count!
                print(self.totalPokemonCount)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        return totalPokemonCount
    }
    
    public func getAllPokemons(totalPokemonCount: Int) {
        DispatchQueue.global(qos: .userInitiated).async {
            var iteration = 0
            for i in 0...totalPokemonCount {
                PokemonAPI().pokemonService.fetchPokemon(i) { result in
                    switch result {
                    case .success(let pokemonResult):
                        iteration += 1
                        let pokemon = Pokemon()
                        pokemon.name = pokemonResult.name
                        pokemon.weight = pokemonResult.weight
                        pokemon.height = pokemonResult.height
                        pokemon.order = pokemonResult.order
                        pokemon.baseExperience = pokemonResult.baseExperience
                        for typeIterator in 0..<pokemonResult.types!.count {
                            if let typeDescription = pokemonResult.types![typeIterator].type?.name {
                                pokemon.types.append(typeDescription)
                            }
                        }
                        for ability in 0..<pokemonResult.abilities!.count {
                            if let abilityDescription = pokemonResult.abilities![ability].ability?.name {
                                pokemon.abilities.append(abilityDescription)
                            }
                        }
                        pokemon.frontSideImagePath = pokemonResult.sprites?.frontDefault
                        pokemon.backSideImagePath = pokemonResult.sprites?.backDefault
                        self.pokemons.append(pokemon)
                        print("Get items \(self.pokemons.count)")
                    case .failure(let error):
                        iteration += 1
                        print(error.localizedDescription)
                    }
                    if iteration == totalPokemonCount {
                        self.isReady = true
                    }
                }
            }
        }
    }
}
