//
//  EntityProtocol.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/10/22.
//

import Foundation

/// Provides entity protocol for CoreData database
protocol EntityProtocol {
    
    /// Gets or sets an ID of entity element
    var id: Int { get set }
}
