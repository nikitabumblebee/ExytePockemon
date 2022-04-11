//
//  MSection.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/11/22.
//

import Foundation

class Section {
    let title: String
    var items: [Pokemon]
    
    init(title: String, items: [Pokemon]) {
        self.title = title
        self.items = items
    }
}
