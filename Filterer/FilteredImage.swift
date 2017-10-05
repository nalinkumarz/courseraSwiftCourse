//
//  File.swift
//  Filterer
//
//  Created by Nalin Kumar on 23/09/16.
//  Copyright © 2016 Nalin. All rights reserved.
//

import UIKit

class FilteredImage {
    
    var filteredImage : UIImage!
    var filterType : Filter
    var intensity : Float
    
    
    init(image: UIImage, filterType: Filter) {
        
        let imageProcessorHelper = ImageProcessorHelper.init(image: image)
        intensity = 1
        self.filterType = filterType
        switch filterType {
        case .GREYSCALE:
            filteredImage = imageProcessorHelper.apply(Filter.GREYSCALE, toImage: image, withIntensity: intensity, intensityIncreasing: false)
            break
        case .SEPIA:
            filteredImage = imageProcessorHelper.apply(Filter.SEPIA, toImage: image, withIntensity: intensity, intensityIncreasing: false)
            break
        case .INVERT:
            filteredImage = imageProcessorHelper.apply(Filter.INVERT, toImage: image, withIntensity: intensity, intensityIncreasing: false)
            break
        case .BRIGHTNESS:
            filteredImage = imageProcessorHelper.apply(Filter.BRIGHTNESS, toImage: image, withIntensity: intensity * 3, intensityIncreasing: false)
        case .RED:
            filteredImage = imageProcessorHelper.apply(Filter.RED, toImage: image, withIntensity: intensity * 5, intensityIncreasing: false)
            break
        case .GREEN:
            filteredImage = imageProcessorHelper.apply(Filter.GREEN, toImage: image, withIntensity: intensity * 5, intensityIncreasing: false)
            break
        case .BLUE:
            filteredImage = imageProcessorHelper.apply(Filter.BLUE, toImage: image, withIntensity: intensity * 5, intensityIncreasing: false)
            break
        default:
            filteredImage = image
            self.filterType = Filter.DEFAULT
            intensity = 1
            break
        }
        
    }

}
