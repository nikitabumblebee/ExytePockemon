//
//  Pokemon.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/8/22.
//

import Foundation

public class Pokemon: Identifiable {
    var name: String?
    var weight: Int?
    var height: Int?
    var order: Int?
    var baseExperience: Int?
    var types: [String] = []
    var abilities: [String] = []
    var frontSideImagePath: String?
    var backSideImagePath: String?
}
