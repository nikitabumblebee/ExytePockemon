//
//  NetworkManager.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/8/22.
//

import Foundation
import PokemonAPI
import Combine

public class NetworkManager {
    public func checkInternet() -> Bool {
        do {
            try Network.reachability = Reachability(hostname: "www.google.com")
            return true
        } catch {
            switch error as? Network.Error {
            case let .failedToCreateWith(hostname)?:
                print("Network error:\nFailed to create reachability object With host named:", hostname)
            case let .failedToInitializeWith(address)?:
                print("Network error:\nFailed to initialize reachability object With address:", address)
            case .failedToSetCallout?:
                print("Network error:\nFailed to set callout")
            case .failedToSetDispatchQueue?:
                print("Network error:\nFailed to set DispatchQueue")
            case .none:
                print(error)
            }
            return false
        }
    }
}
