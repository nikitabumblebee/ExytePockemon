//
//  NetworkManager.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/8/22.
//

import Foundation
import PokemonAPI

public class NetworkManager {
    public func createApiCall() {
        PokemonAPI().berryService.fetchBerry(1) { result in
            switch result {
            case .success(let berry):
                let a = berry
                print(berry.name)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
