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
    
    @IBOutlet weak var pockemonImage: UIImageView!
    @IBOutlet weak var pockemonName: UILabel!
    @IBOutlet weak var favoriteStatusButton: UIButton!
    
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

    func configureCell(viewModel: PockemonCellViewModel) {
        self.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.borderWidth = CGFloat(1)
        self.layer.cornerRadius = CGFloat(8)
        pockemonName.text = viewModel.name
        favoriteStatusButton.titleLabel?.text = viewModel.isFavoriteStatus ? "DISLIKE" : "LIKE"
        viewModel.downloadImage { [weak self] image in
            DispatchQueue.main.async {
                self?.photo.image = image
            }
        }
    }
}
