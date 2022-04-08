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
        
        let a = NetworkManager()
        a.createApiCall()
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.favoriteCollectionView {
            return 2
        } else {
            return 20
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.favoriteCollectionView {
            let cell = favoriteCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PockemonCellCollectionViewCell.self), for: indexPath) as! PockemonCellCollectionViewCell
            cell.configureCell(viewModel: PockemonCellViewModel(name: "123", isFavorite: true, imagePath: ""))
            
            return cell
        }
        else {
            let cell = favoriteCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PockemonCellCollectionViewCell.self), for: indexPath) as! PockemonCellCollectionViewCell
            cell.configureCell(viewModel: PockemonCellViewModel(name: "!!!!", isFavorite: true, imagePath: ""))
            
            return cell
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

