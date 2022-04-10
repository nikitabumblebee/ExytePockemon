//
//  EntityProtocol.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/10/22.
//

import Foundation
import CoreData
import UIKit

protocol DataBaseManagerProtocol {
    func updateEntity(entityName: String, entity: EntityProtocol, value: Any, forKey: String)
    
    func saveEntity(entityName: String, entity: EntityProtocol, keyValuePairs: [String: Any])
    
    func loadData(entityName: String) -> [NSManagedObject]
}

extension DataBaseManagerProtocol {
    func loadData(entityName: String) -> [NSManagedObject] {
        var objects: [NSManagedObject] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return objects
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        do {
            let dbEntities = try managedContext.fetch(fetchRequest)
            for data in dbEntities {
                objects.append(data)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return objects
    }
    
    func updateEntity(entityName: String, entity: EntityProtocol, value: Any, forKey: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "name = %@", entity.name)
        do {
            guard let result = try managedContext.fetch(fetchRequest) as? [NSManagedObject] else { return }
            guard let objc = result.first else { return }
            objc.setValue(value, forKey: forKey)
            do {
                try managedContext.save()
            } catch let error as NSError {
                debugPrint(error)
            }
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
    func saveEntity(entityName: String, entity: EntityProtocol, keyValuePairs: [String: Any]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        let pokemonObject = NSManagedObject(entity: entity, insertInto: managedContext)
        for pair in keyValuePairs {
            pokemonObject.setValue(pair.value, forKey: pair.key)
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
