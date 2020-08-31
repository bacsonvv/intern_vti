//
//  CardViewCell.swift
//  VVBS_Project_CustomCollectionView
//
//  Created by Vuong Vu Bac Son on 8/31/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class CardViewCell: UICollectionViewCell {
    
    static let identifier = "imageCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var photoDescription: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "CardViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(description: String, imageName: String) {
        photoDescription.text = description
        imageView.image = UIImage(named: imageName)
    }
    
    override func layoutSubviews() {
        // Making cell rounded
        self.layer.cornerRadius = 20.0
        self.layer.borderWidth = 5.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
        
        // Making cell shadow
        self.contentView.layer.cornerRadius = 20.0
        self.contentView.layer.borderWidth = 5.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 6.0
        self.layer.shadowOpacity = 0.6
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
}
