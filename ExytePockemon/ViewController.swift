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
    @IBAction func navigationButton(_ sender: UIButton) {
        
    }
    
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
        
        loadData()
    }
    
    private func loadData() {
        DispatchQueue.global(qos: .utility).async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            while self.isLoaded == false {
                self.isLoaded = appDelegate.isLoaded
            }
            self.pokemons = appDelegate.pokemons
            DispatchQueue.main.async {
                self.allCollectionView.reloadData()
                self.favoriteCollectionView.reloadData()
                self.isLoaded = true
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.favoriteCollectionView {
            print("Favorite count: \(self.pokemons.count)")
            return self.pokemons.filter{ $0.isFavorite }.count
        } else {
            print("Total count: \(self.pokemons.count)")
            return self.pokemons.count
        }
//        if isLoaded {
//            if collectionView == self.favoriteCollectionView {
//                return self.pokemons.filter{ $0.isFavorite }.count
//            } else {
//                return self.pokemons.count
//            }
//        } else {
//            if collectionView == self.favoriteCollectionView {
//                return 0
//            } else {
//                return 0
//            }
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == favoriteCollectionView {
            let cell = favoriteCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PockemonCellCollectionViewCell.self), for: indexPath) as! PockemonCellCollectionViewCell
            cell.configureCell(viewModel: self.pokemons[indexPath.row])
            
            return cell
        }
        else {
            if isLoaded {
                if collectionView == allCollectionView {
                    let cell = allCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PockemonCellCollectionViewCell.self), for: indexPath) as! PockemonCellCollectionViewCell
                    cell.configureCell(viewModel: self.pokemons[indexPath.row])
                    cell.navigateButton.tag = indexPath.row
                    cell.navigateButton.addTarget(self, action: #selector(goDetail), for: .touchUpInside)
                    return cell
                } else {
                    let cell = favoriteCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PockemonCellCollectionViewCell.self), for: indexPath) as! PockemonCellCollectionViewCell
                    cell.configureCell(viewModel: self.pokemons[indexPath.row])
                    cell.navigateButton.tag = indexPath.row
                    cell.navigateButton.addTarget(self, action: #selector(goDetail), for: .touchUpInside)
                    return cell
                }
            }
            else {
                let cell = favoriteCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PockemonCellCollectionViewCell.self), for: indexPath) as! PockemonCellCollectionViewCell
                cell.configureCell(viewModel: self.pokemons[indexPath.row])
                cell.navigateButton.tag = indexPath.row
                cell.navigateButton.addTarget(self, action: #selector(goDetail), for: .touchUpInside)
                return cell
            }
        }
    }
    
    @objc func goDetail(sender: UIButton) {
        let pokemon = self.pokemons[sender.tag]
        self.navigationController?.pushViewController(SelectedPokemonDescriptionController(pokemon: pokemon), animated: true)
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

