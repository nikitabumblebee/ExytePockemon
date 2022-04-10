//
//  EntityProtocol.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/10/22.
//

import Foundation
import CoreData
import UIKit

/// Provides methods for CoreData database interaction
protocol DataBaseManagerProtocol {
    
    /**
     Update selected entity
     
     Calling this method is updates value by key for selected entity object
     
     - Parameters:
        - entityName: Table name in CoreData database
        - entity: Entity that should be updated
        - value: New value
        - forKey: Key that updates
     */
    func updateEntity(entityName: String, entity: EntityProtocol, value: Any, forKey: String)
    
    /**
     Save entity
     
     Calling this method will save entity in selected table of CoreData database
     
     - Parameters:
        - entityName: Table name in CoreData database
        - entity: Entity that should be save
        - keyValuePairs: Dictionary of entity fields
     */
    func saveEntity(entityName: String, entity: EntityProtocol, keyValuePairs: [String: Any])
    
    /**
     Load data
     
     Calling this method loads an array of `NSManagedObject` of entity table
     
     - Parameters:
        - entityName: Table name in CoreData database
     
     - Returns:Array of `NSManagedObject` of selected table
     */
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
        fetchRequest.predicate = NSPredicate(format: "id = %@", String(entity.id))
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
