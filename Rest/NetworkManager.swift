//
//  NetworkManager.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/8/22.
//

import Foundation
import PokemonAPI
import Combine

public class NetworkManager {
    
    public private(set) var totalPokemonCount: Int = 0
    
    public private(set) var pokemons: [Pokemon] = []
    
    public private(set) var isReady = false
        
    public func checkInternet() -> Bool {
        do {
            try Network.reachability = Reachability(hostname: "www.google.com")
            return true
        } catch {
            switch error as? Network.Error {
            case let .failedToCreateWith(hostname)?:
                print("Network error:\nFailed to create reachability object With host named:", hostname)
            case let .failedToInitializeWith(address)?:
                print("Network error:\nFailed to initialize reachability object With address:", address)
            case .failedToSetCallout?:
                print("Network error:\nFailed to set callout")
            case .failedToSetDispatchQueue?:
                print("Network error:\nFailed to set DispatchQueue")
            case .none:
                print(error)
            }
            return false
        }
    }
    
    public func getPokemonCount() -> Int {
        var iteration = 0
        while self.totalPokemonCount == 0 || iteration == 20 {
            PokemonAPI().pokemonService.fetchPokemonList(completion: { result in
                switch result {
                case .success(let pokemonResult):
                    if let totalPokemonCount = pokemonResult.count {
                        self.totalPokemonCount = totalPokemonCount
                    } else {
                        self.totalPokemonCount = 0
                    }
                    print("Success \(self.totalPokemonCount)")
                    iteration = 100
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
            iteration += 1
        }
        return totalPokemonCount
    }
    
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
    
    private func buildPokemon(pokemonResult: PKMPokemon) -> Pokemon {
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
        return pokemon
    }
}
