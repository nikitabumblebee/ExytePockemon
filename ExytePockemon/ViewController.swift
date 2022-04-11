//
//  ViewController.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/7/22.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    @IBOutlet weak var pokemonCollection: UICollectionView!
    
    let viewModel = ParentControllerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pokemonCollection.register(UINib(nibName: String(describing: PockemonCellCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PockemonCellCollectionViewCell.self))
        pokemonCollection.register(UINib(nibName: String(describing: HeaderSupplementaryView.self), bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: String(describing: HeaderSupplementaryView.reuseId))
        
        pokemonCollection.delegate = self
        pokemonCollection.dataSource = self

        checkSections()
        self.pokemonCollection.reloadData()
    }
    
    var collectionView: UICollectionView!
    
    var sections: [MSection]?
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let section = self.sections![sectionIndex]
            
            return self.createActiveChatSection()
        }
        
        return layout
    }
    
    func createActiveChatSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(86))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 8, trailing: 0)
                
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 66, leading: 20, bottom: 0, trailing: 20)
        
        return section
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderSupplementaryView.reuseId, for: indexPath) as? HeaderSupplementaryView else {
            return HeaderSupplementaryView()
        }
        headerView.titleLabel.text = sections![indexPath.section].title
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 200, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections![section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PockemonCellCollectionViewCell.reuseId, for: indexPath) as! PockemonCellCollectionViewCell
        let section = sections![indexPath.section]
        let item = section.items[indexPath.item]
        cell.navigateButton.tag = item.id
        cell.navigateButton.addTarget(self, action: #selector(goDetail), for: .touchUpInside)
        cell.favoriteStatusButton.addTarget(self, action: #selector(changeStatusAction), for: .touchUpInside)
        cell.configureCell(pokemon: item)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections!.count
    }
    
    @objc func changeStatusAction(sender: UIButton) {
        checkSections()
        self.pokemonCollection.reloadData()
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
        return CGSize(width: pokemonCollection.frame.width / 2 - 10, height: pokemonCollection.frame.width / 2 - 10)
    }
}

// MARK: Private functions
extension ViewController {
    private func checkSections() {
        if viewModel.getFavoritePokemons().count == 0 {
            sections = [MSection(title: "All", items: viewModel.getUnlikedPokemons())]
        } else {
            sections = [MSection(title: "Favorite", items: viewModel.getFavoritePokemons()),
                        MSection(title: "All", items: viewModel.getUnlikedPokemons())]
        }
    }
    
    private func createPokemonCell(cell: PockemonCellCollectionViewCell, pokemon: Pokemon) -> PockemonCellCollectionViewCell {
        cell.configureCell(pokemon: pokemon)
        cell.navigateButton.tag = pokemon.id
        cell.navigateButton.addTarget(self, action: #selector(goDetail), for: .touchUpInside)
        cell.favoriteStatusButton.addTarget(self, action: #selector(changeStatusAction), for: .touchUpInside)
        return cell
    }
}
