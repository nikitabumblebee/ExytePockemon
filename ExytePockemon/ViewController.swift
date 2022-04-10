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
        
        loadData()
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.favoriteCollectionView {
            return self.pokemons.filter{ $0.isFavorite }.count
        } else {
            return self.pokemons.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == allCollectionView {
            let cell = allCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PockemonCellCollectionViewCell.self), for: indexPath) as! PockemonCellCollectionViewCell
            cell.configureCell(viewModel: self.pokemons[indexPath.row])
            cell.navigateButton.tag = self.pokemons[indexPath.row].id
            cell.navigateButton.addTarget(self, action: #selector(goDetail), for: .touchUpInside)
            cell.favoriteStatusButton.addTarget(self, action: #selector(changeStatusAction), for: .touchUpInside)
            return cell
        } else {
            let cell = favoriteCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PockemonCellCollectionViewCell.self), for: indexPath) as! PockemonCellCollectionViewCell
            cell.configureCell(viewModel: self.pokemons.filter{ $0.isFavorite }[indexPath.row])
            cell.navigateButton.tag = self.pokemons.filter{ $0.isFavorite }[indexPath.row].id
            cell.navigateButton.addTarget(self, action: #selector(goDetail), for: .touchUpInside)
            cell.favoriteStatusButton.addTarget(self, action: #selector(changeStatusAction), for: .touchUpInside)
            return cell
        }
    }
    
    @objc func changeStatusAction(sender: UIButton) {
        self.favoriteCollectionView.reloadData()
        self.allCollectionView.reloadData()
    }
    
    @objc func goDetail(sender: UIButton) {
        let pokemon = self.pokemons.first{ $0.id == sender.tag }
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
        DispatchQueue.global(qos: .utility).async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            self.pokemons = appDelegate.pokemons
            DispatchQueue.main.async {
                self.allCollectionView.reloadData()
                self.favoriteCollectionView.reloadData()
                self.isLoaded = true
            }
        }
    }
}
