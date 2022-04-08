//
//  PockemonCellViewModel.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/8/22.
//

import Foundation
import UIKit

class PokemonCellViewModel {
    private var cachedImage: UIImage?
    private var isDownloading = false
    private var callback: ((UIImage?) -> Void)?
    
    var name: String
    var isFavoriteStatus: Bool
    var imagePath: String = "https://www.forksoverknives.com/wp-content/uploads/fly-images/159962/Middle-Eastern-Pita-Pocket-Sandwiches-wordpress-360x270-c.jpg"
    
    init(name: String, isFavorite: Bool, imagePath: String) {
        self.name = name
        self.isFavoriteStatus = isFavorite
        self.imagePath = imagePath
    }
    
    func downloadImage(imagePath: String = "https://www.forksoverknives.com/wp-content/uploads/fly-images/159962/Middle-Eastern-Pita-Pocket-Sandwiches-wordpress-360x270-c.jpg", completion: ((UIImage?) -> Void)?) {
        if let image = cachedImage {
            completion?(image)
            return
        }
        
        guard !isDownloading else {
            self.callback = completion
            return
        }
        
        isDownloading = true
        
        guard let url = URL(string: imagePath) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self?.cachedImage = image
                self?.callback?(image)
                self?.callback = nil
                completion?(image)
            }
        }
        task.resume()
    }
}
