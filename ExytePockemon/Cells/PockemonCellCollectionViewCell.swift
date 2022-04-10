//
//  PockemonCellCollectionViewCell.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/8/22.
//

import UIKit

class PockemonCellCollectionViewCell: UICollectionViewCell {
    
    private let photo: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
        
    private var isFavorite: Bool = false
    private(set) var pokemonCellModel: PokemonCell?
        
    @IBAction func changeStatusAction(_ sender: UIButton) {
        pokemonCellModel?.changeFavoriteStatus()
        isFavorite.toggle()
        configureButton(sender)
    }

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var pockemonImage: UIImageView!
    @IBOutlet weak var pockemonName: UILabel!
    @IBOutlet weak var favoriteStatusButton: UIButton!
    @IBOutlet weak var navigateButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addSubview(photo)
        addConstraints()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        photo.image = nil
    }
    
    func configureCell(pokemon: Pokemon) {
        self.pokemonCellModel = PokemonCell(pokemon: pokemon)
        createCellRootLayer()
        createFavoriteStatusButton()
        pockemonName.text = pokemon.name
        isFavorite = pokemon.isFavorite
        configureButton(favoriteStatusButton)
        let utility = Utility()
        utility.downloadImage(imagePath: pokemon.frontImage) { [weak self] image in
            DispatchQueue.main.async {
                self?.photo.image = image
            }
        }
    }
}

// MARK: Private methods
extension PockemonCellCollectionViewCell {
    private func createCellRootLayer() {
        self.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.borderWidth = CGFloat(1)
        self.layer.cornerRadius = CGFloat(8)
    }
    
    private func createFavoriteStatusButton() {
        self.favoriteStatusButton.layer.backgroundColor = UIColor.white.cgColor
        self.favoriteStatusButton.tintColor = UIColor.white
        self.favoriteStatusButton.layer.borderColor = UIColor.black.cgColor
        self.favoriteStatusButton.layer.borderWidth = 1
        self.favoriteStatusButton.layer.cornerRadius = 6
        self.favoriteStatusButton.setTitleColor(UIColor.systemBlue, for: .normal)
    }
    
    private func configureButton(_ sender: UIButton) {
        DispatchQueue.main.async {
            let buttonTitle = self.isFavorite ? "DISLIKE" : "LIKE💙"
            sender.setTitle(buttonTitle, for: .normal)
            sender.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([photo.widthAnchor.constraint(equalToConstant: 70),
                                     photo.heightAnchor.constraint(equalToConstant: 70),
                                     photo.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                                     photo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                                     photo.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100)])
    }
}
