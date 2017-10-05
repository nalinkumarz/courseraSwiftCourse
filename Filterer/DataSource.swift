//
//  DataSource.swift
//  Filterer
//
//  Created by Nalin Kumar on 23/09/16.
//  Copyright © 2016 Nalin. All rights reserved.
//

import Foundation
import UIKit

class DataSource {

    var filteredImages:[FilteredImage] = []
    
    init(image: UIImage) {
        filteredImages = getFilteredImages(image)
    }
    
    func getFilteredImages() -> Array<FilteredImage> {
        return filteredImages
    }
    
    func getFilteredImages(imageToFilter: UIImage) -> Array<FilteredImage> {
        let red = FilteredImage.init(image: imageToFilter, filterType: Filter.RED)
        filteredImages.append(red)
        
        let green = FilteredImage.init(image: imageToFilter, filterType: Filter.GREEN)
        filteredImages.append(green)
        
        let blue = FilteredImage.init(image: imageToFilter, filterType: Filter.BLUE)
        filteredImages.append(blue)
        
        let sepia = FilteredImage.init(image: imageToFilter, filterType: Filter.SEPIA)
        filteredImages.append(sepia)
        
        let greyScale = FilteredImage.init(image: imageToFilter, filterType: Filter.GREYSCALE)
        filteredImages.append(greyScale)
        
        let invert = FilteredImage.init(image: imageToFilter, filterType: Filter.INVERT)
        filteredImages.append(invert)
        
        let bright = FilteredImage.init(image: imageToFilter, filterType: Filter.BRIGHTNESS)
        filteredImages.append(bright)
        
        let defaultImage = FilteredImage.init(image: imageToFilter, filterType: Filter.DEFAULT)
        filteredImages.append(defaultImage)
        
        return filteredImages
    }
    
    func getFilteredImageForIndex(index: Int) -> FilteredImage {
        return filteredImages[index]
    }

}