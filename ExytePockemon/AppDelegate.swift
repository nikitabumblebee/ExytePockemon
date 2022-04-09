//
//  AppDelegate.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/7/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private(set) var pokemons: [Pokemon] = []
    
    private(set) var isLoaded = false
    
    private func loadData() {
        let networkManager = NetworkManager()
        DispatchQueue.global(qos: .utility).async {
            let pokemonCount = networkManager.getPokemonCount()
            networkManager.getAllPokemons(totalPokemonCount: pokemonCount)
            while networkManager.isReady == false {
                self.pokemons = networkManager.pokemons
            }
            self.isLoaded = true
        }
    }
    
    private func checkInternet() -> Bool {
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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let isActive = checkInternet()
        if isActive {
            self.loadData()
        } else {
            
        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

