//
//  Utilities.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/10/22.
//

import Foundation
import UIKit

/// Provides different helpers
class Utility {
    
    /**
     Download image
     
     Calling this method will download image from selected path
     
     - Parameters:
        - imagePath: Path to image
        - completion: Return an image
     */
    func downloadImage(imagePath: String, completion: ((UIImage?) -> Void)?) {
        guard let url = URL(string: imagePath) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                completion?(image)
            }
        }
        task.resume()
    }
}
