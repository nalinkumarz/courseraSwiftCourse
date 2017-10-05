//
//  FilteredImageCell.swift
//  Filterer
//
//  Created by Nalin Kumar on 23/09/16.
//  Copyright © 2016 Nalin. All rights reserved.
//

import UIKit

class FilteredImageCell : UICollectionViewCell {

    @IBOutlet weak var filteredImageView: UIImageView!
    
    func setImage(image : UIImage) {
        self.filteredImageView.image = image
        self.filteredImageView?.clipsToBounds = true
        self.filteredImageView!.layer.cornerRadius = 10
        self.filteredImageView.clipsToBounds = true;
    }
}