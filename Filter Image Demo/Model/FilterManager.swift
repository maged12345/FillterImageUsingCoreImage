//
//  FilterManager.swift
//  Filter Image Demo
//
//  Created by maged mohamed on 12/11/21.
//  Copyright © 2021 maged mohamed. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

struct FilterManager {
    
    var currentImage:UIImage!
    var context:CIContext!
    var currentFilter:CIFilter!
    
    func applyProcessing( slider:UISlider! , image:UIImageView) {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(slider.value, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(slider.value * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(slider.value * 10, forKey: kCIInputScaleKey) }
        if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }
        guard let outputImage = currentFilter.outputImage else {return}
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            //self error
            image.image = processedImage
        }
    }

    
    
  
}

