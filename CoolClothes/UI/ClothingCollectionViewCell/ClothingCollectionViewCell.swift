//
//  ClothingCollectionViewCell.swift
//  CoolClothes
//
//  Created by Chatterjee, Sumeru(AWF) on 12/3/17.
//  Copyright © 2017 Chatterjee, Sumeru. All rights reserved.
//

import UIKit
import SDWebImage

public final class ClothingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var clothingImageView: UIImageView!
    @IBOutlet weak var clothingTitleLabel: UILabel!
    @IBOutlet weak var clothingDescriptionLabel: UILabel!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.15)
        self.clothingTitleLabel.font = UIFont.systemFont(ofSize: 12.0)
        self.clothingDescriptionLabel.font = UIFont.systemFont(ofSize: 10.0)
    }
    
    func populate(imageURL: URL?, title: String, description: String) {
        self.clothingTitleLabel.text = title
        self.clothingDescriptionLabel.text = description
        self.clothingImageView.setImage(imageURL: imageURL,  animatedOnce: true)
    }
}

extension ClothingCollectionViewCell: NibLoadableView { }

extension ClothingCollectionViewCell: ReusableView { }
