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
    
    var filterManager = FilterManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filter Image"
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        filterManager.context = CIContext()
        filterManager.currentFilter = CIFilter(name: "CISepiaTone")
        
        
        
    }

    @objc func importPicture ( ) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil )
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
    
    func setFilter(action: UIAlertAction) {
         // make sure we have a valid image before continuing!
        guard filterManager.currentImage != nil else { return }
         
         // safely read the alert action's title
         guard let actionTitle = action.title else { return }
         
        filterManager.currentFilter = CIFilter(name: actionTitle)
         
        let beginImage = CIImage(image: filterManager.currentImage)
        filterManager.currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
         
        filterManager.applyProcessing(slider: intenditySlider, image: imageView)
     }
    
    
    //MARK: - Slider ACtion
    @IBAction func sliderAction(_ sender: UISlider) {
        
         filterManager.applyProcessing(slider: intenditySlider, image: imageView)
        
    }
    
    //MARK: - change Filter Button
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
    
    
    //MARK: - SaveButton
    @IBAction func saveButton(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
}
//MARK: - uiimagepickerControllerDelegater , uinavigationControllerDelegate
extension ViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true, completion: nil)
        filterManager.currentImage = image
        
        let beginImage = CIImage(image: filterManager.currentImage)
        filterManager.currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        
        
         filterManager.applyProcessing(slider: intenditySlider, image: imageView)
    }
}
