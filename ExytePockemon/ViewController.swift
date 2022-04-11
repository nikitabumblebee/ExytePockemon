//
//  ViewController.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/7/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var pokemonCollection: UICollectionView!
    
    let viewModel = ParentControllerViewModel()
    
    let PAGE_ITEMS = 10
    
    var page: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonCollection.register(UINib(nibName: String(describing: PockemonCellCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PockemonCellCollectionViewCell.self))
        pokemonCollection.register(UINib(nibName: String(describing: HeaderSupplementaryView.self), bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: String(describing: HeaderSupplementaryView.reuseId))
        
        pokemonCollection.delegate = self
        pokemonCollection.dataSource = self
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.pokemonCollection.contentOffset.y >= (self.pokemonCollection.contentSize.height - self.pokemonCollection.bounds.size.height)) {
            page = page + 1
            pokemonCollection.reloadData()
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderSupplementaryView.reuseId, for: indexPath) as? HeaderSupplementaryView else {
            return HeaderSupplementaryView()
        }
        headerView.titleLabel.text = viewModel.collectionSections[indexPath.section].title
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 200, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let totalItemsInCollectionSection = viewModel.collectionSections[section].items.count
        let itemsToShow = page * PAGE_ITEMS
        if totalItemsInCollectionSection < PAGE_ITEMS || itemsToShow > totalItemsInCollectionSection {
            return viewModel.collectionSections[section].items.count
        } else {
            return PAGE_ITEMS * page
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PockemonCellCollectionViewCell.reuseId, for: indexPath) as! PockemonCellCollectionViewCell
        let section = viewModel.collectionSections[indexPath.section]
        let item = section.items[indexPath.item]
        cell.navigateButton.tag = item.id
        cell.navigateButton.addTarget(self, action: #selector(goDetail), for: .touchUpInside)
        cell.favoriteStatusButton.addTarget(self, action: #selector(changeStatusAction), for: .touchUpInside)
        cell.configureCell(pokemon: item)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.collectionSections.count
    }
    
    @objc func changeStatusAction(sender: UIButton) {
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
    private func createPokemonCell(cell: PockemonCellCollectionViewCell, pokemon: Pokemon) -> PockemonCellCollectionViewCell {
        cell.configureCell(pokemon: pokemon)
        cell.navigateButton.tag = pokemon.id
        cell.navigateButton.addTarget(self, action: #selector(goDetail), for: .touchUpInside)
        cell.favoriteStatusButton.addTarget(self, action: #selector(changeStatusAction), for: .touchUpInside)
        return cell
    }
}
