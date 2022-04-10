//
//  Pokemon.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/8/22.
//

import Foundation

public class Pokemon {
    public var id: Int
    var name: String
    var weight: Int
    var height: Int
    var order: Int
    var baseExperience: Int
    var types: [String]
    var abilities: [String]
    var frontImage: String
    var backImage: String
    var isFavorite: Bool
    
    init(id: Int, name: String, weight: Int, height: Int, order: Int, baseExperience: Int, types: [String], abilities: [String], frontImage: String, backImage: String, isFavorite: Bool) {
        self.id = id
        self.name = name
        self.weight = weight
        self.height = height
        self.order = order
        self.baseExperience = baseExperience
        self.types = types
        self.abilities = abilities
        self.frontImage = frontImage
        self.backImage = backImage
        self.isFavorite = isFavorite
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        weight = try container.decode(Int.self, forKey: .weight)
        height = try container.decode(Int.self, forKey: .height)
        order = try container.decode(Int.self, forKey: .order)
        baseExperience = try container.decode(Int.self, forKey: .baseExperience)
        types = try container.decode([String].self, forKey: .types)
        abilities = try container.decode([String].self, forKey: .abilities)
        frontImage = try container.decode(String.self, forKey: .frontImage)
        backImage = try container.decode(String.self, forKey: .backImage)
        isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
    }
}

extension Pokemon: Codable {
    enum CodingKeys: CodingKey {
        case id
        case name
        case weight
        case height
        case order
        case baseExperience
        case types
        case abilities
        case frontImage
        case backImage
        case isFavorite
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(weight, forKey: .weight)
        try container.encode(height, forKey: .height)
        try container.encode(order, forKey: .order)
        try container.encode(baseExperience, forKey: .baseExperience)
        try container.encode(types, forKey: .types)
        try container.encode(abilities, forKey: .abilities)
        try container.encode(frontImage, forKey: .frontImage)
        try container.encode(backImage, forKey: .backImage)
        try container.encode(isFavorite, forKey: .isFavorite)
    }
}

extension Pokemon: Identifiable { }
