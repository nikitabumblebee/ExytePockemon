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

        configure()
    }
}

// MARK: Private methods
extension SelectedPokemonDescriptionController {
    private func configure() {
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
            let utility = Utility()
            utility.downloadImage(imagePath: self.pokemon.frontImage) { [weak self] image in
                DispatchQueue.main.async {
                    self?.frontImage.image = image
                }
            }
            utility.downloadImage(imagePath: self.pokemon.backImage) { [weak self] image in
                DispatchQueue.main.async {
                    self?.backImage.image = image
                }
            }
        }
    }
}
