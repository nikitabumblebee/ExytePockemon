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
                        DBManager.shared().saveEntity(entityName: "PokemonList", pokemon: pokemon)
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
