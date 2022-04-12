//
//  HeaderSupplementaryView.swift
//  ExytePockemon
//
//  Created by Nikita Shmelev on 4/11/22.
//

import UIKit

class HeaderSupplementaryView: UICollectionReusableView {

    @IBOutlet weak var titleLabel: UILabel!
    
    static var reuseId: String = "HeaderSupplementaryView"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
