//
//  DBManager.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/9/22.
//

import Foundation
import CoreData
import UIKit

/// Provides CoreData manager (singletone)
class DBManager: DataBaseManagerProtocol {    
    
    private init() { }
    
    class func shared() -> DBManager {
        return sharedDBManage
    }
    
    private static var sharedDBManage: DBManager = {
        let dbManager = DBManager()
        return dbManager
    }()
}
