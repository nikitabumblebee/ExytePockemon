//
//  PokemonHelper.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/9/22.
//

import Foundation
import PokemonAPI
import CoreData

/// Provides helpers that interacts with PokemonAPI
class PokemonHelper {
    
    /**
     Converts array of `NSManagedObject` to `Pokemon` array
     
     Calling this method will convert array of CoreData's entity `NSManagedObject` to `Pokemon` array
     
     - Parameters:
        - objects: An array of `NSManagedObject` of CoreData
     
     - Returns: An array of `Pokemon`
     */
    func getConvertedManagedObjectsToPokemons(objects: [NSManagedObject]) -> [Pokemon] {
        var pokemons: [Pokemon] = []
        for data in objects {
            let id = data.value(forKey: "id") as! Int
            let name = data.value(forKey: "name") as! String
            let weight = data.value(forKey: "weight") as! Int
            let height = data.value(forKey: "height") as! Int
            let order = data.value(forKey: "order") as! Int
            let baseExperience = data.value(forKey: "baseExperience") as! Int
            let types = data.value(forKey: "types") as! [String]
            let abilities = data.value(forKey: "abilities") as! [String]
            let frontImage = data.value(forKey: "frontImage") as! String
            let backImage = data.value(forKey: "backImage") as! String
            let isFavorite = data.value(forKey: "isFavorite") as! Bool
            let pokemon = Pokemon(id: id, name: name, weight: weight, height: height, order: order, baseExperience: baseExperience, types: types, abilities: abilities, frontImage: frontImage, backImage: backImage, isFavorite: isFavorite)
            pokemons.append(pokemon)
        }
        return pokemons
    }
    
    /**
     Get all available pokemons
     
     Calling this method will create an array of available pokemons
     
     - Parameters:
        - totalPokemonCount: Count of pokemons in PokemonAPI
     
     - Returns: An array of `Pokemon`
     */
    func getAllPokemons(totalPokemonCount: Int) -> [Pokemon] {
        var pokemons: [Pokemon] = []
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global(qos: .utility).async {
            for i in 0...totalPokemonCount {
                PokemonAPI().pokemonService.fetchPokemon(i) { result in
                    switch result {
                    case .success(let pokemonResult):
                        let pokemon = self.buildPokemon(pokemonResult: pokemonResult)
                        pokemons.append(pokemon)
                        print("Get items \(pokemons.count)")
                        
                        let pokemonKeyValuePairs: [String: Any] = ["id": pokemon.id,
                                                                   "name": pokemon.name,
                                                                   "height": pokemon.height,
                                                                   "weight": pokemon.weight,
                                                                   "baseExperience": pokemon.baseExperience,
                                                                   "order": pokemon.order,
                                                                   "frontImage": pokemon.frontImage,
                                                                   "backImage": pokemon.backImage,
                                                                   "types": pokemon.types,
                                                                   "abilities": pokemon.abilities,
                                                                   "isFavorite": pokemon.isFavorite]
                        
                        DBManager.shared().saveEntity(entityName: "PokemonList", entity: pokemon, keyValuePairs: pokemonKeyValuePairs)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    if i == totalPokemonCount {
                        group.leave()
                        UserDefaults.standard.set(pokemons.count, forKey: "AvailablePokemons")
                    }
                }
            }
        }
        group.wait()
        return pokemons
    }
    
    // TODO: Update background pokemon count check
    func checkAvailablePokemons(pokemonCount: Int) -> Bool {
        var availablePokemons: Int = 0
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global(qos: .background).async {
            for i in 0...pokemonCount {
                PokemonAPI().pokemonService.fetchPokemon(i) { result in
                    switch result {
                    case .success(_):
                        availablePokemons += 1
                        print("Get items \(availablePokemons)")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    if i == pokemonCount {
                        group.leave()
                    }
                }
            }
        }
        group.wait()
        if availablePokemons == UserDefaults.standard.integer(forKey: "AvailablePokemons") {
            return true
        } else {
            return false
        }
    }
    
    /**
     Get pokemon count from PokemonAPI
     
     Calling this method will find a count of pokemons
     
     - Returns: Pokemons count from PokemonAPI
     */
    func getPokemonCount() -> Int {
        var pokemonCount = 0
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.global(qos: .utility).async {
            PokemonAPI().pokemonService.fetchPokemonList(completion: { result in
                switch result {
                case .success(let pokemonResult):
                    if let totalPokemonCount = pokemonResult.count {
                        pokemonCount = totalPokemonCount
                    } else {
                        pokemonCount = 0
                    }
                    print("Success \(pokemonCount)")
                    group.leave()
                    break
                case .failure(let error):
                    group.leave()
                    print(error.localizedDescription)
                }
            })
        }
        group.wait()

        return pokemonCount
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
