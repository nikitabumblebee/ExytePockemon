//
//  DBManager.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/9/22.
//

import Foundation
import CoreData
import UIKit

class DBManager {
    private init() { }
    
    class func shared() -> DBManager {
        return sharedDBManage
    }
    
    private static var sharedDBManage: DBManager = {
        let dbManager = DBManager()
        return dbManager
    }()
    
    func loadPokemonData(entityName: String) -> [Pokemon] {
        var pokemons: [Pokemon] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return pokemons
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        do {
            let dbEntities = try managedContext.fetch(fetchRequest)
            for data in dbEntities {
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
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return pokemons
    }
    
    func saveEntity(entityName: String, pokemon: Pokemon) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        let pokemonObject = NSManagedObject(entity: entity, insertInto: managedContext)
        pokemonObject.setValue(pokemon.id, forKey: "id")
        pokemonObject.setValue(pokemon.name, forKeyPath: "name")
        pokemonObject.setValue(pokemon.height, forKey: "height")
        pokemonObject.setValue(pokemon.weight, forKey: "weight")
        pokemonObject.setValue(pokemon.baseExperience, forKey: "baseExperience")
        pokemonObject.setValue(pokemon.order, forKey: "order")
        pokemonObject.setValue(pokemon.frontImage, forKey: "frontImage")
        pokemonObject.setValue(pokemon.backImage, forKey: "backImage")
        pokemonObject.setValue(pokemon.types, forKey: "types")
        pokemonObject.setValue(pokemon.abilities, forKey: "abilities")
        pokemonObject.setValue(pokemon.isFavorite, forKey: "isFavorite")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func updateEntity(entityName: String, pokemon: Pokemon) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let  fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "name = %@", pokemon.name)
        do {
            guard let result = try managedContext.fetch(fetchRequest) as? [NSManagedObject] else { return }
            guard let objc = result.first else { return }
            objc.setValue(pokemon.isFavorite, forKey: "isFavorite")
            do {
                try managedContext.save()
            } catch let error as NSError {
                debugPrint(error)
            }
        } catch let error as NSError {
            debugPrint(error)
        }
    }
}
