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
        
    private(set) var viewModel: Pokemon?
    
    @IBAction func changeStatusAction(_ sender: UIButton) {
        self.viewModel?.isFavorite.toggle()
        DBManager.shared().updateEntity(entityName: "PokemonList", pokemon: viewModel!)
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
    
    private func addConstraints() {
        NSLayoutConstraint.activate([photo.widthAnchor.constraint(equalToConstant: 70),
                                     photo.heightAnchor.constraint(equalToConstant: 70),
                                     photo.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                                     photo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                                     photo.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100)])
    }

    func configureCell(viewModel: Pokemon) {
        self.viewModel = viewModel
        self.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.borderWidth = CGFloat(1)
        self.layer.cornerRadius = CGFloat(8)
        pockemonName.text = viewModel.name
        configureButton(favoriteStatusButton)
        let utility = Utility()
        utility.downloadImage(imagePath: viewModel.frontImage) { [weak self] image in
            DispatchQueue.main.async {
                self?.photo.image = image
            }
        }
    }
}

// MARK: Private methods
extension PockemonCellCollectionViewCell {
    private func configureButton(_ sender: UIButton) {
        DispatchQueue.main.async {
            let buttonTitle = self.viewModel!.isFavorite ? "DISLIKE" : "LIKE💙"
            sender.setTitle(buttonTitle, for: .normal)
            sender.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
}
