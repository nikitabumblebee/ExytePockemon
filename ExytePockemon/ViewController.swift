//
//  ViewController.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/7/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var allCollectionView: UICollectionView!
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    
    private var isFavorite = false
    
    private var isLoaded = false
    
    private var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteCollectionView.delegate = self
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.register(UINib(nibName: String(describing: PockemonCellCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PockemonCellCollectionViewCell.self))
        
        allCollectionView.delegate = self
        allCollectionView.dataSource = self
        allCollectionView.register(UINib(nibName: String(describing: PockemonCellCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PockemonCellCollectionViewCell.self))
        
        let favoriteLabel = UILabel()
        favoriteLabel.text = "Favorite"
        contentScrollView.addSubview(favoriteLabel)
        let allLabel = UILabel()
        allLabel.text = "All"
        contentScrollView.addSubview(allLabel)
        
        let networkManager = NetworkManager()
        var pokemonCount = networkManager.getPokemonCount()
        DispatchQueue.global(qos: .userInitiated).async {
            while pokemonCount == 0 {
                pokemonCount = networkManager.totalPokemonCount
            }
            networkManager.getAllPokemons(totalPokemonCount: pokemonCount)
            while networkManager.isReady == false {
                self.pokemons = networkManager.pokemons
            }
            DispatchQueue.main.async {
                self.allCollectionView.indexPathsForVisibleItems.forEach {
                    if let cell = self.allCollectionView.cellForItem(at: $0) as? PockemonCellCollectionViewCell {
                        if let imagePath = self.pokemons[$0.row].frontSideImagePath,
                           let pokemonName = self.pokemons[$0.row].name {
                            cell.configureCell(viewModel: PokemonCellViewModel(name: pokemonName, isFavorite: false, imagePath: imagePath))
                            self.isLoaded = true
                            self.allCollectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoaded {
            if collectionView == self.favoriteCollectionView {
                return 2
            } else {
                return self.pokemons.count
            }
        } else {
            if collectionView == self.favoriteCollectionView {
                return 2
            } else {
                return 20
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.favoriteCollectionView {
            let cell = favoriteCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PockemonCellCollectionViewCell.self), for: indexPath) as! PockemonCellCollectionViewCell
            cell.configureCell(viewModel: PokemonCellViewModel(name: "123", isFavorite: true, imagePath: ""))
            
            return cell
        }
        else {
            if isLoaded {
                let cell = favoriteCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PockemonCellCollectionViewCell.self), for: indexPath) as! PockemonCellCollectionViewCell
                if let name = self.pokemons[indexPath.row].name,
                   let imagePath = self.pokemons[indexPath.row].frontSideImagePath {
                    cell.configureCell(viewModel: PokemonCellViewModel(name: name, isFavorite: true, imagePath: imagePath))
                }
                
                return cell
            }
            else {
                let cell = favoriteCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PockemonCellCollectionViewCell.self), for: indexPath) as! PockemonCellCollectionViewCell
                cell.configureCell(viewModel: PokemonCellViewModel(name: "!!!!", isFavorite: true, imagePath: ""))
                
                return cell
            }
            
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: favoriteCollectionView.frame.width / 2 - 10, height: favoriteCollectionView.frame.width / 2 - 10)
    }
}

