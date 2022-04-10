//
//  ViewController.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/7/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var allCollectionView: UICollectionView!
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    
    let viewModel = ParentControllerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteCollectionView.delegate = self
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.register(UINib(nibName: String(describing: PockemonCellCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PockemonCellCollectionViewCell.self))
        
        allCollectionView.delegate = self
        allCollectionView.dataSource = self
        allCollectionView.register(UINib(nibName: String(describing: PockemonCellCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PockemonCellCollectionViewCell.self))
        
        loadData()
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.favoriteCollectionView {
            favoriteCollectionView.isHidden = self.viewModel.setFavoriteHidden()
            favoriteLabel.isHidden = self.viewModel.setFavoriteHidden()
            return self.viewModel.getFavoritePokemons().count
        } else {
            return self.viewModel.pokemons.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == allCollectionView {
            return buildAllCollectionCell(indexPath: indexPath)
        } else {
            return buildFavoriteCell(indexPath: indexPath)
        }
    }
    
    @objc func changeStatusAction(sender: UIButton) {
        self.favoriteCollectionView.reloadData()
        self.allCollectionView.reloadData()
    }
    
    @objc func goDetail(sender: UIButton) {
        let pokemon = self.viewModel.getConcretePokemonByID(id: sender.tag)
        guard let existingPokemon = pokemon else {
            return
        }
        self.navigationController?.pushViewController(SelectedPokemonDescriptionController(pokemon: existingPokemon), animated: true)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: favoriteCollectionView.frame.width / 2 - 10, height: favoriteCollectionView.frame.width / 2 - 10)
    }
}

// MARK: Private functions
extension ViewController {
    private func loadData() {
        DispatchQueue.main.async {
            self.allCollectionView.reloadData()
            self.favoriteCollectionView.reloadData()
        }
    }
    
    private func createPokemonCell(cell: PockemonCellCollectionViewCell, pokemon: Pokemon) -> PockemonCellCollectionViewCell {
        cell.configureCell(pokemon: pokemon)
        cell.navigateButton.tag = pokemon.id
        cell.navigateButton.addTarget(self, action: #selector(goDetail), for: .touchUpInside)
        cell.favoriteStatusButton.addTarget(self, action: #selector(changeStatusAction), for: .touchUpInside)
        return cell
    }
    
    private func buildAllCollectionCell(indexPath: IndexPath) -> PockemonCellCollectionViewCell {
        var cell = allCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PockemonCellCollectionViewCell.self), for: indexPath) as! PockemonCellCollectionViewCell
        let pokemon = self.viewModel.pokemons[indexPath.row]
        cell = createPokemonCell(cell: cell, pokemon: pokemon)
        return cell
    }
    
    private func buildFavoriteCell(indexPath: IndexPath) -> PockemonCellCollectionViewCell {
        var cell = favoriteCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PockemonCellCollectionViewCell.self), for: indexPath) as! PockemonCellCollectionViewCell
        let pokemon = self.viewModel.getFavoritePokemons()[indexPath.row]
        cell = createPokemonCell(cell: cell, pokemon: pokemon)
        return cell
    }
}
