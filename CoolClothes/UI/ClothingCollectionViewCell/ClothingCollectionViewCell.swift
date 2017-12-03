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
    
    // MARK: - IBOutlet properties
    @IBOutlet weak var clothingImageView: UIImageView!
    @IBOutlet weak var clothingTitleLabel: UILabel!

    // MARK: - UICollectionViewCell life cycle
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.15)
        self.clothingTitleLabel.font = UIFont.systemFont(ofSize: 12.0)
    }
    
    func populate(imageURL: URL?, title: String) {
        self.clothingTitleLabel.text = title
        self.clothingImageView.sd_setImage(with: imageURL, placeholderImage: nil, options: .avoidAutoSetImage)
    }
}


extension ClothingCollectionViewCell: NibLoadableView { }

extension ClothingCollectionViewCell: ReusableView { }
