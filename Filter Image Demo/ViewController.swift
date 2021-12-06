//
//  ViewController.swift
//  Filter Image Demo
//
//  Created by maged mohamed on 12/6/21.
//  Copyright © 2021 maged mohamed. All rights reserved.
//

import UIKit
import CoreImage



class ViewController: UIViewController {

    @IBOutlet weak var intenditySlider: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    
    var currentImage:UIImage!
    
    var context:CIContext!
    var currentFilter:CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filter Image"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
    }
    @objc func importPicture ( ) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil )
    }

    
    
    
    
    
   
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys

           if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intenditySlider.value, forKey: kCIInputIntensityKey) }
           if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(intenditySlider.value * 200, forKey: kCIInputRadiusKey) }
           if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(intenditySlider.value * 10, forKey: kCIInputScaleKey) }
           if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }

           if let cgimg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent) {
               let processedImage = UIImage(cgImage: cgimg)
               self.imageView.image = processedImage
           }
    }
    func setFilter(action: UIAlertAction) {
        // make sure we have a valid image before continuing!
        guard currentImage != nil else { return }

        // safely read the alert action's title
        guard let actionTitle = action.title else { return }

        currentFilter = CIFilter(name: actionTitle)

        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

        applyProcessing()
    }
    @IBAction func sliderAction(_ sender: UISlider) {
        
            applyProcessing()
       }
   
    
    @IBAction func changeFilterButton(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        if let popOverController = ac.popoverPresentationController {
            popOverController.sourceView = sender
            popOverController.sourceRect = sender.bounds
        }
        present(ac, animated: true)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    @IBAction func saveButton(_ sender: UIButton) {
            guard let image = imageView.image else { return }

               UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
           }
}

extension ViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true, completion: nil)
        currentImage = image
        
         let beginImage = CIImage(image: currentImage)
          currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        

        applyProcessing()
    }
}
