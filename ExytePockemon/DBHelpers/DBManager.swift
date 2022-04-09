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
    
    private(set) var dbEntities: [NSManagedObject] = []
    
    func loadData(entityName: String) -> [NSManagedObject] {
        var dbEntities: [NSManagedObject] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return dbEntities
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        do {
            dbEntities = try managedContext.fetch(fetchRequest)
            self.dbEntities = dbEntities
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return dbEntities
    }
    
    func saveEntity(entityName: String, pokemon: Pokemon) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(pokemon.name, forKeyPath: "name")
        person.setValue(pokemon.height, forKey: "height")
        person.setValue(pokemon.weight, forKey: "weight")
        person.setValue(pokemon.baseExperience, forKey: "baseExperience")
        person.setValue(pokemon.order, forKey: "order")
        person.setValue(pokemon.frontSideImagePath, forKey: "frontImage")
        person.setValue(pokemon.backSideImagePath, forKey: "backImage")
        //person.setValue(pokemon.types, forKey: "types")
        //person.setValue(pokemon.abilities, forKey: "abilities")
        
        do {
            try managedContext.save()
            dbEntities.append(person)
            print("DB count: \(dbEntities.count)")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
