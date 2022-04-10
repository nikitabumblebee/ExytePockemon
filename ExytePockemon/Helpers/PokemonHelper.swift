//
//  PokemonHelper.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/9/22.
//

import Foundation
import PokemonAPI
import CoreData

class PokemonHelper {
    public private(set) var pokemons: [Pokemon] = []
    
    public private(set) var isReady = false
    
    private(set) var isChecked = false
    
    public private(set) var totalPokemonCount: Int = 0
    
    private(set) var apiPokemonCounter = 0
    
    public func getAllPokemons(totalPokemonCount: Int) {
        DispatchQueue.global(qos: .utility).async {
            var iteration = 0
            let downloadGroup = DispatchGroup()
            for i in 0...totalPokemonCount {
                downloadGroup.enter()
                PokemonAPI().pokemonService.fetchPokemon(i) { result in
                    switch result {
                    case .success(let pokemonResult):
                        iteration += 1
                        downloadGroup.leave()
                        let pokemon = self.buildPokemon(pokemonResult: pokemonResult)
                        self.pokemons.append(pokemon)
                        print("Get items \(self.pokemons.count)")
                        DBManager.shared().saveEntity(entityName: "PokemonList", pokemon: pokemon)
                    case .failure(let error):
                        iteration += 1
                        print(error.localizedDescription)
                    }
                    if iteration == totalPokemonCount {
                        self.isReady = true
                    }
                }
            }
            downloadGroup.wait()
        }
    }
    
    public func getPokemonCount() -> Int {
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.global(qos: .utility).async {
            PokemonAPI().pokemonService.fetchPokemonList(completion: { result in
                switch result {
                case .success(let pokemonResult):
                    if let totalPokemonCount = pokemonResult.count {
                        self.totalPokemonCount = totalPokemonCount
                    } else {
                        self.totalPokemonCount = 0
                    }
                    print("Success \(self.totalPokemonCount)")
                    group.leave()
                    break
                case .failure(let error):
                    group.leave()
                    print(error.localizedDescription)
                }
            })
        }
        group.wait()

        return totalPokemonCount
    }
    
    private func buildPokemon(pokemonResult: PKMPokemon) -> Pokemon {
        if let id = pokemonResult.id,
           let name = pokemonResult.name,
           let weight = pokemonResult.weight,
           let height = pokemonResult.height,
           let order = pokemonResult.order,
           let baseExperience = pokemonResult.baseExperience,
           let frontImage = pokemonResult.sprites?.frontDefault,
           let backImage = pokemonResult.sprites?.backDefault,
           let typesCount = pokemonResult.types,
           let abilitiesCount = pokemonResult.abilities {
            var types: [String] = []
            for typeIterator in 0..<typesCount.count {
                if let typeDescription = pokemonResult.types![typeIterator].type?.name {
                    types.append(typeDescription)
                }
            }
            var abilities: [String] = []
            for ability in 0..<abilitiesCount.count {
                if let abilityDescription = pokemonResult.abilities![ability].ability?.name {
                    abilities.append(abilityDescription)
                }
            }
            let pokemon = Pokemon(id: id, name: name, weight: weight, height: height, order: order, baseExperience: baseExperience, types: types, abilities: abilities, frontImage: frontImage, backImage: backImage, isFavorite: false)
            return pokemon
        } else {
            return Pokemon(id: 1, name: "", weight: 0, height: 0, order: 0, baseExperience: 0, types: [""], abilities: [""], frontImage: "", backImage: "", isFavorite: false)
        }
    }
}
