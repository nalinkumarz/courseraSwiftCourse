import UIKit

public enum Filter{case GREYSCALE, SEPIA, INVERT, BRIGHTNESS, RED, GREEN, BLUE, DEFAULT}


public class ImageProcessorHelper {
    
    var image : UIImage
    var intensityIncreasing : Bool
    
    public init(image: UIImage) {
        self.image = image
        intensityIncreasing = false
    }
    
    // MARK - filter methods
    public func apply(filter: Filter, toImage imageToFilter: UIImage, withIntensity intensity:Float, intensityIncreasing increasing: Bool) -> UIImage {
        
        var filteredImage = UIImage()
        self.intensityIncreasing = increasing
        switch filter {
        case .GREYSCALE:
            filteredImage =  applyGreyScaleFilter(toImage: imageToFilter, withIntensity: intensity)
            break
        case .SEPIA:
            filteredImage =  applySepiaFilter(toImage: imageToFilter, withIntensity :intensity)
            break
        case .INVERT:
            filteredImage =  applyInvertFilter(toImage: imageToFilter, withIntensity :intensity)
            break
        case .BRIGHTNESS:
            filteredImage = applyBrightnessFilter(toImage: imageToFilter,withIntensity :intensity)
            break
        case .RED:
            filteredImage = applyColorToImage(filter, toImage: imageToFilter, withIntensity: intensity)
            break
        case .GREEN:
            filteredImage = applyColorToImage(filter, toImage: imageToFilter, withIntensity: intensity)
            break
        case .BLUE:
            filteredImage = applyColorToImage(filter, toImage: imageToFilter, withIntensity: intensity)
            break
        default:
            filteredImage = imageToFilter
            break
        }
        
        return filteredImage
    }
    
    private func applyColorToImage(filter:Filter, toImage imageToFilter: UIImage, withIntensity intensity: Float) -> UIImage {
        var rgbaImage = RGBAImage(image: imageToFilter)!
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var  pixel = rgbaImage.pixels[index]
            
                
                switch filter {
                case .RED:
                    pixel.red = UInt8(min(255, intensity * 100))
                    break
                case .GREEN:
                    pixel.green = UInt8(min(255, intensity * 100))
                    break
                case .BLUE:
                    pixel.blue = UInt8(min(255, intensity * 100))
                    break
                default:
                    break
                }
                
                rgbaImage.pixels[index] = pixel
            }
        }
        return rgbaImage.toUIImage()!
    
    }
    
    public func applyMutipleFilters(filters:[Filter], toImage imageToFilter: UIImage, withIntensity intensity: Float) -> UIImage {
        var filteredImage = UIImage()
        var count = 0
        
        for filter in filters {
            var image = UIImage()
            if (count == 0) {
                image = apply(filter, toImage: imageToFilter, withIntensity :intensity, intensityIncreasing: false)
            } else {
                image = apply(filter, toImage: filteredImage, withIntensity :intensity, intensityIncreasing: false)
            }
            count += 1
            filteredImage = image
        }
        return filteredImage
    }
    
    func applyBrightnessFilter(toImage image:UIImage , withIntensity intensity: Float) -> UIImage {
        print("In Brightness")
        var rgbaImage = RGBAImage(image: image)!
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                
                let index = y * rgbaImage.width + x
                var  pixel = rgbaImage.pixels[index]
                
                let outputRed = Float(pixel.red)
                let outputGreen = Float(pixel.green)
                let outputBlue = Float(pixel.blue)
                
                pixel.red = UInt8(min(255, outputRed * intensity))
                pixel.green = UInt8(min(255, outputGreen * intensity))
                pixel.blue = UInt8(min(255, outputBlue * intensity))
                
                rgbaImage.pixels[index] = pixel
            }
        }
        return rgbaImage.toUIImage()!
    }
    
    
    func applySepiaFilter(toImage image:UIImage, withIntensity intensity: Float) -> UIImage {
        print("In Sepia")
        var rgbaImage = RGBAImage(image: image)!
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                
                let index = y * rgbaImage.width + x
                var  pixel = rgbaImage.pixels[index]
                
                //Stackoverflow
                //http://stackoverflow.com/questions/1061093/how-is-a-sepia-tone-created
                
                let inputRed = Double(pixel.red)
                let inputGreen = Double(pixel.green)
                let inputBlue = Double(pixel.blue)
                
                let outputRed = ((inputRed * 0.393) + (inputGreen * 0.769) + (inputBlue * 0.189)) * Double(intensity)
                let outputGreen = ((inputRed * 0.349) + (inputGreen * 0.686) + (inputBlue * 0.168)) * Double(intensity)
                let outputBlue = ((inputRed * 0.272) + (inputGreen * 0.534) + (inputBlue * 0.131)) * Double(intensity)
                
                pixel.red = UInt8(min(255, outputRed))
                pixel.green = UInt8(min(255, outputGreen))
                pixel.blue = UInt8(min(255, outputBlue))
                
                rgbaImage.pixels[index] = pixel
            }
        }
        return rgbaImage.toUIImage()!
    }
    
    
    func applyGreyScaleFilter(toImage image:UIImage, withIntensity intense: Float) -> UIImage {
        print("In GreyScale with intensity", intense)
        
        let intensity = round(intense)
        
        var rgbaImage = RGBAImage(image: image)!
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                
                let index = y * rgbaImage.width + x
                var  pixel = rgbaImage.pixels[index]
                let average = (Float(pixel.red) + Float(pixel.green) + Float(pixel.blue) + intensity)/3
                
                pixel.red = UInt8(min(255, average * intensity))
                pixel.green = UInt8(min(255, average * intensity))
                pixel.blue = UInt8(min(255, average * intensity))
                
                rgbaImage.pixels[index] = pixel
            }
        }
        return rgbaImage.toUIImage()!
    }
    
    func applyInvertFilter(toImage image:UIImage, withIntensity intense: Float) -> UIImage {
        
        var rgbaImage = RGBAImage(image: image)!
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
            
                pixel.red =  UInt8(min(255, 255 - pixel.red))
                pixel.green = UInt8(min(255, 255 - pixel.green))
                pixel.blue = UInt8(min(255, 255 - pixel.blue))
                
                rgbaImage.pixels[index] = pixel
            }
        }
        return rgbaImage.toUIImage()!
    }
}

