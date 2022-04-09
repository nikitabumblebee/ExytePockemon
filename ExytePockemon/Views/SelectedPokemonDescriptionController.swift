//
//  SelectedPokemonDescriptionController.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/9/22.
//

import UIKit

class SelectedPokemonDescriptionController: UIViewController {

    @IBOutlet weak var frontImage: UIImageView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var typesMultilineLabel: UILabel!
    @IBOutlet weak var abilitiesMultilineLabel: UILabel!
    
    
    var pokemon: Pokemon
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.nameLabel.text = self.pokemon.name
            self.weightLabel.text = String(self.pokemon.weight)
            self.heightLabel.text = String(self.pokemon.height)
            self.orderLabel.text = String(self.pokemon.order)
            self.experienceLabel.text = String(self.pokemon.baseExperience)
            for type in self.pokemon.types {
                self.typesMultilineLabel.text?.append(contentsOf: "\(type) \n")
            }
            for ability in self.pokemon.abilities {
                self.abilitiesMultilineLabel.text?.append(contentsOf: "\(ability) \n")
            }
            self.loadImage(imagePath: self.pokemon.frontImage) { [weak self] image in
                DispatchQueue.main.async {
                    self?.frontImage.image = image
                }
            }
            self.loadImage(imagePath: self.pokemon.backImage) { [weak self] image in
                DispatchQueue.main.async {
                    self?.backImage.image = image
                }
            }
        }
        
        print("qwerty")
        // Do any additional setup after loading the view.
    }

    private func loadImage(imagePath: String, completion: ((UIImage?) -> Void)?) {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
